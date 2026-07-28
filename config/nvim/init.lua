-- Leader key must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.number = true -- show line numbers
vim.opt.termguicolors = true -- 24-bit colour (needed for themes)
vim.opt.mouse = "a" -- enable mouse support in all modes
vim.opt.undofile = true -- persist undo history between sessions
vim.opt.clipboard = "unnamed,unnamedplus" -- use the system clipboard for yank and paste operations
vim.opt.signcolumn = "yes" -- always show the sign column so text doesn't shift
vim.opt.showmode = false -- the statusline displays the current mode
vim.opt.cmdheight = 0 -- hide the command line until it is needed
vim.opt.cursorline = true -- highlight the line under the cursor

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

vim.keymap.set("n", "<space>", "<nop>")

-- Save and quit
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save current buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit current window" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false, -- load during startup
    priority = 1000, -- load before other plugins
    opts = {
      on_highlights = function(highlights, colors)
        highlights.CursorLine = { bg = "#1f2335" }
        highlights.CursorLineNr = { fg = "#737aa2" }
        highlights.VirtColumn = { fg = "#24283b" }
        highlights.SnacksDashboardDesc = { fg = colors.fg_dark }
        highlights.SnacksDashboardFooter = { fg = colors.comment }
        highlights.SnacksDashboardHeader = { fg = colors.blue, bold = true }
        highlights.SnacksDashboardKey = { fg = colors.magenta }
        highlights.SnacksDashboardNormal = { fg = colors.fg, bg = colors.bg }
        highlights.SnacksDashboardSpecial = { fg = colors.purple }
        highlights.SnacksInputBorder = { fg = colors.blue }
        highlights.SnacksInputNormal = { fg = colors.fg, bg = colors.bg }
        highlights.SnacksInputPrompt = { fg = colors.blue }
        highlights.SnacksInputTitle = { fg = colors.blue }
        highlights.SnacksPickerBoxBorder = { fg = colors.blue }
        highlights.SnacksPickerBox = { bg = colors.bg }
        highlights.SnacksPickerInputBorder = { fg = colors.blue }
        highlights.SnacksPickerInput = { bg = colors.bg }
        highlights.SnacksPickerInputTitle = { fg = colors.blue }
        highlights.SnacksPickerListBorder = { fg = colors.blue }
        highlights.SnacksPickerList = { bg = colors.bg }
        highlights.SnacksPickerListCursorLine = { bg = "#1f2335" }
        highlights.SnacksPickerListTitle = { fg = colors.blue }
        highlights.SnacksPickerMatch = { fg = colors.blue, bold = true }
        highlights.SnacksPickerPreviewBorder = { fg = colors.blue }
        highlights.SnacksPickerPreview = { bg = colors.bg }
        highlights.SnacksPickerPreviewTitle = { fg = colors.blue }
        highlights.SnacksPickerPrompt = { fg = colors.blue }
        highlights.SnacksPickerSelected = { fg = colors.orange }
        highlights.SnacksTitle = { fg = colors.blue }
        highlights.WhichKey = { fg = colors.blue }
        highlights.WhichKeyBorder = { fg = colors.blue, bg = colors.bg }
        highlights.WhichKeyDesc = { fg = colors.fg }
        highlights.WhichKeyGroup = { fg = colors.blue, bold = true }
        highlights.WhichKeyNormal = { fg = colors.fg, bg = colors.bg }
        highlights.WhichKeySeparator = { fg = colors.fg_dark }
        highlights.WhichKeyTitle = { fg = colors.blue, bg = colors.bg }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    -- Git change indicators in the sign column
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      local available = {}
      local installing = {}
      local pending = {}

      for _, language in ipairs(treesitter.get_available()) do
        available[language] = true
      end

      local function start(buf, language)
        if vim.api.nvim_buf_is_valid(buf) then
          pcall(vim.treesitter.start, buf, language)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Install and enable Tree-sitter parsers on demand",
        callback = function(event)
          local filetype = vim.bo[event.buf].filetype
          local language = vim.treesitter.language.get_lang(filetype) or filetype

          if not available[language] then
            return
          end

          if vim.treesitter.language.add(language) then
            start(event.buf, language)
            return
          end

          pending[language] = pending[language] or {}
          pending[language][event.buf] = true
          if installing[language] then
            return
          end

          installing[language] = true
          treesitter.install(language):await(function()
            installing[language] = nil
            if vim.treesitter.language.add(language) then
              for buf in pairs(pending[language]) do
                start(buf, language)
              end
            end
            pending[language] = nil
          end)
        end,
      })
    end,
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = "▕",
      highlight = "VirtColumn",
      virtcolumn = "80",
    },
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      bigfile = {},
      explorer = {},
      dashboard = {
        formats = {
          icon = function()
            return { "", width = 0 }
          end,
        },
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
          keys = {
            { key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
            { key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
            { key = "n", desc = "New file", action = ":ene | startinsert" },
            {
              key = "c",
              desc = "Edit config",
              action = function()
                vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
              end,
            },
            { key = "l", desc = "Lazy", action = ":Lazy" },
            { key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header", padding = 1 },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup", icon = "" },
        },
      },
      input = { icon = "" },
      picker = {
        prompt = "> ",
        layout = {
          layout = { backdrop = 41 },
          config = function(layout)
            layout.layout[1].title = "{title} {flags}"
          end,
        },
        icons = {
          files = { enabled = false, dir = "", dir_open = "", file = "" },
          git = { enabled = false },
        },
        sources = {
          explorer = {
            layout = { auto_hide = { "input" } },
          },
          projects = {
            dev = { "~/Developer/repos", "~/Developer/worktrees" },
            format = function(item)
              local path = vim.fn.fnamemodify(item.file, ":~")
              local parent, name = path:match("^(.*[/])([^/]+)$")
              return {
                { parent or "", "SnacksPickerDir" },
                { name or path, "SnacksPickerFile" },
              }
            end,
            max_depth = 4,
            patterns = { ".git" },
            recent = false,
          },
        },
      },
      quickfile = {},
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find text" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      icons = { group = "", mappings = false, rules = false },
      spec = {
        { "<leader>f", group = "Find" },
      },
      show_keys = false,
      win = { title = "Keymaps" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local theme = require("lualine.themes.tokyonight")
      theme.normal.c.bg = "#24283b"
      theme.normal.c.fg = "#737aa2"
      theme.inactive.c.bg = "#24283b"
      theme.inactive.c.fg = "#737aa2"

      return {
        options = {
          theme = theme,
          globalstatus = true,
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(mode) return mode:sub(1, 1) end } },
          lualine_b = { { "branch", icons_enabled = false }, "diff", "diagnostics" },
          lualine_c = { { "filename", path = 3 } },
          lualine_x = {},
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
})
