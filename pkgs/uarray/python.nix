{ stdenv
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
  name = "uarray";
  disabled = pythonPackages.pythonOlder "3.7";
  format = "flit";

  src = with builtins; filterSource
      (path: _:
         !elem (baseNameOf path) [".git"])
         ../../../uarray;

  checkInputs = with pythonPackages; [
    pytest nbval pytestcov numba mypy
  ];

  propagatedBuildInputs = with pythonPackages; [
    matchpy numpy astunparse typing-extensions black
  ];

  checkPhase = ''
    mypy uarray
    ${pythonPackages.python.interpreter} extract_readme_tests.py
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Universal array library";
    homepage = https://github.com/Quansight-Labs/uarray;
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
