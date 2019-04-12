{ pkgs
, pythonPackages
, devlib
}:

let theme = fetchGit {
      url = "https://github.com/Andrew-Shay/lektor-theme-simple-strap.git";
      ref = "master";
    };
in
pkgs.stdenv.mkDerivation rec {
  name = "quansight-labs-site";

  src = devlib.devSrc {
     inherit name;
     url = https://github.com/Quansight-Labs/quansight-labs-site;
     branch = "master";
     localPath = ../../../quansight-labs-site;
  };

  buildInputs = [ pythonPackages.lektor ];

  postConfigure = ''
    rmdir themes/lektor-theme-simple-strap
    ln -sf ${theme}/ $PWD/themes/lektor-theme-simple-strap
  '';

  buildPhase = ''
    lektor build --output-path build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/* $out/
  '';

}
