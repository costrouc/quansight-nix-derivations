{ stdenv
, devlib
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
  name = "matchpy";
  disabled = pythonPackages.pythonOlder "3.6";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/HPAC/matchpy;
     branch = "master";
     localPath = ../../../../matchpy;
  };

  SETUPTOOLS_SCM_PRETEND_VERSION="v0.4.6";

  buildInputs = with pythonPackages; [ setuptools_scm pytestrunner ];
  checkInputs = with pythonPackages; [ pytest hypothesis ];
  propagatedBuildInputs = with pythonPackages; [ hopcroftkarp multiset ];

  meta = with stdenv.lib; {
    description = "A library for pattern matching on symbolic expressions";
    homepage = https://github.com/HPAC/matchpy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
