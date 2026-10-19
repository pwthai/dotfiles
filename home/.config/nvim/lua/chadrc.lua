-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "akane",
  -- Keep theme-owned floats and popups opaque; init.lua selectively makes
  -- editing surfaces transparent after Base46 loads.
  transparency = false,
}

return M
