-- #region Chunklib Namespace Import
_, Chunklib     = ...

-- #endregion Import

-- console_init.lua encapsulates all of the functions to create and configure the console; this file
-- exists primarily to separate the lengthy script of creating WoW UI elements from the functions that
-- utilize the console to produce output in the game or interact with its components in some way.

--local function initializeConsole()
local config    = {
  width       = 640,
  height      = 480,
  font        = "Interface\\AddOns\\Chunklib\\media\\fonts\\veramono.ttf",
  fontSize    = 14,
  bgColor     = {0, 0, 0, 0.8}, -- Solid black, semi-transparent
  borderColor = {1, 1, 1, 1},   -- Solid white
  title       = "|cFFADFF2FChunklib Console|r",
}

local titleFont = CreateFont( "ChunkTitle" )
titleFont:SetFont( config.font, 12, "" )

-- Create the console frame
local cf = CreateFrame( "Frame", "ChunklibConsoleFrame", UIParent,
  "BackdropTemplate" )
cf:SetSize( config.width, config.height )
cf:SetPoint( "CENTER" )
cf:SetBackdrop( {
  bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile     = false,
  tileSize = 0,
  edgeSize = 16,
  insets   = {left = 4, right = 4, top = 4, bottom = 4}
} )

cf:SetBackdropColor( unpack( config.bgColor ) )
cf:SetBackdropBorderColor( unpack( config.borderColor ) )
cf:SetMovable( true )
cf:SetResizable( true )
cf:SetScript( "OnMouseDown", function ( self, button )
  if button == "RightButton" then
    self:Hide()
  end
end )

-- Create an invisible resize area
local resizer = CreateFrame( "Frame", nil, cf )
resizer:SetPoint( "BOTTOMRIGHT", cf, "BOTTOMRIGHT", 0, 0 )
resizer:SetSize( 20, 20 )
resizer:EnableMouse( true )

-- Create the title bar frame
local titleBar = CreateFrame( "Frame", nil, cf )
titleBar:SetPoint( "TOPLEFT", cf, "TOPLEFT", 0, 0 )
titleBar:SetPoint( "TOPRIGHT", cf, "TOPRIGHT", 0, 0 )
titleBar:SetHeight( 30 )
titleBar:EnableMouse( true )
titleBar:RegisterForDrag( "LeftButton" )
titleBar:SetScript( "OnDragStart", function () cf:StartMoving() end )
titleBar:SetScript( "OnDragStop", function () cf:StopMovingOrSizing() end )

-- Title Text; use ElvUIFontNormal
local title = titleBar:CreateFontString( nil, "OVERLAY" )
title:SetFontObject( titleFont )
title:SetPoint( "CENTER", titleBar, "CENTER" )
title:SetText( config.title )

-- Create the scrollable text area
local sf = CreateFrame( "ScrollFrame", nil, cf, "UIPanelScrollFrameTemplate" )
sf:SetPoint( "TOPLEFT", 10, -30 )
sf:SetPoint( "BOTTOMRIGHT", -30, 10 )

local eb = CreateFrame( "EditBox", nil, sf )
eb:SetMultiLine( true )
-- Make sure not to remove the third parameter (font extra/outline); it's required
eb:SetFont( config.font, config.fontSize, "OUTLINE" )
eb:SetAutoFocus( false )
eb:SetEnabled( true )
eb:EnableMouse( true )
eb:SetScript( "OnEscapePressed", function () Chunklib.toggleConsole() end )
eb:SetWidth( config.width - 60 )
eb:SetPoint( "TOPLEFT" )
eb:SetPoint( "BOTTOMRIGHT" )
eb:SetFrameLevel( cf:GetFrameLevel() + 1 )

sf:SetScrollChild( eb )

resizer:SetScript( "OnMouseDown", function ( self, button )
  if button == "LeftButton" then
    cf:StartSizing( "BOTTOMRIGHT" )
  end
end )

resizer:SetScript( "OnMouseUp", function ( self, button )
  cf:StopMovingOrSizing()
end )

cf:Show()

config                            = nil

Chunklib.consoleFrame             = cf
Chunklib.consoleFrame.editBox     = eb
Chunklib.consoleFrame.scrollFrame = sf
