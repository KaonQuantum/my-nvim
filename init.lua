vim.loader.enable()

vim.opt.termguicolors = true
vim.g.mapleader = " "

-- disable unused built-in plugins
vim.g.loaded_netrw        = 1
vim.g.loaded_netrwPlugin  = 1
vim.g.loaded_tutor        = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_zipPlugin    = 1
vim.g.loaded_tarPlugin    = 1
vim.g.loaded_gzip         = 1

-- disable unused providers (nothing in this config needs them)
vim.g.loaded_node_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0

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
vim.opt.showcmd       = false
vim.opt.showmode      = false

-- ── Plugins ────────────────────────────────────────────────
require("lazy").setup({

  -- ── Existing plugins (migrated from vim-plug) ───────────
  { "mrcjkb/rustaceanvim", version = "^9", lazy = false },
  "neovim/nvim-lspconfig",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false, -- nvim-treesitter (main) doesn't support lazy-loading
    config = function()
      require("nvim-treesitter").install({
        "bash", "regex", "rust", "toml", "json", "yaml",
        "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bash", "sh", "rust", "toml", "json", "yaml", "c", "lua", "vim", "markdown" },
        callback = function() vim.treesitter.start() end,
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          preview = {
            treesitter = false,
          },
        },
      })
      require("telescope").load_extension("fzf")
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },

  { "hrsh7th/cmp-nvim-lsp" },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "cmdline" } },
      })
    end,
  },
  { "fruit-in/brainfuck-vim", ft = "brainfuck" },

  -- ── Editing QoL ─────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.splitjoin",
    keys = { { "gS", desc = "Toggle split/join" } },
    opts = {},
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
          todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
          note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    event = "BufReadPre",
    config = function()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ── Theme ───────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "frappe" })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- ── Status bar ──────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      local cd = {
        blue    = "#8caaee",  -- blue
        green   = "#a6d189",  -- green
        mauve   = "#ca9ee6",  -- mauve
        peach   = "#ef9f76",  -- peach
        red     = "#e78284",  -- red
        lavender = "#babbf1", -- lavender
        bg      = "#303446",  -- base
        bg_hl   = "#414559",  -- surface0
        fg      = "#c6d0f5",  -- text
        fg_dark = "#737994",  -- overlay0
      }

      local theme = {
        normal   = { a = { fg = cd.bg, bg = cd.blue,   gui = "bold" }, b = { fg = cd.blue,   bg = cd.bg_hl }, c = { fg = cd.fg_dark, bg = cd.bg } },
        insert   = { a = { fg = cd.bg, bg = cd.green,  gui = "bold" }, b = { fg = cd.green,  bg = cd.bg_hl } },
        visual   = { a = { fg = cd.bg, bg = cd.mauve,  gui = "bold" }, b = { fg = cd.mauve,  bg = cd.bg_hl } },
        command  = { a = { fg = cd.bg, bg = cd.peach,  gui = "bold" }, b = { fg = cd.peach,  bg = cd.bg_hl } },
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
            { function()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and "recording @" .. reg or ""
              end,
            },
          },
          lualine_x = {
            { function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                return table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")
              end,
            },
            "selectioncount", "encoding", "fileformat", "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── Noice ───────────────────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {},
  },

  -- ── File explorer ───────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>t", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
    },
    opts = {
      window = { width = 30 },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
      },
    },
  },

  -- ── Git signs ───────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ── WakaTime ────────────────────────────────────────────
  { "wakatime/vim-wakatime", lazy = false },
}, {
  rocks = { enabled = false }, -- no plugins need luarocks; skip hererocks install
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

-- ── Inlay hints ────────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

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
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>",                                                          { desc = "Next diagnostic" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>",                                                          { desc = "Prev diagnostic" })
map("n", "]e", "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",             { desc = "Next error" })
map("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",             { desc = "Prev error" })

