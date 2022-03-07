''
  {
    "languageserver": {
      "nix": {
        "command": "rnix-lsp",
        "filetypes": ["nix"]
      },
      "clangd": {
        "command": "clangd",
        "rootPatterns": ["compile_flags.txt", "compile_commands.json"],
        "filetypes": ["cpp"]
        }
      }
  }
''
