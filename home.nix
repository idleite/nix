{ pkgs, inputs, ... }: {
  imports = [
    inputs.zen-browser.homeModules.beta
    ./apps/zen.nix
    ./apps/k9s.nix
    ./apps/plasma-manager.nix
  ];
  home.username = "harry";
  home.homeDirectory = "/home/harry";

  # Do not change this value even if you update Home Manager versions
  home.stateVersion = "25.05"; 

  # Packages to install for this user
  home.packages = with pkgs; [
    git
    htop
  ];
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        device_name = "nixt";
      };
    };
  };
  programs.thunderbird.enable = true;
  # programs.git-credential-oauth.enable = true;
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
    programs.git = {
        enable = true;

        settings = {
            init.defaultBranch = "main";
            user.name = "Harry Esses";
            user.email = "harryessesdev@harryesses.com";
            credential = {
              credentialStore = "cache";
              cacheOptions = "--timeout 999999";
              # helper = "manager cache --timeout 21600";
              helper = "manager";
              interactive = "auto";
              guiPrompt = "false";
              # generic.git.harryesses.com
            
            };
            # credential 
        };
    };

}
