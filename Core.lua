local ADDON, NS = ...

Tweak = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
  profile = {
    positionPlayerFrames = true,
  },
}

local configOptions = {
  name = ADDON,
  handler = Tweak,
  type = 'group',
  args = {
    positionPlayerFrames = {
      name = "Re-position player frames in combat.",
      desc = "Place the player and target frames in HUD-like positions in combat.",
      type = "toggle",
      set = "SetPositionPlayerFrames",
      get = "GetPositionPlayerFrames"
    }
  },
}

function Tweak:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New(ADDON .. "DB", defaults, true)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON, configOptions, {"tweak"})
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON, "Interface Tweaks")
end

function Tweak:OnEnable()
  self:RegisterEvent("PLAYER_REGEN_DISABLED")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function Tweak:OnDisable()
  self:ResetPlayerFrames()
end

function Tweak:PLAYER_REGEN_DISABLED()
  if self.db.profile.positionPlayerFrames then
    self:PositionPlayerFrames()
  end
end

function Tweak:PLAYER_REGEN_ENABLED()
  if self.db.profile.positionPlayerFrames then
    self:ResetPlayerFrames()
  end  
end

function Tweak:GetPositionPlayerFrames(info)
  return self.db.profile.positionPlayerFrames
end

function Tweak:SetPositionPlayerFrames(info, value)
  self.db.profile.positionPlayerFrames = value
end

function Tweak:PositionPlayerFrames()  
  local yOffset = (UIParent:GetHeight() / 5) * -1
  local xOffset = UIParent:GetWidth() / 4
  
  TARGET_FRAME_BUFFS_ON_TOP = true
  TargetFrame:ClearAllPoints()
  TargetFrame:SetPoint("BOTTOMRIGHT", UIParent, "CENTER", xOffset, yOffset)  
  TargetFrame:SetUserPlaced(true)

  PlayerFrame:ClearAllPoints()
  PlayerFrame:SetPoint("BOTTOMLEFT", UIParent, "CENTER", xOffset * -1, yOffset)
  PlayerFrame:SetUserPlaced(true)
end

function Tweak:ResetPlayerFrames()
  TARGET_FRAME_BUFFS_ON_TOP = false
  TargetFrame_ResetUserPlacedPosition()
  PlayerFrame_ResetUserPlacedPosition()
end