--[[ Сделано магистром программирования под ником Jaff. steamcommunity.com/id/jaffies
	Вдохновено тем, как кое-какой пидорок решился повторить опыт кодинга YoptaScript на ебучем C++ через define'ы.
	Вот поэтому я решился повторить это на луа, конечно же через костыли, ведь это же тебе не C++, детка.

	Что из себя YoptaScript (Glua edition) предствавляет?
	Это обычный конвертер кода, который по своей сути больше похож на интерпретатор, но вместо кода в байты, он переставляет йоптакод в обычный код.
--]]
function YoptaScript(str) -- Хуйня, которая делает ранстринг и работает как поебота какая то.
	RunString(YoptaConvert(str), "YoptaScript")
end
function FastYoptaScript(str) -- Хуйня, которая делает ранстринг и работает как поебота какая то.
	RunString(YoptaFastConvert(str), "YoptaScript")
end
local function YoptaScriptQuoteTab(str)
	local str1 = str
	local strtabs = {}
	local number = 1
	local find = str1:find("\"",number)
	while find != nil do
		number = find+1
		table.insert(strtabs, find)
		find = str1:find("\"",number)
	end
	local tab = {}
	for i=1, #strtabs do
		if !tab[math.Round(i/2)] then tab[math.Round(i/2)] = {} end
		tab[math.Round(i/2)][1-i%2+1] = strtabs[i]
	end
	return tab
end
local function YoptaCheckInQuotes(quotetab, number)
	for i=1, #quotetab do
		if number > quotetab[i][1] and number < quotetab[i][2] then return true end
	end
	return false
end
function YoptaConvert(str) -- Конвертер стрингов на lua лад.
	local str1 = string.Replace(string.Replace(string.Replace(string.Replace(string.Replace(string.Replace(" " .. str .. " ", "\t", " \t " ), "\n", " \n "), ";", " ; "), "(", " ( "), ")", " ) "), ",", " , ") -- Берем копию оригинальной строчки.
	local quotes = YoptaScriptQuoteTab(str1)
	local number = 1
	local find, find1 = 0,0 
	for i=1, #YoptaWords do
		find, find1 = str1:find( (YoptaWords[i][1][1] == "." or YoptaWords[i][1][1] == ":") and YoptaWords[i][1] .. " " or YoptaWords[i][1]:Right(1) == "." and " " .. YoptaWords[i][1] or " " .. YoptaWords[i][1] .. " ", number, true)
		while find do
			number = number+1
			if !YoptaCheckInQuotes(quotes, find) then
				str1 = str1:sub(1, (YoptaWords[i][1][1] == "." or YoptaWords[i][1][1] == ":") and find-1 or find) .. YoptaWords[i][2] .. str1:sub(YoptaWords[i][1]:Right(1) == "." and find1+1 or find1, -1)
				quotes = YoptaScriptQuoteTab(str1)
			end
		find, find1 = str1:find( (YoptaWords[i][1][1] == "." or YoptaWords[i][1][1] == ":") and YoptaWords[i][1] .. " " or YoptaWords[i][1]:Right(1) == "." and " " .. YoptaWords[i][1] or " " .. YoptaWords[i][1] .. " ", number, true)
		end
		number = 1
	end
	return str1
end
function YoptaConvertFromLua(str) -- Конвертер стрингов в йоптакод
	local str1 = string.Replace(string.Replace(string.Replace(string.Replace(string.Replace(string.Replace(" " .. str .. " ", "\t", " \t " ), "\n", " \n "), ";", " ; "), "(", " ( "), ")", " ) "), ",", " , ") -- Берем копию оригинальной строчки.
	local quotes = YoptaScriptQuoteTab(str1)
	local number = 1
	local find, find1 = 0,0
	for i=1, #YoptaWords do
		find, find1 = str1:find( (YoptaWords[i][2][1] == "." or YoptaWords[i][2][1] == ":") and YoptaWords[i][2] .. " " or YoptaWords[i][2]:Right(1) == "." and " " .. YoptaWords[i][2] or " " .. YoptaWords[i][2] .. " ", number, true)
		while find do
			number = number+1
			if !YoptaCheckInQuotes(quotes, find) then
				str1 = str1:sub(1, (YoptaWords[i][2][1] == "." or YoptaWords[i][2][1] == ":") and find-1 or find) .. YoptaWords[i][1] .. str1:sub(YoptaWords[i][2]:Right(1) == "." and find1+1 or find1, -1)
				quotes = YoptaScriptQuoteTab(str1)
			end
		find, find1 = str1:find((YoptaWords[i][2][1] == "." or YoptaWords[i][2][1] == ":") and YoptaWords[i][2] .. " " or YoptaWords[i][2]:Right(1) == "." and " " .. YoptaWords[i][2] or " " .. YoptaWords[i][2] .. " ", number, true)
		end
		number = 1
	end
	return str1
end
function YoptaFastConvert(str) -- Очень быстрый конверт кода, но с ошибками.
	local str1 = str
	for i=1, #YoptaWords do
		str1 = string.Replace(str1, YoptaWords[i][1], YoptaWords[i][2])
	end
	return str1
end
function YoptaFastConvertFromLua(str) -- Очень быстрый конверт кода, но с ошибками.
	local str1 = str
	for i=1, #YoptaWords do
		str1 = string.Replace(str1, YoptaWords[i][2], YoptaWords[i][1])
	end
	return str1
end
--[[
	Спасибо таким пидорам, как: Jaff, The Jaff, Jaffies, Jaffie и т.д за помощь в создании GMOD YoptaScript.
	Функции таковы:
	Компиляция fast йопта кода. Имеет следующие ограничения:
		При наличии коллизии слов, может проебаться и вставить другую комманду. Пример малява превращается в маляinва, а не в print.
		Заменяет все слова в ковычках, и других конструкторов стрингов на йопта лад ("У нас шухер, пацаны" превращается в "У нас print, пацаны")
	Плюсы в том, что это просто быстрее, чем normal.
	Компиляция normal йопта кода. Имеет следующие ограничения:
		Добавляет пробелы, очень много пробелов (не критично для самого языка, но все же.)
		Между запятыми в ковычках появляются пробелы ("Я, антон и вася идем гулять" на "Я ,  антон и вася идем гулять")
		Медленее, чем fast компиляция.
	Плюсы:
		Не заменяет слова в двойных ковычках на йопта лад (малява "Я хотел написать ему, но моя малява получилась ужансой" превращается в print "Я хотел написать ему, но моя малява получилась ужансой")
		Не имеет проблем с коллизией слов.
	Пример кода:

	YoptaScript [[
	го i сука 1, 15 крч
		малява("Вот тебе и малява" .. tostring(i) )
	есть
	]]
--]]