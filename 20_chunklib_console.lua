-- Chunklib is the namespace shared by all files in the Chunklib addon
_, Chunklib = ...

local hlErr = Chunklib.hlErr
-- chunklib_console.lua implements a basic, no-frills developer console for use by Chunklib
-- and other addons; the goal is to serve as an alternative to chat frame output so debug text
-- can be more easily read, navigated, and copy-pasted into other tools

-- Local reference to Chunklib's init table to collect one-time loading & configuration functions
-- called after ADDON_LOADED.
local init  = Chunklib.init

-- Create & apply initial configuration to the components of the developer console
local function initConsole()
  -- Configuration & custom settings
  local consoleConfig = {
    consoleTitle    = "Developer Console",
    initialWidth    = 800,
    initialHeight   = 600,
    fontFace        = "Interface\\AddOns\\Chunklib\\fonts\\veramono.ttf",
    fontSize        = 14,
    backgroundColor = {0, 0, 0, 0.8}, -- Solid black, semi-transparent
    borderColor     = {1, 1, 1, 1},   -- Solid white
  }

  -- Create the console frame
  local consoleFrame = CreateFrame( "Frame", "ChunklibConsoleFrame", UIParent, "BackdropTemplate" )
  consoleFrame:SetSize( consoleConfig.initialWidth, consoleConfig.initialHeight )
  consoleFrame:SetPoint( "CENTER" )
  consoleFrame:SetBackdrop( {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 0,
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4}
  } )
  consoleFrame:SetBackdropColor( unpack( consoleConfig.backgroundColor ) )
  consoleFrame:SetBackdropBorderColor( unpack( consoleConfig.borderColor ) )
  consoleFrame:EnableMouse( true )
  consoleFrame:SetMovable( true )
  consoleFrame:RegisterForDrag( "LeftButton" )
  consoleFrame:SetScript( "OnDragStart", consoleFrame.StartMoving )
  consoleFrame:SetScript( "OnDragStop", consoleFrame.StopMovingOrSizing )

  -- Create the title bar
  local titleBar = consoleFrame:CreateFontString( nil, "OVERLAY", "GameFontNormal" )
  titleBar:SetPoint( "TOP", consoleFrame, "TOP", 0, -10 )
  titleBar:SetText( consoleConfig.consoleTitle )

  -- Create the scrollable text area
  local scrollFrame = CreateFrame( "ScrollFrame", nil, consoleFrame, "UIPanelScrollFrameTemplate" )
  scrollFrame:SetPoint( "TOPLEFT", 10, -30 )
  scrollFrame:SetPoint( "BOTTOMRIGHT", -30, 10 )

  local content = CreateFrame( "Frame", nil, scrollFrame )
  content:SetSize( consoleConfig.initialWidth - 60, consoleConfig.initialHeight - 60 )
  scrollFrame:SetScrollChild( content )

  local textArea = content:CreateFontString( nil, "OVERLAY", "GameFontHighlight" )
  textArea:SetFont( consoleConfig.fontFace, consoleConfig.fontSize )
  textArea:SetJustifyH( "LEFT" )
  textArea:SetJustifyV( "TOP" )
  textArea:SetPoint( "TOPLEFT" )
  textArea:SetWidth( consoleConfig.initialWidth - 60 )

  -- Store references for later use
  consoleFrame.textArea = textArea
  consoleFrame.scrollFrame = scrollFrame

  consoleFrame:Hide()
  Chunklib.consoleFrame = consoleFrame
end

-- "Clearscreen" for the console; delete all text and reset the scroll position if necessary
local function clearConsole()
  if Chunklib.consoleFrame and Chunklib.consoleFrame.textArea then
    Chunklib.consoleFrame.textArea:SetText( "" )
    Chunklib.consoleFrame.scrollFrame:SetVerticalScroll( 0 )
  end
end

-- Write text to the console; wrapping and scrolling as needed
local function consoleOut( text )
  if Chunklib.consoleFrame and Chunklib.consoleFrame.textArea then
    local currentText = Chunklib.consoleFrame.textArea:GetText() or ""
    Chunklib.consoleFrame.textArea:SetText( currentText .. "\n" .. text )
    Chunklib.consoleFrame.scrollFrame:SetVerticalScroll( Chunklib.consoleFrame.scrollFrame
      :GetVerticalScrollRange() )
  end
end

-- Scroll the text area up/down to reveal previous or subsequent output
local function scrollConsole( direction )
  if Chunklib.consoleFrame and Chunklib.consoleFrame.scrollFrame then
    local offset = 20 * (direction or 1)
    local newOffset = Chunklib.consoleFrame.scrollFrame:GetVerticalScroll() + offset
    Chunklib.consoleFrame.scrollFrame:SetVerticalScroll( math.max( 0,
      math.min( newOffset, Chunklib.consoleFrame.scrollFrame:GetVerticalScrollRange() ) ) )
  end
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

-- Hide the console, clearing its content and any other resources
local function closeConsole()
  if Chunklib.consoleFrame then
    clearConsole()
    Chunklib.consoleFrame:Hide()
  end
end

local function printError( str )
  local errStr = hlErr( str )
  consoleOut( errStr )
end
-- Add a temporary slash command to the slash commands table to test printError
Chunklib.slashCommands["PRINT_ERROR"]    = {
  cmd = {"/perr"},
  func = function ()
    printError( "This is a test error message." )
  end,
}
-- Add the console's init function to Chunklib's init table for execution after ADDON_LOADED
init["Developer Console"]                = initConsole

-- Add references to the consoles functions to Chunklib; other Addons may associate them with
-- slash commands (e.g., /cls to clear the console)
Chunklib.console                         = {
  clear  = clearConsole,
  out    = consoleOut,
  scroll = scrollConsole,
  toggle = toggleConsole,
  close  = closeConsole,
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
