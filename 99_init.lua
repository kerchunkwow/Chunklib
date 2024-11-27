-- Chunklib is the namespace shared by all files in the Chunklib addon
_, Chunklib         = ...

local fr            = Chunklib.fr
local eventHandlers = Chunklib.eventHandlers
local slashCommands = Chunklib.slashCommands

-- chunklib_init.lua will always be the last file in the load order, ensuring it can safely access
-- other files and that the various tables used to accumulate functions and settings for deferred
-- processing will be populated.

-- Loop through Chunklib.init, invoking each function in the table then destroying it
local function initChunklib()
  for label, func in pairs( Chunklib.init ) do
    func()
    Chunklib.init[label] = nil
  end
  -- Unregister for any further ADDON_LOADED events
  -- fr:UnregisterEvent( "ADDON_LOADED" )
  -- eventHandlers["ADDON_LOADED"] = nil
  -- Cleanup the init table itself
  Chunklib.init = nil
end

-- Once we've received ADDON_LOADED for Chunklib, invoke all functions that have been collected in
-- the init table, undefining each after invocation and then the init table itself.
local function _ADDON_LOADED( addonName )
  -- Safeguard against incidental re-entry after the first invocation
  if not Chunklib.init then return end
  if addonName == "Chunklib" then
    -- Start a timer to invoke initChunklib 2 seconds from now
    C_Timer.After( 2, initChunklib )
    -- Start a timer to nil initChunklib 3 seconds from now
    ---@diagnostic disable-next-line: cast-local-type
    C_Timer.After( 3, function () initChunklib = nil end )
  end
end
-- eventHandlers["ADDON_LOADED"] = _ADDON_LOADED

Chunklib.initChunklib = initChunklib

-- Create slash commands as defined in the slashCommands table
for name, data in pairs( slashCommands ) do
  for i, cmd in ipairs( data.cmd ) do
    _G["SLASH_" .. name .. i] = cmd
  end
  SlashCmdList[name] = data.func
end
