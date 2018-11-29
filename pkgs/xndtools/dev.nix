{ pkgs
, pythonPackages
, xndtools
 }:

let pythonEnv = pythonPackages.python.withPackages
                  (ps: with ps; [ xndtools ]);
in {

  shell = pkgs.mkShell {
    buildInputs = [ pythonEnv ];
  };
}
