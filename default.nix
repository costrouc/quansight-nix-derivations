{ pythonVersion ? "37" }:

let
  # call package design pattern
  # https://lethalman.blogspot.com/2014/09/nix-pill-13-callpackage-design-pattern.html
  nixpkgs = import <nixpkgs> {};
  allPkgs = nixpkgs // pkgs;
  callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
  pkgs = with nixpkgs; {
    pythonPackages = builtins.getAttr "python${pythonVersion}Packages" nixpkgs;

    gumath = callPackage ./pkgs/gumath/python.nix { };

    gumath-docs = callPackage ./pkgs/gumath/docs.nix { };

    libgumath = callPackage ./pkgs/gumath/library.nix { };

    libndtypes = callPackage ./pkgs/ndtypes/library.nix { };

    libxnd = callPackage ./pkgs/xnd/library.nix { };

    mtypes = callPackage ./pkgs/mtypes.nix { };

    ndtypes = callPackage ./pkgs/ndtypes/python.nix { };

    ndtypes-docs = callPackage ./pkgs/ndtypes/docs.nix { };

    numba-xnd = callPackage ./pkgs/numba-xnd.nix { };

    uarray = callPackage ./pkgs/uarray/python.nix { };

    uarray-docs = callPackage ./pkgs/uarray/docs.nix { };

    xnd = callPackage ./pkgs/xnd/python.nix { };

    xnd-docs = callPackage ./pkgs/xnd/docs.nix { };

    xndframes = callPackage ./pkgs/xndframes/python.nix { };

    xndframes-docs = callPackage ./pkgs/xndframes/docs.nix { };

    xndtools = callPackage ./pkgs/xndtools/python.nix { };

    xndtools-docs = callPackage ./pkgs/xndtools/docs.nix { };

  };
in pkgs
