# Quansight Nix

This repository contains nix derivations for
[Quansight](https://www.quansight.com/) projects along with
definitions to help with development. For newcomers here are some
advantages of `nix` for development.

  - `nix` makes a great `Makefile` replacement
  - all builds/tests/commands are run in an isolated environment
  - ensure that developers have identical environments
  - works seamlessly with monorepos along with seperate repositories for each project
  - keeps source repositories clean (all builds are done in a sandboxed temporary directory)
  - unify continuous integration pipeline
 
# Dependencies

The beauty of `nix` is its lack of dependencies. Simply [install
nix](https://nixos.org/nixos/download.html) it is compatible with all
linux distributions, OpenBSD and darwin (OSX). It will not conflict
with your package manager or system at all.

These repository builds make one assumption about the layout of the
repositories. It expects a flat hierarchy shown below. In the future I
can add git support to use "master".

```
...
|-- gumath/
|-- mtypes/
|-- ndtypes/
|-- numba-xnd/
|-- quansight-nix/
|-- uarray/
|-- xnd/
|-- xndframes/
|-- xndtools/
...
```

# Deterministic

Nixpkgs pinning is used to **guarantee** the same builds between
developers. I mean it. You can now expect that if it builds on `linux
x86_64` it will build on any machine of the same architecture and
distribution. In order to upgrade the packages you will need to
increment to a new [nixpkgs commit](https://github.com/nixos/nixpkgs)
sha256. Dont worry about the sha256 just change the last letter and
nix will complain that the shas don't match and provide the expected
sha. There are other ways but this is the easiest.

```nix
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/costrouc/nixpkgs/archive/7b77c7ff9332c68c24f2cfb72ba716a2b89915e1.tar.gz";
    sha256 = "1pxm5817s5a6k3bb2fpxb9323y922i46y6rrv5bccxc2zkwrfp2a";
  }) { };
```

# Usage

Available attributes can be found in `default.nix`. I will do my best
to keep the following list up to date. By default all packages are run
with all tests.

 - `libgumath`, `gumath`, `gumath-docs`
 - `libndtypes`, `ndtypes`, `ndtypes-docs`
 - `libxnd`, `xnd`, `xnd-docs`
 - `mtypes` (broken)
 - `numba-xnd` (broken)
 - `uarray`, `uarray-docs`
 - `xndframes` (broken), `xndframes-docs` (depends on xndframes)
 - `xndtools` (broken), `xndtools-docs`

Building a package includes running all tests. It is as simple as

```shell
nix-build -A xnd
```


