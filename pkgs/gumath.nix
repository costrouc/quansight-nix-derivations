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
        --replace 'include_dirs = ["libgumath", "ndtypes/python/ndtypes", "xnd/python/xnd"] + INCLUDES' \
                  'include_dirs = ["${ndtypesBuild.libndtypes}/include", "${xndBuild.libxnd}/include", "${libgumath}/include"]' \
        --replace 'library_dirs = ["libgumath", "ndtypes/libndtypes", "xnd/libxnd"] + LIBS' \
                  'library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${xndBuild.libxnd}/lib", "${libgumath}/lib"]' \
        --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                  'runtime_library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${xndBuild.libxnd}/lib", "${libgumath}/lib"]'
    '';

    doCheck = true;

    meta = packageMeta;
  };

}
