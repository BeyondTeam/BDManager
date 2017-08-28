
--Begin Fun.lua By @BeyondTeam
--Special Thx To @ToOfan
--------------------------------

local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
--------------------------------
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
--------------------------------
local function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
--------------------------------
local function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then 
		zoom=4
	else 
		zoom = 13 
	end
	local parameters =
		"size=600x300" ..
		"&zoom="  .. zoom ..
		"&center=" .. URL.escape(area) ..
		"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
--------------------------------
local function get_weather(msg, location)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
   if not lang then
 temp = 'The temperature of '..city..' is now '..weather.main.temp..' ° C\n____________________'
else
	 temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________'
 end
   if not lang then
	 conditions = 'Current weather conditions : '
 else
	 conditions = 'شرایط فعلی آب و هوا : '
 end
	if weather.weather[1].main == 'Clear' then
   if not lang then
		conditions = conditions .. 'Sunny☀'
    else
		conditions = conditions .. 'آفتابی☀'
  end
	elseif weather.weather[1].main == 'Clouds' then
   if not lang then
		conditions = conditions .. 'Cloudy ☁☁'
     else
		conditions = conditions .. 'ابری ☁☁'
  end
	elseif weather.weather[1].main == 'Rain' then
   if not lang then
		conditions = conditions .. 'Rainy ☔'
   else
		conditions = conditions .. 'بارانی ☔'
 end
	elseif weather.weather[1].main == 'Thunderstorm' then
   if not lang then
		conditions = conditions .. 'Stormy ☔☔☔☔'
    else
		conditions = conditions .. 'طوفانی ☔☔☔☔'
  end
	elseif weather.weather[1].main == 'Mist' then
   if not lang then
		conditions = conditions .. 'Mist 💨'
   else
		conditions = conditions .. 'مه 💨'
      end
	end
	return temp .. '\n' .. conditions..'\n@BeyondTeam'
end
--------------------------------
local function calc(msg, exp)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
 if not lang then
    text = 'Result = '..b..'\n____________________\n@BeyondTeam'
   else
    text = 'نتیجه = '..b..'\n____________________\n@BeyondTeam'
 end
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return text
end
--------------------------------
function run(msg, matches) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	if matches[1]:lower() == 'calc' and matches[2] then 
		if msg.to.type == "private" then 
			return 
       end
		return calc(msg, matches[2])
	end
--------------------------------
	if matches[1]:lower() == 'praytime' then
		if matches[2] then
			city = matches[2]
		elseif not matches[2] then
			city = 'Tehran'
		end
		local lat,lng,url	= get_staticmap(city)
		local dumptime = run_bash('date +%s')
		local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Tehran&method=7')
		local jdat = json:decode(code)
		local data = jdat.data.timings
   if not lang then
		 text = 'City: '..city
		text = text..'\nMorning Azan: '..data.Fajr
		text = text..'\nSunrise: '..data.Sunrise
		text = text..'\nNoon Azan: '..data.Dhuhr
		text = text..'\nSunset: '..data.Sunset
		text = text..'\nMaghrib Azan: '..data.Maghrib
		text = text..'\nIsha: '..data.Isha
		text = text.."\n@BeyondTeam"
  else
		 text = 'شهر: '..city
		text = text..'\nاذان صبح: '..data.Fajr
		text = text..'\nطلوع آفتاب: '..data.Sunrise
		text = text..'\nاذان ظهر: '..data.Dhuhr
		text = text..'\nغروب آفتاب: '..data.Sunset
		text = text..'\nاذان مغرب: '..data.Maghrib
		text = text..'\nعشاء : '..data.Isha
		text = text.."\n@BeyondTeam"
    end
		return text
	end
--------------------------------
if matches[1] == 'tosticker' then
if msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, "./download_path/"..msg.to.id..".webp")
sleep(1)
sendDocument(msg.to.id, "./download_path/"..msg.to.id..".webp", msg.id, "@BeyondTeam")
        end
     end
  end
-------------------------------- 
if matches[1] == 'tophoto' then
if msg.reply_to_message then
if msg.reply_to_message.sticker then
downloadFile(msg.reply_to_message.sticker.file_id, "./download_path/"..msg.to.id..".jpg")
sleep(1)
sendPhoto(msg.to.id, "./download_path/"..msg.to.id..".jpg", "@BeyondTeam", msg.id)
        end
     end
  end
--------------------------------
	if matches[1]:lower() == 'weather' then
		city = matches[2]:lower()
		local wtext = get_weather(msg, city)
		if not wtext then
   if not lang then
			wtext = 'Imported location is not correct'
   else
			wtext = 'مکان وارد شده صحیح نیست'
        end
		end
		return wtext
	end
--------------------------------
	if matches[1]:lower() == 'time' then
		local url , res = http.request('http://api.beyond-dev.ir/time/')
		if res ~= 200 then
			return "No connection"
		end
		local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
		local fonts = {'mathbf','mathit','mathfrak','mathrm'}
		local jdat = json:decode(url)
		local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
		local file = download_to_file(url,'time.webp')
sendDocument(msg.to.id, file, msg.id, "@BeyondTeam")

	end
--------------------------------
	if matches[1]:lower() == 'voice' then
 local text = matches[2]
    textc = text:gsub(' ','.')
    
  if msg.to.type == 'private' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'BD-Manager.mp3')
sendDocument(msg.to.id, file, msg.id, "@BeyondTeam")
   end
end

 --------------------------------
	if matches[1]:lower() == 'tr' then 
	local to = matches[2]
		local res, url = http.request('http://api.beyond-dev.ir/translate?from=.&to='..to..'&text='..URL.escape(matches[3])..'&simple=json')
		data = json:decode(res)
  if not lang then
		return 'Language : '..data.to..'\nTranslation : '..data.translate..'\n____________________\n@BeyondTeam'
    else
		return 'زبان : '..data.to..'\nترجمه : '..data.translate..'\n____________________\n@BeyondTeam'
      end
	end
--------------------------------
	if matches[1]:lower() == 'short' then
		local longlink = http.request('http://api.beyond-dev.ir/shortLink?url='..matches[2])
		local shlink = json:decode(longlink)
		if shlink.status then
    if not lang then
			return 'Short Links:\nGoogle: '..(shlink.results.google or '')..'\nOpizo: '..(shlink.results.opizo or '')..'\nBitly: '..(shlink.results.bitly or '')..'\nYon: '..(shlink.results.yon or '')..'\nLlink: '..(shlink.results.llink or '')..'\nU2S: '..(shlink.results.u2s or '')..'\nShorte: '..(shlink.results.shorte or '')
   else
			return 'لینک های کوتاه شده :\nGoogle: '..(shlink.results.google or '')..'\nOpizo: '..(shlink.results.opizo or '')..'\nBitly: '..(shlink.results.bitly or '')..'\nYon: '..(shlink.results.yon or '')..'\nLlink: '..(shlink.results.llink or '')..'\nU2S: '..(shlink.results.u2s or '')..'\nShorte: '..(shlink.results.shorte or '')
        end
		else
    if not lang then
			return '_Input Correct Link!_'
   else
			return '_لینک صحیح را وارد کنید!_'
        end
		end
	end
--------------------------------
	if matches[1]:lower() == 'sticker' then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.webp')
sendDocument(msg.to.id, file, msg.id, "@BeyondTeam")
	end
--------------------------------
	if matches[1]:lower() == 'photo' then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.jpg')
sendPhoto(msg.to.id, file, "@BeyondTeam", msg.id)
	end
if matches[1] == 'fal' then
local url , res = http.request('http://api.beyond-dev.ir/fal')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
     if not lang then
       fal = "*Poems*:\n"..jdat.poem.."\n\n*Interpretation:*\n"..jdat.mean..'\n\n@BeyondTeam'
     else
       fal = "_غزل:_\n"..jdat.poem.."\n\n_تعبیر فال:_\n"..jdat.mean..'\n\n@BeyondTeam'
        end
      return fal
  end
if matches[1] == 'bazaar' or matches[1] == 'fibazaar' then
if matches[1] == 'bazaar' then
xurl  = 'http://api.beyond-dev.ir/bazaar/?q='..URL.escape(matches[2])
elseif matches[1] == 'fibazaar' then
xurl = 'http://api.beyond-dev.ir/bazaar/?price=yes&q='..URL.escape(matches[2])
end
local url , res = http.request(xurl)
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
    if not lang then
       bazaar = "Results:\n"..jdat.information
     else
       bazaar = "نتایج:\n"..jdat.information
   end
      return check_markdown(bazaar)
end
--------------------------------
if matches[1] == "helpfun" then
if not lang then
helpfun = [[
_Beyond Manager Fun Help Commands:_

*!time*
_Get time in a sticker_

*!short* `[link]`
_Make short url_

*!voice* `[text]`
_Convert text to voice_

*!tr* `[lang] [word]`
_Translates multy languages_
_Example:_
*!tr fa hi*

*!sticker* `[word]`
_Convert text to sticker_

*!photo* `[word]`
_Convert text to photo_

*!calc* `[number]`
Calculator

*!praytime* `[city]`
_Get Patent (Pray Time)_

*!tosticker* `[reply]`
_Convert photo to sticker_

*!tophoto* `[reply]`
_Convert text to photo_

*!weather* `[city]`
_Get weather_

*!bazaar* `[App Name]`
_Search in CafeBazaar market_

*!fibazaar* `[App Name]`
_Search in CafeBazaar market with app price_

*!fal*
_Fale Hafez_

_You can use_ *[!/#]* _at the beginning of commands._

*Good luck ;)*]]
else

helpfun = [[
_راهنمای فان ربات بیوند منیجر:_

*!time*
_دریافت ساعت به صورت استیکر_

*!short* `[link]`
_کوتاه کننده لینک_

*!voice* `[text]`
_تبدیل متن به صدا_

*!tr* `[lang]` `[word]`
_ترجمه به زبانهای مختلف_
_مثال:_
_!tr en سلام_

*!sticker* `[word]`
_تبدیل متن به استیکر_

*!photo* `[word]`
_تبدیل متن به عکس_

*!calc* `[number]`
_ماشین حساب_

*!praytime* `[city]`
_اعلام ساعات شرعی_

*!tosticker* `[reply]`
_تبدیل عکس به استیکر_

*!tophoto* `[reply]`
_تبدیل استیکر‌به عکس_

*!weather* `[city]`
_دریافت اب وهوا_

*!bazaar* `[App Name]`
_جستجو در برنامه های بازار_

*!fibazaar* `[App Name]`
_جستجو در برنامه های بازار با درج قیمت برنامه_

*!fal*
_فال حافظ_

*شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*

موفق باشید ;)]]
end
return helpfun.."\n@BeyondTeam"
end

end
--------------------------------
return {               
	patterns = {
      "^[!/#](helpfun)$",
    	"^[!/#](weather) (.*)$",
		"^[!/#](calc) (.*)$",
		"^[#!/](time)$",
		"^[#!/](tophoto)$",
		"^[#!/](tosticker)$",
		"^[!/#](voice) +(.*)$",
		"^[/!#]([Pp]raytime) (.*)$",
		"^[/!#](praytime)$",
		"^[!/#]([Tt]r) ([^%s]+) (.*)$",
		"^[!/#]([Ss]hort) (.*)$",
		"^[!/#](photo) (.+)$",
		"^[!/#](sticker) (.+)$",
		'^[/!](fal)$',
		'^[/!](bazaar) (.*)$',
		'^[/!](fibazaar) (.*)$',
		}, 
	run = run,
	}

--#by @BeyondTeam :)
