{ self, inputs, ... }:
{
  flake.nixosConfigurations.starfish = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with self.nixosModules; [
      inputs.home-manager.nixosModules.home-manager
      inputs.tuxedo-nixos.nixosModules.default

      starfishConfiguration
    ];
  };
  flake.nixosConfigurations.Anomalocaris = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with self.nixosModules; [
      inputs.home-manager.nixosModules.home-manager
      inputs.tuxedo-nixos.nixosModules.default

      anomalocarisConfiguration
    ];
  };
}
