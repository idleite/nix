{ pkgs, ... }: {
  home.username = "harry";
  home.homeDirectory = "/home/harry";

  # Do not change this value even if you update Home Manager versions
  home.stateVersion = "25.05"; 

  # Packages to install for this user
  home.packages = with pkgs; [
    git
    htop
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  programs.git.settings = {
    enable = true;
    userName = "Harry Esses";
    userEmail = "harryessesdev@harryesses.com";
  };
}
