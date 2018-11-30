{ pythonPackages
, devlib
, libndtypes
, libxnd
, ndtypes
}:

pythonPackages.buildPythonPackage rec {
  name = "xnd";
  disabled = pythonPackages.pythonOlder "3.6";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/xnd/;
     branch = "master";
     localPath = ../../../xnd;
  };

  propagatedBuildInputs = [ ndtypes ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'include_dirs = ["libxnd", "ndtypes/python/ndtypes"] + INCLUDES' \
                'include_dirs = ["${libndtypes}/include", "${ndtypes}/include/ndtypes", "${libxnd}/include"]' \
      --replace 'library_dirs = ["libxnd", "ndtypes/libndtypes"] + LIBS' \
                'library_dirs = ["${libndtypes}/lib", "${libxnd}/lib"]' \
      --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                'runtime_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib"]' \
  '';

  postInstall = ''
    mkdir -p $out/include/xnd
    cp python/xnd/*.h $out/include/xnd
  '';

  doCheck = true;

  meta = libxnd.meta;
}
