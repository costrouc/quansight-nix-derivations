{ stdenv
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

  src = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../../xndtools;

  buildInputs = with pythonPackages; [ pytestrunner libndtypes libxnd libgumath ];
  checkInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = [ ndtypes xnd gumath ];

  meta = with stdenv.lib; {
    description = "Development tools for the XND project";
    homepage = https://github.com/plures/xndtools;
    license = licenses.bsd3;
  };

}
