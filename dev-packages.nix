{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [

    pkgs.pre-commit
    pkgs.tmux
    pkgs.vscode
    pkgs.neovim
    pkgs.git
    pkgs.git-credential-manager
    pkgs.devenv

    ];

}