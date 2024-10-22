-- #region Import from Chunklib Namespace
_, Chunklib      = ...

local colors     = Chunklib.colorLibrary
local highlights = Chunklib.stringHighlights

-- #endregion Import

-- chunklib_color.lua encapsulates all interactions with Chunklibcolors.


-- Tex, or texture colors are used to style WoW UI elements and use RGBA values between 0 and 1
local function colorTex( colorName )
  return colors[colorName].tex
end

-- Hexidecimal equivalent of the color value
local function colorHex( colorName )
  return colors[colorName].hex
end

-- Frequently used text tags for formatting output to chat frames, consoles, and in UI frames
local function colorTxt( colorName )
  return colors[colorName] and colors[colorName].txt or colors["dim_grey"].txt
end

-- This table defines a number of labels that are associated with categories or types of events;
-- these are used by various output functions to establish a consistency in meaning between colors
-- and in-game events or certain types of messages being produced by Addons.
highlights = {
  ["error"]        = colorTxt( "medium_violet_red" ),
  ["err"]          = colorTxt( "medium_violet_red" ),
  ["warning"]      = colorTxt( "dark_orange" ),
  ["warn"]         = colorTxt( "dark_orange" ),
  ["system"]       = colorTxt( "medium_orchid" ),
  ["sys"]          = colorTxt( "medium_orchid" ),
  ["thread"]       = colorTxt( "medium_orchid" ),
  ["info"]         = colorTxt( "royal_blue" ),
  ["debug"]        = colorTxt( "royal_blue" ),
  ["good"]         = colorTxt( "spring_green" ),
  ["success"]      = colorTxt( "spring_green" ),
  ["bad"]          = colorTxt( "indian_red" ),
  ["failure"]      = colorTxt( "indian_red" ),
  ["number"]       = colorTxt( "medium_purple" ),
  ["value"]        = colorTxt( "medium_purple" ),
  ["val"]          = colorTxt( "medium_purple" ),
  ["text"]         = colorTxt( "light_goldenrod" ),
  ["string"]       = colorTxt( "light_goldenrod" ),
  ["function"]     = colorTxt( "yellow_green" ),
  ["func"]         = colorTxt( "yellow_green" ),
  ["operator"]     = colorTxt( "maroon" ),
  ["op"]           = colorTxt( "maroon" ),
  ["player"]       = colorTxt( "deep_sky_blue" ),
  ["name"]         = colorTxt( "deep_sky_blue" ),
  ["enemy"]        = colorTxt( "salmon" ),
  ["target"]       = colorTxt( "salmon" ),
  ["mob"]          = colorTxt( "salmon" ),
  ["boolean"]      = colorTxt( "violet_red" ),
  ["data"]         = colorTxt( "cyan" ),
  ["table"]        = colorTxt( "cyan" ),
  ["userdata"]     = colorTxt( "cyan" ),
  ["variable"]     = colorTxt( "medium_turquoise" ),
  ["var"]          = colorTxt( "medium_turquoise" ),
  ["key"]          = colorTxt( "medium_turquoise" ),
  ["ui"]           = colorTxt( "cadet_blue" ),
  ["magic"]        = colorTxt( "purple" ),
  ["spell"]        = colorTxt( "purple" ),
  -- [ TODO ] Add these to Chunklibcolors eventually w/ other data formats
  ["Death Knight"] = "|cFFC41E3A",
  ["Demon Hunter"] = "|cFFA330C9",
  ["Druid"]        = "|cFFFF7C0A",
  ["Evoker"]       = "|cFF33937F",
  ["Hunter"]       = "|cFFAAD372",
  ["Mage"]         = "|cFF3FC7EB",
  ["Monk"]         = "|cFF00FF98",
  ["Paladin"]      = "|cFFF48CBA",
  ["Priest"]       = "|cFFFFFFFF",
  ["Rogue"]        = "|cFFFFF468",
  ["Shaman"]       = "|cFF0070DD",
  ["Warlock"]      = "|cFF8788EE",
  ["Warrior"]      = "|cFFC69B6D",
}

-- Returns a string with embedded color tags; highlight can be a predefined highlight color from
-- the Chunklib.highLights table or a named color from the ChunklibColors table
local function highlightString( str, highlight )
  local tag = highlights[highlight] or colorTxt( highlight )
  return tag .. str .. "|r"
end

-- Highlight each string in a list with tags for the same color
local function highlightStrings( strList, strColor )
  for i, s in ipairs( strList ) do
    strList[i] = highlightString( s, strColor )
  end
  return strList
end

-- Highlight each string in a list with the corresponding color in an equal-length list of colors
local function highlightLists( strList, colorList )
  for i, s in ipairs( strList ) do
    strList[i] = highlightString( s, colorList[i] )
  end
  return strList
end

-- Get a printable string w/ information about a specific color including: name, hex, rgb, and txt tag;
-- derive text tag by replacing "|cFF" in .txt property, not through conversion of the .hex property
local function colorInfoString( colorName )
  if not colors[colorName] then return nil end
  local color = colors[colorName]
  local tag = color.txt:gsub( "|cFF", "" )
  return string.format( '%s | %s | (%d, %d, %d) | "%s"',
    color.name, colorHex( colorName ), color.rgba.r, color.rgba.g, color.rgba.b, ".cFF" .. tag )
end

-- Get the color tag string associated with a specific class
local function classColor( class )
  return highlights[class]
end

-- #region Chunklib Namespace Export

-- Add references to the color library's functions to Chunklib
Chunklib.classColor       = classColor
Chunklib.highlightString  = highlightString
Chunklib.highlightStrings = highlightStrings
Chunklib.highlightLists   = highlightLists
Chunklib.colorTex         = colorTex
Chunklib.colorHex         = colorHex
Chunklib.colorTxt         = colorTxt
Chunklib.colorInfoString  = colorInfoString

-- #endregion
