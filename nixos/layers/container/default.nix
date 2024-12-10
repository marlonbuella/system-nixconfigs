{
  virtualisation = {
    cores = 1;
    memorySize = 1024;

    forwardPorts = [
      # allow SSH connection
      { from = "host"; host.port = 11022; guest.port = 22; }
    ];
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh.enable = true;
}