{
  description = "Avery's very bad flake :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";    
      };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
    };

    nixcord = {
      url = "github:kaylorben/nixcord/40dafe281bdadedc894879f8671aef19af6bafd6";
    };

    stylix = {
      url = "github:danth/stylix";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {self, nixpkgs, anyrun, ... }@inputs:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.Fish-2 = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
            ./Systems/Fish-2/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.nixvim.nixosModules.nixvim
            {environment.systemPackages = [ anyrun.packages.${system}.anyrun ];}
            #{environment.systemPackages = [ inputs.matugen.packages.${system}.default ];}
          ];
        };
    };
}