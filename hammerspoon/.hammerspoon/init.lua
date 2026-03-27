local terminalBundleIds = {
  ["com.mitchellh.ghostty"] = true,
  ["com.googlecode.iterm2"] = true,
  ["com.github.wez.wezterm"] = true,
}

SwitchToABC = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() == hs.keycodes.map["b"] and event:getFlags():containExactly({ "ctrl" }) then
    local bundleId = hs.application.frontmostApplication():bundleID()
    if terminalBundleIds[bundleId] then
      hs.keycodes.setLayout("ABC")
    end
  end
  return false
end)
SwitchToABC:start()
