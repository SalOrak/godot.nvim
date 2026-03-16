local Logger = require 'godot.logger'
local CmdBuilder = require 'godot.command'
local Pickers = require 'godot.picker'

local M = {
}

local config = {
	godot_exec = nil, -- Either a Path(String), command(Table) or nil for automatic finding
	picker = "telescope"
}

local data  = {
	last_scene = nil
}

--- Sets the godot executable. 
---@param godot_exec String|table|nil Get the command based on the executable
---path, command or try to find it automatically.
local get_godot_exec = function(godot_exec)
	if type(godot_exec) == "table" then
		return godot_exec
	end

	local res = {}
	if type(godot_exec) == "string" then
		table.insert(res, godot_exec)
	else 
		-- TODO: maybe find more godot executables?
		table.insert(res, "godot")
	end

	return res
end

M.last = function()
	if not data.last_scene then
		Logger:error("Run a scene first to rerun it later with this function.")
		return
	end

	M.run_scene(data.last_scene)
end

--- Runs a scene from neovim
---@param scene String scene filepath
M.run_scene = function(scene)

	local exec = get_godot_exec(config.godot_exec)
	vim.print(exec)

	local cmd = CmdBuilder:builder()

	for _,c in pairs(exec) do
		cmd:add(c)
	end
	cmd:add(scene)

	vim.print(cmd:build())

	local res = vim.system(cmd:build(),{text = true}, on_exit):wait()
	if res.code == 0 then
		data.last_scene = scene
	end
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
	local opts = opts or {}
	config = vim.tbl_deep_extend('force', config, opts)
end


return M
