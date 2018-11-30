{ stdenv
, devlib
, pythonPackages
, libndtypes
, libxnd
, libgumath
, ndtypes
, xnd
, gumath
}:

pythonPackages.buildPythonPackage rec {
  name = "xndtools";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/plures/xndtools;
     branch = "master";
     localPath = ../../../xndtools;
  };

  buildInputs = with pythonPackages; [ pytestrunner libndtypes libxnd libgumath ];
  checkInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = [ ndtypes xnd gumath ];

  meta = with stdenv.lib; {
    description = "Development tools for the XND project";
    homepage = https://github.com/plures/xndtools;
    license = licenses.bsd3;
  };

}
