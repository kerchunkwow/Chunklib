-- #region Chunklib Namespace Import
_, Chunklib = ...

local hlTag = Chunklib.hlTag
-- #endregion

-- chunklib_std.lua implements a "standard library" of useful functions that are not natively
-- implemented in Lua 5.1.

-- #region String Manipulation & Comparisons

-- Get a "clean" player name with no realm data by removing everything after the first non-alpha
-- character (utf8-aware)
local function trimName( name )
  return name:match( "^([%a]+)" ) or name
end

-- Check if a string contains any of a list of multiple substrings
local function strContainsAny( str, substrList )
  for _, substr in ipairs( substrList ) do
    if str:find( substr, 1, true ) then
      return true
    end
  end
  return false
end

-- Return a string with n repetitions of the specified character based on the difference in length
-- between str and pad; pad can be an integer representing the desired length or a string to compare
-- against; align is optional and left by default
local function padStr( str, pad, char, align )
  char = char or " "
  align = align or "left"
  local padLength = 0

  if type( pad ) == "number" then
    padLength = pad - #str
  elseif type( pad ) == "string" then
    padLength = #pad - #str
  end
  if padLength <= 0 then return str end
  local padding = char:rep( padLength )
  if align == "right" then
    return padding .. str
  elseif align == "center" then
    local leftPad = math.floor( padLength / 2 )
    local rightPad = padLength - leftPad
    return char:rep( leftPad ) .. str .. char:rep( rightPad )
  else
    return str .. padding
  end
end

-- Return a string with n repetitions of the specified character, if the optional title string
-- is included, position it in the center of the rule (having truncated 2 plus the length of the
-- string to keep the total length the same)
local function hrule( char, len, title )
  char = char or "-"
  len = len or 40
  if title then
    local titleLen = #title + 2
    local sideLen = math.floor( (len - titleLen) / 2 )
    return char:rep( sideLen ) .. " " .. title .. " " .. char:rep( len - sideLen - titleLen )
  else
    return char:rep( len )
  end
end

-- #endregion

-- #region Table Manipulation & Comparisons

-- Alternative to "next" syntax for testing table emptiness
local function isEmpty( tbl )
  return next( tbl ) == nil
end

-- Check if a value exists in a table
local function isInTable( value, tbl )
  for _, v in pairs( tbl ) do
    if v == value then
      return true
    end
  end
  return false
end

-- Check if a string exists in a list of strings
local function isInList( str, list )
  for _, v in ipairs( list ) do
    if v == str then
      return true
    end
  end
  return false
end

-- Compare two nested tables for equality
local function deepCompare( tbl1, tbl2 )
  if type( tbl1 ) ~= type( tbl2 ) then return false end
  if type( tbl1 ) ~= "table" then return tbl1 == tbl2 end
  for k, v in pairs( tbl1 ) do
    if not deepCompare( v, tbl2[k] ) then
      return false
    end
  end
  for k, v in pairs( tbl2 ) do
    if not deepCompare( v, tbl1[k] ) then
      return false
    end
  end
  return true
end

-- Create a copy of a nested table
local function deepCopy( tbl )
  if type( tbl ) ~= "table" then return tbl end
  local copy = {}
  for k, v in pairs( tbl ) do
    copy[k] = deepCopy( v )
  end
  return copy
end

-- Attempt to convert the data in a nested table into a printable string including newlines and
-- 2-space indentation for readability
local function tableToString( tbl, indent )
  indent = indent or 0
  local spacing = string.rep( "  ", indent )
  local result = "{\n"
  for k, v in pairs( tbl ) do
    local key = tostring( k )
    local value
    if type( v ) == "table" then
      value = tableToString( v, indent + 2 )
    else
      value = tostring( v )
    end
    result = result .. spacing .. "  [" .. key .. "] = " .. value .. ",\n"
  end
  result = result .. spacing .. "}"
  return result
end

-- Use tableToString and consoleOut to send the contents of a table to the developer console
local function tableToConsole( tbl )
  local function highlightString( str )
    -- Example highlighting logic using the global color table (Chunklib.color)
    local colors = Chunklib.color.library
    local highlighted = str
    for colorName, colorData in pairs( colors ) do
      if highlighted:find( colorName ) then
        local colorTag = colorData.txt
        highlighted = highlighted:gsub( colorName, colorTag .. colorName .. "|r" )
      end
    end
    return highlighted
  end

  local formattedTable = tableToString( tbl )
  local highlightedOutput = highlightString( formattedTable )
  Chunklib.console.out( highlightedOutput )
end


-- #endregion

-- #region Integers and Miscellaneous

-- Clamp a value to a specified range; useful in some contexts like constraining UI elements
local function clamp( value, min, max )
  return math.max( min, math.min( max, value ) )
end

-- Given a number n > 999, return an abbreviated string using K, M, B, T, etc. abbreviations;
-- accepts n as an integer or a string
local function abbreviateNumber( n )
  n = tonumber( n )
  if not n then return tostring( n ) end
  local suffixes = {"", "K", "M", "B", "T"}
  local i = 1
  while n >= 1000 and i < #suffixes do
    n = n / 1000
    i = i + 1
  end
  return string.format( "%.1f%s", n, suffixes[i] )
end

-- Given a number n > 999, return a string with commas separating groups of three digits;
-- accepts n as an integer or a string
local function expandNumber( n )
  n = tostring( n )
  local formatted = n:reverse():gsub( "%d%d%d", "%1," )
  formatted = formatted:reverse():gsub( "^,", "" )
  return formatted
end

-- #endregion

-- Add all the functions to the Chunklib namespace
Chunklib.trimName         = trimName
Chunklib.strContainsAny   = strContainsAny
Chunklib.padStr           = padStr
Chunklib.hrule            = hrule
Chunklib.isEmpty          = isEmpty
Chunklib.isInTable        = isInTable
Chunklib.isInList         = isInList
Chunklib.deepCompare      = deepCompare
Chunklib.deepCopy         = deepCopy
Chunklib.tableToString    = tableToString
Chunklib.clamp            = clamp
Chunklib.abbreviateNumber = abbreviateNumber
Chunklib.expandNumber     = expandNumber
