{ ... }:
{
  flake.nixosModules.starfishUsers =
    { inputs, pkgs, ... }:

    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      users.users.avafrog = {
        isNormalUser = true;
        description = "Avery";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        packages = with pkgs; [
          kdePackages.kate
          #  thunderbird
        ];
        shell = pkgs.zsh;
      };

      home-manager = {
        # Pass inputs to home-manager modules.
        extraSpecialArgs = { inherit inputs; };
        users = {
          avafrog.home = {
            username = "avafrog";
            homeDirectory = "/home/avafrog";
            stateVersion = "25.05"; # Dont change this you dumbass avery.
          };
        };
        backupFileExtension = "homebackup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
