-- groupmanager.lua by @BeyondTeam
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '_You are not bot admin_'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '_Group_* ['..msg.to.title..']*_ is already added_'
end
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "creator" then
if v.user.username then
creator_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = check_markdown(v.user.first_name)
end
end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {[tostring(creator_id)] = user_name},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_edit = 'no',
          lock_mention = 'no',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
		  lock_join = 'no',
		  lock_arabic = 'no',
		  num_msg_max = '5',
		  set_char = '40',
		  time_check = '2',
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photo = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_tgservice = 'no',
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
  return '*Group ['..msg.to.title..'] has been added*'
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '_You are not bot admin_'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '_Group is not added_'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '*Group has been removed*'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "_Group is not added_"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return "_No_ *moderator* _in this group_"
end
   message = '*List of moderators :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "_Group is not added_"
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "_No_ *owner* _in this group_"
end
   message = '*List of owners :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
        return "_Word_ *"..word.."* _is already filtered_"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
      return "_Word_ *"..word.."* _added to filtered words list_"
    end

local function unfilter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
        return "_Word_ *"..word.."* _removed from filtered words list_"
    else
        return "_Word_ *"..word.."* _is not filtered_"
    end
  end

local function lock_link(msg, data, target)
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "*Link* _Posting Is Already Locked_"
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Link* _Posting Has Been Locked_"
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "*Link* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "*Link* _Posting Has Been Unlocked_" 
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "*Tag* _Posting Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Tag* _Posting Has Been Locked_"
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "*Tag* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "*Tag* _Posting Has Been Unlocked_" 
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "*Mention* _Posting Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "*Mention* _Posting Has Been Locked_"
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "*Mention* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "*Mention* _Posting Has Been Unlocked_" 
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "*Arabic/Persian* _Posting Is Already Locked_"
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Arabic/Persian* _Posting Has Been Locked_"
end
end

local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "*Arabic/Persian* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
return "*Arabic/Persian* _Posting Has Been Unlocked_" 
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "*Editing* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Editing* _Has Been Locked_"
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "*Editing* _Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "*Editing* _Has Been Unlocked_" 
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "*Spam* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Spam* _Has Been Locked_"
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "*Spam* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
return "*Spam* _Posting Has Been Unlocked_" 
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "yes" then
 return "*Flooding* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Flooding* _Has Been Locked_"
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"]
 if lock_flood == "no" then
return "*Flooding* _Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_flood"] = "no" save_data(_config.moderation.data, data) 
return "*Flooding* _Has Been Unlocked_" 
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "*Bots* _Protection Is Already Enabled_"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Bots* _Protection Has Been Enabled_"
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "*Bots* _Protection Is Not Enabled_" 
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "*Bots* _Protection Has Been Disabled_" 
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
 return "*Lock Join* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Lock Join* _Has Been Locked_"
end
end

local function unlock_join(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
return "*Lock Join* _Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
return "*Lock Join* _Has Been Unlocked_" 
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*Markdown* _Posting Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Markdown* _Posting Has Been Locked_"
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*Markdown* _Posting Is Not Locked_"
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "*Markdown* _Posting Has Been Unlocked_"
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "*Webpage* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Webpage* _Has Been Locked_"
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "*Webpage* _Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "*Webpage* _Has Been Unlocked_" 
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "*Pinned Message* _Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "*Pinned Message* _Has Been Locked_"
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "*Pinned Message* _Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "*Pinned Message* _Has Been Unlocked_" 
end
end

function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "_You're Not_ *Moderator*"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "*Group Settings:*\n_Lock edit :_ *"..settings.lock_edit.."*\n_Lock links :_ *"..settings.lock_link.."*\n_Lock tags :_ *"..settings.lock_tag.."*\n_Lock Join :_ *"..settings.lock_join.."*\n_Lock flood :_ *"..settings.flood.."*\n_Lock spam :_ *"..settings.lock_spam.."*\n_Lock mention :_ *"..settings.lock_mention.."*\n_Lock arabic :_ *"..settings.lock_arabic.."*\n_Lock webpage :_ *"..settings.lock_webpage.."*\n_Lock markdown :_ *"..settings.lock_markdown.."*\n_Group welcome :_ *"..settings.welcome.."*\n_Lock pin message :_ *"..settings.lock_pin.."*\n_Bots protection :_ *"..settings.lock_bots.."*\n_Flood sensitivity :_ *"..settings.num_msg_max.."*\n_Character sensitivity :_ *"..settings.set_char.."*\n_Flood check time :_ *"..settings.time_check.."*\n*____________________*\n*Bot Channel*: @BeyondTeam"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
text = string.gsub(text, '0', '0⃣')
text = string.gsub(text, '1', '1⃣')
text = string.gsub(text, '2', '2️⃣')
text = string.gsub(text, '3', '3️⃣')
text = string.gsub(text, '4', '4️⃣')
text = string.gsub(text, '5', '5️⃣')
text = string.gsub(text, '6', '6️⃣')
text = string.gsub(text, '7', '7️⃣')
text = string.gsub(text, '8', '8️⃣')
text = string.gsub(text, '9', '9️⃣')
return text
end

--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return "_You're Not_ *Moderator*" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "*Mute All* _Is Already Enabled_" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "*Mute All* _Has Been Enabled_" 
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "_You're Not_ *Moderator*" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "*Mute All* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute All* _Has Been Disabled_"  
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "*Mute Gif* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Gif* _Has Been Enabled_"
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "*Mute Gif* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Gif* _Has Been Disabled_" 
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "*Mute Text* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Text* _Has Been Enabled_"
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "*Mute Text* _Is Already Disabled_"
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Text* _Has Been Disabled_" 
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "*Mute Photo* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Photo* _Has Been Enabled_"
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "*Mute Photo* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Photo* _Has Been Disabled_" 
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "*Mute Video* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "*Mute Video* _Has Been Enabled_"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "*Mute Video* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Video* _Has Been Disabled_" 
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "*Mute Audio* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Audio* _Has Been Enabled_"
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "*Mute Audio* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "*Mute Audio* _Has Been Disabled_"
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "*Mute Voice* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Voice* _Has Been Enabled_"
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "*Mute Voice* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "*Mute Voice* _Has Been Disabled_" 
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "*Mute Sticker* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Sticker* _Has Been Enabled_"
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "*Mute Sticker* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
return "*Mute Sticker* _Has Been Disabled_" 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "*Mute Contact* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Contact* _Has Been Enabled_"
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "*Mute Contact* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Contact* _Has Been Disabled_" 
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "*Mute Forward* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Forward* _Has Been Enabled_"
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "*Mute Forward* _Is Already Disabled_"
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
return "*Mute Forward* _Has Been Disabled_" 
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "*Mute Location* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "*Mute Location* _Has Been Enabled_"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "*Mute Location* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Location* _Has Been Disabled_" 
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "*Mute Document* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute Document* _Has Been Enabled_"
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "*Mute Document* _Is Already Disabled_" 
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute Document* _Has Been Disabled_" 
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "*Mute TgService* _Is Already Enabled_"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*Mute TgService* _Has Been Enabled_"
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "*Mute TgService* _Is Already Disabled_"
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "*Mute TgService* _Has Been Disabled_"
end
end

----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
 	return "_You're Not_ *Moderator*"	
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
 text = " *Group Mute List* : \n_Mute all : _ *"..mutes.mute_all.."*\n_Mute gif :_ *"..mutes.mute_gif.."*\n_Mute text :_ *"..mutes.mute_text.."*\n_Mute photo :_ *"..mutes.mute_photo.."*\n_Mute video :_ *"..mutes.mute_video.."*\n_Mute audio :_ *"..mutes.mute_audio.."*\n_Mute voice :_ *"..mutes.mute_voice.."*\n_Mute sticker :_ *"..mutes.mute_sticker.."*\n_Mute contact :_ *"..mutes.mute_contact.."*\n_Mute forward :_ *"..mutes.mute_forward.."*\n_Mute location :_ *"..mutes.mute_location.."*\n_Mute document :_ *"..mutes.mute_document.."*\n_Mute TgService :_ *"..mutes.mute_tgservice.."*\n*____________________*\n*Bot Channel*: @BeyondTeam"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
 return text
end

local function BeyondTeam(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------Begin Msg Matches--------------
if matches[1] == "gadd" and is_admin(msg) then
return modadd(msg)
   end
if matches[1] == "grem" and is_admin(msg) then
return modrem(msg)
   end
if matches[1] == "ownerlist" and is_mod(msg) then
return ownerlist(msg)
   end
if matches[1] == "filterlist" and is_mod(msg) then
return filter_list(msg)
   end
if matches[1] == "modlist" and is_mod(msg) then
return modlist(msg)
   end
if matches[1] == "whitelist" and is_mod(msg) then
return whitelist(msg.to.id)
   end
if matches[1] == "whois" and matches[2] and is_mod(msg) then
		local user = getUser(matches[2])
		if not user.result then
			return 'User not found'
		end
		user = user.information
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		local text = 'Username: @'..(check_markdown(user.username) or '')..' \nFirstName: '..escape_markdown(user.firstname)..' \nLastName: '..lst_name..' \nBio: '..(escape_markdown(user.bio) or '')
		return text
end
if matches[1] == "res" and matches[2] and is_mod(msg) then
		local user = resolve_username(matches[2])
		if not user.result then
			return 'User not found'
		end
		user = user.information
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		local text = 'Username: @'..(check_markdown(user.username) or '')..' \nFirstName: '..escape_markdown(user.firstname)..' \nLastName: '..lst_name..' \nBio: '..(escape_markdown(user.bio) or '')
		return text
end
if matches[1] == 'beyond' then
return _config.info_text
end
if matches[1] == "id" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, 'Chat ID: '..msg.to.id..'\nUser ID: '..msg.from.id)
	else
   return "*Chat ID :* `"..tostring(msg.to.id).."`\n*User ID :* `"..tostring(msg.from.id).."`"
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return 'User not found'
		end
     return "`"..status.information.id.."`"
   elseif matches[2] == "from" and msg.reply_to_message and msg.reply.fwd_from then
     return "`"..msg.reply.fwd_from.id.."`"
   end
end
if matches[1] == "pin" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*Message Has Been Pinned*"
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*Message Has Been Pinned*"
end
end
if matches[1] == 'unpin' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "*Pin message has been unpinned*"
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "*Pin message has been unpinned*"
end
end
if matches[1] == 'mutelist' then
return mutes(msg, target)
end
if matches[1] == 'settings' then
return group_settings(msg, target)
end
   if matches[1] == "setowner" and is_admin(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _is now_ *group owner*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_User_ "..user_name.." `"..matches[2].."` _is already_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[2].."` _is now_ *group owner*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is now_ *group owner*"
   end
end
end
   if matches[1] == "remowner" and is_admin(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _is no longer_ *group owner*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[2].."` _is no longer_ *group owner*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not_ *group owner*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is no longer_ *group owner*"
      end
end
end
   if matches[1] == "promote" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _is now_ *group moderator*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_User_ "..user_name.." `"..matches[2].."` _is already_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[2].."` _is now_ *group moderator*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is now_ *group moderator*"
   end
end
end
   if matches[1] == "demote" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _is no longer_ *group moderator*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[2].."` _is no longer_ *group moderator*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not_ *group moderator*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is no longer_ *group moderator*"
      end
end
end
   if matches[1] == "whitelist" and matches[2] == "+" and is_mod(msg) then
   if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _added to_ *white list*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_User_ "..user_name.." `"..matches[3].."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = user_name
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[3].."` _added to_ *white list*"
   end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[3]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _added to_ *white list*"
   end
end
end
   if matches[1] == "whitelist" and matches[2] == "-" and is_mod(msg) then
      if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _removed from_ *white list*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_User_ "..user_name.." `"..matches[3].."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[3].."` _removed from_ *white list*"
      end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[3]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _removed_ *white list*"
      end
end
end
if matches[1]:lower() == "lock" and is_mod(msg) then
if matches[2] == "link" then
return lock_link(msg, data, target)
end
if matches[2] == "tag" then
return lock_tag(msg, data, target)
end
if matches[2] == "mention" then
return lock_mention(msg, data, target)
end
if matches[2] == "arabic" then
return lock_arabic(msg, data, target)
end
if matches[2] == "edit" then
return lock_edit(msg, data, target)
end
if matches[2] == "spam" then
return lock_spam(msg, data, target)
end
if matches[2] == "flood" then
return lock_flood(msg, data, target)
end
if matches[2] == "bots" then
return lock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return lock_webpage(msg, data, target)
end
if matches[2] == "pin" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "join" then
return lock_join(msg, data, target)
end
end
if matches[1]:lower() == "unlock" and is_mod(msg) then
if matches[2] == "link" then
return unlock_link(msg, data, target)
end
if matches[2] == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2] == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2] == "arabic" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2] == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2] == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2] == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "pin" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "join" then
return unlock_join(msg, data, target)
end
end
if matches[1]:lower() == "mute" and is_mod(msg) then
if matches[2] == "gif" then
return mute_gif(msg, data, target)
end
if matches[2] == "text" then
return mute_text(msg ,data, target)
end
if matches[2] == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2] == "video" then
return mute_video(msg ,data, target)
end
if matches[2] == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2] == "location" then
return mute_location(msg ,data, target)
end
if matches[2] == "document" then
return mute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'all' then
return mute_all(msg ,data, target)
end
end
if matches[1]:lower() == "unmute" and is_mod(msg) then
if matches[2] == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2] == "text" then
return unmute_text(msg, data, target)
end
if matches[2] == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "video" then
return unmute_video(msg ,data, target)
end
if matches[2] == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "location" then
return unmute_location(msg ,data, target)
end
if matches[2] == "document" then
return unmute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
 if matches[2] == 'all' then
return unmute_all(msg ,data, target)
end
end
  if matches[1] == 'filter' and matches[2] and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'unfilter' and matches[2] and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
		if matches[1] == 'setlink' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_Please send the new group_ *link* _now_'
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "*Newlink* _has been set_"
       end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "_First set a link for group with using_ /setlink"
      end
       text = "[Tap Here To Join ➣ { "..msg.to.title.." }]("..check_markdown(linkgp)..")"
        return text
     end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "*Group rules* _has been set_"
  end
  if matches[1] == "rules" then
 if not data[tostring(target)]['rules'] then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@BeyondTeam"
        else
     rules = "*Group Rules :*\n"..data[tostring(target)]['rules']
      end
    return rules
  end
		if matches[1]:lower() == 'setchar' then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
     return "*Character sensitivity* _has been set to :_ *[ "..matches[2].." ]*"
  end
  if matches[1]:lower() == 'setflood' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ *[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
       end
  if matches[1]:lower() == 'setfloodtime' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "_Wrong number, range is_ *[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _check time has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "_No_ *moderators* _in this group_"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *moderators* _has been demoted_"
         end
			if matches[2] == 'filterlist' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "*Filtered words list* _is empty_"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*Filtered words list* _has been cleaned_"
			end
			if matches[2] == 'rules' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "_No_ *rules* _available_"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "*Group rules* _has been cleaned_"
       end
			if matches[2] == 'welcome' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "*Welcome Message not set*"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "*Welcome message* _has been cleaned_"
       end
			if matches[2] == 'about' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "_No_ *description* _available_"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "*Group description* _has been cleaned_"
		   	end
        end
		if matches[1]:lower() == 'clean' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					return "_No_ *owners* _in this group_"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *owners* _has been demoted_"
			end
     end
if matches[1] == "setname" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
setChatTitle(msg.to.id, gp_name)
end
if matches[1] == 'setphoto' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
     if not msg.caption and not msg.reply_to_message then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_Please send the new group_ *photo* _now_'
     elseif not msg.caption and msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*Photo Saved*"
     elseif msg.caption and not msg.reply_to_message then
if msg.photo then
if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*Photo Saved*"
		end
  end
if matches[1] == "delphoto" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "*Group Photo* _has been_ *removed*"
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "*Group description* _has been set_"
  end
  if matches[1] == "about" and msg.to.type == "group" then
 if not data[tostring(msg.to.id)]['about'] then
     about = "_No_ *description* _available_"
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "del" and is_mod(msg) then
del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
   end
if matches[1] == "config" and is_owner(msg) then
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "administrator" then
if v.user.username then
admins_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = escape_markdown(v.user.first_name)
      end
  data[tostring(msg.to.id)]['mods'][tostring(admins_id)] = user_name
    save_data(_config.moderation.data, data)
    end
  end
    return "_All_ `group admins` _has been_ *promoted*"
end
if matches[1] == 'rmsg' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "*Wrong Number !*\n*Number Should be Between* 1-100 *Numbers !*"
end
print(num)
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
end
--------------------- Welcome -----------------------
	if matches[1] == "welcome" and is_mod(msg) then
		if matches[2] == "enable" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "yes" then
				return "_Group_ *welcome* _is already enabled_"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "_Group_ *welcome* _has been enabled_"
			end
		end
		
		if matches[2] == "disable" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "_Group_ *Welcome* _is already disabled_"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "_Group_ *welcome* _has been disabled_"
			end
		end
	end
	if matches[1] == "setwelcome" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{gpname} Group Name_\n_{rules} ➣ Show Group Rules_\n_{time} ➣ Show time english _\n_{date} ➣ Show date english _\n_{timefa} ➣ Show time persian _\n_{datefa} ➣ show date persian _\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"
	end
-------------Help-------------
  if matches[1] == "help" and is_mod(msg) then
    local text = [[
*Beyond Bot Commands:*

*!gadd* 
_Add Group To Database_

*!grem*
 _Remove Group From Database_

*!setowner* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

*!remowner* `[username|id|reply]` 
 _Remove User From Owner List_

*!promote* `[username|id|reply]` 
_Promote User To Group Admin_

*!demote* `[username|id|reply]` 
_Demote User From Group Admins List_

*!setflood* `[1-50]`
_Set Flooding Number_

*!setchar* `[Number]`
_Set Flooding Characters_

*!setfloodtime* `[1-10]`
_Set Flooding Time_

*!silent* `[username|id|reply]` 
_Silent User From Group_

*!unsilent* `[username|id|reply]` 
_Unsilent User From Group_

*!kick* `[username|id|reply]` 
_Kick User From Group_

*!ban* `[username|id|reply]` 
_Ban User From Group_

*!unban* `[username|id|reply]` 
_UnBan User From Group_

*!whitelist* [+-] `[username|id|reply]` 
_Add Or Remove User From White List_

*!res* `[username]`
_Show User ID_

*!id* `[reply | username]`
_Show User ID_

*!whois* `[id]`
_Show User's Username And Name_

*!lock* `[link | join | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin | cmds]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_If This Actions Unlock, Bot Not Delete Them_

*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

*!set*`[rules | name | photo[also reply] | link | about | welcome]`
_Bot Set Them_

*!clean* `[bans | mods | bots | rules | about | silentlist | filtelist | welcome]`   
_Bot Clean Them_

*!delphoto*
_Delete Group Photo_

*!filter* `[word]`
_Word filter_

*!unfilter* `[word]`
_Word unfilter_

*!pin* `[reply]`
_Pin Your Message_

*!unpin* 
_Unpin Pinned Message_

*!welcome enable/disable*
_Enable Or Disable Group Welcome_

*!settings*
_Show Group Settings_

*!mutelist*
_Show Mutes List_

*!silentlist*
_Show Silented Users List_

*!filterlist*
_Show Filtered Words List_

*!banlist*
_Show Banned Users List_

*!ownerlist*
_Show Group Owners List_ 

*!modlist* 
_Show Group Moderators List_

*!whitelist* 
_Show Group White List Users_

*!rules*
_Show Group Rules_

*!about*
_Show Group Description_

*!id*
_Show Your And Chat ID_

*!gpinfo*
_Show Group Information_

*!link*
_Show Group Link_

*!setwelcome [text]*
_set Welcome Message_

*!helptools*
_Show Tools Help_

_You Can Use_ *[!/]* _To Run The Commands_
_This Help List Only For_ *Moderators/Owners!*
_Its Means, Only Group_ *Moderators/Owners* _Can Use It!_

*Good luck ;)*]]
    return text
  end
----------------End Msg Matches--------------
end
local function pre_process(msg)
-- print(serpent.block(msg, {comment=false}))
local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
    if msg.photo then
  if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
     end
		send_msg(msg.to.id, "*Photo Saved*", msg.id, "md")
  end
	local url , res = http.request('http://api.beyond-dev.ir/time/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		local data = load_data(_config.moderation.data)
 if msg.newuser then
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		wlc = data[tostring(msg.to.id)]['settings']['welcome']
		if wlc == "yes" and tonumber(msg.newuser.id) ~= tonumber(bot.id) then
    if data[tostring(msg.to.id)]['setwelcome'] then
     welcome = data[tostring(msg.to.id)]['setwelcome']
      else
     welcome = "*Welcome Dude*"
     end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@BeyondTeam"
end
if msg.newuser.username then
user_name = "@"..check_markdown(msg.newuser.username)
else
user_name = ""
end
		welcome = welcome:gsub("{rules}", rules)
		welcome = welcome:gsub("{name}", escape_markdown(msg.newuser.print_name))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{time}", jdat.ENtime)
		welcome = welcome:gsub("{date}", jdat.ENdate)
		welcome = welcome:gsub("{timefa}", jdat.FAtime)
		welcome = welcome:gsub("{datefa}", jdat.FAdate)
		welcome = welcome:gsub("{gpname}", msg.to.title)
		send_msg(msg.to.id, welcome, msg.id, "md")
        end
		end
	end
 if msg.newuser then
 if msg.newuser.id == bot.id and is_admin(msg) then
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
   modadd(msg)
   send_msg(msg.to.id, '*Group ['..msg.to.title..'] has been added and group creator is now group owner*', msg.id, "md")
      end
    end
  end
end
return {
  patterns = {
    "^[!/](help)$",
    "^[!/](gadd)$",
    "^[!/](grem)$",
    "^[!/](config)$",
    "^[!/](setowner)$",
    "^[!/](remowner)$",
    "^[!/](setowner) (.*)$",
    "^[!/](remowner) (.*)$",
    "^[!/](promote)$",
    "^[!/](demote)$",
    "^[!/](promote) (.*)$",
	"^[!/](demote) (.*)$",
	"^[!/](whitelist) ([+-])$",
	"^[!/](whitelist) ([+-]) (.*)$",
	"^[!/](whitelist)$",
	"^[!/](lock) (.*)$",
	"^[!/](unlock) (.*)$",
	"^[!/](mute) (.*)$",
	"^[!/](unmute) (.*)$",
	"^[!/](settings)$",
	"^[!/](mutelist)$",
	"^[!/](filter) (.*)$",
	"^[!/](unfilter) (.*)$",
    "^[!/](filterlist)$",
    "^[!/](ownerlist)$",
    "^[!/](modlist)$",
    "^[!/](del)$",
	"^[!/](setrules) (.*)$",
    "^[!/](rules)$",
    "^[!/](setlink)$",
    "^[!/](link)$",
    "^[!/](setphoto)$",
    "^[!/](delphoto)$",
    "^[!/](id)$",
    "^[!/](id) (.*)$",
	"^[!/](res) (.*)$",
	"^[!/](clean) (.*)$",
	"^[!/](setname) (.*)$",
	"^[!/](welcome) (.*)$",
	"^[!/](setwelcome) (.*)$",
	"^[!/](pin)$",
    "^[!/](unpin)$",
    "^[!/](about)$",
	"^[!/](setabout) (.*)$",
    "^[!/](setchar) (%d+)$",
    "^[!/](setflood) (%d+)$",
    "^[!/](setfloodtime) (%d+)$",
    "^[!/](whois) (%d+)$",
    "^[!/](rmsg) (%d+)$",
	"^[!/](beyond)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$"
    },
  run = BeyondTeam,
  pre_process = pre_process
}
