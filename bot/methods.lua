function getUser(user_id)
local url = http.request('https://www.api.beyond-dev.ir/getUserById?token='..bot_token..'&user_id='..user_id)
local user = JSON.decode(url)
return user
end

function resolve_username(username)
local url = http.request('https://www.api.beyond-dev.ir/getUserByUsername?token='..bot_token..'&username='..username)
local user = JSON.decode(url)
return user
end

function send_msg(chat_id, text, reply_to_message_id, markdown)

	local url = send_api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

  if markdown == 'md' or markdown == 'markdown' then
    url = url..'&parse_mode=Markdown'
  elseif markdown == 'html' then
    url = url..'&parse_mode=HTML'
  end

	return send_req(url)

end

 function edit(chat_id, message_id, text, keyboard, markdown)
	
	local url = send_api .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return send_req(url)

end
function send(chat_id, text, keyboard, markdown)
	
	local url = send_api.. '/sendMessage?chat_id=' .. chat_id
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url..'&text='..URL.escape(text)
	
	url = url..'&reply_markup='..JSON.encode(keyboard)
	
	return send_req(url)

end
function send_document(chat_id, name)
	local send = send_api.."/sendDocument"
	local curl_command = 'curl -s "'..send..'" -F "chat_id='..chat_id..'" -F "document=@'..name..'"'
	return io.popen(curl_command):read("*all")
end

function fwd_msg(chat_id, from_chat_id, message_id)

	local url = send_api .. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id

	return send_req(url)

end
function edit_key(chat_id, message_id, reply_markup)
 
 local url = send_api .. '/editMessageReplyMarkup?chat_id=' .. chat_id ..
  '&message_id='..message_id..
  '&reply_markup='..URL.escape(JSON.encode(reply_markup))
 
 return send_req(url)

end
function send_key(chat_id, text, keyboard, reply_to_message_id, markdown)
 
 local url = send_api .. '/sendMessage?chat_id=' .. chat_id
 
	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

  if markdown == 'md' or markdown == 'markdown' then
    url = url..'&parse_mode=Markdown'
  elseif markdown == 'html' then
    url = url..'&parse_mode=HTML'
  end
 
 url = url..'&text='..URL.escape(text)
 
 url = url..'&disable_web_page_preview=true'
 
	url = url..'&reply_markup='..URL.escape(JSON.encode(keyboard))
 return send_req(url)
end

 function edit_msg(chat_id, message_id, text, keyboard, markdown)
	
	local url = send_api .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return send_req(url)

end

 function edit_inline(inline_message_id, text, keyboard)
  local urlk = send_api .. '/editMessageText?inline_message_id='..inline_message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return send_req(urlk)
  end

 function get_alert(callback_query_id, text, show_alert)
	
	local url = send_api .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	
	if show_alert then
		url = url..'&show_alert=true'
	end
	
	return send_req(url)
	
end

function send_inline(inline_query_id, query_id , title , description , text , keyboard)
local results = {{}}
 results[1].id = query_id
results[1].type = 'article'
results[1].description = description
results[1].title = title
results[1].message_text = text
  url = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
url = send_api .. '&parse_mode=Markdown'
  if keyboard then
   results[1].reply_markup = keyboard
  url = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    return send_req(url)
  end

function edit_key(chat_id, message_id, reply_markup)
	
	local url = send_api .. '/editMessageReplyMarkup?chat_id=' .. chat_id ..
		'&message_id='..message_id..
		'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	
	return send_req(url)

end

function string:input()
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

function serialize_to_file(data, file, uglify)
  file = io.open(file, 'w+')
  local serialized
  if not uglify then
    serialized = serpent.block(data, {
        comment = false,
        name = '_'
      })
  else
    serialized = serpent.dump(data)
  end
  file:write(serialized)
  file:close()
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

function getChatMember(chat_id, user_id)
 local url = send_api .. '/getChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
   return send_req(url)
end

function getChatAdministrators(chat_id)
	local url = send_api .. '/getChatAdministrators?chat_id=' .. chat_id
	return send_req(url)
end

 function unbanChatMember(chat_id, user_id)
  local url = send_api .. '/unbanChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
  return send_req(url)
end

function leave_group(chat_id)
  local url = send_api .. '/leaveChat?chat_id=' .. chat_id
  return send_req(url)
end

function del_msg(chat_id, message_id)
local url = send_api..'/deletemessage?chat_id='..chat_id..'&message_id='..message_id
return send_req(url)
end

function kick_user(user_id, chat_id)
local url = send_api .. '/kickChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
return send_req(url)
end

function getChatMembersCount(chat_id)
	
	local url = send_api .. '/getChatMembersCount?chat_id=' .. chat_id
	
	return send_req(url)
	
end

 function downloadFile(file_id, download_path)

  if not file_id then return nil, "file_id not specified" end
  if not download_path then return nil, "download_path not specified" end

  local response = {}

  local file_info = getFile(file_id)
  local download_file_path = download_path or "downloads/" .. file_info.result.file_path

  local download_file = io.open(download_file_path, "w")

  if not download_file then return nil, "download_file could not be created"
  else
    local success, code, headers, status = https.request{
      url = "https://api.telegram.org/file/bot" .. bot_token .. "/" .. file_info.result.file_path,
      --source = ltn12.source.string(body),
      sink = ltn12.sink.file(download_file),
    }

    local r = {
      success = true,
      download_path = download_file_path,
      file = file_info.result
    }
    return r
  end
end

function restrictChatMember(chat_id, user_id, can_send_messages, can_send_media_messages, can_send_other_messages, can_add_web_page_previews, until_date)

	local url = send_api .. '/restrictChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	if can_send_messages then
		url = url .. '&can_send_messages=true'
	else
		url = url .. '&can_send_messages=false'
	end
	
	if can_send_media_messages then
		url = url .. '&can_send_media_messages=true'
	else
		url = url .. '&can_send_media_messages=false'
	end
	
	if can_send_other_messages then
		url = url .. '&can_send_other_messages=true'
	else
		url = url .. '&can_send_other_messages=false'
	end
	
	if can_add_web_page_previews then
		url = url .. '&can_add_web_page_previews=true'
	else
		url = url .. '&can_add_web_page_previews=false'
	end
	
	if until_date then
		url = url .. '&until_date='..until_date
	end
	return send_req(url)

end

function restrictChatMember(chat_id, user_id, can_change_info, can_post_messages, can_edit_messages, can_delete_messages, can_invite_users, can_restrict_members, can_pin_messages, can_promote_members)

	local url = send_api .. '/restrictChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	if can_change_info then
		url = url .. '&can_change_info=true'
	else
		url = url .. '&can_change_info=false'
	end
	
	if can_post_messages then
		url = url .. '&can_post_messages=true'
	else
		url = url .. '&can_post_messages=false'
	end
	
	if can_edit_messages then
		url = url .. '&can_edit_messages=true'
	else
		url = url .. '&can_edit_messages=false'
	end
	
	if can_delete_messages then
		url = url .. '&can_delete_messages=true'
	else
		url = url .. '&can_delete_messages=false'
	end
	
	if can_invite_users then
		url = url .. '&can_invite_users=true'
	else
		url = url .. '&can_invite_users=false'
	end
	
	if can_restrict_members then
		url = url .. '&can_restrict_members=true'
	else
		url = url .. '&can_restrict_members=false'
	end
	
	if can_pin_messages then
		url = url .. '&can_pin_messages=true'
	else
		url = url .. '&can_pin_messages=false'
	end
	
	if can_promote_members then
		url = url .. '&can_promote_members=true'
	else
		url = url .. '&can_promote_members=false'
	end
	return send_req(url)

end

function exportChatInviteLink(chat_id)
	
	local url = send_api .. '/exportChatInviteLink?chat_id=' .. chat_id
	return send_req(url)
	
end

function setChatPhoto(chat_id, photo)
	
	local url = send_api .. '/setChatPhoto'
	cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("photo", photo)
	data = {}
    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()
	return table.concat(data), c:getinfo_response_code()
	
end

function deleteChatPhoto(chat_id)
	
	local url = send_api .. '/deleteChatPhoto?chat_id=' .. chat_id
	return send_req(url)
	
end

function setChatTitle(chat_id, title)
	
	local url = send_api .. '/setChatTitle?chat_id=' .. chat_id .. '&title=' .. URL.escape(title)
	return send_req(url)
	
end

function setChatDescription(chat_id, description)
	
	local url = send_api .. '/setChatDescription?chat_id=' .. chat_id .. '&description=' .. URL.escape(description)
	return send_req(url)
	
end

function pinChatMessage(chat_id, message_id, disable_notification)
	
	local url = send_api .. '/pinChatMessage?chat_id=' .. chat_id .. '&message_id=' .. message_id
	if disable_notification then
		url = url .. '&disable_notification=false'
	end
	return send_req(url)
	
end

function unpinChatMessage(chat_id)
	
	local url = send_api .. '/unpinChatMessage?chat_id=' .. chat_id
	return send_req(url)
	
end

function sendPhotoById(chat_id, file_id, reply_to_message_id, caption)
 
 local url = send_api .. '/sendPhoto?chat_id=' .. chat_id .. '&photo=' .. file_id
 
 if reply_to_message_id then
  url = url..'&reply_to_message_id='..reply_to_message_id
 end
 if caption then
  url = url..'&caption='..URL.escape(caption)
 end
 
 return send_req(url)
 
end

function sendPhoto(chat_id, photo, caption, reply_to_message_id, reply_markup, disable_notification)

	local url = send_api .. '/sendPhoto'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("photo", photo)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end
	
	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
	
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()
end

function sendAudio(chat_id, audio, reply_to_message_id, caption, title, duration, performer, reply_markup, disable_notification)

	local url = send_api .. '/sendAudio'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("audio", audio)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end
	
	if duration then
		form:add_content("duration", duration)
	end

	if performer then
		form:add_content("performer", performer)
	end

	if title then
		form:add_content("title", title)
	end

	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
	
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()

end

function sendDocument(chat_id, document, reply_to_message_id, caption, reply_markup, disable_notification)

	local url = send_api .. '/sendDocument'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("document", document)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end

	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
	
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()

end

function sendSticker(chat_id, sticker, reply_to_message_id, reply_markup, disable_notification)

	local url = send_api .. '/sendSticker'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("sticker", sticker)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
	
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()

end

function sendVideo(chat_id, video, duration, caption, reply_to_message_id, reply_markup, width, height, disable_notification)

	local url = send_api .. '/sendVideo'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("video", video)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if duration then
		form:add_content("duration", duration)
	end

	if caption then
		form:add_content("caption", caption)
	end

	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	
	if width then
		form:add_content("width", width)
	end
	
	if height then
		form:add_content("height", height)
	end
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()

end

function sendVoice(chat_id, voice, reply_to_message_id, caption, duration, reply_markup, disable_notification)

	local url = send_api .. '/sendVoice'
    cUrl_Command:setopt_url(url)

    local form = curl.form()
    form:add_content("chat_id", chat_id)
    form:add_file("voice", voice)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end
	
	if duration then
		form:add_content("duration", duration)
	end
	
	if reply_markup then
		form:add_content("reply_markup", URL.escape(JSON.encode(reply_markup)))
	end
	if disable_notification then
		form:add_content("disable_notification", 'false')
	end
    data = {}

    local c = cUrl_Command:setopt_writefunction(table.insert, data)
                          :setopt_httppost(form)
                          :perform()

	return table.concat(data), c:getinfo_response_code()

end

function sendLocation(chat_id, latitude, longitude, reply_to_message_id, reply_markup, disable_notification)

	local url = send_api .. '/sendLocation?chat_id=' .. chat_id .. '&latitude=' .. latitude .. '&longitude=' .. longitude

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	if disable_notification then
		url = url .. '&disable_notification=false'
	end
	
	if reply_markup then
		url = url..'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	end
	
	return send_req(url)

end

function sendContact(chat_id, phone_number, first_name, last_name, reply_to_message_id, reply_markup, disable_notification)

	local url = send_api.. '/sendContact?chat_id=' .. chat_id .. '&phone_number=' .. phone_number .. '&first_name=' .. first_name

	if last_name then
		url = url .. '&last_name=' .. last_name
	end
	
	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	if disable_notification then
		url = url .. '&disable_notification=false'
	end
	
	if reply_markup then
		url = url..'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	end
	
	return send_req(url)

end

 -- action = typing, upload_photo, record_video, upload_video, record_audio, upload_audio, upload_document, find_location
function sendChatAction(chat_id, action)

	local url = send_api .. '/sendChatAction?chat_id=' .. chat_id .. '&action=' .. action
	return send_req(url)

end

function getUserProfilePhotos(user_id, offset, limit)

	local url = send_api .. '/getUserProfilePhotos?user_id='..user_id
	if offset then
		url = url..'&offset='..offset
	end
	if limit then
		if tonumber(limit) > 100 then 
			limit = 100 
		end
		url = url..'&limit='..limit
	end
	return send_req(url)

end

function getFile(file_id)
	
	local url = send_api .. '/getFile?file_id='..file_id
	return send_req(url)
	
end
