{ stdenv
, devlib
, cmake
}:

stdenv.mkDerivation rec {
  name = "umem";

  src = devlib.devSrc {
    inherit name;
    url = https://github.com/plures/umem;
    branch = "master";
    localPath = ../../../umem;
  };

  buildInputs = [ cmake ];

  preConfigure = ''
    cd c
  '';

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Unifying MEmory Management library for connecting different memory devices and interfaces";
    homepage = https://github.com/plures/umem;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
