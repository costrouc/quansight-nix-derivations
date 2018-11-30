{ lib
, localSrcOverrides
, defaultSrc
}:

{
  devSrc = with builtins;
    { name, url, branch ? "master", tag ? null, localPath }:
      if (elem name localSrcOverrides) || (defaultSrc == "local")
        then filterSource
               (path: _: !elem  (baseNameOf path) [".git"])
               (toPath localPath)
      else if defaultSrc == "repo"
        then fetchGit { inherit url; ref = branch; }
      else if defaultSrc == "release"
        then if tag != null
          then fetchGit { inherit url; ref = tag; }
          else throw ''no git tag specified for "${name}" repository "${url}"''
      else throw ''invalid src location "${defaultSrc}" options (local, repo, release)'';

}
