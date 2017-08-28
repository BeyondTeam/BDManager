-- groupmanager.lua by @BeyondTeam
local function modadd(msg)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        if not lang then
        return '_You are not bot admin_'
else
     return 'شما مدیر ربات نمیباشید'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   if not lang then
   return '_Group_* ['..msg.to.title..']*_ is already added_'
else
return 'گروه در لیست گروه های مدیریتی ربات هم اکنون موجود است'
  end
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
		  time_check = '2'
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
				   mute_tgservice = 'no'
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
  if not lang then
    return '*Group ['..escape_markdown(msg.to.title)..'] has been added and group creator is now group owner*'
else
  return 'گروه ['..escape_markdown(msg.to.title)..'] با موفقیت به لیست گروه های مدیریتی ربات افزوده شد'
end
end

local function modrem(msg)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        if not lang then
        return '_You are not bot admin_'
   else
        return 'شما مدیر ربات نمیباشید'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
   if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  if not lang then
  return '*Group has been removed*'
 else
  return 'گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد'
end
end

local function modlist(msg)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    if not lang then
    return "_No_ *moderator* _in this group_"
else
   return "در حال حاضر هیچ مدیری برای گروه انتخاب نشده است"
  end
end
   if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    if not lang then
    return "_No_ *owner* _in this group_"
else
    return "در حال حاضر هیچ مالکی برای گروه انتخاب نشده است"
  end
end
  if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مالکین گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
        if not lang then
         return "_Word_ *"..word.."* _is already filtered_"
            else
         return "_کلمه_ *"..word.."* _از قبل فیلتر بود_"
    end
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
       if not lang then
         return "_Word_ *"..word.."* _added to filtered words list_"
            else
         return "_کلمه_ *"..word.."* _به لیست کلمات فیلتر شده اضافه شد_"
    end
    end

local function unfilter_word(msg, word)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
        if not lang then
         return "_Word_ *"..word.."* _removed from filtered words list_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از لیست کلمات فیلتر شده حذف شد_"
     end
    else
        if not lang then
         return "_Word_ *"..word.."* _is not filtered_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از قبل فیلتر نبود_"
      end
    end
  end

local function lock_link(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "*Link* _Posting Is Already Locked_"
elseif lang then
 return "ارسال لینک در گروه هم اکنون ممنوع است"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Link* _Posting Has Been Locked_"
else
 return "ارسال لینک در گروه ممنوع شد"
end
end
end

local function unlock_link(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "*Link* _Posting Is Not Locked_" 
elseif lang then
return "ارسال لینک در گروه ممنوع نمیباشد"
end 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Link* _Posting Has Been Unlocked_" 
else
return "ارسال لینک در گروه آزاد شد"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "*Tag* _Posting Is Already Locked_"
elseif lang then
 return "ارسال تگ در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag* _Posting Has Been Locked_"
else
 return "ارسال تگ در گروه ممنوع شد"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "*Tag* _Posting Is Not Locked_" 
elseif lang then
return "ارسال تگ در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag* _Posting Has Been Unlocked_" 
else
return "ارسال تگ در گروه آزاد شد"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "*Mention* _Posting Is Already Locked_"
elseif lang then
 return "ارسال فراخوانی افراد هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mention* _Posting Has Been Locked_"
else 
 return "ارسال فراخوانی افراد در گروه ممنوع شد"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "*Mention* _Posting Is Not Locked_" 
elseif lang then
return "ارسال فراخوانی افراد در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Mention* _Posting Has Been Unlocked_" 
else
return "ارسال فراخوانی افراد در گروه آزاد شد"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
if not lang then
 return "*Arabic/Persian* _Posting Is Already Locked_"
elseif lang then
 return "ارسال کلمات عربی/فارسی در گروه هم اکنون ممنوع است"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Arabic/Persian* _Posting Has Been Locked_"
else
 return "ارسال کلمات عربی/فارسی در گروه ممنوع شد"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
if not lang then
return "*Arabic/Persian* _Posting Is Not Locked_" 
elseif lang then
return "ارسال کلمات عربی/فارسی در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Arabic/Persian* _Posting Has Been Unlocked_" 
else
return "ارسال کلمات عربی/فارسی در گروه آزاد شد"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "*Editing* _Is Already Locked_"
elseif lang then
 return "ویرایش پیام هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Editing* _Has Been Locked_"
else
 return "ویرایش پیام در گروه ممنوع شد"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "*Editing* _Is Not Locked_" 
elseif lang then
return "ویرایش پیام در گروه ممنوع نمیباشد"
end 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Editing* _Has Been Unlocked_" 
else
return "ویرایش پیام در گروه آزاد شد"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "*Spam* _Is Already Locked_"
elseif lang then
 return "ارسال هرزنامه در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Spam* _Has Been Locked_"
else
 return "ارسال هرزنامه در گروه ممنوع شد"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "*Spam* _Posting Is Not Locked_" 
elseif lang then
 return "ارسال هرزنامه در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
if not lang then 
return "*Spam* _Posting Has Been Unlocked_" 
else
 return "ارسال هرزنامه در گروه آزاد شد"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "yes" then
if not lang then
 return "*Flooding* _Is Already Locked_"
elseif lang then
 return "ارسال پیام مکرر در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Flooding* _Has Been Locked_"
else
 return "ارسال پیام مکرر در گروه ممنوع شد"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"]
 if lock_flood == "no" then
if not lang then
return "*Flooding* _Is Not Locked_" 
elseif lang then
return "ارسال پیام مکرر در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Flooding* _Has Been Unlocked_" 
else
return "ارسال پیام مکرر در گروه آزاد شد"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "*Bots* _Protection Is Already Enabled_"
elseif lang then
 return "محافظت از گروه در برابر ربات ها هم اکنون فعال است"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Bots* _Protection Has Been Enabled_"
else
 return "محافظت از گروه در برابر ربات ها فعال شد"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "*Bots* _Protection Is Not Enabled_" 
elseif lang then
return "محافظت از گروه در برابر ربات ها غیر فعال است"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Bots* _Protection Has Been Disabled_" 
else
return "محافظت از گروه در برابر ربات ها غیر فعال شد"
end
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
if not lang then
 return "*Lock Join* _Is Already Locked_"
elseif lang then
 return "ورود به گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Lock Join* _Has Been Locked_"
else
 return "ورود به گروه ممنوع شد"
end
end
end

local function unlock_join(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
if not lang then
return "*Lock Join* _Is Not Locked_" 
elseif lang then
return "ورود به گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Lock Join* _Has Been Unlocked_" 
else
return "ورود به گروه آزاد شد"
end 
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "*Markdown* _Posting Is Already Locked_"
elseif lang then
 return "ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Markdown* _Posting Has Been Locked_"
else
 return "ارسال پیام های دارای فونت در گروه ممنوع شد"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "*Markdown* _Posting Is Not Locked_"
elseif lang then
return "ارسال پیام های دارای فونت در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Markdown* _Posting Has Been Unlocked_"
else
return "ارسال پیام های دارای فونت در گروه آزاد شد"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "*Webpage* _Is Already Locked_"
elseif lang then
 return "ارسال صفحات وب در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Webpage* _Has Been Locked_"
else
 return "ارسال صفحات وب در گروه ممنوع شد"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "*Webpage* _Is Not Locked_" 
elseif lang then
return "ارسال صفحات وب در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Webpage* _Has Been Unlocked_" 
else
return "ارسال صفحات وب در گروه آزاد شد"
end
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
if not lang then
 return "*Pinned Message* _Is Already Locked_"
elseif lang then
 return "سنجاق کردن پیام در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Pinned Message* _Has Been Locked_"
else
 return "سنجاق کردن پیام در گروه ممنوع شد"
end
end
end

local function unlock_pin(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
if not lang then
return "*Pinned Message* _Is Not Locked_" 
elseif lang then
return "سنجاق کردن پیام در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Pinned Message* _Has Been Unlocked_" 
else
return "سنجاق کردن پیام در گروه آزاد شد"
end
end
end

function group_settings(msg, target) 	
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 	if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"]
if not lang then
text = "*Group Settings:*\n_Lock edit :_ *"..settings.lock_edit.."*\n_Lock links :_ *"..settings.lock_link.."*\n_Lock tags :_ *"..settings.lock_tag.."*\n_Lock Join :_ *"..settings.lock_join.."*\n_Lock flood :_ *"..settings.flood.."*\n_Lock spam :_ *"..settings.lock_spam.."*\n_Lock mention :_ *"..settings.lock_mention.."*\n_Lock arabic :_ *"..settings.lock_arabic.."*\n_Lock webpage :_ *"..settings.lock_webpage.."*\n_Lock markdown :_ *"..settings.lock_markdown.."*\n_Group welcome :_ *"..settings.welcome.."*\n_Lock pin message :_ *"..settings.lock_pin.."*\n_Bots protection :_ *"..settings.lock_bots.."*\n_Flood sensitivity :_ *"..settings.num_msg_max.."*\n_Character sensitivity :_ *"..settings.set_char.."*\n_Flood check time :_ *"..settings.time_check.."*\n*____________________*\n*Bot Channel*: @BeyondTeam"
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
else
text = "*تنظیمات گروه:*\n_قفل ویرایش پیام :_ *"..settings.lock_edit.."*\n_قفل لینک :_ *"..settings.lock_link.."*\n_قفل ورود :_ *"..settings.lock_join.."*\n_قفل تگ :_ *"..settings.lock_tag.."*\n_قفل پیام مکرر :_ *"..settings.flood.."*\n_قفل هرزنامه :_ *"..settings.lock_spam.."*\n_قفل فراخوانی :_ *"..settings.lock_mention.."*\n_قفل عربی :_ *"..settings.lock_arabic.."*\n_قفل صفحات وب :_ *"..settings.lock_webpage.."*\n_قفل فونت :_ *"..settings.lock_markdown.."*\n_پیام خوشآمد گویی :_ *"..settings.welcome.."*\n_قفل سنجاق کردن :_ *"..settings.lock_pin.."*\n_محافظت در برابر ربات ها :_ *"..settings.lock_bots.."*\n_حداکثر پیام مکرر :_ *"..settings.num_msg_max.."*\n_حداکثر حروف مجاز :_ *"..settings.set_char.."*\n_زمان بررسی پیام های مکرر :_ *"..settings.time_check.."*\n*کانال ما*: @BeyondTeam"
end
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
return text
end

--------Mute all--------------------------
local function mute_all(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "*Mute All* _Is Already Enabled_" 
elseif lang then
return "بیصدا کردن همه فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Enabled_" 
else
return "بیصدا کردن همه فعال شد"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "*Mute All* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن همه غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Disabled_" 
else
return "بیصدا کردن همه غیر فعال شد"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "*Mute Gif* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن تصاویر متحرک فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*Mute Gif* _Has Been Enabled_"
else
 return "بیصدا کردن تصاویر متحرک فعال شد"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "*Mute Gif* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن تصاویر متحرک غیر فعال بود"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Gif* _Has Been Disabled_" 
else
return "بیصدا کردن تصاویر متحرک غیر فعال شد"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "*Mute Text* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن متن فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Text* _Has Been Enabled_"
else
 return "بیصدا کردن متن فعال شد"
end
end
end

local function unmute_text(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
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
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
return "*Mute Text* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن متن غیر فعال است" 
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Text* _Has Been Disabled_" 
else
return "بیصدا کردن متن غیر فعال شد"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
 return "*Mute Photo* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن عکس فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Photo* _Has Been Enabled_"
else
 return "بیصدا کردن عکس فعال شد"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "*Mute Video* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن فیلم فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mute Video* _Has Been Enabled_"
else
 return "بیصدا کردن فیلم فعال شد"
end
end
end

local function unmute_video(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "*Mute Video* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن فیلم غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Video* _Has Been Disabled_" 
else
return "بیصدا کردن فیلم غیر فعال شد"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "*Mute Audio* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن آهنگ فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Audio* _Has Been Enabled_"
else 
return "بیصدا کردن آهنگ فعال شد"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "*Mute Audio* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن آهنک غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Audio* _Has Been Disabled_"
else
return "بیصدا کردن آهنگ غیر فعال شد" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "*Mute Voice* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن صدا فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Voice* _Has Been Enabled_"
else
 return "بیصدا کردن صدا فعال شد"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "*Mute Voice* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن صدا غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Voice* _Has Been Disabled_" 
else
return "بیصدا کردن صدا غیر فعال شد"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "*Mute Sticker* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن برچسب فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Sticker* _Has Been Enabled_"
else
 return "بیصدا کردن برچسب فعال شد"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "*Mute Sticker* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن برچسب غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Sticker* _Has Been Disabled_"
else
return "بیصدا کردن برچسب غیر فعال شد"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "*Mute Contact* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن مخاطب فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Contact* _Has Been Enabled_"
else
 return "بیصدا کردن مخاطب فعال شد"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "*Mute Contact* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن مخاطب غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Contact* _Has Been Disabled_" 
else
return "بیصدا کردن مخاطب غیر فعال شد"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "*Mute Forward* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن نقل قول فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Forward* _Has Been Enabled_"
else
 return "بیصدا کردن نقل قول فعال شد"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "*Mute Forward* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن نقل قول غیر فعال است"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Forward* _Has Been Disabled_" 
else
return "بیصدا کردن نقل قول غیر فعال شد"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "*Mute Location* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن موقعیت فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "*Mute Location* _Has Been Enabled_"
else
 return "بیصدا کردن موقعیت فعال شد"
end
end
end

local function unmute_location(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "*Mute Location* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن موقعیت غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Location* _Has Been Disabled_" 
else
return "بیصدا کردن موقعیت غیر فعال شد"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "*Mute Document* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن اسناد فعال لست"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Document* _Has Been Enabled_"
else
 return "بیصدا کردن اسناد فعال شد"
end
end
end

local function unmute_document(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "*Mute Document* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن اسناد غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Document* _Has Been Disabled_" 
else
return "بیصدا کردن اسناد غیر فعال شد"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "*Mute TgService* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن خدمات تلگرام فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute TgService* _Has Been Enabled_"
else
return "بیصدا کردن خدمات تلگرام فعال شد"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "*Mute TgService* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن خدمات تلگرام غیر فعال است"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute TgService* _Has Been Disabled_"
else
return "بیصدا کردن خدمات تلگرام غیر فعال شد"
end 
end
end

----------MuteList---------
local function mutes(msg, target)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
 	if not lang then
        return "_You're Not_ *Moderator*"
   else
        return 'شما مدیر ربات نمیباشید'
    end	
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
if not lang then 
 text = " *Group Mute List* : \n_Mute all : _ *"..mutes.mute_all.."*\n_Mute gif :_ *"..mutes.mute_gif.."*\n_Mute text :_ *"..mutes.mute_text.."*\n_Mute photo :_ *"..mutes.mute_photo.."*\n_Mute video :_ *"..mutes.mute_video.."*\n_Mute audio :_ *"..mutes.mute_audio.."*\n_Mute voice :_ *"..mutes.mute_voice.."*\n_Mute sticker :_ *"..mutes.mute_sticker.."*\n_Mute contact :_ *"..mutes.mute_contact.."*\n_Mute forward :_ *"..mutes.mute_forward.."*\n_Mute location :_ *"..mutes.mute_location.."*\n_Mute document :_ *"..mutes.mute_document.."*\n_Mute TgService :_ *"..mutes.mute_tgservice.."*\n*____________________*\n*Bot Channel*: @BeyondTeam"
else
 text = " *لیست بیصدا ها* : \n_بیصدا همه : _ *"..mutes.mute_all.."*\n_بیصدا تصاویر متحرک :_ *"..mutes.mute_gif.."*\n_بیصدا متن :_ *"..mutes.mute_text.."*\n_بیصدا عکس :_ *"..mutes.mute_photo.."*\n_بیصدا فیلم :_ *"..mutes.mute_video.."*\n_بیصدا آهنگ :_ *"..mutes.mute_audio.."*\n_بیصدا صدا :_ *"..mutes.mute_voice.."*\n_بیصدا برچسب :_ *"..mutes.mute_sticker.."*\n_بیصدا مخاطب :_ *"..mutes.mute_contact.."*\n_بیصدا نقل قول :_ *"..mutes.mute_forward.."*\n_بیصدا موقعیت :_ *"..mutes.mute_location.."*\n_بیصدا اسناد :_ *"..mutes.mute_document.."*\n_بیصدا خدمات تلگرام :_ *"..mutes.mute_tgservice.."*\n*____________________*\n*Bot channel*: @BeyondTeam"
end
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
 return text
end

local function BeyondTeam(msg, matches)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
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
if matches[1] == "whois" and matches[2] and (matches[2]:match('^%d+') or matches[2]:match('-%d+')) and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, text = '', '', '', '', ''
		local user = getUser(matches[2])
		if not user.result then
		if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '---'

		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		if not lang then
		text = 'Username: '..usr_name..' \nFirstName: '..fst_name..' \nLastName: '..lst_name..' \nBio: '..biotxt
		else
		text = 'نام کاربری: '..usr_name..' \nنام: '..fst_name..' \nنام خانوادگی: '..lst_name..' \nتوضیحات: '..biotxt
		end
		return text
end
if matches[1] == "res" and matches[2] and not matches[2]:match('^%d+') and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, UID, text = '', '', '', '', '', ''
		local user = resolve_username(matches[2])
		if not user.result then
			if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '_Error! Please Try Again._'
			return usr_name
		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.id then
			UID = user.id
		else
			UID = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		if lang then
		text = 'نام کاربری: '..usr_name..' \nشناسه: '..UID..'\nنام: '..fst_name..' \nنام خانوادگی: '..lst_name..' \nتوضیحات: '..biotxt
		else
		text = 'Username: '..usr_name..' \nUser ID: '..UID..'\nFirstName: '..fst_name..' \nLastName: '..lst_name..' \nBio: '..biotxt
		end
		return text
end
if matches[1] == 'beyond' then
return _config.info_text
end
if matches[1] == "id" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
   if lang then
   sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, 'شناسه گروه: '..msg.to.id..'\nشناسه شما: '..msg.from.id)
   else
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, 'Chat ID: '..msg.to.id..'\nUser ID: '..msg.from.id)
	end
	else
	if lang then
	return "*شناسه گروه :* `"..tostring(msg.to.id).."`\n*شناسه شما :* `"..tostring(msg.from.id).."`"
	else
   return "*Chat ID :* `"..tostring(msg.to.id).."`\n*User ID :* `"..tostring(msg.from.id).."`"
   end
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not msg.reply_id and not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
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
if lang then
return 'پیام سنجاق شد.'
else
return "*Message Has Been Pinned*"
end
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
if lang then
return 'پیام سنجاق شد.'
else
return "*Message Has Been Pinned*"
end
end
end
if matches[1] == 'unpin' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
if lang then
return 'سنجاق پیام برداشته شد.'
else
return "*Message Has Been UnPinned*"
end
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
if lang then
return 'سنجاق پیام برداشته شد.'
else
return "*Message Has Been UnPinned*"
end
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
   if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل مالک گروه بود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is already_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _اکنون مالک گروه است._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _is now_ *group owner*"
	end
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
	if lang then
   return "_کاربر_ "..user_name.." `"..matches[2].."` _از قبل مالک گروه بود._"
   else
    return "_User_ "..user_name.." `"..matches[2].."` _is already_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..user_name.." `"..matches[2].."` _اکنون مالک گروه است._"
	else
    return "_User_ "..user_name.." `"..matches[2].."` _is now_ *group owner*"
	end
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
	if lang then
   return "_کاربر_ "..check_markdown(status.username).." `"..status.id.."` _از قبل مالک گروه بود._"
   else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..check_markdown(status.username).." `"..status.id.."` _اکنون مالک گروه است._"
	else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is now_ *group owner*"
	end
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
	if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل مالک گروه نبود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _از مالک گروه برکنار شد._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _is no longer_ *group owner*"
	end
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    if lang then
   return "_کاربر_ "..user_name.." `"..matches[2].."` _از قبل مالک گروه نبود._"
   else
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..user_name.." `"..matches[2].."` _از مالک گروه برکنار شد._"
	else
    return "_User_ "..user_name.." `"..matches[2].."` _is no longer_ *group owner*"
	end
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    if lang then
   return "_کاربر_ "..check_markdown(status.username).." `"..status.id.."` _از قبل مالک گروه نبود._"
   else
    return "_User_ "..check_markdown(status.username).." `"..status.id.."` _is not_ *group owner*"
	end
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..check_markdown(status.username).." `"..status.id.."` _از مالک گروه برکنار شد._"
	else
    return "_User_ "..check_markdown(status.username).." `"..status.id.."` _is no longer_ *group owner*"
	end
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
	if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل مدیر گروه بود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is already_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _اکنون مدیر گروه است._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _is now_ *group moderator*"
	end
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    if lang then
   return "_کاربر_ "..user_name.." `"..matches[2].."` _از قبل مدیر گروه بود._"
   else
    return "_User_ "..user_name.." `"..matches[2].."` _is already_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..user_name.." `"..matches[2].."` _اکنون مدیر گروه است._"
	else
    return "_User_ "..user_name.." `"..matches[2].."` _is now_ *group moderator*"
	end
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    if lang then
   return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از قبل مدیر گروه بود._"
   else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _اکنون مدیر گروه است._"
	else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is now_ *group moderator*"
	end
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
	if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل مدیر گروه نبود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _از مدیر گروه برکنار شد._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _is no longer_ *group moderator*"
	end
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    if lang then
   return "_کاربر_ "..user_name.." `"..matches[2].."` _از قبل مدیر گروه نبود._"
   else
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..user_name.." `"..matches[2].."` _از مدیر گروه برکنار شد._"
	else
    return "_User_ "..user_name.." `"..matches[2].."` _is no longer_ *group moderator*"
	end
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    if lang then
   return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از قبل مدیر گروه نبود._"
   else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not_ *group moderator*"
	end
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از مدیر گروه برکنار شد._"
	else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is no longer_ *group moderator*"
	end
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
	if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل در لیست سفید بود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is already in_ *white list*"
	end
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _اکنون در لیست سفید است._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _added to_ *white list*"
	end
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    if lang then
   return "_کاربر_ "..user_name.." `"..matches[3].."` _از قبل در لیست سفید بود._"
   else
    return "_User_ "..user_name.." `"..matches[3].."` _is already in_ *white list*"
	end
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = user_name
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..user_name.." `"..matches[3].."` _اکنون در لیست سفید است._"
	else
    return "_User_ "..user_name.." `"..matches[3].."` _added to_ *white list*"
	end
   end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[3]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    if lang then
   return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از قبل در لیست سفید بود._"
   else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already in_ *white list*"
	end
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
	if lang then
   return "_کاربر_ "..username.." `"..msg.reply.id.."` _از قبل در لیست سفید نبود._"
   else
    return "_User_ "..username.." `"..msg.reply.id.."` _is not in_ *white list*"
	end
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
	if lang then
	return "_کاربر_ "..username.." `"..msg.reply.id.."` _از لیست سفید حذف شد._"
	else
    return "_User_ "..username.." `"..msg.reply.id.."` _removed from_ *white list*"
	end
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    if lang then
   return "_کاربر_ "..user_name.." `"..matches[3].."` _از قبل در لیست سفید نبود._"
   else
    return "_User_ "..user_name.." `"..matches[3].."` _is not in_ *white list*"
	end
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = nil
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ "..user_name.." `"..matches[3].."` _از لیست سفید حذف شد._"
	else
    return "_User_ "..user_name.." `"..matches[3].."` _removed from_ *white list*"
	end
      end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   if not lang then
			return 'User not found'
		else
			return 'کاربر یافت نشد.'
		end
    end
   local status = resolve_username(matches[3]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    if lang then
   return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از قبل در لیست سفید نبود._"
   else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not in_ *white list*"
	end
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    if lang then
	return "_کاربر_ @"..check_markdown(status.username).." `"..status.id.."` _از لیست سفید حذف شد._"
	else
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _removed from_ *white list*"
	end
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
  if matches[1] == 'newlink' and is_mod(msg) then
  local administration = load_data(_config.moderation.data)
  local link = exportChatInviteLink(msg.to.id)
	if not link then
	if lang then
		return '_خطا! ربات ادمین گروه نیست ویا دسترسی به ایجاد لینک ندارد._'
	else
		return "_Error! Bot is not Admin or not restrict invite link._"
		end
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		if lang then
		return '_لینک جدید ساخنه و ذخیره شد._'
		else
		return "*Newlink Created And Saved.*"
		end
	end
   end
		if matches[1] == 'setlink' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			if lang then
			return '_لطفا لینک جدید را ارسال کنید._'
			else
			return '_Please send the new group_ *link* _now_'
			end
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				if lang then
				return '_لینک جدید ذخیره شد_'
				else
				return "*Newlink* _has been set_"
				end
       end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
	  if lang then
	  return '_لطفا لینک گروه را با دستور_ /setlink یا /newlink _ذخیره کنید_'
	  else
        return "_First set a link for group with using_ /setlink _or send_ /newlink _to export new invite link._"
		end
      end
	  if lang then
	  text = "[برای ورود کلیک کنید ➣ { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
	  else
       text = "[Tap Here To Join ➣ { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
	   end
        return text
     end
    if matches[1] == 'linkpv' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        if lang then
	  return '_لطفا لینک گروه را با دستور_ /setlink یا /newlink _ذخیره کنید_'
	  else
        return "_First set a link for group with using_ /setlink _or send_ /newlink _to export new invite link._"
		end
      end
       if lang then
	  text = "[برای ورود کلیک کنید ➣ { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
	  else
       text = "[Tap Here To Join ➣ { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
	   end
           send_msg(msg.from.id, text, nil, "md")
		   if lang then
		   return '_لینک گروه به چت خصوصی شما ارسال شد_'
		   else
        return "*Group link* _was send in your_ *private chat*"
		end
     end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
	  if lang then
	  return '_قوانین گروه ذخیره شد_'
	  else
    return "*Group rules* _has been set_"
	end
  end
  if matches[1] == "rules" then
 if not data[tostring(target)]['rules'] then
if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban."
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود."
 end
 else
 if lang then
 rules = "*قوانین گروه :*\n"..data[tostring(target)]['rules']
 else
     rules = "*Group Rules :*\n"..data[tostring(target)]['rules']
	 end
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
     if not lang then
     return "*Character sensitivity* _has been set to :_ *[ "..matches[2].." ]*"
   else
     return "_حداکثر حروف مجاز در پیام تنظیم شد به :_ *[ "..matches[2].." ]*"
		end
  end
  if matches[1]:lower() == 'setflood' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
			if not lang then
				return "_Wrong number, range is_ *[2-50]*"
				else
				return '_عدد باید بین 1 - 50 باشد_'
				end
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    if not lang then
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
    else
    return '_محدودیت پیام مکرر به_ *'..tonumber(matches[2])..'* _تنظیم شد._'
    end
       end
  if matches[1]:lower() == 'setfloodtime' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 10 then
				if not lang then
				return "_Wrong number, range is_ *[2-50]*"
				else
				return '_عدد باید بین 1 - 10 باشد_'
				end
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _check time has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "هیچ مدیری برای گروه انتخاب نشده است"
				end
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            return "تمام مدیران گروه تنزیل مقام شدند"
			end
         end
			if matches[2] == 'filterlist' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					if not lang then
					return "*Filtered words list* _is empty_"
         else
					return "_لیست کلمات فیلتر شده خالی است_"
             end
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				if not lang then
				return "*Filtered words list* _has been cleaned_"
           else
				return "_لیست کلمات فیلتر شده پاک شد_"
           end
			end
			if matches[2] == 'rules' then
				if not data[tostring(msg.to.id)]['rules'] then
					if not lang then
					return "_No_ *rules* _available_"
             else
               return "قوانین برای گروه ثبت نشده است"
             end
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "قوانین گروه پاک شد"
			end
       end
			if matches[2] == 'welcome' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					if not lang then
					return "*Welcome Message not set*"
             else
               return "پیام خوشآمد گویی ثبت نشده است"
             end
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				if not lang then
				return "*Welcome message* _has been cleaned_"
          else
            return "پیام خوشآمد گویی پاک شد"
			end
       end
			if matches[2] == 'about' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					if not lang then
					return "_No_ *description* _available_"
            else
              return "پیامی مبنی بر درباره گروه ثبت نشده است"
          end
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "پیام مبنی بر درباره گروه پاک شد"
             end
		   	end
        end
		if matches[1]:lower() == 'clean' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "مالکی برای گروه انتخاب نشده است"
            end
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "تمامی مالکان گروه تنزیل مقام شدند"
          end
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
			if not lang then
			return '_Please send the new group_ *photo* _now_'
			else
			return '_لطفا عکس جدید را ارسال کنید_'
			end
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
	if lang then
	return '_عکس پروفایل گروه تعویض شد_'
	else
  return "*Photo Saved*"
  end
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
if not lang then
  return "*Group Photo* _has been_ *removed*"
  else
  return '_عکس پروفایل گروه حذف شد_'
  end
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    if not lang then
    return "*Group description* _has been set_"
    else
     return "پیام مبنی بر درباره گروه ثبت شد"
      end
  end
  if matches[1] == "about" and msg.to.type == "group" then
 if not data[tostring(msg.to.id)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "پیامی مبنی بر درباره گروه ثبت نشده است"
       end
        else
		if not lang then
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
	 else
	 about = "*توضیحات گروه :*\n"..data[tostring(chat)]['about']
	 end
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
  if not lang then
    return "_All_ `group admins` _has been_ *promoted*"
	else
	return '_تمامی ادمین های گزوه به مدیر ربات ارتقا داده شدند_'
	end
end
if matches[1] == 'rmsg' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
if not lang then
				return "*Wrong Number !*\n*Number Should be Between* 1-100 *Numbers !*"
				else
				return '_عدد باید بین 1 - 100 باشد_'
				end
end
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
end
--------------------- Welcome -----------------------
	if matches[1] == "welcome" and is_mod(msg) then
		if matches[2] == "enable" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "yes" then
				if not lang then
				return "_Group_ *welcome* _is already enabled_"
       elseif lang then
				return "_خوشآمد گویی از قبل فعال بود_"
           end
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				if not lang then
				return "_Group_ *welcome* _has been enabled_"
       elseif lang then
				return "_خوشآمد گویی فعال شد_"
          end
			end
		end
		
		if matches[2] == "disable" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				if not lang then
				return "_Group_ *Welcome* _is already disabled_"
      elseif lang then
				return "_خوشآمد گویی از قبل فعال نبود_"
         end
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				if not lang then
				return "_Group_ *welcome* _has been disabled_"
      elseif lang then
				return "_خوشآمد گویی غیرفعال شد_"
          end
			end
		end
	end
	if matches[1] == "setwelcome" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		if not lang then
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{gpname} Group Name_\n_{rules} ➣ Show Group Rules_\n_{time} ➣ Show time english _\n_{date} ➣ Show date english _\n_{timefa} ➣ Show time persian _\n_{datefa} ➣ show date persian _\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"
       else
		return "_پیام خوشآمد گویی تنظیم شد به :_\n*"..matches[2].."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{rules} ➣ نمایش قوانین گروه_\n_{time} ➣ ساعت به زبان انگلیسی _\n_{date} ➣ تاریخ به زبان انگلیسی _\n_{timefa} ➣ ساعت به زبان فارسی _\n_{datefa} ➣ تاریخ به زبان فارسی _\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"
        end
		end
-------------SetLang-------
if matches[1] == "setlang" and is_owner(msg) then
local hash = "group_lang:"..msg.to.id
   if matches[2] == "en" then
local hash = "group_lang:"..msg.to.id
 redis:del(hash)
  return "_Group Language Set To:_ *EN*"
  elseif matches[2] == "fa" then
redis:set(hash, true)
  return "_زبان گروه تنظیم شد به : فارسی_"
   end
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

*!mute* `[gif | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unmute* `[gif | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

*!set*`[rules | name | photo[also reply] | link | about | welcome]`
_Bot Set Them_

*!clean* `[bans | mods | rules | about | silentlist | filterlist | welcome]`   
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
    local fatext = [[
_دستورات ربات بیوند:_

*!gadd* 
_اضافه کردن گروه به ربات_

*!grem*
 _حذف گروه از ربات_

*!setowner* `[username|id|reply]`
_انتخاب مالک گروه(قابل انتخاب چند مالک)_

*!remowner* `[username|id|reply]`
_حذف کردن فرد از فهرست مالکان گروه_

*!promote* `[username|id|reply]`
_ارتقا مقام کاربر به مدیر گروه_

*!demote* `[username|id|reply]`
_تنزیل مقام مدیر به کاربر_

*!setflood* `[1-50]`
_تنظیم حداکثر تعداد پیام مکرر_

*!setchar* `[Number]`
_تنظیم حداکثر کاراکتر پیام مکرر_

*!setfloodtime* `[1-10]`
_تنظیم زمان ارسال پیام مکرر_

*!silent* `[username|id|reply]`
_بیصدا کردن کاربر در گروه_

*!unsilent* `[username|id|reply]`
_در آوردن کاربر از حالت بیصدا در گروه_

*!kick* `[username|id|reply]`
_حذف کاربر از گروه_

*!ban* `[username|id|reply]`
_مسدود کردن کاربر از گروه_

*!unban* `[username|id|reply]`
_در آوردن از حالت مسدودیت کاربر از گروه_

*!whitelist* `[+|-]` `[یوزرنیم|ایدی|ریپلی]` 
_افزودن افراد به لیست سفید_

*!res* `[username]`
_نمایش شناسه کاربر_

*!id* `[reply]`
نمایش شناسه کاربر

*!whois* `[id]`
_نمایش نام کاربر, نام کاربری و اطلاعات حساب_

*!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

*!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention | pin]`
_در صورت قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدد بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

*!unmute* `[gif | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

*!set*`[rules | name | photo | link | about | welcome]`
_ربات آنهارا ثبت خواهد کرد_

*!clean* `[bans | mods | rules | about | silentlist | filterlist | welcome]`
_ربات آنهارا پاک خواهد کرد_

*!filter* `[word]`
_فیلتر‌کلمه مورد نظر_

*!unfilter* `[word]`
_ازاد کردن کلمه مورد نظر_

*!pin* `[reply]`
_ربات پیام شمارا در گروه سنجاق خواهد کرد_

*!unpin *
ربات پیام سنجاق شده در گروه را حذف خواهد کرد

*!welcome* `enable/disable`
_فعال یا غیرفعال کردن خوشامد گویی_

*!settings*
_نمایش تنظیمات گروه_

*!mutelist*
_نمایش فهرست بیصدا های گروه_

*!silentlist*
_نمایش فهرست افراد بیصدا_

*!filterlist*
_نمایش لیست کلمات فیلتر شده_

*!banlist*
_نمایش افراد مسدود شده از گروه_

*!ownerlist*
_نمایش فهرست مالکان گروه_

*!modlist*
_نمایش فهرست مدیران گروه_

*!whitelist*
_نمایش افراد سفید شده از گروه_

*!rules*
_نمایش قوانین گروه_

*!about*
_نمایش درباره گروه_

*!id*
_نمایش شناسه شما و گروه_

*!newlink*
_ساخت لینک جدید_

*!setlink*
_تنظیم لینک جدید_

*!link*
_نمایش لینک گروه_

*!linkpv*
_ارسال لینک گروه به چت خصوصی شما_

*!setwelcome* `[text]`
_ثبت پیام خوش آمد گویی_

*!setlang* `[fa | en]`
_تنظیم زبان ربات به فارسی یا انگلیسی_

*!helptools*
_نمایش راهنمای ابزار_

*!helpfun*
_نمایش راهنمای سرگرمی_

_شما میتوانید از [/!] در اول دستورات برای اجرای آنها بهره بگیرید_

_این راهنما فقط برای مدیران/مالکان گروه میباشد!_

_این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_

_موفق باشید_ *;)*
]]
if lang then
return fatext
else
	return text
  end
  end
----------------End Msg Matches--------------
end
local function pre_process(msg)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
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
	 if lang then
	 send_msg(msg.to.id, "*عکس پروفایل گروه تعویض شد*", msg.id, "md")
	 else
		send_msg(msg.to.id, "*Photo Saved*", msg.id, "md")
  end
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
     if not lang then
     welcome = "*Welcome Dude*"
    elseif lang then
     welcome = "_خوش آمدید_"
        end
     end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
     if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@BeyondTeam"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@BeyondTeam"
 end
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
   if lang then
   send_msg(msg.to.id, '*گروه ['..escape_markdown(msg.to.title)..'] به گروههای ربات اضافه شد و سازنده گروه اکنون مالک ربات است*', msg.id, "md")
   else
   send_msg(msg.to.id, '*Group ['..escape_markdown(msg.to.title)..'] has been added and group creator is now group owner*', msg.id, "md")
      end
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
    "^[!/](linkpv)$",
	"^[!/](newlink)$",
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
	"^[!/](setlang) (.*)$",
    "^[!/](setchar) (%d+)$",
    "^[!/](setflood) (%d+)$",
    "^[!/](setfloodtime) (%d+)$",
    "^[!/](whois) (.*)$",
    "^[!/](rmsg) (%d+)$",
	"^[!/](beyond)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$"
    },
  run = BeyondTeam,
  pre_process = pre_process
}
