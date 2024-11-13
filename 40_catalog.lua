-- #region Import from Chunklib Namespace
_, Chunklib = ...

local consoleOut = Chunklib.consoleOut

-- #endregion

-- Chunklib_abilityCatalog will be a saved variable designed to accumulate data about all abilities
-- that exist in WoW; the index field will track the identifier of the highest-numbered ability which
-- has been checked and/or cataloged, the data table will map unique ability IDs to tables of data
-- about each ability.

-- Initialize the ability catalog saved variable if not already present
if not Chunklib_abilityCatalog then
  Chunklib_abilityCatalog = {
    index = 0,
    data  = {}
  }
end
-- Flag to control cataloging
Chunklib.isCataloging = false

-- Add or update catalog data related to an ability as identified by its integer id
local function catalogAbilityData( id, data )
  -- Ensure the entry for this id exists
  if not Chunklib_abilityCatalog.data[id] then
    Chunklib_abilityCatalog.data[id] = {}
  end
  -- Update or add each key-value pair from data parameter
  for key, value in pairs( data ) do
    Chunklib_abilityCatalog.data[id][key] = value
  end
end

-- Function to collect and store spell data
local function collectSpellData( id )
  local spellInfo = C_Spell.GetSpellInfo( id )

  if spellInfo then
    local abilityEntry = {
      id       = spellInfo['spellID'],
      name     = spellInfo['name'],
      castTime = spellInfo['castTime'],
      minRange = spellInfo['minRange'],
      maxRange = spellInfo['maxRange'],
    }

    local spellDescription = C_Spell.GetSpellDescription( id )
    if spellDescription and spellDescription ~= "" then
      abilityEntry['description'] = spellDescription
    end
    -- Store boolean on harmful status (helpful is not harmful no need for two values)
    abilityEntry['harmful'] = C_Spell.IsSpellHarmful( id )

    catalogAbilityData( id, abilityEntry )
  end
end

local function requestNextSpellData()
  C_Spell.RequestLoadSpellData( Chunklib_abilityCatalog.index )
end

local function _SPELL_DATA_LOAD_RESULT( spellID, success )
end

-- Slash-command handler to turn the cataloging of ability data on and off
local function toggleCataloging()
  Chunklib.isCataloging = not Chunklib.isCataloging
  local state = Chunklib.isCataloging and "on" or "off"
  -- Based on isCataloging, set local state_color to chartreuse or tomato for on and off
  local state_color = Chunklib.isCataloging and "chartreuse" or "tomato"
  -- Use consoleOut to report status change
  consoleOut( "Ability cataloging " .. state, state_color )
end

-- #region Chunklib Namespace Export

-- Slash Command: /conout writes to the console (mostly for validation)
Chunklib.slashCommands["TOGGLE_CATALOG"] = {
  cmd = {"/clcatalog"},
  func = function ()
    toggleCataloging()
  end
}

Chunklib.eventHandlers["SPELL_DATA_LOAD_RESULT"] = _SPELL_DATA_LOAD_RESULT

-- #endregion
