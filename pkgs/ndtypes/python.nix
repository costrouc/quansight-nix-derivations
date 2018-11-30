{ devlib
, pythonPackages
, libndtypes
}:

pythonPackages.buildPythonPackage rec {
  name = "ndtypes";
  disabled = pythonPackages.pythonOlder "3.6";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/ndtypes/;
     branch = "master";
     localPath = ../../../ndtypes;
  };

  propagatedBuildInputs = [ pythonPackages.numpy ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'include_dirs = ["libndtypes"]' \
                'include_dirs = ["${libndtypes}/include"]' \
      --replace 'library_dirs = ["libndtypes"]' \
                'library_dirs = ["${libndtypes}/lib"]' \
      --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                'runtime_library_dirs = ["${libndtypes}/lib"]'
  '';

  postInstall = ''
    mkdir -p $out/include/ndtypes
    cp python/ndtypes/*.h $out/include/ndtypes
  '';

  meta = libndtypes.meta;
}
