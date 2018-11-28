{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

let numbaxndSrc = with builtins; filterSource
        (path: _:
           !elem (baseNameOf path) [".git"])
        ../../numba-xnd;

    ndtypesBuild = import ./ndtypes.nix { };
    xndBuild = import ./xnd.nix { };
    gumathBuild = import ./gumath.nix { };
in {
  numba-xnd = pythonPackages.buildPythonPackage rec {
    name = "numba-xnd";

    src = numbaxndSrc;

    propagatedBuildInputs = with pythonPackages; [numpy llvmlite argparse xndBuild.xnd gumathBuild.gumath ]
       ++ pkgs.stdenv.lib.optional (!isPy3k) funcsigs
       ++ pkgs.stdenv.lib.optional (isPy27 || isPy33) singledispatch;

    postPatch = ''
      substituteInPlace structinfo_config.py \
        --replace 'include_dirs = lib_dirs + [include_dir]' \
                  'include_dirs = [ "${ndtypesBuild.libndtypes}/include", "${xndBuild.libxnd}/include", "${gumathBuild.libgumath}/include", "${ndtypesBuild.ndtypes}/include", "${xndBuild.xnd}/include", "${gumathBuild.gumath}/include" ]' \
        --replace 'library_dirs = [site_packages[: site_packages.find("/python")]]' \
                  'library_dirs = [ "${ndtypesBuild.libndtypes}/lib", "${xndBuild.libxnd}/lib", "${gumathBuild.libgumath}/lib" ]' \
    '';

    meta = with pkgs.lib; {
      description = "Integrating xnd into numba";
      homepage = https://github.com/Quansight-Labs/numba-xnd;
      license = licenses.bsd3;
      broken = true;
    };
  };
}
