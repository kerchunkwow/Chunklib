-- #region Chunklib Namespace Import
_, Chunklib           = ...

local init            = Chunklib.init
local highlightString = Chunklib.highlightString
local colors          = Chunklib.colorLibrary

local cf              = Chunklib.consoleFrame
local eb              = cf.editBox
local sf              = cf.scrollFrame
-- #endregion Import

-- chunklib_console.lua implements a basic, no-frills developer console for use by Chunklib
-- and other addons; the goal is to serve as an alternative to chat frame output so debug text
-- can be more easily read, navigated, and copy-pasted into other tools

-- Append the new output to any existing output and scroll to the bottom; type is an optional category
-- string which can be used to highlight the output string by context
local function consoleOut( text, type )
  -- Ensure the highlightString function is safe for use
  text = type and highlightString( text, type ) or text
  local currentText = eb:GetText() or ""
  eb:SetText( currentText .. "\n" .. text )

  -- Scroll to bottom
  C_Timer.After( 0, function ()
    sf:SetVerticalScroll( sf:GetVerticalScrollRange() )
  end )
end

local lastConsoleOut = 0
-- Calls consoleOut only if it has been at least delta seconds since the last time it called consoleOut
local function consoleOutThrottled( text, type, delta )
  local now = GetTime()
  if now - lastConsoleOut > delta then
    consoleOut( text, type )
    lastConsoleOut = now
  end
end

-- Print a nicely-formatted represntation of the value of a variable; useful for debugging
local function consolePrintVar( var, val )
  local valType = type( val )
  if valType ~= "string" then val = tostring( val ) end
  local valString = highlightString( val, valType )
  local varString = highlightString( var, "var" )
  local opString  = highlightString( " == ", "op" )
  local msg       = varString .. opString .. valString
  consoleOut( msg )
end

-- Print a "title line" with horizontal rules
local function consoleTitle( title, char )
  -- Use hyphens by default
  char      = char or "-"
  -- Get right/left parts of the rule with room for a centered title & spaces
  local w   = 80 - (string.len( title ) + 2)
  local hrl = string.rep( char, math.floor( w / 2 ) ) .. " "
  local hrr = " " .. string.rep( char, math.ceil( w / 2 ) )
  consoleOut( hrl .. title .. hrr )
end

-- "Clearscreen" for the console; set its text to an empty string and reset scroll position
local function clearConsole()
  eb:SetText( "" )
  sf:SetVerticalScroll( 0 )
end

-- Toggle visibility of the console; maintain contents by default but wipe if clear parameter is true
local function toggleConsole( clear )
  if Chunklib.consoleFrame then
    if Chunklib.consoleFrame:IsShown() then
      Chunklib.consoleFrame:Hide()
    else
      Chunklib.consoleFrame:Show()
    end
    if clear then
      clearConsole()
    end
  end
end

local function showColorInfo( color )
  -- Local reference to the info string function
  local colorInfoString = Chunklib.colorInfoString

  if color and color ~= "" then
    local infoString = colorInfoString( color )
    consoleOut( infoString, color )
  else
    for c, data in pairs( colors ) do
      local infoString = colorInfoString( c )
      consoleOut( infoString, c )
    end
  end
end

-- Slash Command: /color prints information about a specific color (or all if no parameter is given)
Chunklib.slashCommands["COLOR_INFO"]     = {
  cmd = {"/color"},
  func = function ( color )
    showColorInfo( color )
  end
}

-- Slash Command: /cls clears the output console
Chunklib.slashCommands["CLEAR_CONSOLE"]  = {
  cmd = {"/cls"},
  func = function ()
    clearConsole()
  end,
}

-- Slash Command: /console opens & closes WWRA's output console
Chunklib.slashCommands["CONSOLE_TOGGLE"] = {
  cmd = {"/con"},
  func = function ()
    toggleConsole()
  end,
}

-- Slash Command: /conout writes to the console (mostly for validation)
Chunklib.slashCommands["CONSOLE_OUT"]    = {
  cmd = {"/conout"},
  func = function ( msg )
    consoleOut( msg )
  end
}


Chunklib.consoleOut          = consoleOut
Chunklib.toggleConsole       = toggleConsole
Chunklib.consolePrintVar     = consolePrintVar
Chunklib.consoleTitle        = consoleTitle
Chunklib.clearConsole        = clearConsole
Chunklib.consoleOutThrottled = consoleOutThrottled
