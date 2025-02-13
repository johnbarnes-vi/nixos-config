{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jb";
  home.homeDirectory = "/home/jb";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your configuration.

    # Rebuild short-hand
    (pkgs.writeShellScriptBin "rb" ''
      if [ $# -ne 1 ]; then
        echo "Usage: rb <target>"
        echo "Available targets: home, workstation"
        exit 1
      fi

      target=$1
      case $target in
        home)
          sudo nixos-rebuild switch --flake ~/nixos#home
          ;;
        workstation)
          sudo nixos-rebuild switch --flake ~/nixos#workstation
          ;;
        *)
          echo "Invalid target: $target"
          echo "Available targets: home, workstation"
          exit 1
          ;;
      esac
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jb/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  # Configure dotfiles
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      "move-to-monitor-down" = ["<Ctrl>Down"];
      "move-to-monitor-up" = ["<Ctrl>Up"];
      "move-to-monitor-left" = ["<Ctrl>Left"];
      "move-to-monitor-right" = ["<Ctrl>Right"];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "tiling-assistant@leleat-on-github"
      ];
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      edge-tiling = true;
      tile-to-grid = true;
      window-gap = 10;
      single-screen-gap = 10;
      modifier-key = "Super";

      # Tiling keybinds
      "center-window" = ["<Ctrl>KP_5"];
      "tile-maximize" = ["<Ctrl>KP_0"];
      "restore-window" = ["<Ctrl>KP_Decimal"];
      "tile-topleft-quarter" = ["<Ctrl>KP_7"];
      "tile-topright-quarter" = ["<Ctrl>KP_9"];
      "tile-top-half" = ["<Ctrl>KP_8"];
      "tile-left-half" = ["<Ctrl>KP_4"];
      "tile-right-half" = ["<Ctrl>KP_6"];
      "tile-bottomleft-quarter" = ["<Ctrl>KP_1"];
      "tile-bottomright-quarter" = ["<Ctrl>KP_3"];
      "tile-bottom-half" = ["<Ctrl>KP_2"];
    };
  };

  # Enable git
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "johnbarnes-vi";
    userEmail = "lj502jr@gmail.com";
  };
}
