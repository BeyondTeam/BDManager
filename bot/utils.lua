 local clock = os.clock
function sleep(time)  -- seconds
  local t0 = clock()
  while clock() - t0 <= time do end
end

function string.random(length)
   local str = "";
   for i = 1, length do
      math.random(97, 122)
      str = str..string.char(math.random(97, 122));
   end
   return str;
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

-- DEPRECATED
function string.trim(s)
  print("string.trim(s) is DEPRECATED use string:trim() instead")
  return s:gsub("^%s*(.-)%s*$", "%1")
end

-- Removes spaces
function string:trim()
  return self:gsub("^%s*(.-)%s*$", "%1")
end

function get_http_file_name(url, headers)
  -- Eg: foo.var
  local file_name = url:match("[^%w]+([%.%w]+)$")
  -- Any delimited alphanumeric on the url
  file_name = file_name or url:match("[^%w]+(%w+)[^%w]+$")
  -- Random name, hope content-type works
  file_name = file_name or str:random(5)

  local content_type = headers["content-type"]

  local extension = nil
  if content_type then
    extension = mimetype.get_mime_extension(content_type)
  end
  if extension then
    file_name = file_name.."."..extension
  end

  local disposition = headers["content-disposition"]
  if disposition then
    -- checking
    -- attachment; filename=CodeCogsEqn.png
    file_name = disposition:match('filename=([^;]+)') or file_name
  end
	-- return
  return file_name
end

--  Saves file to /tmp/. If file_name isn't provided,
-- will get the text after the last "/" for filename
-- do ski
msg_caption = '\n@'..string.reverse("maeTdnoyeB")
-- Waiting for ski:)
-- and content-type for extension
function download_to_file(url, file_name)
  -- print to server
  -- print("url to download: "..url)
  -- uncomment if needed
  local respbody = {}
  local options = {
    url = url,
    sink = ltn12.sink.table(respbody),
    redirect = true
  }

  -- nil, code, headers, status
  local response = nil

  if url:starts('https') then
    options.redirect = false
    response = {https.request(options)}
  else
    response = {http.request(options)}
  end

  local code = response[2]
  local headers = response[3]
  local status = response[4]

  if code ~= 200 then return nil end

  file_name = file_name or get_http_file_name(url, headers)

  local file_path = "download_path/"..file_name
  -- print("Saved to: "..file_path)
	-- uncomment if needed
  file = io.open(file_path, "w+")
  file:write(table.concat(respbody))
  file:close()

  return file_path
end
function run_command(str)
  local cmd = io.popen(str)
  local result = cmd:read('*all')
  cmd:close()
  return result
end
function string:isempty()
  return self == nil or self == ''
end

-- Returns true if the string is blank
function string:isblank()
  self = self:trim()
  return self:isempty()
end

-- DEPRECATED!!!!!
function string.starts(String, Start)
  -- print("string.starts(String, Start) is DEPRECATED use string:starts(text) instead")
  -- uncomment if needed
  return Start == string.sub(String,1,string.len(Start))
end

-- Returns true if String starts with Start
function string:starts(text)
  return text == string.sub(self,1,string.len(text))
end
function unescape_html(str)
  local map = {
    ["lt"]  = "<",
    ["gt"]  = ">",
    ["amp"] = "&",
    ["quot"] = '"',
    ["apos"] = "'"
  }
  new = string.gsub(str, '(&(#?x?)([%d%a]+);)', function(orig, n, s)
    var = map[s] or n == "#" and string.char(s)
    var = var or n == "#x" and string.char(tonumber(s,16))
    var = var or orig
    return var
  end)
  return new
end

function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

function plugins_names( )
  local files = {}
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .lua
    if (v:match(".lua$")) then
      table.insert(files, v)
    end
  end
  return files
end

function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

function check_markdown(text) --markdown escape ( when you need to escape markdown , use it like : check_markdown('your text')
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
			
		else
			output = str
		end
	return output
end

function escape_markdown(name) --markdown escape ( only use it for name of users or groups , use it like : escape_markdown(msg.from.first_name)
  str = name
  if str:match('_') then
   str = str:gsub('_','')
  end
	if str:match('*') then
   str = str:gsub('*','')
  end
	if str:match('`') then
   str = str:gsub('`','')
  end
 return str
end

function is_sudo(msg)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
      var = true
    end
  end
  return var
end

function is_owner(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

function is_admin(msg)
  local var = false
  local user = msg.from.id
  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['mods'] then
      if data[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

function is_sudo1(user_id)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
      var = true
    end
  end
  return var
end

function is_owner1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(user)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

function is_admin1(user_id)
  local var = false
  local user = user_id
  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['mods'] then
      if data[tostring(chat_id)]['mods'][tostring(usert)] then
        var = true
      end
    end
  end

  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(usert)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

function is_filter(msg, text)
local var = false
local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat.id)]['filterlist'] then
for k,v in pairs(data[tostring(msg.chat.id)]['filterlist']) do 
    if string.find(string.lower(text), string.lower(k)) then
       var = true
        end
     end
  end
 return var
end
function is_banned(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['banned'] then
      if data[tostring(chat_id)]['banned'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

 function is_silent_user(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['is_silent_users'] then
      if data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

function is_whitelist(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['whitelist'] then
      if data[tostring(chat_id)]['whitelist'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

function is_gbanned(user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  local gban_users = 'gban_users'
  if data[tostring(gban_users)] then
    if data[tostring(gban_users)][tostring(user)] then
      var = true
    end
  end
return var
end

function ban_user(user_name, user_id, chat_id)
    local data = load_data(_config.moderation.data)
if data[tostring(chat_id)]['banned'][tostring(user_id)] then
     return
   end
data[tostring(chat_id)]['banned'][tostring(user_id)] = user_name
    save_data(_config.moderation.data, data)
 end

function silent_user(user_name, user_id, chat_id)
    local data = load_data(_config.moderation.data)
if data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] then
     return
   end
data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] = user_name
    save_data(_config.moderation.data, data)
 end

 function unban_user(user_id, chat_id)
    local data = load_data(_config.moderation.data)
if not data[tostring(chat_id)]['banned'][tostring(user_id)] then
    return
   end
data[tostring(chat_id)]['banned'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
  end

function unsilent_user(user_id, chat_id)
    local data = load_data(_config.moderation.data)
if not data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] then
    return
   end
data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
  end

function banall_user(user_name, user_id)
    local data = load_data(_config.moderation.data)
  if not data['gban_users'] then
    data['gban_users'] = {}
    save_data(_config.moderation.data, data)
    end
if is_gbanned(user_id) then
     return
   end
  data['gban_users'][tostring(user_id)] = user_name
    save_data(_config.moderation.data, data)
  end

function unbanall_user(user_id)
    local data = load_data(_config.moderation.data)
  if not data['gban_users'] then
    data['gban_users'] = {}
    save_data(_config.moderation.data, data)
    end
if not is_gbanned(user_id) then
     return
   end
  data['gban_users'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
  end

 function banned_list(chat_id)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(chat_id)] then
    return '_Group is not added_'
  end
  -- determine if table is empty
  if next(data[tostring(chat_id)]['banned']) == nil then --fix way
					return "_No_ *banned* _users in this group_"
				end
   message = '*List of banned users :*\n'
  for k,v in pairs(data[tostring(chat_id)]['banned']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

 function silent_users_list(chat_id)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(chat_id)] then
    return '_Group is not added_'
  end
  -- determine if table is empty
  if next(data[tostring(chat_id)]['is_silent_users']) == nil then --fix way
					return "_No_ *silent* _users in this group_"
				end
   message = '*List of silent users :*\n'
  for k,v in pairs(data[tostring(chat_id)]['is_silent_users']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

function whitelist(chat_id)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(chat_id)] then
    return '_Group is not added_'
  end
  if not data[tostring(chat_id)]['whitelist'] then
    data[tostring(chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, data)
    end
  -- determine if table is empty
  if next(data[tostring(chat_id)]['whitelist']) == nil then --fix way
					return "_No_ *users* _in white list_"
				end
   message = '*Users of white list :*\n'
  for k,v in pairs(data[tostring(chat_id)]['whitelist']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

 function gbanned_list(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data['gban_users'] then
    data['gban_users'] = {}
    save_data(_config.moderation.data, data)
  end
  if next(data['gban_users']) == nil then --fix way
					return "_No_ *globally banned* _users available_"
				end
   message = '*List of globally banned users :*\n'
  for k,v in pairs(data['gban_users']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

 function filter_list(msg)
    local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat.id)]['filterlist'] then
    data[tostring(msg.chat.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
  if not data[tostring(msg.chat.id)] then
    return '_Group is not added_'
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat.id)]['filterlist']) == nil then --fix way
    return "*Filtered words list* _is empty_"
  end
  if not data[tostring(msg.chat.id)]['filterlist'] then
    data[tostring(msg.chat.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
       filterlist = '*List of filtered words :*\n'
 local i = 1
   for k,v in pairs(data[tostring(msg.chat.id)]['filterlist']) do
              filterlist = filterlist..'*'..i..'* - _'..check_markdown(k)..'_\n'
             i = i + 1
         end
     return filterlist
   end

function get_var_inline(msg)
if msg.query then
if msg.query:match("-%d+") then
msg.chat = {}
msg.chat.id = "-"..msg.query:match("%d+")
    end
elseif not msg.query then
msg.chat.id = msg.chat.id
end
match_plugins(msg)
end
function get_var(msg)
 msg.data = {}
msg.to = {}
msg.id = msg.message_id
if msg.chat.type ~= "private" then
msg.to.id = msg.chat.id
msg.to.type = msg.chat.type
msg.to.title = msg.chat.title
  else
msg.to.id = msg.chat.id
msg.to.type = msg.chat.type
msg.to.title = false
end
if msg.game or msg.new_chat_member or msg.left_chat_member or msg.new_chat_title or msg.new_chat_photo or msg.delete_chat_photo or msg.pinned_message then
  msg.service = true
   else
  msg.service = false
 end
 if msg.left_chat_member then
msg.deluser = {}
 msg.deluser.id = msg.left_chat_member.id
if msg.left_chat_member.last_name then
msg.deluser.print_name = msg.left_chat_member.first_name..' '..msg.left_chat_member.last_name
  else
msg.deluser.print_name = msg.left_chat_member.first_name
end
msg.deluser.username = msg.left_chat_member.username
msg.deluser.first_name = msg.left_chat_member.first_name
msg.deluser.last_name = msg.left_chat_member.last_name
 end
 if msg.new_chat_member then
msg.newuser = {}
 msg.newuser.id = msg.new_chat_member.id
if msg.new_chat_member.last_name then
msg.newuser.print_name = msg.new_chat_member.first_name..' '..msg.new_chat_member.last_name
  else
msg.newuser.print_name = msg.new_chat_member.first_name
end
msg.newuser.username = msg.new_chat_member.username
msg.newuser.first_name = msg.new_chat_member.first_name
msg.newuser.last_name = msg.new_chat_member.last_name
 end
if msg.reply_to_message then
msg.reply = {}
msg.reply_id = msg.reply_to_message.message_id
msg.reply.id = msg.reply_to_message.from.id
if msg.reply_to_message.from.last_name then
msg.reply.print_name = msg.reply_to_message.from.first_name..' '..msg.reply_to_message.from.last_name
else
msg.reply.print_name = msg.reply_to_message.from.first_name
end
msg.reply.first_name = msg.reply_to_message.from.first_name
msg.reply.last_name = msg.reply_to_message.from.last_name
msg.reply.username = msg.reply_to_message.from.username
if msg.reply_to_message.forward_from then
msg.reply.fwd_from = {}
msg.reply.fwd_from.id = msg.reply_to_message.forward_from.id
if msg.reply_to_message.forward_from.last_name then
msg.reply.fwd_from.print_name = msg.reply_to_message.forward_from.first_name..' '..msg.reply_to_message.forward_from.last_name
else
msg.reply.fwd_from.print_name = msg.reply_to_message.forward_from.first_name
end
msg.reply.fwd_from.first_name = msg.reply_to_message.forward_from.first_name
msg.reply.fwd_from.last_name = msg.reply_to_message.forward_from.last_name
msg.reply.fwd_from.username = msg.reply_to_message.forward_from.username
  end
end
if msg.from.last_name then
msg.from.print_name = msg.from.first_name..' '..msg.from.last_name
else
msg.from.print_name = msg.from.first_name
end
if msg.forward_from then
msg.fwd_from = {}
msg.fwd_from.id = msg.forward_from.id
msg.fwd_from.first_name = msg.forward_from.first_name
msg.fwd_from.last_name = msg.forward_from.last_name
if msg.forward_from.last_name then
msg.fwd_from.print_name = msg.forward_from.first_name..' '..msg.forward_from.last_name
else
msg.fwd_from.print_name = msg.forward_from.first_name
end
msg.fwd_from.username = msg.forward_from.username
end
match_plugins(msg)
end

