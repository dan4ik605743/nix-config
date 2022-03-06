''
  {
    "languageserver": {
      "nix": {
        "command": "rnix-lsp",
        "filetypes": ["nix"]
      },
      "ccls": {
        "command": "ccls",
        "filetypes": ["c", "cpp", "c++" ],
        "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
        "initializationOptions": {
          "cache": {
            "directory": "/tmp/ccls"
          }
        }
      }
    }
  }
''
