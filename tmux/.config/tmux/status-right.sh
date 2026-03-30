#!/usr/bin/env bash
# Dynamic status-right builder for tmux
# Outputs segments with separators, skipping unavailable features.

SEP="│"
segments=()

# --- Online status (via tmux-online-status plugin) ---
ONLINE_SCRIPT="$HOME/.config/tmux/plugins/tmux-online-status/scripts/online_status_icon.sh"
online=$( [ -x "$ONLINE_SCRIPT" ] && "$ONLINE_SCRIPT" 2>/dev/null || echo "nok" )

if [ "$online" = "ok" ]; then
  segments+=("#[fg=#{@thm_mauve}] 󰖩 on ")
else
  segments+=("#[fg=#{@thm_red},bold,reverse] 󰖪 off #[none]")
fi

# --- Memory usage ---
MEMCPU="$HOME/.config/tmux/plugins/tmux-mem-cpu-load/tmux-mem-cpu-load"
if [ -x "$MEMCPU" ]; then
  mem=$("$MEMCPU" -i 2 -m 2 2>/dev/null | awk '{gsub(/[^0-9]/,"",$1); print $1+0}')
  if [ -n "$mem" ]; then
    segments+=("#[fg=#{@thm_blue},bold]  ${mem}% ")
  fi
fi

# --- CPU ---
CPU_SCRIPT="$HOME/.config/tmux/plugins/tmux-cpu/scripts/cpu_percentage.sh"
if [ -x "$CPU_SCRIPT" ]; then
  cpu=$("$CPU_SCRIPT" 2>/dev/null)
  if [ -n "$cpu" ]; then
    segments+=("#[fg=#{@thm_green},bold] 󰍛 ${cpu} ")
  fi
fi

# --- Battery (only if hardware present) ---
if [ -d /sys/class/power_supply/BAT0 ] || [ -d /sys/class/power_supply/BAT1 ] || \
   { [ "$(uname)" = "Darwin" ] && pmset -g batt 2>/dev/null | grep -q "InternalBattery"; }; then
  BATT_SCRIPT="$HOME/.config/tmux/plugins/tmux-battery/scripts/battery_percentage.sh"
  if [ -x "$BATT_SCRIPT" ]; then
    batt=$("$BATT_SCRIPT" 2>/dev/null)
  fi
  if [ -n "$batt" ]; then
    batt_num=${batt%%%}
    if [ "${batt_num:-100}" -le 20 ] 2>/dev/null; then
      segments+=("#[bg=#{@thm_red},fg=default,bold] 󱐋 ${batt} #[none]")
    else
      segments+=("#[fg=#{@thm_red},bold] 󱐋 ${batt} ")
    fi
  fi
fi

# --- IME (macOS only) ---
if [ "$(uname)" = "Darwin" ] && [ -x "$HOME/.config/tmux/ime-status.sh" ]; then
  ime=$("$HOME/.config/tmux/ime-status.sh" 2>/dev/null)
  if [ -n "$ime" ]; then
    segments+=("#[fg=#{@thm_lavender},bold] ${ime} ")
  fi
fi

# --- Date/Time (always) ---
segments+=("#[fg=#{@thm_blue}] 󰭦 $(date '+%Y-%m-%d 󰅐 %H:%M') ")

# --- Join with separators ---
result=""
sep_style="#[bg=default,fg=#{@thm_overlay0},none,bold]"
for i in "${!segments[@]}"; do
  if [ "$i" -gt 0 ]; then
    result+="${sep_style}${SEP}"
  fi
  result+="#[bg=default]${segments[$i]}"
done

printf "%s" "$result"
