-- #region Chunklib Namespace Import
_, Chunklib    = ...

local init     = Chunklib.init
local colorTbl = ChunklibColors
local tags     = Chunklib.tags

-- #endregion

-- chunklib_color.lua creates a global color library mapping named colors to various formats and
-- providing various accessor functions.

-- Each tag consists of a "tag name" and two colors: one for the tag itself and one for the text; this
-- will create a visually distinct output when sending important messages to the console (or chat frames
tags           = {
  ["error"] = {
    tag = "ERR",
    tagColor = "firebrick",
    strColor = "indian_red",
  },
  ["system"] = {
    tag = "SYS",
    tagColor = "deep_pink",
    strColor = "violet",
  },
  ["data"] = {
    tag = "DAT",
    tagColor = "goldenrod",
    strColor = "light_goldenrod",
  },
  ["warning"] = {
    tag = "WRN",
    tagColor = "orange_red",
    strColor = "dark_orange",
  },
  ["debug"] = {
    tag = "DBG",
    tagColor = "royal_blue",
    strColor = "sky_blue",
  },
}

-- Validate that every color in the color library has the expected structure and valid values
local function validateColorLibrary()
  for name, data in pairs( colorTbl ) do
    -- Validate that data.name exists and matches the key
    if data.name ~= name then
      return false
    end
    -- Validate that data.hex exists and is a number
    if type( data.hex ) ~= "number" then
      return false
    end
    -- Validate that data.txt exists and is a string
    if type( data.txt ) ~= "string" then
      return false
    end
    -- Validate that data.rgba exists and has four integer values between 0 and 255
    if type( data.rgba ) ~= "table" or #data.rgba ~= 4 then
      return false
    end
    for _, val in ipairs( data.rgba ) do
      if type( val ) ~= "number" or val < 0 or val > 255 then
        return false
      end
    end
    -- Validate that data.tex exists and has four float values between 0 and 1
    if type( data.tex ) ~= "table" or #data.tex ~= 4 then
      return false
    end
    for _, val in ipairs( data.tex ) do
      if type( val ) ~= "number" or val < 0 or val > 1 then
        return false
      end
    end
  end
  return true
end

-- Highlight a single string with the txt color tag for the named color
local function hl( str, strColor )
  return colorTbl[strColor].txt .. str .. "|r"
end

-- Useful for distinguishing output arriving rapidly from multiple sources, this function "tags"
-- a line of output by prepending it with a formatted string in the form: "[TAG] "
local function hlTag( s, tag, tagColor, strColor )
  local tagL, tagR = hl( "[", "cadet_blue" ), hl( "] ", "cadet_blue" )
  local tagTxt     = hl( tag, tagColor )
  local tagStr     = tagL .. tagTxt .. tagR
  local str        = hl( s, strColor )
  return tagStr .. str
end

-- Highlight each string in a list with tags for the same color
local function hlStrings( strList, strColor )
  for i, s in ipairs( strList ) do
    strList[i] = hl( s, strColor )
  end
  return strList
end

-- Highlight each string in a list with the corresponding color in an equal-length list of colors
local function hlLists( strList, colorList )
  for i, s in ipairs( strList ) do
    strList[i] = hl( s, colorList[i] )
  end
  return strList
end

-- For styling textures and UI elements, get the decimal RGBA values for the named color
local function colorTex( c )
  return colorTbl[c].tex
end

-- For integration with with other hex-based systems, get the hex value of the named color
local function colorHex( c )
  return colorTbl[c].hex
end

-- For styling text in chat and console output, get the string tag for the named color
local function colorTxt( c )
  return colorTbl[c].txt
end

-- If validation of the color library fails, send an error message to the default chat frame with
-- no coloration (duh)
local function initColorLibrary()
  if not validateColorLibrary() then
    Chunklib.baseOut( "Chunklib failed to validate color library", "error" )
  else
    Chunklib.baseOut( "Chunklib validated color library", "success" )
  end
end

-- #region Chunklib Namespace Export

-- Add references to the color library's functions to Chunklib
Chunklib.hl                    = hl
Chunklib.hlStrings             = hlStrings
Chunklib.hlLists               = hlLists
Chunklib.hlTag                 = hlTag
Chunklib.colorTex              = colorTex
Chunklib.colorHex              = colorHex
Chunklib.colorTxt              = colorTxt
Chunklib.validateColorLibrary  = validateColorLibrary

Chunklib.init["Color Library"] = initColorLibrary

-- #endregion
