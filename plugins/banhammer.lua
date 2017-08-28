-- @BeyondTeam
local function BeyondTeam(msg, matches)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
----------------Kick ----------------
if matches[1] == 'kick' and is_mod(msg) then
   if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   if not lang then
   return "*I can't kick my self*"
  else
   return "_من قادر به اخراج کردن خود نیستم_"
      end
    end
if is_mod1(msg.to.id, msg.reply.id) then
   if not lang then
   return "_You can't_ *kick* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را اخراج کنید_"
      end
    else
	kick_user(msg.reply.id, msg.to.id) 
 end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   if not lang then
   return "*I can't kick my self*"
  else
   return "_من قادر به اخراج کردن خود نیستم_"
      end
    end
if is_mod1(msg.to.id, User.id) then
   if not lang then
   return "_You can't_ *kick* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را اخراج کنید_"
      end
     else
	kick_user(User.id, msg.to.id) 
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   if not lang then
   return "*I can't kick my self*"
  else
   return "_من قادر به اخراج کردن خود نیستم_"
      end
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   if not lang then
   return "_You can't_ *kick* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را اخراج کنید_"
      end
   else
     kick_user(tonumber(matches[2]), msg.to.id) 
        end
     end
   end 

---------------Ban-------------------      
                   
if matches[1] == 'ban' and is_mod(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
if tonumber(msg.reply.id) == tonumber(our_id) then
    if not lang then
   return "*I can't ban my self*"
  else
   return "_من قادر به محروم کردن خود از گروه نیستم_"
      end
    end
if is_mod1(msg.to.id, msg.reply.id) then
   if not lang then
   return "_You can't_ *ban* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را از گروه محروم کنید_"
      end
    end
  if is_banned(msg.reply.id, msg.to.id) then
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is already_ *banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از گروه محروم بود_"
      end
    else
	ban_user(un, msg.reply.id, msg.to.id)
     kick_user(msg.reply.id, msg.to.id) 
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _has been_ *banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از گروه محروم شد_"
      end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
    if not lang then
   return "*I can't ban my self*"
  else
   return "_من قادر به محروم کردن خود از گروه نیستم_"
      end
    end
if is_mod1(msg.to.id, User.id) then
   if not lang then
   return "_You can't_ *ban* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را از گروه محروم کنید_"
      end
    end
  if is_banned(User.id, msg.to.id) then
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is already_ *banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از گروه محروم بود_"
      end
    else
   ban_user(check_markdown(User.username), User.id, msg.to.id)
     kick_user(User.id, msg.to.id) 
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _has been_ *banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از گروه محروم شد_"
      end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
    if not lang then
   return "*I can't ban my self*"
  else
   return "_من قادر به محروم کردن خود از گروه نیستم_"
      end
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   if not lang then
   return "_You can't_ *ban* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات را از گروه محروم کنید_"
      end
    end
  if is_banned(tonumber(matches[2]), msg.to.id) then
    if not lang then
     return "_User_ `"..matches[2].."` _is already_ *banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از گروه محروم بود_"
      end
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    if not lang then
     return "_User_ `"..matches[2].."` _has been_ *banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از گروه محروم شد_"
          end
        end
     end
   end

---------------Unban-------------------                         

if matches[1] == 'unban' and is_mod(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
  if not is_banned(msg.reply.id, msg.to.id) then
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is not_ *banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از گروه محروم نبود_"
      end
    else
unban_user(msg.reply.id, msg.to.id)
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _has been_ *unbanned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از محرومیت گروه خارج شد_"
      end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
  if not is_banned(User.id, msg.to.id) then
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is not_ *banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از گروه محروم نبود_"
      end
    else
   unban_user(User.id, msg.to.id)
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _has been_ *unbanned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از محرومیت گروه خارج شد_"
      end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_banned(tonumber(matches[2]), msg.to.id) then
    if not lang then
     return "_User_ `"..matches[2].."` _is not_ *banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از گروه محروم نبود_"
      end
    else
   unban_user(matches[2], msg.to.id)
    if not lang then
     return "_User_ `"..matches[2].."` _has been_ *unbanned*"
   else
     return "_کاربر_ `"..matches[2].."` _از محرومیت گروه خارج شد_"
          end
        end
     end
   end

------------------------Silent-------------------------------------

if matches[1] == 'silent' and is_mod(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
if tonumber(msg.reply.id) == tonumber(our_id) then
    if not lang then
   return "*I can't silent my self*"
  else
   return "_من قادر به گرفتن توانایی چت کردن از خود نیستم_"
      end
    end
if is_mod1(msg.to.id, msg.reply.id) then
   if not lang then
   return "_You can't_ *silent* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید توانایی چت کردن را از مدیران،صاحبان گروه و ادمین های ربات بگیرید_"
      end
    end
  if is_silent_user(msg.reply.id, msg.to.id) then
   if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is already_ *silent*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از قبل توانایی چت کردن در گروه را نداشت_"
      end
    else
silent_user(un, msg.reply.id, msg.to.id)
   if not lang then
    return "_User_ "..un.." `"..msg.reply.id.."` _added to_ *silent users list*"
  else
    return "_کاربر_ "..un.." `"..msg.reply.id.."` _توانایی چت کردن در گروه را از دست داد_"
     end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
    if not lang then
   return "*I can't silent my self*"
  else
   return "_من قادر به گرفتن توانایی چت کردن از خود نیستم_"
      end
    end
if is_mod1(msg.to.id, User.id) then
   if not lang then
   return "_You can't_ *silent* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید توانایی چت کردن را از مدیران،صاحبان گروه و ادمین های ربات بگیرید_"
      end
    end
  if is_silent_user(User.id, msg.to.id) then
   if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is already_ *silent*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از قبل توانایی چت کردن در گروه را نداشت_"
      end
    else
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id)
    if not lang then
    return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _added to_ *silent users list*"
  else
    return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _توانایی چت کردن در گروه را از دست داد_"
     end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
    if not lang then
   return "*I can't silent my self*"
  else
   return "_من قادر به گرفتن توانایی چت کردن از خود نیستم_"
      end
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   if not lang then
   return "_You can't_ *silent* _mods, owners, bot admins_"
  else
   return "_شما نمیتوانید توانایی چت کردن را از مدیران،صاحبان گروه و ادمین های ربات بگیرید_"
      end
    end
  if is_silent_user(tonumber(matches[2]), msg.to.id) then
   if not lang then
     return "_User_ `"..matches[2].."` _is already_ *silent*"
   else
     return "_کاربر_ `"..matches[2].."` _از قبل توانایی چت کردن در گروه را نداشت_"
      end
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
   if not lang then
    return "_User_ `"..matches[2].."` _added to_ *silent users list*"
  else
    return "_کاربر_ `"..matches[2].."` _توانایی چت کردن در گروه را از دست داد_"
     end
        end
     end
   end

------------------------Unsilent----------------------------
if matches[1] == 'unsilent' and is_mod(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
  if not is_silent_user(msg.reply.id, msg.to.id) then
   if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is not_ *silent*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از قبل توانایی چت کردن در گروه را داشت_"
      end
    else
unsilent_user(msg.reply.id, msg.to.id)
   if not lang then
    return "_User_ "..un.." `"..msg.reply.id.."` _removed from_ *silent users list*"
  else
    return "_کاربر_ "..un.." `"..msg.reply.id.."` _توانایی چت کردن در گروه را به دست آورد_"
     end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
  if not is_silent_user(User.id, msg.to.id) then
   if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is not_ *silent*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از قبل توانایی چت کردن در گروه را داشت_"
      end
    else
   unsilent_user(User.id, msg.to.id)
   if not lang then
    return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _removed from_ *silent users list*"
  else
    return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _توانایی چت کردن در گروه را به دست آورد_"
     end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then
   if not lang then
     return "_User_ `"..matches[2].."` _is not_ *silent*"
   else
     return "_کاربر_ `"..matches[2].."` _از قبل توانایی چت کردن در گروه را داشت_"
      end
    else
   unsilent_user(matches[2], msg.to.id)
   if not lang then
    return "_User_ `"..matches[2].."` _removed from_ *silent users list*"
  else
    return "_کاربر_ `"..matches[2].."` _توانایی چت کردن در گروه را به دست آورد_"
     end
        end
     end
   end
-------------------------Banall-------------------------------------
                   
if matches[1] == 'banall' and is_admin(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
if tonumber(msg.reply.id) == tonumber(our_id) then
    if not lang then
   return "*I can't global ban my self*"
  else
   return "_من قادر به محروم کردن خود از تمام گروه  های ربات نیستم_"
      end
    end
if is_admin1(msg.reply.id) then
   if not lang then
   return "_You can't_ *global ban* _other admins_"
  else
   return "_شما نمیتوانید ادمین های ربات رو از تمام گروه های ربات محروم کنید_"
      end
    end
  if is_gbanned(msg.reply.id) then
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is already_ *globally banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از گروه های ربات محروم بود_"
      end
    else
  banall_user(un, msg.reply.id)
     kick_user(msg.reply.id, msg.to.id) 
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _has been_ *globally banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از تمام گروه های ربات محروم شد_"
      end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
    if not lang then
   return "*I can't global ban my self*"
  else
   return "_من قادر به محروم کردن خود از تمام گروه  های ربات نیستم_"
      end
    end
if is_admin1(User.id) then
   if not lang then
   return "_You can't_ *global ban* _other admins_"
  else
   return "_شما نمیتوانید ادمین های ربات رو از تمام گروه های ربات محروم کنید_"
      end
    end
  if is_gbanned(User.id) then
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is already_ *globally banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از گروه های ربات محروم بود_"
      end
    else
   banall_user("@"..check_markdown(User.username), User.id)
     kick_user(User.id, msg.to.id) 
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _has been_ *globally banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از تمام گروه های ربات محروم شد_"
      end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
    if not lang then
   return "*I can't global ban my self*"
  else
   return "_من قادر به محروم کردن خود از تمام گروه  های ربات نیستم_"
      end
    end
if is_admin1(tonumber(matches[2])) then
   if not lang then
   return "_You can't_ *global ban* _other admins_"
  else
   return "_شما نمیتوانید ادمین های ربات رو از تمام گروه های ربات محروم کنید_"
      end
    end
  if is_gbanned(tonumber(matches[2])) then
    if not lang then
     return "_User_ `"..matches[2].."` _is already_ *globally banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از گروه های ربات محروم بود_"
      end
    else
   banall_user('', matches[2])
     kick_user(tonumber(matches[2]), msg.to.id)
    if not lang then
     return "_User_ `"..matches[2].."` _has been_ *globally banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از تمام گروه های ربات محروم شد_"
          end
        end
     end
   end
--------------------------Unbanall-------------------------

if matches[1] == 'unbanall' and is_admin(msg) then
if msg.reply_id then
if msg.reply.username then
	un = "@"..check_markdown(msg.reply.username)
	else
	un = escape_markdown(msg.reply.print_name) 
	end
  if not is_gbanned(msg.reply.id) then
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _is not_ *globally banned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از گروه های ربات محروم نبود_"
      end
    else
unbanall_user(msg.reply.id)
    if not lang then
     return "_User_ "..un.." `"..msg.reply.id.."` _has been_ *globally unbanned*"
   else
     return "_کاربر_ "..un.." `"..msg.reply.id.."` _از محرومیت گروه های ربات خارج شد_"
      end
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   if not lang then
   return "*User not found*"
  else
   return "_کاربر یافت نشد_"
       end
    end
	local User = resolve_username(matches[2]).information
  if not is_gbanned(User.id) then
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _is not_ *globally banned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از گروه های ربات محروم نبود_"
      end
    else
   unbanall_user(User.id)
    if not lang then
     return "_User_ @"..check_markdown(User.username).." `"..User.id.."` _has been_ *globally unbanned*"
   else
     return "_کاربر_ @"..check_markdown(User.username).." `"..User.id.."` _از محرومیت گروه های ربات خارج شد_"
      end
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_gbanned(tonumber(matches[2])) then
    if not lang then
     return "_User_ `"..matches[2].."` _is not_ *globally banned*"
   else
     return "_کاربر_ `"..matches[2].."` _از گروه های ربات محروم نبود_"
      end
    else
   unbanall_user(matches[2])
    if not lang then
     return "_User_ `"..matches[2].."` _has been_ *globally unbanned*"
   else
     return "_کاربر_ `"..matches[2].."` _از محرومیت گروه های ربات خارج شد_"
          end
        end
     end
   end
   -----------------------------------LIST---------------------------
   if matches[1] == 'banlist' and is_mod(msg) then
   return banned_list(msg.to.id)
   end
   if matches[1] == 'silentlist' and is_mod(msg) then
   return silent_users_list(msg.to.id)
   end
   if matches[1] == 'gbanlist' and is_admin(msg) then
   return gbanned_list(msg)
   end
   ---------------------------clean---------------------------
   if matches[1] == 'clean' and is_mod(msg) then
			if matches[2] == 'bans' then
				if next(data[tostring(msg.to.id)]['banned']) == nil then
     if not lang then
					return "_No_ *banned* _users in this group_"
   else
					return "*هیچ کاربری از این گروه محروم نشده*"
              end
				end
				for k,v in pairs(data[tostring(msg.to.id)]['banned']) do
					data[tostring(msg.to.id)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
     if not lang then
				return "_All_ *banned* _users has been unbanned_"
    else
				return "*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"
           end
			end
			if matches[2] == 'silentlist' then
				if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then
        if not lang then
					return "_No_ *silent* _users in this group_"
   else
					return "*لیست کاربران سایلنت شده خالی است*"
             end
				end
				for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do
					data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
       if not lang then
				return "*Silent list* _has been cleaned_"
   else
				return "*لیست کاربران سایلنت شده پاک شد*"
               end
			    end
	if matches[2] == 'gbans' and is_admin(msg) then
				if next(data['gban_users']) == nil then
    if not lang then
					return "_No_ *globally banned* _users available_"
   else
					return "*هیچ کاربری از گروه های ربات محروم نشده*"
             end
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
      if not lang then
				return "_All_ *globally banned* _users has been unbanned_"
   else
				return "*تمام کاربرانی که از گروه های ربات محروم بودند از محرومیت خارج شدند*"
          end
			end
     end
  end
return {
	patterns = {
"^[!/](ban) (.*)$",
"^[!/](ban)$",
"^[!/](unban) (.*)$",
"^[!/](unban)$",
"^[!/](kick) (.*)$",
"^[!/](kick)$",
"^[!/](banall) (.*)$",
"^[!/](banall)$",
"^[!/](unbanall) (.*)$",
"^[!/](unbanall)$",
"^[!/](unsilent) (.*)$",
"^[!/](unsilent)$",
"^[!/](silent) (.*)$",
"^[!/](silent)$",
"^[!/](silentlist)$",
"^[!/](banlist)$",
"^[!/](gbanlist)$",
"^[!/](clean) (.*)$",
	},
	run = BeyondTeam,

}
