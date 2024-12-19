{
  pkgs,
  inputs,
  system,
  ...
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "shell-thingy";
  src = ./.;

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    glib
    dart-sass
  ];

  buildInputs = with inputs.astal.packages.${system}; [
    io
    astal3
    apps
    battery
    wireplumber
    network
    mpris
    hyprland
  ];

  meta.mainProgram = finalAttrs.name; 
})
