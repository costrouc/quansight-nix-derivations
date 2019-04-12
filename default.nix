{ pythonVersion ? "37", localSrcOverrides ? "", defaultSrc ? "local" }:

let
  # pinning nixpkgs for fully deterministic builds
  # https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
  nixpkgs = import (builtins.fetchGit {
    url = "git://github.com/costrouc/nixpkgs";
    ref = "python-lektor-upgrade";
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

    ### Quansight Packages

    gumath = callPackage ./pkgs/gumath/python.nix { };

    gumath-dev = callPackage ./pkgs/gumath/dev.nix { };

    gumath-docs = callPackage ./pkgs/gumath/docs.nix { };

    libgumath = callPackage ./pkgs/gumath/library.nix { };

    libndtypes = callPackage ./pkgs/ndtypes/library.nix { };

    libxnd = callPackage ./pkgs/xnd/library.nix { };

    mtypes = callPackage ./pkgs/mtypes { };

    ndtypes = callPackage ./pkgs/ndtypes/python.nix { };

    ndtypes-docs = callPackage ./pkgs/ndtypes/docs.nix { };

    numba-xnd = callPackage ./pkgs/numba-xnd/python.nix { };

    numba-xnd-dev = callPackage ./pkgs/numba-xnd/dev.nix { };

    psi-compiler = callPackage ./pkgs/psi-compiler { };

    uarray = callPackage ./pkgs/uarray/python.nix { };

    uarray-dev = callPackage ./pkgs/uarray/dev.nix { };

    uarray-docs = callPackage ./pkgs/uarray/docs.nix { };

    umem = callPackage ./pkgs/umem { };

    xnd = callPackage ./pkgs/xnd/python.nix { };

    xnd-docs = callPackage ./pkgs/xnd/docs.nix { };

    xndframes = callPackage ./pkgs/xndframes/python.nix { };

    xndframes-docs = callPackage ./pkgs/xndframes/docs.nix { };

    xndtools = callPackage ./pkgs/xndtools/python.nix { };

    xndtools-dev = callPackage ./pkgs/xndtools/dev.nix { };

    xndtools-docs = callPackage ./pkgs/xndtools/docs.nix { };

    quansight-labs-site = callPackage ./pkgs/quansight-labs-site { };

    ### Quansight Dependencies

    matchpy = callPackage ./pkgs/dependencies/matchpy/python.nix { };

    matchpy-dev = callPackage ./pkgs/dependencies/matchpy/dev.nix { };

    numpy = callPackage ./pkgs/dependencies/numpy/python.nix { blas = nixpkgs.openblas; };

  };
in pkgs
