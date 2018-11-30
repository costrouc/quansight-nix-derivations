# Quansight Nix

[![Build Status](https://travis-ci.org/costrouc/quansight-nix-derivations.svg?branch=master)](https://travis-ci.org/costrouc/quansight-nix-derivations)

## Motivation

XND and packages that use XND have a chain of dependencies where it is
hard to develop one and understand the downstream changes. 

This repository contains nix derivations for
[Quansight](https://www.quansight.com/) projects along with
definitions to help with development. For newcomers here are some
advantages of `nix` for development.

  - `nix` makes a great `Makefile` replacement
  - all builds/tests/commands are run in an isolated environment
  - all builds are cached (never build same package twice)
  - ensure that developers have identical environments
  - works seamlessly with monorepos along with separate repositories for each project
  - keeps source repositories clean (all builds are done in a sandboxed temporary directory)
  - unify continuous integration pipeline (nix becomes pipeline)
  - small docker containers with optimized layers
 
# Dependencies

The beauty of `nix` is its lack of dependencies. Simply [install
nix](https://nixos.org/nixos/download.html) it is compatible with all
linux distributions, OpenBSD and darwin (OSX). It will not conflict
with your package manager or system at all.

This repository makes one assumption about the layout of the
repositories. It expects a flat hierarchy shown below if you are going
to do any local builds.

```
...
|-- gumath/
|-- mtypes/
|-- ndtypes/
|-- numba-xnd/
|-- quansight-nix-derivations/ <-- you are here
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
  url = "https://github.com/nixos/nixpkgs/archive/7b77c7ff9332c68c24f2cfb72ba716a2b89915e1.tar.gz";
  sha256 = "1pxm5817s5a6k3bb2fpxb9323y922i46y6rrv5bccxc2zkwrfp2a";
}) { }
```

# Usage

Available attributes can be found in `default.nix`. I will do my best
to keep the following list up to date. By default all packages are run
with all tests.

 - `libgumath`, `gumath`, `gumath-docs`, `gumath-dev.shell`, `gumath-dev.docker`
 - `libndtypes`, `ndtypes`, `ndtypes-docs`
 - `libxnd`, `xnd`, `xnd-docs`
 - `mtypes` (broken)
 - `numba-xnd` (broken), `numba-xnd-dev.shell` (broken), `numba-xnd-dev.docker` (broken) 
 - `uarray`, `uarray-docs`, `uarray-dev.docker`, `uarray-dev.shell`
 - `xndframes` (broken), `xndframes-docs` (depends on xndframes)
 - `xndtools`, `xndtools-docs`, `xndtools-dev.shell`

## Packages

A typical development environment involves testing a package that you
are building. Building a package includes running all tests. It is as
simple as

```shell
nix-build -A xnd
```

We are not limited to python packages. We can also build documentation
for a project.

```shell
nix-build -A xnd-docs
firefox result/index.html
```

Or we can build some latex papers needed for `uarray`.

```shell
nix-build -A uarray-docs
ls result # several pdfs generated
```

## Interactive virtualenv

Trying out a package can be done with nix shell with usually a `-dev`
at the end with several attributes that you can look up. The `shell`
attribute will create a TRUE virtualenv with the package that you can
interact with.

```shell
nix-shell -A gumath-dev.shell
```

## Docker Images

Nix is **THE** way to create docker images. Since nix knows all of the
dependencies of the required package and each package is built
seperately we get serveral nice benifits. See [this blog post by
Graham
Christensen](https://grahamc.com/blog/nix-and-layered-docker-images)
that explains the power of nix + docker. In summary:

 - we can actually optimize the layers for optimal caching
 - the "RUN" step is often not needed
 - oh and it **doesn't** require docker to build and no root
 
Try it out right now! It is fast and fully deterministic.

```shell
nix-build -A gumath-dev.docker
docker load < ./result
docker run -it gumath
```

What does a nix docker expression look like?

```nix
let
  pythonEnv = pythonPackages.python.withPackages (ps: with ps; [ gumath ]);
in
pkgs.dockerTools.buildLayeredImage {
  name = "gumath";
  tag = "latest";
  config.Cmd = [ "${pythonEnv.interpreter}" ];
  maxLayers = 120;
}
```

`pythonEnv` defined a python environment where we actually merge all
the python dependencies in `lib/pythonX.X/site-packages/...`. The next
step has many more options that you would expect from docker images
like tags, run commands, etc. Here we build an image that has python
with gumath installed. `maxLayers` is where the magic happens. `nix`
will create a layer for each package in an ordered way similar to the
way that [python MRO
works](https://www.python.org/download/releases/2.3/mro/). So now not
only will your images be small but they will cache well out of the
box.

# Options

`default.nix` turns out to actually be a nix function with default
arguments of `pythonVersion` and `useLocal`. 

```nix
{ pythonVersion ? "37", localSrcOverrides ? "", defaultSrc ? "local" }:

{
  ...
}
```

These are convenience options to control the python version of the
packages (`pythonVersion`) and control the version of each package
used (`localSrcOverrides` and `defaultSrc`).

## Python Version

The default version for Python is 3.7 as shown above. To
build `xnd` for Python 3.6 execute the following.

```shell
nix-build -A xnd --argstr pythonVersion 36
```

## Chosing Source Location

Often times we would like to build a package with our source code
changes, build others based on the `master` of a git repository or
possibly the lastest stable relase (e.g. `v1.0.1`). The options
`localSrcOverrides` and `defaultSrc` allow us to control where the
source comes from.

`defaultSrc` sets the default src that all packages in
`quansight-nix-derivations` will use. It has three options `local`,
`repo`, and `release` (subject to change). Lets take an example.

```shell
nix-build -A xnd --argstr defaultSrc repo
```

This means that xnd will be built using the `master` branch for all
quansight projects that it depends on (`libndtypes`, `ndtypes`, and
`libxnd`). Yeah it is that simple. Setting `release` would mean that
it will use the latest stable release for each quansight package it
depends on. And lastly `local` means that it will be built using the
local source code. In this case the following paths need to exist
`../xnd` and `../ndtypes`. The default is `local`.

What if we want to build our package with our local changes but use
the latest stable release of all other packages? This case is where
`localSrcOverrides` comes in. It allows you to specify which packages
should be forced to build from our local source changes.

```shell
nix-build -A xnd --argstr defaultSrc release --argstr localSrcOverrides libndtypes,xnd
```

In this case `xnd` and `libndtypes` will be built with our local
source code while `ndtypes` will be built with master on
[plures/ndtypes](https://github.com/plures/ndtypes).

# Continous Integration

Continuous Integration tools become much easier to use with nix
becuase you no longer have any dependencies that you have to install!
Additionally nix handles all of the build dependency login for you. I
chose travis in this example becuase it is commonly used. Nix will
build packages from each derivation. Since these builds are
deterministic we can cache the results. Thus we can also create CI now
as a build tool. We will use one new service that have gained quite
some traction in the nix community
[cachix](https://cachix.org/). Cachix is a free service that will
store the results of each build and all of it dependencies. So you
never have to build the same package twice. This will dramatically
save on build time.

```yaml
language: nix
# cachix is used to cache builds
# sadly there is boiler plate that has to be done
# set secret env variable CACHIX_SIGNING_KEY

matrix:
  include:
    - env: PYTHON_VERSION=36
    - env: PYTHON_VERSION=37

script:
# (1) install cachix
  - nix-env -iA cachix -f https://github.com/NixOS/nixpkgs/tarball/889c72032f8595fcd7542c6032c208f6b8033db6
# (2) enable cachix cache
  - cachix use quansight
# (3) watch for builds needed for intermediate builds
  - cachix push quansight --watch-store&
# (4) build and push result to cachix
  - nix-build -A ndtypes --argstr pythonVersion $PYTHON_VERSION --argstr defaultSrc repo | cachix push quansight
```

Since travis is now responsible for the builds and uploading them to
cachix. We can use `travis` as our build server. If properly
authenticated the following command will enable the cachix cache to be
used on your machine.

```bash
cachix use quansight
```
