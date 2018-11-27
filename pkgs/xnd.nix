{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let packageMeta = with pkgs.lib; {
      description = "C library for managing typed memory blocks and Python container module";
      homepage = https://xnd.io/;
      license = licenses.bsd3;
    };

    xndSrc = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../xnd;

    # could use remote git source as well instead of local
    ndtypesBuild = import ./ndtypes.nix { };
in
rec {
  libxnd = pkgs.stdenv.mkDerivation {
    name = "libxnd";

    src = xndSrc;

    buildInputs = [ ndtypesBuild.libndtypes ];

    configureFlags = [
      # Override linker with cc (symlink to either gcc or clang)
      # Library expects to use cc for linking
      "LD=${pkgs.stdenv.cc.targetPrefix}cc"
      # needed for tests
      "--with-includes=${ndtypesBuild.libndtypes}/include"
      "--with-libs=${ndtypesBuild.libndtypes}/lib"
    ];

    doCheck = true;

    meta = packageMeta;
  };

  xnd = pythonPackages.buildPythonPackage {
    name = "xnd";

    src = xndSrc;

    propagatedBuildInputs = [ ndtypesBuild.ndtypes ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace 'include_dirs = ["libxnd", "ndtypes/python/ndtypes"] + INCLUDES' \
                  'include_dirs = ["${ndtypesBuild.libndtypes}/include", "${ndtypesBuild.ndtypes}/include", "${libxnd}/include"]' \
        --replace 'library_dirs = ["libxnd", "ndtypes/libndtypes"] + LIBS' \
                  'library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${libxnd}/lib"]' \
        --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                  'runtime_library_dirs = ["${ndtypesBuild.libndtypes}/lib", "${libxnd}/lib"]' \
    '';

    postInstall = ''
      mkdir $out/include
      cp python/xnd/*.h $out/include
    '';

    doCheck = true;

    meta = packageMeta;
  };

}
