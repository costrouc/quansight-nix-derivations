{ stdenv
, devlib
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
  name = "mtypes";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/xnd/;
     branch = "master";
     localPath = ../../mtypes;
  };

  meta = with stdenv.lib; {
    description = "Memory Types for Python";
    homepage = https://github.com/Quansight-Labs/mtypes;
    license = licenses.bsd3;
    broken = true;
  };
}
