{ stdenv
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
  name = "mtypes";

  src = with builtins; filterSource
      (path: _:
         !elem (baseNameOf path) [".git"])
      ../../mtypes;

  meta = with stdenv.lib; {
    description = "Memory Types for Python";
    homepage = https://github.com/Quansight-Labs/mtypes;
    license = licenses.bsd3;
    broken = true;
  };
}
