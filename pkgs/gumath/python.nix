{ pythonPackages
, devlib
, libndtypes
, libxnd
, libgumath
, ndtypes
, xnd
}:

pythonPackages.buildPythonPackage rec {
  name = "gumath";
  disabled = pythonPackages.pythonOlder "3.6";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/gumath/;
     branch = "master";
     localPath = ../../../gumath;
  };

  checkInputs = [ pythonPackages.numba ];
  propagatedBuildInputs = [ ndtypes xnd ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'add_include_dirs = [".", "libgumath", "ndtypes/python/ndtypes", "xnd/python/xnd"] + INCLUDES' \
                'add_include_dirs = [".", "${libndtypes}/include", "${libxnd}/include", "${libgumath}/include", "${ndtypes}/include/ndtypes", "${xnd}/include/xnd"]' \
      --replace 'add_library_dirs = ["libgumath", "ndtypes/libndtypes", "xnd/libxnd"] + LIBS' \
                'add_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]' \
      --replace 'add_runtime_library_dirs = ["$ORIGIN"]' \
                'add_runtime_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]'
  '';

  doCheck = true;

  postInstall = ''
    mkdir -p $out/include/gumath
    cp python/gumath/*.h $out/include/gumath
  '';

  meta = libgumath.meta;
}
