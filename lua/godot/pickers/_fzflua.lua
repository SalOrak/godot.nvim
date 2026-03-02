local Godot = require'godot'
local Fzf = require'fzf-lua'

-- TODO: Sane config defaults for fzf-lua 

local scene_files = " .tscn$"

local defaults = {
    prompt = "[Godot] Run scene >> ",
    actions = {
        ["default"] = function(selected)
			vim.print(selected)
		end
    },
	fd_opts = "--color=never --type f --hidden --follow --exclude .git" .. scene_files,
	find_opts = "--color=never --type f --hidden --follow --exclude .git" .. scene_files,
	rg_opts = "--color=never --files --hidden --follow -g '!.git'" .. scene_files,
	fn_format_entry = function(entry)
		if entry.alias then
			return (
				"["
				.. entry.alias
				.. "] "
				.. vim.fn.fnamemodify(entry.path, ":t")
			)
		end

		return entry.path
	end
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
