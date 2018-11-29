{ stdenv
, pythonPackages
, xnd
}:

pythonPackages.buildPythonPackage rec {
  name = "xndframes";

  src = with builtins; filterSource
          (path: _:
             !elem (baseNameOf path) [".git"])
          ../../../xndframes;

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
