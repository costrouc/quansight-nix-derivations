{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let packageMeta = with pkgs.lib; {
      description = "Library supporting function dispatch on general data containers. C base and Python wrapper";
      homepage = https://xnd.io/;
      license = licenses.bsd3;
    };

    gumathSrc = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../gumath;

    ndtypesBuild = import ./ndtypes.nix { };
    xndBuild = import ./xnd.nix { };
in
rec {
  libgumath = pkgs.stdenv.mkDerivation {
    name = "libgumath";

    src = gumathSrc;

    buildInputs = [ ndtypesBuild.libndtypes xndBuild.libxnd ];

    # Override linker with cc (symlink to either gcc or clang)
    # Library expects to use cc for linking
    configureFlags = [
      "LD=${pkgs.stdenv.cc.targetPrefix}cc"
    ];

    doCheck = true;

    meta = packageMeta;
  };

  gumath = pythonPackages.buildPythonPackage {
    name = "gumath";

    src = gumathSrc;

    checkInputs = [ pythonPackages.numba ];
    propagatedBuildInputs = [ ndtypesBuild.ndtypes xndBuild.xnd ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace 'add_include_dirs = [".", "libgumath", "ndtypes/python/ndtypes", "xnd/python/xnd"] + INCLUDES' \
                  'add_include_dirs = [".", "${ndtypesBuild.libndtypes}/include", "${xndBuild.libxnd}/include", "${libgumath}/include"]' \
        --replace 'add_library_dirs = ["libgumath", "ndtypes/libndtypes", "xnd/libxnd"] + LIBS' \
                  'add_library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${xndBuild.libxnd}/lib", "${libgumath}/lib"]' \
        --replace 'add_runtime_library_dirs = ["$ORIGIN"]' \
                  'add_runtime_library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${xndBuild.libxnd}/lib", "${libgumath}/lib"]'
    '';

    doCheck = true;

    postInstall = ''
      mkdir $out/include
      cp python/gumath/*.h $out/include
    '';

    meta = packageMeta;
  };

  gumath-docs = pkgs.stdenv.mkDerivation {
    name = "gumath-docs";

    src = gumathSrc;

    buildInputs = with pythonPackages; [ sphinx_rtd_theme sphinx ndtypesBuild.ndtypes xndBuild.xnd gumath ];

    buildPhase = ''
      cd doc
      sphinx-build -b doctest -d build/doctrees . build/html
      # output.txt gets added to html from doctest
      rm build/html/output.txt
      sphinx-build -b html -d build/doctrees . build/html
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/html/* $out
    '';
  };

}
