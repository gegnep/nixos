{ ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };

  sops.secrets = {
    ssh-key-personal = {
      owner = "pengeg";
      mode = "0600";
    };
    atuin-key = {
      owner = "pengeg";
      mode = "0600";
    };
  };
}
