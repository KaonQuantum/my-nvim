vim.opt.termguicolors = true
vim.g.mapleader = " "

-- ── Bootstrap lazy.nvim ────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ── Options ────────────────────────────────────────────────
-- (Preserved from init.vim; termguicolors added for theme support)
vim.opt.expandtab     = true
vim.opt.tabstop       = 4
vim.opt.shiftwidth    = 4
vim.opt.softtabstop   = 4
vim.opt.number        = true
vim.opt.relativenumber = true
vim.opt.cursorline    = true
vim.opt.signcolumn    = "yes"
vim.opt.updatetime    = 300

-- ── Plugins ────────────────────────────────────────────────
require("lazy").setup({

  -- ── Existing plugins (migrated from vim-plug) ───────────
  { "mrcjkb/rustaceanvim", version = "^9", lazy = false },
  "neovim/nvim-lspconfig",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          preview = {
            treesitter = false,
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },
  { "fruit-in/brainfuck-vim", ft = "brainfuck" },

  -- ── Theme ───────────────────────────────────────────────
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        italic_comments      = true,
        hide_fillchars       = true,
        borderless_telescope = true,
        overrides = function(p)
          return {
            Keyword                  = { fg = p.orange,  italic = true },
            ["@keyword"]             = { fg = p.orange,  italic = true },
            ["@keyword.function"]    = { fg = p.orange,  italic = true },
            ["@keyword.return"]      = { fg = p.orange,  italic = true },
            ["@keyword.import"]      = { fg = p.orange,  italic = true },
            ["@keyword.modifier"]    = { fg = p.orange,  italic = true },
            ["@keyword.repeat"]      = { fg = p.magenta, italic = true },
            ["@keyword.conditional"] = { fg = p.magenta, italic = true },
            ["@keyword.operator"]    = { fg = p.purple,  italic = true },
          }
        end,
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },

  -- ── Status bar ──────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "scottmckendry/cyberdream.nvim" },
    config = function()
      local cd = {
        cyan    = "#5ef1ff",
        green   = "#5eff6c",
        pink    = "#ff5ef1",
        orange  = "#ffbd5e",
        red     = "#ff6e5e",
        purple  = "#bd5eff",
        bg      = "#16181a",
        bg_hl   = "#1e2124",
        fg      = "#ffffff",
        fg_dark = "#a0a8b0",
      }

      local theme = {
        normal   = { a = { fg = cd.bg, bg = cd.cyan,   gui = "bold" }, b = { fg = cd.cyan,   bg = cd.bg_hl }, c = { fg = cd.fg_dark, bg = cd.bg } },
        insert   = { a = { fg = cd.bg, bg = cd.green,  gui = "bold" }, b = { fg = cd.green,  bg = cd.bg_hl } },
        visual   = { a = { fg = cd.bg, bg = cd.pink,   gui = "bold" }, b = { fg = cd.pink,   bg = cd.bg_hl } },
        command  = { a = { fg = cd.bg, bg = cd.orange, gui = "bold" }, b = { fg = cd.orange, bg = cd.bg_hl } },
        replace  = { a = { fg = cd.bg, bg = cd.red,    gui = "bold" }, b = { fg = cd.red,    bg = cd.bg_hl } },
        inactive = { a = { fg = cd.fg_dark, bg = cd.bg }, b = { fg = cd.fg_dark, bg = cd.bg }, c = { fg = cd.fg_dark, bg = cd.bg } },
      }

      require("lualine").setup({
        options = {
          theme        = theme,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", file_status = true, path = 1,
              symbols = { modified = "●", readonly = "[-]", unnamed = "[No Name]" },
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── Git signs ───────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ── WakaTime ────────────────────────────────────────────
  { "wakatime/vim-wakatime", lazy = false },
})

-- ── Rust globals ───────────────────────────────────────────
vim.g.rustaceanvim = {
  server = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        cargo = { buildScripts = { enable = true } },
        check = { command = "clippy" },
      },
    },
  },
}

-- ── Format on save ────────────────────────────────────────
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- ── Keymaps (preserved verbatim from init.vim) ─────────────
local map = vim.keymap.set

-- Cargo
map("n", "<leader>cb", ":!cargo build<CR>",  { desc = "Cargo build" })
map("n", "<leader>ct", ":!cargo test<CR>",   { desc = "Cargo test"  })
map("n", "<leader>cr", ":!cargo run<CR>",    { desc = "Cargo run"   })
map("n", "<leader>cc", ":!cargo check<CR>",  { desc = "Cargo check" })

-- LSP
map("n", "gd",         "<cmd>lua vim.lsp.buf.definition()<CR>",    { desc = "Go to definition"  })
map("n", "K",          "<cmd>lua vim.lsp.buf.hover()<CR>",          { desc = "Hover docs"        })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",   { desc = "Code action"       })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",        { desc = "Rename symbol"     })
map("n", "<leader>e",  "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostics float" })

