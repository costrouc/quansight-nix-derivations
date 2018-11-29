{ pythonVersion ? "37", useLocal ? true }:

let
  # pinning nixpkgs for fully deterministic builds
  # https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/7b77c7ff9332c68c24f2cfb72ba716a2b89915e1.tar.gz";
    sha256 = "1pxm5817s5a6k3bb2fpxb9323y922i46y6rrv5bccxc2zkwrfp2a";
  }) { };
  allPkgs = nixpkgs // pkgs;

  # call package design pattern
  # https://lethalman.blogspot.com/2014/09/nix-pill-13-callpackage-design-pattern.html
  callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
  pkgs = with nixpkgs; {
    # set python package version used for all builds
    pythonPackages = builtins.getAttr "python${pythonVersion}Packages" nixpkgs;

    gumath = callPackage ./pkgs/gumath/python.nix { };

    gumath-dev = callPackage ./pkgs/gumath/dev.nix { };

    gumath-docs = callPackage ./pkgs/gumath/docs.nix { };

    libgumath = callPackage ./pkgs/gumath/library.nix { };

    libndtypes = callPackage ./pkgs/ndtypes/library.nix { };

    libxnd = callPackage ./pkgs/xnd/library.nix { };

    mtypes = callPackage ./pkgs/mtypes.nix { };

    ndtypes = callPackage ./pkgs/ndtypes/python.nix { };

    ndtypes-docs = callPackage ./pkgs/ndtypes/docs.nix { };

    numba-xnd = callPackage ./pkgs/numba-xnd/python.nix { };

    numba-xnd-dev = callPackage ./pkgs/numba-xnd/dev.nix { };

    uarray = callPackage ./pkgs/uarray/python.nix { };

    uarray-dev = callPackage ./pkgs/uarray/dev.nix { };

    uarray-docs = callPackage ./pkgs/uarray/docs.nix { };

    xnd = callPackage ./pkgs/xnd/python.nix { };

    xnd-docs = callPackage ./pkgs/xnd/docs.nix { };

    xndframes = callPackage ./pkgs/xndframes/python.nix { };

    xndframes-docs = callPackage ./pkgs/xndframes/docs.nix { };

    xndtools = callPackage ./pkgs/xndtools/python.nix { };

    xndtools-dev = callPackage ./pkgs/xndtools/dev.nix { };

    xndtools-docs = callPackage ./pkgs/xndtools/docs.nix { };

  };
in pkgs
