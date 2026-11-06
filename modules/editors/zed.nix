{ ... }:
{

  flake.nixosModules.zed =
    { pkgs, ... }:

    {
      home-manager.sharedModules = [
        {
          programs.zed-editor = {
            enable = true;

            package = pkgs.zed-editor.fhsWithPackages (
              pkgs: with pkgs; [
                nil
                nixd
                qt6.qtdeclarative
                color-lsp
                rust-analyzer
                beam27Packages.elixir-ls
                csharp-ls

                prettier
              ]
            );
          };
        }
      ];

      environment.systemPackages = with pkgs; [
        nil
        nixd
        qt6.qtdeclarative
        cargo
        rust-analyzer
        rustc
        gcc
        lua-language-server
        jdk21
        dotnet-sdk_10
      ];

      environment.variables = {
        DOTNET_BIN = "${pkgs.dotnet-sdk_10}/bin/dotnet";
      };

      programs.nix-ld.enable = true;
      # so language servers downloaded by Zed can resolve dynamic libraries without wrapping and work out of the box.
    };
}
