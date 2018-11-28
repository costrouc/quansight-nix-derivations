{ pkgs ? import <nixpkgs> { }
, pythonVersion ? "37"
}:

let
  # allow for pythonPackages to be changed from `--argstr`
  # example: `--argstr pythonVersion 36`
  pythonPackages = builtins.getAttr "python${pythonVersion}Packages" pkgs;
in
  (import ./pkgs/gumath.nix     { inherit pkgs pythonPackages; }) //
  (import ./pkgs/mtypes.nix     { inherit pkgs pythonPackages; }) //
  (import ./pkgs/ndtypes.nix    { inherit pkgs pythonPackages; }) //
  (import ./pkgs/numba-xnd.nix  { inherit pkgs pythonPackages; }) //
  (import ./pkgs/uarray.nix     { inherit pkgs pythonPackages; }) //
  (import ./pkgs/xnd.nix        { inherit pkgs pythonPackages; }) //
  (import ./pkgs/xndframes.nix  { inherit pkgs pythonPackages; }) //
  (import ./pkgs/xndtools.nix   { inherit pkgs pythonPackages; })
