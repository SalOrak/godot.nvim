local Tele = require("telescope.builtin")
local TActions = require'telescope.actions'
local TState = require'telescope.actions.state'
local Godot = require'godot'

local Cmd = require'godot.command'

local defaults = {
    results_title = false,
    layout_strategy = "center",
    previewer = false,
    layout_config = {
        --preview_cutoff = 1000,
        height = 0.3,
        width = 0.4,
    },
    sorting_strategy = "ascending",
    border = true,
	find_command = Cmd:builder():add("fd"):add("--color=never"):add("--type"):add("f"):add("--follow"):add("--exclude"):add(".git"):add(".tscn$"):build(),
	attach_mappings = function(prompt_bufnr, map)
		TActions.select_default:replace(function()
			TActions.close(prompt_bufnr)
			local selection = TState.get_selected_entry()
			if selection then
				Godot.run_scene(selection[1])
			end
		end)
		return true
	end,
}


local picker = function(opts)
	local opts = opts or {}
    local telescope_opts = vim.tbl_deep_extend('force', defaults, opts.telescope_opts or {})

    -- For compatiblity reasons
    telescope_opts = vim.tbl_deep_extend('force', telescope_opts, opts.theme or {})

	local cwd = vim.uv.cwd()
	local godot_path = Godot.godot_project_path(cwd)
	if not godot_path then 
		return
	end

	-- Godot needs to be launched where the project.godot file lives for
	-- a scene to be properly executed
	telescope_opts.cwd = godot_path

	Tele.fd(telescope_opts)
end


return {
    picker = picker
}
