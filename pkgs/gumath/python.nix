{ pythonPackages
, libndtypes
, libxnd
, libgumath
, ndtypes
, xnd
}:

pythonPackages.buildPythonPackage {
  name = "gumath";

  src = libgumath.src;

  checkInputs = [ pythonPackages.numba ];
  propagatedBuildInputs = [ ndtypes xnd ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'add_include_dirs = [".", "libgumath", "ndtypes/python/ndtypes", "xnd/python/xnd"] + INCLUDES' \
                'add_include_dirs = [".", "${libndtypes}/include", "${libxnd}/include", "${libgumath}/include"]' \
      --replace 'add_library_dirs = ["libgumath", "ndtypes/libndtypes", "xnd/libxnd"] + LIBS' \
                'add_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]' \
      --replace 'add_runtime_library_dirs = ["$ORIGIN"]' \
                'add_runtime_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]'
  '';

  doCheck = true;

  postInstall = ''
    mkdir $out/include
    cp python/gumath/*.h $out/include
  '';

  meta = libgumath.meta;
}
