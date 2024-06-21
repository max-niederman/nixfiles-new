self: super: {
  plover-wlroots = self.callPackage ./plover-wlroots.nix { };

  wolfram-desktop = self.callPackage ./wolfram-desktop.nix { };

  vscode-extensions = super.vscode-extensions // (with self.vscode-utils; {
    julialang.language-julia = extensionFromVscodeMarketplace {
      name = "language-julia";
      publisher = "julialang";
      version = "1.66.2";
      sha256 = "sha256-CsrVmDOcozZ/8OV+r5SUi86LZMyQDqNk0Makmq3ayBk=";
    };

    icrawl.discord-vscode = extensionFromVscodeMarketplace {
      name = "discord-vscode";
      publisher = "icrawl";
      version = "5.8.0";
      sha256 = "sha256-IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU=";
    };

    sourcegraph.cody-ai = extensionFromVscodeMarketplace {
      name = "cody-ai";
      publisher = "sourcegraph";
      version = "1.11.1711206676";
      sha256 = "sha256-PVR+loiDnGfgr79w8tGh/loiDsSNKBAeC26G7bPqbzQ=";
    };
  });
}
