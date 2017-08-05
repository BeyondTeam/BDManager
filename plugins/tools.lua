local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end

local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

--By @SoLiD021
local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

--By @SoLiD021
local function already_admin(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

--By @SoLiD
local function sudolist(msg)
local sudo_users = _config.sudo_users
local text = "Sudo Users :\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

local function adminlist(msg)
 text = '*List of bot admins :*\n'
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
		  		text = '_No_ *admins* _available_'
		  	end
		  	return text
    end

local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = 'List of Groups:\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end

local function run(msg, matches)
    local data = load_data(_config.moderation.data)
   if matches[1] == "sudolist" and is_sudo(msg) then
    return sudolist(msg)
   end
  if tonumber(msg.from.id) == tonumber(sudo_id) then
   if matches[1] == "visudo" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if already_sudo(tonumber(msg.reply.id)) then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already_ *sudoer*"
    else
          table.insert(_config.sudo_users, tonumber(msg.reply.id)) 
      print(msg.reply.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_User_ "..username.." `"..msg.reply.id.."` _is now_ *sudoer*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
   if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if already_sudo(tonumber(matches[2])) then
    return "_User_ "..user_name.." `"..matches[2].."` _is already_ *sudoer*"
    else
           table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2]..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_User_ "..user_name.." `"..matches[2].."` _is now_ *sudoer*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2])
   if already_sudo(tonumber(status.information.id)) then
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is already_ *sudoer*"
    else
          table.insert(_config.sudo_users, tonumber(status.information.id)) 
      print(status.information.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is now_ *sudoer*"
     end
  end
end
   if matches[1] == "desudo" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not already_sudo(tonumber(msg.reply.id)) then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *sudoer*"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.reply.id)))
		save_config()
     reload_plugins(true) 
    return "_User_ "..username.." `"..msg.reply.id.."` _is no longer_ *sudoer*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not already_sudo(tonumber(matches[2])) then
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *sudoer*"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(matches[2])))
		save_config()
     reload_plugins(true) 
    return "_User_ "..user_name.." `"..matches[2].."` _is no longer_ *sudoer*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2])
   if not already_sudo(tonumber(status.information.id)) then
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is not_ *sudoer*"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(status.information.id)))
		save_config()
     reload_plugins(true) 
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is no longer_ *sudoer*"
          end
      end
   end
end
  if is_sudo(msg) then
   if matches[1] == "adminprom" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if already_admin(tonumber(msg.reply.id)) then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already an_ *admin*"
    else
	    table.insert(_config.admins, {tonumber(msg.reply.id), username})
		save_config() 
    return "_User_ "..username.." `"..msg.reply.id.."` _has been promoted as_ *admin*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
   if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if already_admin(tonumber(matches[2])) then
    return "_User_ "..user_name.." `"..matches[2].."` _is already an_ *admin*"
    else
	    table.insert(_config.admins, {tonumber(matches[2]), user_name})
		save_config()
    return "_User_ "..user_name.." `"..matches[2].."` _has been promoted as_ *admin*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2])
   if already_admin(tonumber(status.information.id)) then
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is already an_ *admin*"
    else
	    table.insert(_config.admins, {tonumber(status.information.id), check_markdown(status.information.username)})
		save_config()
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _has been promoted as_ *admin*"
     end
  end
end
   if matches[1] == "admindem" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not already_admin(tonumber(msg.reply.id)) then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not_ *admin*"
    else
	local nameid = index_function(tonumber(msg.reply.id))
		table.remove(_config.admins, nameid)
		save_config()
    return "_User_ "..username.." `"..msg.reply.id.."` _has been demoted from_ *admin*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not already_admin(tonumber(matches[2])) then
    return "_User_ "..user_name.." `"..matches[2].."` _is not_ *admin*"
    else
	local nameid = index_function(tonumber(matches[2]))
		table.remove(_config.admins, nameid)
		save_config()
    return "_User_ "..user_name.." `"..matches[2].."` _has been demoted from_ *admin*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[2])
   if not already_admin(tonumber(status.information.id)) then
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _is not_ *admin*"
    else
	local nameid = index_function(tonumber(status.information.id))
		table.remove(_config.admins, nameid)
		save_config()
    return "_User_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _has been demoted from_ *admin*"
          end
      end
   end
end
  if is_sudo(msg) then
	if matches[1]:lower() == "sendfile" and matches[2] and matches[3] and msg.reply_to_message then
		local send_file = "./"..matches[2].."/"..matches[3]
		sendDocument(msg.to.id, send_file, msg.id, "@BeyondTeam")
	end
	if matches[1]:lower() == "sendplug" and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		sendDocument(msg.to.id, plug, msg.id, "@BeyondTeam")
    end
	if matches[1]:lower() == "savefile" and matches[2]then
	local fn = matches[2]:gsub('(.*)/', '')
	local pt = matches[2]:gsub('/'..fn..'$', '')
if msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
elseif msg.reply_to_message.sticker then
fileid = msg.reply_to_message.sticker.file_id
elseif msg.reply_to_message.voice then
fileid = msg.reply_to_message.voice.file_id
elseif msg.reply_to_message.video then
fileid = msg.reply_to_message.video.file_id
elseif msg.reply_to_message.document then
fileid = msg.reply_to_message.document.file_id
end
downloadFile(fileid, "./"..pt.."/"..fn)
return "*File* `"..fn.."` _has been saved in_ *"..pt.."*"
  end
end
	if matches[1]:lower() == "save" and matches[2] then
if msg.reply_to_message then
if msg.reply_to_message.document then
fileid = msg.reply_to_message.document.file_id
filename = msg.reply_to_message.document.file_name
if tostring(filename):match(".lua") then
downloadFile(fileid, "./plugins/"..matches[2]..".lua")
return "*Plugin* `"..matches[2]..".lua` _has been saved_"
        end
     end
  end
end
if matches[1] == 'adminlist' and is_admin(msg) then
return adminlist(msg)
    end
if matches[1] == 'chats' and is_admin(msg) then
return chat_list(msg)
    end
		if matches[1] == 'grem' and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   send_msg(matches[2], "Group has been removed by admin command", nil, 'md')
    return '_Group_ *'..matches[2]..'* _removed_'
		end
     if matches[1] == 'leave' and is_admin(msg) then
  leave_group(msg.to.id)
   end
     if matches[1] == 'bc' and is_admin(msg) and matches[2] and matches[3] then
		local text = matches[2]
send_msg(matches[3], text)	end
 end
   if matches[1] == 'broadcast' and is_sudo(msg) then		
  local data = load_data(_config.moderation.data)		
  local bc = matches[2]			
  for k,v in pairs(data) do				
send_msg(k, bc)			
  end	
end
     if matches[1] == 'autoleave' and is_admin(msg) then
local hash = 'AutoLeaveBot'
--Enable Auto Leave
     if matches[2] == 'enable' then
    redis:del(hash)
   return 'Auto leave has been enabled'
--Disable Auto Leave
     elseif matches[2] == 'disable' then
    redis:set(hash, true)
   return 'Auto leave has been disabled'
--Auto Leave Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return 'Auto leave is enable'
       else
   return 'Auto leave is disable'
         end
      end
   end
---------------Help Tools----------------
  if matches[1] == "helptools" and is_admin(msg) then
    local text = [[

_Sudoer And Admins Beyond Bot Help :_

*!visudo* `[username|id|reply]`
_Add Sudo_

*!desudo* `[username|id|reply]`
_Demote Sudo_

*!sudolist *
_Sudo(s) list_

*!adminprom* `[username|id|reply]`
_Add admin for bot_

*!admindem* `[username|id|reply]`
_Demote bot admin_

*!adminlist *
_Admin(s) list_

*!leave *
_Leave current group_

*!autoleave* `[disable/enable]`
_Automatically leaves group_

*!chats*
_List of added groups_

*!grem* `[id]`
_Remove a group from Database_

*!broadcast* `[text]`
_Send message to all added groups_

*!bc* `[text] [GroupID]`
_Send message to a specific group_

*!sendfile* `[folder] [file]`
_Send file from folder_

*!sendplug* `[plug]`
_Send plugin_

*!save* `[plugin name] [reply]`
_Save plugin by reply_

*!savefile* `[address/filename] [reply]`
_Save File by reply to specific folder_

*!config*
_Set Owner and Admin Group_

_You can use_ *[!/]* _at the beginning of commands._

`This help is only for sudoers/bot admins.`
 
*This means only the sudoers and its bot admins can use mentioned commands.*

*Good luck ;)*]]
    return text
  end
end
return {
  patterns = {
    "^[!/](helptools)$",
    "^[!/](visudo)$",
    "^[!/](desudo)$",
    "^[!/](visudo) (.*)$",
    "^[!/](desudo) (.*)$",
    "^[!/](sudolist)$",
    "^[!/](adminprom)$",
    "^[!/](admindem)$",
    "^[!/](adminprom) (.*)$",
    "^[!/](admindem) (.*)$",
    "^[!/](adminlist)$",
    "^[!/](chats)$",
    "^[!/](sendfile) (.*) (.*)$",
    "^[!/](savefile) (.*)$",
    "^[!/](bc) (.*) (-%d+)$",
    "^[!/](broadcast) (.*)$",
    "^[!/](sendplug) (.*)$",
    "^[!/](save) (.*)$",
    "^[!/](leave)$",
    "^[!/](autoleave) (.*)$",
    "^[!/](grem) (-%d+)$",
    },
  run = run,
  pre_process = pre_process
}
