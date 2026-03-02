local Logger = require 'godot.logger'
local CmdBuilder = require 'godot.command'
local Pickers = require 'godot.picker'

local config = {
	godot_exec = "godot",
	picker = "telescope"
}

local M = {}

--- Runs a scene from neovim
---@param scene String scene filepath
M.run_scene = function(scene)

	local cmd = CmdBuilder:builder()
	cmd:add(config.godot_exec)
	cmd:add(scene)

	vim.system(cmd:build(),{text = true}, on_exit):wait()
end


M.run = function(opts)

	local opts = opts or {}
	local run_opts = vim.tbl_deep_extend('force', config, opts)

	local picker = Pickers.get_picker(run_opts.picker)
	if picker == nil then
		picker = Pickers.get_picker("telescope") -- Fallback picker
	end

	picker.picker()
end

M.setup = function(opts)
	
end


return M
