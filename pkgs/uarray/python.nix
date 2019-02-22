{ stdenv
, devlib
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
  name = "uarray";
  disabled = pythonPackages.pythonOlder "3.7";
  format = "flit";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/Quansight-Labs/uarray;
     branch = "master";
     localPath = ../../../uarray;
  };

  checkInputs = with pythonPackages; [
    pytest pytestcov nbval numpy mypy hypothesis
  ];

  propagatedBuildInputs = with pythonPackages; [
    matchpy numpy numba astunparse typing-extensions black ply graphviz
  ];

  checkPhase = ''
    # mypy uarray
    pytest uarray/parser
  '';

  meta = with stdenv.lib; {
    description = "Universal array library";
    homepage = https://github.com/Quansight-Labs/uarray;
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
