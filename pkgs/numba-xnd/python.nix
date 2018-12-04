{ stdenv
, devlib
, pythonPackages
, ndtypes
, xnd
, gumath
, libndtypes
, libxnd
, libgumath
, xndtools
}:

pythonPackages.buildPythonPackage rec {
  name = "numba-xnd";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/Quansight-Labs/numba-xnd;
     branch = "master";
     localPath = ../../../numba-xnd;
  };

  buildInputs = [ xndtools ];
  propagatedBuildInputs = [ pythonPackages.numpy pythonPackages.llvmlite pythonPackages.argparse pythonPackages.numba xnd gumath ]
     ++ stdenv.lib.optional (!pythonPackages.isPy3k) pythonPackages.funcsigs
     ++ stdenv.lib.optional (pythonPackages.isPy27 || pythonPackages.isPy33) pythonPackages.singledispatch;

  postPatch = ''
    substituteInPlace structinfo_config.py \
      --replace 'include_dirs = lib_dirs + [include_dir]' \
      'include_dirs = ["${libndtypes}/include", "${libxnd}/include", "${libgumath}/include", "${ndtypes}/include/ndtypes", "${xnd}/include/xnd", "${gumath}/include/gumath", "${pythonPackages.numba}/${pythonPackages.python.sitePackages}/numba/runtime"]' \
      --replace 'library_dirs = [site_packages[: site_packages.find("/python")]]' \
                'library_dirs = [ "${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib" ]' \
  '';

  preBuild = ''
    # generate xnd_structinfo.c
    structinfo_generator structinfo_config.py
  '';

  meta = with stdenv.lib; {
    description = "Integrating xnd into numba";
    homepage = https://github.com/Quansight-Labs/numba-xnd;
    license = licenses.bsd3;
    # broken = true;
  };
}
