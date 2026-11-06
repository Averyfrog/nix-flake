{ ... }:
{
  flake.nixosModules.music = { pkgs, inputs, ... }:
  {
    environment.systemPackages = with pkgs; [
      inputs.sonora.packages.${system}.default
    ];
  };
}
