{ stdenv
, fetchgit
, buildGoModule
, makeDesktopItem
}:

buildGoModule
{
  name = "karasik";
  src = fetchgit
    {
      url = "https://git.sr.ht/~begs/termvk";
      sha256 = "1pm0zgg60j4dhjlwxazxpy72b53j0zgq4p3vz5cks4mqlsxksy1c";
    };
  vendorSha256 = "12g4n4mjjk4ivyrgay73g95h2shmamhxn7cbx7as86ydggbpajrw";
}
