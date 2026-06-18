-- Glass WoW 3.3.5 Compatibility Layer
-- Provides polyfills for missing APIs in WotLK

local _G = _G

---
-- WOW_PROJECT_ID polyfill for libraries that check for it
if not _G.WOW_PROJECT_ID then
  _G.WOW_PROJECT_ID = 1  -- Mainline/Retail equivalent, but we're on WotLK
  _G.WOW_PROJECT_MAINLINE = 1
  _G.WOW_PROJECT_CLASSIC = 2
end

---
-- Mixin polyfill
-- Copies methods from mixins to the target object
if not _G.Mixin then
  function _G.Mixin(target, ...)
    for i = 1, select("#", ...) do
      local mixin = select(i, ...)
      if mixin then
        for key, value in pairs(mixin) do
          target[key] = value
        end
      end
    end
    return target
  end
end

---
-- MouseIsOver polyfill
-- Checks if the mouse is currently over a frame
if not _G.MouseIsOver then
  function _G.MouseIsOver(frame, topOffset, bottomOffset, leftOffset, rightOffset)
    if not frame:IsVisible() then
      return false
    end
    
    topOffset = topOffset or 0
    bottomOffset = bottomOffset or 0
    leftOffset = leftOffset or 0
    rightOffset = rightOffset or 0
    
    local x, y = GetCursorPosition()
    local scale = frame:GetEffectiveScale()
    x, y = x / scale, y / scale
    
    local left, bottom, width, height = frame:GetRect()
    if not left then return false end
    
    local right = left + width
    local top = bottom + height
    
    left = left + leftOffset
    right = right - rightOffset
    top = top - topOffset
    bottom = bottom + bottomOffset
    
    return x >= left and x <= right and y >= bottom and y <= top
  end
end

---
-- CreateObjectPool polyfill
-- Simple object pooling implementation
if not _G.CreateObjectPool then
  function _G.CreateObjectPool(creationFunc, resetterFunc)
    local pool = {
      objects = {},
      activeObjects = {},
      creationFunc = creationFunc,
      resetterFunc = resetterFunc,
    }
    
    function pool:Acquire()
      local obj
      if #self.objects > 0 then
        obj = table.remove(self.objects)
      else
        obj = self.creationFunc(self)
      end
      self.activeObjects[obj] = true
      return obj
    end
    
    function pool:Release(obj)
      if self.activeObjects[obj] then
        self.activeObjects[obj] = nil
        if self.resetterFunc then
          self.resetterFunc(self, obj)
        end
        table.insert(self.objects, obj)
      end
    end
    
    function pool:ReleaseAll()
      for obj in pairs(self.activeObjects) do
        self:Release(obj)
      end
    end
    
    function pool:GetNumActive()
      local count = 0
      for _ in pairs(self.activeObjects) do
        count = count + 1
      end
      return count
    end
    
    return pool
  end
end

---
-- C_Timer polyfill using OnUpdate frame
-- Provides delayed callback functionality
if not _G.C_Timer then
  local timerFrame = CreateFrame("Frame")
  local timers = {}
  local timerIndex = 0
  
  timerFrame:SetScript("OnUpdate", function(self, elapsed)
    for id, timer in pairs(timers) do
      timer.elapsed = timer.elapsed + elapsed
      if timer.elapsed >= timer.duration then
        if timer.callback then
          timer.callback()
        end
        if timer.repeating then
          timer.elapsed = 0
        else
          timers[id] = nil
        end
      end
    end
  end)
  
  _G.C_Timer = {}
  
  function _G.C_Timer.NewTimer(duration, callback)
    timerIndex = timerIndex + 1
    local id = timerIndex
    timers[id] = {
      duration = duration,
      elapsed = 0,
      callback = callback,
      repeating = false,
    }
    return {
      Cancel = function()
        timers[id] = nil
      end,
      IsCancelled = function()
        return timers[id] == nil
      end,
    }
  end
  
  function _G.C_Timer.NewTicker(duration, callback, iterations)
    timerIndex = timerIndex + 1
    local id = timerIndex
    local count = 0
    timers[id] = {
      duration = duration,
      elapsed = 0,
      callback = function()
        count = count + 1
        callback()
        if iterations and count >= iterations then
          timers[id] = nil
        end
      end,
      repeating = not iterations or count < iterations,
    }
    return {
      Cancel = function()
        timers[id] = nil
      end,
      IsCancelled = function()
        return timers[id] == nil
      end,
    }
  end
  
  function _G.C_Timer.After(duration, callback)
    _G.C_Timer.NewTimer(duration, callback)
  end
end

---
-- SetColorTexture polyfill
-- In 3.3.5, we use SetTexture with solid color files or SetVertexColor
local frameMeta = getmetatable(CreateFrame("Frame")).__index

-- Store original texture methods
local originalSetTexture = nil

-- Add SetColorTexture method to texture objects
local function AddSetColorTexture(texture)
  if texture and not texture.SetColorTexture then
    texture.SetColorTexture = function(self, r, g, b, a)
      -- Use solid white texture and tint it
      self:SetTexture("Interface\\Buttons\\WHITE8x8")
      self:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
    end
  end
  return texture
end

-- Hook CreateTexture to add SetColorTexture method
local originalCreateTexture = frameMeta.CreateTexture
frameMeta.CreateTexture = function(self, name, layer, inherits, subLayer)
  local texture = originalCreateTexture(self, name, layer, inherits, subLayer)
  return AddSetColorTexture(texture)
end

---
-- StopAnimating polyfill
-- Stops all animation groups on a frame
if not frameMeta.StopAnimating then
  frameMeta.StopAnimating = function(self)
    -- In 3.3.5, we need to manually stop known animation groups
    if self.showAg then
      self.showAg:Stop()
    end
    if self.hideAg then
      self.hideAg:Stop()
    end
    -- Generic approach - look for common animation group names
    local agNames = {"introAg", "outroAg", "fadeAg", "slideAg"}
    for _, name in ipairs(agNames) do
      if self[name] and self[name].Stop then
        self[name]:Stop()
      end
    end
  end
end

---
-- SOUNDKIT polyfill
-- In 3.3.5, sounds use different identifiers
if not _G.SOUNDKIT then
  _G.SOUNDKIT = {
    IG_MAINMENU_OPTION = "igMainMenuOption",
    GS_TITLE_OPTION_EXIT = "gsTitleOptionExit",
    IG_CHARACTER_INFO_TAB = "igCharacterInfoTab",
    IG_SPELLBOOK_OPEN = "igSpellBookOpen",
    IG_SPELLBOOK_CLOSE = "igSpellBookClose",
    IG_ABILITY_ICON_DROP = "igAbilityIconDrop",
    U_CHAT_SCROLL_BUTTON = "uChatScrollButton",
  }
end

---
-- BackdropTemplateMixin doesn't exist in 3.3.5
-- Frames use SetBackdrop directly without needing a template
_G.BackdropTemplateMixin = nil

---
-- Hyperlink handling for 3.3.5
-- SetHyperlinksEnabled might work differently
local simpleFrameMeta = getmetatable(CreateFrame("Frame")).__index
if not simpleFrameMeta.SetHyperlinksEnabled then
  simpleFrameMeta.SetHyperlinksEnabled = function(self, enabled)
    -- In 3.3.5, hyperlinks are generally handled via event hooks
    -- This is a no-op placeholder
    self._hyperlinksEnabled = enabled
  end
end

---
-- SetIndentedWordWrap polyfill for FontStrings
-- This feature doesn't exist in 3.3.5, so we skip it
local fontStringMeta = getmetatable(UIParent:CreateFontString()).__index
if not fontStringMeta.SetIndentedWordWrap then
  fontStringMeta.SetIndentedWordWrap = function(self, enabled)
    -- Not available in 3.3.5, silent no-op
  end
end

---
-- Mask texture polyfills (not available in 3.3.5)
if not frameMeta.CreateMaskTexture then
  frameMeta.CreateMaskTexture = function(self)
    -- Return a dummy object that won't crash
    return {
      SetTexture = function() end,
      SetSize = function() end,
      SetPoint = function() end,
      Show = function() end,
      Hide = function() end,
    }
  end
end

local textureMeta = getmetatable(UIParent:CreateTexture()).__index
if not textureMeta.AddMaskTexture then
  textureMeta.AddMaskTexture = function(self, mask)
    -- Not available in 3.3.5, silent no-op
  end
end

---
-- Animation SetSmoothing polyfill (may not exist in 3.3.5)
-- We'll try to safely add it if it doesn't exist
do
  local testFrame = CreateFrame("Frame")
  local testAg = testFrame:CreateAnimationGroup()
  local testAnim = testAg:CreateAnimation("Alpha")
  if testAnim and not testAnim.SetSmoothing then
    local animMeta = getmetatable(testAnim).__index
    if animMeta then
      animMeta.SetSmoothing = function(self, smoothType)
        -- Not available in 3.3.5, silent no-op
      end
    end
  end
end

---
-- FCF_GetNumActiveChatFrames polyfill
if not _G.FCF_GetNumActiveChatFrames then
  function _G.FCF_GetNumActiveChatFrames()
    local count = 0
    for i = 1, NUM_CHAT_WINDOWS do
      local frame = _G["ChatFrame"..i]
      if frame and frame:IsShown() then
        count = count + 1
      end
    end
    return count
  end
end

---
-- IsCombatLog polyfill
if not _G.IsCombatLog then
  function _G.IsCombatLog(chatFrame)
    return chatFrame == _G.ChatFrame2
  end
end

---
-- Print compatibility notice
print("|c00DFBA69Glass|r: WotLK 3.3.5 compatibility layer loaded")
