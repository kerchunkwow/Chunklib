-- #region Import from Chunklib Namespace
_, Chunklib               = ...

-- #endregion Import

-- Global frame object for Chunklib; may only bee needed during development since other addons
-- that use Chunklib will have their own.
Chunklib.fr               = Chunklib.fr or CreateFrame( "Frame" )

-- These tables will be populated throughout other files to accumulate command, function, and event
-- pairings and references to init functions that will be more safely invoked after ADDON_LOADED
Chunklib.slashCommands    = {}
Chunklib.eventHandlers    = {}
Chunklib.init             = {}

-- A table to define a standard set of "tags" for console output that can be used to flag messages
-- by type to distinguish them; especially useful during periods of rapid output from multiple sources
Chunklib.stringHighlights = {}

-- Simplified version of consoleOut to be overidden by later files or other addons; just passes
-- the string unaltered directly to the chat frame.
local function consoleOut( message, tag )
  print( message )
end

-- Invoke all functions in the init table then undefine them and itself
local function invokeInitFunctions()
  for label, func in pairs( Chunklib.init ) do
    func()
    Chunklib.init[label] = nil
  end
  Chunklib.invokeInitFunctions = nil
end

-- #region Chunklib Namespace Export

Chunklib.consoleOut          = consoleOut
Chunklib.invokeInitFunctions = invokeInitFunctions

-- #endregion
