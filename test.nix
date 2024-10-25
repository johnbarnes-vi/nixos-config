  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
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
    ];
    userSettings = {
      "extensions.autoUpdate" = false;
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Dracula";
    };
  };