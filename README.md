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
|-- quansight-nix/
|-- xnd/
|-- xndtools/
|-- gumath/
|-- ndtypes/
|-- uarray/
...
```

# Usage

Available attributes can be found in `default.nix`. I will do my best
to keep the following list up to date. By default all packages are run
with all tests.

 - `libndtypes`, `ndtypes`, `ndtypes-docs`
 - `libxnd`, `xnd`, `xnd-docs`
 - `libgumath`, `gumath`, `gumath-docs`
 - `uarray`, `uarray-docs`
 - `xndtools` (not complete), `xndtools-docs`
 - `mtypes`

Building a package includes running all tests. It is as simple as

```shell
nix-build -A xnd
```


