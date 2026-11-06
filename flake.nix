{
  description = "AVAS FLAKE :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # IMPORTANT

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";

    vicinae.url = "github:vicinaehq/vicinae";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.3";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    star-shell = {
      url = "github:averyfrog/star-shell";
    };

    constellate = {
      url = "github:averyfrog/constellate";
    };

    matugen = {
      url = "github:InioX/matugen/v4.1.0";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    hytale-launcher = {
      url = "github:JPyke3/hytale-launcher-nix";
    };

    sonora = {
      url = "github:sonorahq/sonora";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    horizon = {
      url = "github:forge-sa/horizon-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
