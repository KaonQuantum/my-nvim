# nvim config

Neovim config built for Rust development. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management — plugins auto-install on first launch.

## Install

```bash
git clone https://github.com/KaonQuantum/my-nvim.git ~/.config/nvim
```

Then open Neovim and lazy.nvim will install everything automatically.

## Keymaps

Leader key is `Space`.

### Cargo
| Key | Action |
|-----|--------|
| `<leader>cb` | `cargo build` |
| `<leader>ct` | `cargo test` |
| `<leader>cr` | `cargo run` |
| `<leader>cc` | `cargo check` |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>e` | Show diagnostics float |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error only |

### Telescope (fuzzy finder)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text in project) |
| `<leader>fb` | Switch buffers |

### File explorer (neo-tree)
| Key | Action |
|-----|--------|
| `<leader>t` | Toggle file tree |
| `H` (inside tree) | Toggle hidden files |

## Statusline (lualine)

`[mode | branch diff diagnostics | filename  macro]`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`[LSP  selectioncount encoding format filetype | progress | line:col]`

- Mode pill changes color per mode (normal=blue, insert=green, visual=pink, command=orange, replace=red)
- Macro indicator appears when recording (`recording @q`)
- LSP shows the active language server for the current file
- Selection count shows chars/lines selected in visual mode

Colors are hardcoded to [catppuccin frappe](https://github.com/catppuccin/nvim) palette. If you switch themes, update the hex values in the lualine section of `init.lua`.

## Plugins

| Plugin | Purpose |
|--------|---------|
| rustaceanvim | Rust LSP, inlay hints, cargo commands |
| nvim-lspconfig | LSP client config |
| nvim-treesitter | Syntax highlighting |
| telescope.nvim | Fuzzy finder |
| nvim-cmp | Autocomplete |
| catppuccin | Colorscheme (frappe) |
| lualine.nvim | Statusline |
| neo-tree.nvim | File explorer sidebar |
| gitsigns.nvim | Git diff signs in gutter |
| vim-wakatime | Coding time tracking (Hackatime) |
| noice.nvim | Replaces cmdline/messages with floating UI |
| brainfuck-vim | Brainfuck syntax support |

## Rust LSP notes

- Runs `clippy` on save (slower than `cargo check` but more thorough)
- `buildScripts` enabled for future `build.rs` support — safe to leave on even if unused
- Formats on save via `rustfmt`
