-- Chunklib is the namespace shared by all files in the Chunklib addon
_, Chunklib            = ...

-- Global frame object for Chunklib; may only bee needed during development since other addons
-- that use Chunklib will have their own.
Chunklib.fr            = Chunklib.fr or CreateFrame( "Frame" )

-- These tables will be populated throughout other files to accumulate command, function, and event
-- pairings and references to init functions that will be more safely invoked after ADDON_LOADED
Chunklib.slashCommands = {}
Chunklib.eventHandlers = {}
Chunklib.init          = {}

-- Color library to be populated by chunklib_color.lua
ChunklibColors         = ChunklibColors or {}

-- A table to define a standard set of "tags" for console output that can be used to flag messages
-- by type to distinguish them; especially useful during periods of rapid output from multiple sources
Chunklib.tags          = {}

-- Invoke all functions in the init table then undefine them and itself
local function invokeInitFunctions()
  for label, func in pairs( Chunklib.init ) do
    func()
    Chunklib.init[label] = nil
  end
  Chunklib.invokeInitFunctions = nil
end

local function baseOut( str, type )
  local warriorColor = "|cFFC69B6D"
  local ui = ChunklibColors["cadet_blue"].txt
  local tag = ui .. "[" .. warriorColor .. "Chunklib" .. ui .. "]|r "
  local msgColor = ChunklibColors["gainsboro"].txt
  if type == "error" or type == "err" then
    msgColor = ChunklibColors["medium_violet_red"].txt
  elseif type == "success" or type == "good" then
    msgColor = ChunklibColors["yellow_green"].txt
  end
  local outStr = tag .. msgColor .. str
  DEFAULT_CHAT_FRAME:AddMessage( outStr )
end

-- #region Chunklib Namespace Export

Chunklib.baseOut             = baseOut
Chunklib.invokeInitFunctions = invokeInitFunctions

-- #endregion
