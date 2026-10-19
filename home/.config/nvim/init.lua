vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
local function safe_dofile(path)
  if vim.loop.fs_stat(path) then
    dofile(path)
  end
end

safe_dofile(vim.g.base46_cache .. "defaults")
safe_dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Keep the editing canvas open to the terminal background without making
-- completion menus, floating windows, diagnostics, or the statusline faint.
local function preserve_highlight_with_background(group, background)
  local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  highlight = ok and highlight or {}
  highlight.bg = background
  highlight.ctermbg = background == "none" and "none" or nil
  vim.api.nvim_set_hl(0, group, highlight)
end

local function preserve_highlight(group, foreground, background)
  local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  highlight = ok and highlight or {}
  highlight.fg = foreground
  highlight.bg = background
  highlight.ctermbg = background == "none" and "none" or nil
  vim.api.nvim_set_hl(0, group, highlight)
end

local function apply_surface_groups(groups, foreground, background)
  for _, group in ipairs(groups) do
    preserve_highlight(group, foreground, background)
  end
end

local function apply_transparency()
  local akane_plum = "#211A24"
  local charcoal_red = "#241B20"
  local deep_crimson = "#7F303A"
  local akane_red = "#E55454"
  local vermilion = "#F07863"
  local lotus_pink = "#EAA0A0"
  local sunset_peach = "#FFB38A"
  local warm_gold = "#F4C27A"
  local warm_ivory = "#F2E3DC"
  local ash_rose = "#AA8588"

  -- The editing canvas inherits Ghostty's translucent Akane Plum background.
  local editor_surfaces = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "FoldColumn",
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",
    "Terminal",
    "TermNormal",
    "NvimTreeNormal",
    "NvimTreeNormalNC",
    "NvimTreeEndOfBuffer",
  }

  for _, group in ipairs(editor_surfaces) do
    preserve_highlight_with_background(group, "none")
  end

  preserve_highlight_with_background("NvimTreeWinSeparator", "none")
  preserve_highlight_with_background("WinSeparator", "none")

  -- Temporary UI stays opaque Charcoal Red for legibility over transparency.
  apply_surface_groups({
    "NormalFloat", "Pmenu", "PmenuSbar", "TelescopeNormal", "LazyNormal",
    "MasonNormal", "NoicePopup", "NoiceCmdlinePopup", "NotifyBackground",
    "WhichKeyNormal", "StatusLine", "StatusLineNC", "TabLine",
    "TabLineFill", "NvimTreeStatusLine", "NvimTreeStatusLineNC",
  }, warm_ivory, charcoal_red)

  apply_surface_groups({
    "FloatBorder", "TelescopeBorder", "LazyBorder", "MasonBorder",
    "NoicePopupBorder", "NoiceCmdlinePopupBorder", "NotifyERRORBorder",
    "NotifyWARNBorder", "NotifyINFOBorder", "NotifyDEBUGBorder",
    "NotifyTRACEBorder", "WhichKeyBorder", "NvimTreeWinSeparator",
    "WinSeparator", "VertSplit",
  }, deep_crimson, charcoal_red)

  apply_surface_groups({ "PmenuSel", "TabLineSel", "TbLineBufOn" }, akane_plum, warm_gold)
  apply_surface_groups({ "Visual", "CursorLine", "LazyButtonActive" }, warm_ivory, deep_crimson)
  apply_surface_groups({ "Search", "IncSearch", "CurSearch" }, akane_plum, warm_gold)
  apply_surface_groups({ "LazyButton", "WhichKeyTitle", "TelescopeSelection" }, warm_ivory, deep_crimson)
  apply_surface_groups({ "TelescopePromptTitle", "TelescopeResultsTitle", "TelescopePreviewTitle" }, akane_plum, akane_red)

  apply_surface_groups({ "LineNr", "LineNrAbove", "LineNrBelow", "FoldColumn" }, ash_rose, "none")
  apply_surface_groups({ "CursorLineNr", "NvimTreeFolderIcon", "NvimTreeOpenedFolderIcon" }, warm_gold, "none")
  apply_surface_groups({ "NvimTreeFolderName", "NvimTreeOpenedFolderName" }, lotus_pink, "none")
  apply_surface_groups({ "NvimTreeRootFolder", "NvimTreeSpecialFile" }, warm_ivory, "none")

  -- Keep file-state recognition independent from Git's foreground colors:
  -- the open file gets a quiet surface, while the cursor row gets a clear plum band.
  preserve_highlight_with_background("NvimTreeOpenedHL", charcoal_red)
  preserve_highlight_with_background("NvimTreeCursorLine", deep_crimson)

  apply_surface_groups({ "DiagnosticError", "DiagnosticSignError" }, akane_red, "none")
  apply_surface_groups({ "DiagnosticWarn", "DiagnosticSignWarn" }, vermilion, "none")
  apply_surface_groups({ "DiagnosticInfo", "DiagnosticSignInfo" }, lotus_pink, "none")
  apply_surface_groups({ "DiagnosticHint", "DiagnosticSignHint" }, warm_gold, "none")
  apply_surface_groups({ "DiagnosticVirtualTextError" }, akane_red, charcoal_red)
  apply_surface_groups({ "DiagnosticVirtualTextWarn" }, vermilion, charcoal_red)
  apply_surface_groups({ "DiagnosticVirtualTextInfo" }, lotus_pink, charcoal_red)
  apply_surface_groups({ "DiagnosticVirtualTextHint" }, warm_gold, charcoal_red)

  apply_surface_groups({ "Comment", "NonText", "Whitespace", "EndOfBuffer" }, ash_rose, "none")
  apply_surface_groups({ "Title", "Directory", "Special" }, warm_gold, "none")
  apply_surface_groups({ "ErrorMsg", "NvimTreeExecFile" }, akane_red, "none")
  apply_surface_groups({ "WarningMsg" }, vermilion, "none")
  apply_surface_groups({ "String" }, sunset_peach, "none")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_transparency,
})

apply_transparency()
vim.schedule(apply_transparency)
