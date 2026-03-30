-- Plugin setup
require("git"):setup { order = 1500 }
require("full-border"):setup { type = ui.Border.ROUNDED }
require("relative-motions"):setup {
	show_numbers = "relative",
	show_motion = true,
	enter_mode = "first",
}
require("bookmarks"):setup {
	last_directory = { enable = true, persist = true, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = true,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
}

-- Flat status bar: nvim/tmux style (no powerline, │ separators, nerd font icons)

local SEP_FG = "#414559" -- surface0, matching nvim lualine separator

function Status:mode()
	local style = self:style()
	local icon, label
	if self._tab.mode.is_select then
		icon = "󰒅"
		label = "SEL"
	elseif self._tab.mode.is_unset then
		icon = "󰜺"
		label = "UNS"
	else
		icon = ""
		label = "NOR"
	end
	return ui.Line {
		ui.Span(" " .. icon .. " " .. label .. " "):style(style.main),
		ui.Span("│"):fg(SEP_FG),
	}
end

function Status:length()
	local h = self._current.hovered
	local size = h and h.cha.len or 0
	return ui.Line {
		ui.Span(" " .. ya.readable_size(size) .. " "):style(self:style().alt),
		ui.Span("│"):fg(SEP_FG),
	}
end

function Status:name()
	local h = self._current.hovered
	if not h then
		return ""
	end
	return ui.Line {
		ui.Span(" " .. ui.printable(h.name)):fg("#8caaee"):bold(),
	}
end

function Status:percent()
	local percent = 0
	local cursor = self._current.cursor
	local length = #self._current.files
	if cursor ~= 0 and length ~= 0 then
		percent = math.floor((cursor + 1) * 100 / length)
	end
	local text
	if percent == 0 then
		text = "Top"
	elseif percent == 100 then
		text = "Bot"
	else
		text = string.format("%2d%%", percent)
	end
	return ui.Line {
		ui.Span(" │"):fg(SEP_FG),
		ui.Span(" " .. text .. " "):style(self:style().alt),
	}
end

function Status:position()
	local cursor = self._current.cursor
	local length = #self._current.files
	return ui.Line {
		ui.Span("│"):fg(SEP_FG),
		ui.Span(string.format(" %2d/%-2d ", math.min(cursor + 1, length), length)):style(self:style().main),
	}
end
