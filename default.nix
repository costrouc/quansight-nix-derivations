{ pythonVersion ? "37", localSrcOverrides ? "", defaultSrc ? "local" }:

let
  # pinning nixpkgs for fully deterministic builds
  # https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/b6708d49af3c3da51fdddbe1bc2e30d5e0954dda.tar.gz";
    sha256 = "0j2w72fqgnbhqwd82njv0d49c8i2sllps65vs82z9hksna5zh0m1";
  }) { };
  allPkgs = nixpkgs // pkgs;

  # call package design pattern
  # https://lethalman.blogspot.com/2014/09/nix-pill-13-callpackage-design-pattern.html
  callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
  pkgs = with nixpkgs; {
    ## python package version used for all builds
    # BE WARNED build cache only exists for python2Packages and python3Packages and their aliases (27, 37)
    # Available attributes:
    #  - python27Packages == python2Packages
    #  - python35Packages, python36Packages, python37Packages == python3Packages
    pythonPackages = builtins.getAttr "python${pythonVersion}Packages" nixpkgs;

    ## localPackages
    # these are the packages you with to explicitely override
    # to be built using local source in flat hierarchy
    # must be comma separated list of packages
    localSrcOverrides = lib.splitString "," localSrcOverrides;

    ## default src to use
    # available values see devlib.devSrc for implementation
    #  - local   :: by default build all packages from local source
    #  - repo    :: by default build all packages from git repository
    #  - release :: by default build all packages from lastest release (not implemented)
    inherit defaultSrc;

    # inherit tools
    devlib = callPackage ./lib/utils.nix { };

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
