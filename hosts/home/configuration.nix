# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  boot.supportedFilesystems = [ "ntfs" ]; # maybe fix this so we can access windows again lol

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };


  networking.hostName = "home"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true; 
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Enable GPU inside docker containers
  hardware.nvidia-container-toolkit.enable = true;

  # Nvidia GPU settings
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable rtl-sdr device usage for non-root users
  hardware.rtl-sdr.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable docker daemon
  virtualisation.docker.enable = true;

  # Enable Powermate controller  
  services.powermate-controller.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jb = {
    isNormalUser = true;
    description = "jb";
    extraGroups = [ "networkmanager" "wheel" "minecraft" "docker" "dialout" "plugdev" ];
    packages = with pkgs; [
      google-chrome
      gimp
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbD147g1OsgWaJbNK9p+EAzYYHpqQYKSSwOO0cHs68UWR0UjVOS7tQRbp8wF8Kmrp0PgztPeL+3iVBxwz27nz/k0JLMAU6XB0+Zh7IFHhsz9zfAZnWiXnp4KrUqom63RDTE1vW3LH8rWpdy+uJOsegAjykK2FowbIhYtfc8uvvrc1fARemgDMjhD7u9edfPB8LBuoJAVFFtvm6NWq/vV0UZUX/it6hz7Eu4ME6fJ339VTsIdo2fkTUXkDnPIrK33wkXx1GUfBRpwDw1u7EJrfbvs7x3IAxrlDWCt0SI6EDCb4GRn3FrGcrEXhVgbKS7+0MfJo2EOxSLamNbL5p0/6UYZnEWteaOrRxVxpSaxEQmCwIwiNu6OdhuEgE8OUuvaHKOyGKhFIkVn7BoBHw5SwIRdMYj+AaCrp6rsuPFuzQw7RSo/5rHVr5trhHZGCaySQrqjIEDztIAmp3sgA3nbATJnJkJMQ7zxFH86nrYNQOg+ch0L28+/+G2Egnyaqvteuw2ceLTXcJ5L00GKaqwYl6aGhjQ3zOgipSMfz7LN2sBSE9QtJ6yh4SY+aZosBvqD6a3T4AzMEdkIBE8gNbn+yB96KnjNfLCGD5qT76bTK7h036n7WYcW20KofmiwIj6l/6fMbjEkvcdpi07sRGaM3dNXKet57mPHhXJ8vigxIF9Q== lj502jr@gmail.com"
    ];
  };
  
  # Enable home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "jb" = import ./home.nix;
    };
  };  

  # Enable automatic login for the user. 
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jb";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install steam.
  programs.steam.enable = true;

  # Enable nix-direnv
  programs.direnv.enable = true;
  programs.bash.interactiveShellInit = ''eval "$(direnv hook bash)"'';

  # Enable nix-ld for vscode-remote
  programs.nix-ld.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environement session variables
  environment.sessionVariables = {
	  FLAKE = "/home/jb/nixos";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.tiling-assistant
    vim
    tree
    spotify
    discord
    teams-for-linux
    prismlauncher #minecraft launcher
    os-prober
    ntfs3g
    qbittorrent
    tmux
    p7zip
    texliveFull
    proj
    geos
    wget
    rtl-sdr
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        mkhl.direnv
        bbenoist.nix
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode.cpptools
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        tomoki1207.pdf
        file-icons.file-icons
        dbaeumer.vscode-eslint
        ms-vscode-remote.remote-ssh
        haskell.haskell
        justusadam.language-haskell
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "esp-idf-extension";
          publisher = "espressif";
          version = "1.9.0";
          sha256 = "sha256-Aym282DsR2a9KPSShcyDJzk5cy/5G9zYy37NO6A6SP8=";
        }
      ];
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Minecraft Server, imperatively mananged plugins (gave up on declarative for now)
  services.minecraft-servers = {
    enable = false; # change to true to enable, obviously <-------------------------------
    eula = true;
    openFirewall = true;

    dataDir = "/var/lib/mc-servers";

    servers = {
      colonial-craft-mc = {
        enable = true;
        openFirewall = true;
        package = pkgs.paperServers.paper-1_21_1; # this should be paper for ideal server
        jvmOpts = "-Xmx16G -Xms8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
        serverProperties = {
          server-port = 7077;
          gamemode = "survival";
          difficulty = "hard";
          max-players = 5;
          motd = "Welcome to ColonialCraftMC!";
          server-name = "ColonialCraftMC";
          level-name = "world-test";
          simulation-distance = 32;
          enforce-secure-profile = false; # for GeyserMC crossplay from bedrock clients
          white-list = false;
        };

        whitelist = {
          OcdJonny = "a62d1f4e-ecf7-4825-b8aa-5db0701e6fa6";
          Stanton__ = "c566f75e-e75f-4c34-a0a6-37975cb67cd4";
        };

        symlinks = {
          "ops.json" = pkgs.writeTextFile {
            name = "ops.json";
            text = builtins.toJSON [
              {
                uuid = "a62d1f4e-ecf7-4825-b8aa-5db0701e6fa6";
                name = "OcdJonny";
                level = 4;
                bypassesPlayerLimit = false;
              }
              {
                uuid = "c566f75e-e75f-4c34-a0a6-37975cb67cd4";
                name = "Stanton__";
                level = 4;
                bypassesPlayerLimit = false;
              }
            ];
          };
        };
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    ports = [7077];
  };


  services.fail2ban.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
