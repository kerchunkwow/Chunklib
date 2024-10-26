-- #region: Import from Chunklib Namespace
_, Chunklib              = ...

-- #endregion

-- message.lua encapsulates chat & whisper utilities which for now consists primarily of a message
-- queue designed to send messages at a metered rate to avoid triggering Blizzard's chat throttling
-- and allow certain functions to communicate with everyone in a raid.

-- A message object consists of three properties: message, channel, target; target is optional and
-- only applies when channel is WHISPER.

-- Queue to hold unsent messages
local messageQueue       = {}

-- Minimum time to wait between subsequent messages
local messageRate        = 0.25

local processingMessages = false

-- Send a whisper to the specified player
local function sendToPlayer( message, player )
  SendChatMessage( message, "WHISPER", nil, player )
end

-- Send a chat message to the specified channel
local function sendToChannel( message, channel )
  SendChatMessage( message, channel )
end

-- "Pop" the next message off of the queue and send it; if more messages remain, queue another processing
-- call to take place messageRate in the future
local function processMessageQueue()
  local nextMessage = table.remove( messageQueue, 1 )
  if nextMessage then
    if nextMessage.channel == "WHISPER" then
      sendToPlayer( nextMessage.message, nextMessage.target )
    else
      sendToChannel( nextMessage.message, nextMessage.channel )
    end
    C_Timer.After( messageRate, processMessageQueue )
  else
    processingMessages = false
  end
end

-- Add a new message to the message queue; start processing if we're not already
local function queueMessage( message, channel, target )
  -- Add the message to the messageQueue
  table.insert( messageQueue, {message = message, channel = channel, target = target} )
  if not processingMessages then
    processingMessages = true
    C_Timer.After( messageRate, processMessageQueue )
  end
end

-- #region: Namespace Export, Command & Event Registration

Chunklib.queueMessage = queueMessage

-- #endregion
