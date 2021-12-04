let
  dan4ik = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOIuIutmkslaS/C6seRY1Pg/416wekBGcE7USHUoxK+";
in
{
  "secrets.age".publicKeys = [ dan4ik ];
}
