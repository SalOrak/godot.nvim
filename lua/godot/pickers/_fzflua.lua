local Godot = require'godot'
local Fzf = require'fzf-lua'
local Path = require'fzf-lua'.path

-- TODO: Sane config defaults for fzf-lua 

local scene_files = " .tscn$"


local get_fullpath = function(selected, opts)
end

local defaults = {
    prompt = "[Godot] Run scene >> ",
	cwd_prompt = false,
    actions = {
        ["default"] = function(selected, opts)
			--- Inspiration from fzf_lua.actions.vimcmd_entry
			local entry = Path.entry_to_file(selected[1], opts, opts._uri)
			if entry.path == "<none>" then return end
			local fullpath = entry.bufname or entry.uri and entry.uri:match("^[%a%-]+://(.*)") or entry.path
			if not fullpath then return end
			if not Path.is_absolute(fullpath) then
				fullpath = Path.join({ opts.cwd or opts._cwd or vim.loop.cwd(), fullpath })
			end

			Godot.run_scene(fullpath)
		end
    },
	previewer = false,
	fd_opts = "--color=never --type f --hidden --follow --exclude .git" .. scene_files,
	find_opts = "--color=never --type f --hidden --follow --exclude .git" .. scene_files,
	rg_opts = "--color=never --files --hidden --follow -g '!.git'" .. scene_files,
	file_icons = false,
}


local picker = function(opts)
	local opts = opts or {}

	local fzf_opts = vim.tbl_deep_extend('force', defaults, opts.fzflua_opts or {})
	local dirs_map = {}

	Fzf.files(fzf_opts)

end


return {
	picker = picker
}
