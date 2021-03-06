{ stdenv
, devlib
, pythonPackages
, xnd
}:

pythonPackages.buildPythonPackage rec {
  name = "xndframes";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/Quansight-Labs/xndframes;
     branch = "master";
     localPath = ../../../xndframes;
  };

  buildInputs = with pythonPackages; [ pytestrunner ];
  checkInputs = with pythonPackages; [ pytest flake8 ];
  propagatedBuildInputs = [ xnd pythonPackages.pandas ];

  meta = with stdenv.lib; {
    description = "Pandas ExtensionDType/Array backed by xnd";
    homepage = https://github.com/Quansight-Labs/xndframes;
    license = licenses.bsd3;
    # broken = true;
  };

}
