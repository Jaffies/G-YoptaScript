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
	local str0 = " ".. str .. " "
	local str1 = str0:Replace("\t", " \t "):Replace("\n", " \n "):Replace(";", " ; "):Replace(")", " ) "):Replace("(", " ( "):Replace(",", " , "):Replace(":", " : "):Replace(".", " . ") -- Берем копию оригинальной строчки.
	
	local quotes = YoptaScriptQuoteTab(str1)
	local number = 1
	local find, find1 = 0,0 
	for i=1, #YoptaWords do
		find, find1 = str1:find( " " .. YoptaWords[i][1] .. " ", number, true)
		while find do
			number = number+1
			if !YoptaCheckInQuotes(quotes, find) then
				str1 = str1:sub(1, find) .. YoptaWords[i][2] .. str1:sub(find1, -1)
				quotes = YoptaScriptQuoteTab(str1)
			end
		find, find1 = str1:find( " " .. YoptaWords[i][1] .. " ", number, true)
		end
		number = 1
	end
	return str1:sub(2,#str1-1):Replace(" \t ", "\t"):Replace(" \n ", "\n"):Replace(" ; ", ";"):Replace(" ( ", "("):Replace(" ) ", ")"):Replace(" , ", ","):Replace(" : ", ":"):Replace(" . ", ".")
end
function YoptaConvertFromLua(str) -- Конвертер стрингов в йоптакод
	local str0 = " ".. str .. " "
	local str1 = str0:Replace("\t", " \t "):Replace("\n", " \n "):Replace(";", " ; "):Replace(")", " ) "):Replace("(", " ( "):Replace(",", " , "):Replace(":", " : "):Replace(".", " . ") -- Берем копию оригинальной строчки.
	local quotes = YoptaScriptQuoteTab(str1)
	local number = 1
	local find, find1 = 0,0
	for i=1, #YoptaWords do
		find, find1 = str1:find( " " .. YoptaWords[i][2] .. " ", number, true)
		while find do
			number = number+1
			if !YoptaCheckInQuotes(quotes, find) then
				str1 = str1:sub(1, find) .. YoptaWords[i][1] .. str1:sub(find1, -1)
				quotes = YoptaScriptQuoteTab(str1)
			end
		find, find1 = str1:find( " " .. YoptaWords[i][2] .. " ", number, true)
		end
		number = 1
	end
	return str1:sub(2,#str1-1):Replace(" \t ", "\t"):Replace(" \n ", "\n"):Replace(" ; ", ";"):Replace(" ( ", "("):Replace(" ) ", ")"):Replace(" , ", ","):Replace(" : ", ":"):Replace(" . ", ".")
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
--[=[
	Спасибо таким пидорам, как: Jaff, The Jaff, Jaffies, Jaffie и т.д за помощь в создании GMOD YoptaScript.
	Функции таковы:
	Компиляция fast йопта кода. Имеет следующие ограничения:
		При наличии коллизии слов, может проебаться и вставить другую комманду. Пример малява превращается в маляinва, а не в print. (только в конверции с lua кода.)
		Заменяет все слова в ковычках, и других конструкторов стрингов на йопта лад ("У нас шухер, пацаны" превращается в "У нас print, пацаны")
	Плюсы в том, что это просто быстрее, чем normal.
	Компиляция normal йопта кода. Имеет следующие ограничения:
		Медленее, чем fast компиляция.
	Плюсы:
		Не заменяет слова в двойных ковычках на йопта лад (малява "Я хотел написать ему, но моя малява получилась ужансой" превращается в print "Я хотел написать ему, но моя малява получилась ужансой")
		Не имеет проблем с коллизией слов.
	Пример кода:
		YoptaScript [[
			го i сука 1, 15 крч
				малява(i%2 однахуйня 0 ичо "Четное число" иличо "Нечетное число", "\n", гопец.гопинус( (i-1)/14) )
			есть
		]]


		YoptaScript [[
			Noise внатуре {}
			йопта QuinticCurve(t)
			  отвечаю гопец.гопень(t, 3) * (t * (t * 6 - 15) + 10) нах 
			есть
			йопта CosineCurve(t)
				отвечаю (1 - гопец.гопосинос(t * гопец.Пиздец) ) / 2
			есть
			йопта CubicCurve(t)
				отвечаю -2 * t * t * t + 3 * t * t
			есть
			йопта Noise:CreateSimpleNoise(rtsize, size, хуйчик, хуйло, alpha, name, mult)
				вилкойвглаз mult однахуйня нихуя жы mult внатуре 1 есть
				куку texture12 внатуре вычислитьЦельДосок("rt1_noise_" .. name, rtsize, rtsize, нечетко)
				доскаОхуенная.PushRenderTarget(texture12, 0, 0, texture12:Width(), texture12:Height())
					доскаОхуенная.Clear(255, 255, 255, 255)
					cam.Start2D()
					куку scale внатуре texture12:Width() / size
					малява(scale)
					го y внатуре 0, size - 1 крч
						го x внатуре 0, size - 1 крч
							куку dot внатуре гопец.шара(хуйчик, хуйло)
							доска.SetDrawColor(dot * mult, dot * mult, dot * mult, aplha)
							доска.DrawRect(x * scale, y * scale, 1 * scale, 1 * scale)
						есть
					есть
					cam.End2D()
				доскаОхуенная.PopRenderTarget()
				отвечаю texture12, "rt_noise_" .. name
			есть
			йопта BillinearLerp(tx, ty, topleft, topright, downleft, downright)
				отвечаю (topleft-topright-downleft+downright) * ( tx * ty ) + (topright-topleft) * tx + (downleft-topleft) * ty + topleft
			есть
			йопта Noise:Blur(text, blursize, passes)
				доскаОхуенная.PushRenderTarget(text, 0, 0, text:Width(), text:Height())
					доскаОхуенная.BlurRenderTarget(text, blursize, blursize, passes)
				доскаОхуенная.PopRenderTarget()
			есть
			йопта Noise:Interp(rt, size, name)
				куку texture внатуре вычислитьЦельДосок("rt_noise_" .. name, rt:Width(), rt:Height(), нечетко)
				куку scale внатуре rt:Width() / size
				доскаОхуенная.PushRenderTarget(rt, 0, 0, rt:Width(), rt:Height())
					доскаОхуенная.CapturePixels()
				доскаОхуенная.PopRenderTarget()
				доскаОхуенная.PushRenderTarget(texture, 0, 0, texture:Width(), texture:Height())
				доскаОхуенная.Clear(255, 255, 255, 255)
				cam.Start2D()
					го x внатуре 0, rt:Width() крч
						го y внатуре 0, rt:Height() крч
							куку floorx внатуре гопец.бабкиГони(x / scale) * scale
							куку ceilx внатуре гопец.ЧирикГони(x / scale) * scale
							вилкойвглаз ceilx однахуйня rt:Width() жы ceilx внатуре floorx есть
							куку floory внатуре гопец.бабкиГони(y / scale) * scale
							куку ceily внатуре гопец.ЧирикГони(y / scale) * scale
							вилкойвглаз ceily однахуйня rt:Width() жы ceily внатуре floory есть
							куку topleftpixel внатуре доскаОхуенная.ReadPixel(floorx, floory)
							куку toprightpixel внатуре доскаОхуенная.ReadPixel(ceilx, floory)
							куку downleftpixel внатуре доскаОхуенная.ReadPixel(floorx, ceily)
							куку downrightpixel внатуре доскаОхуенная.ReadPixel(ceilx, ceily)
							куку posx внатуре x / scale - гопец.бабкиГони(x / scale)
							куку posy внатуре y / scale - гопец.бабкиГони(y / scale)
							куку lerp внатуре BillinearLerp(CubicCurve(posx), CubicCurve(posy), topleftpixel, toprightpixel, downleftpixel, downrightpixel)
							доска.SetDrawColor(lerp, lerp, lerp, 255)
							доска.DrawRect(x, y, 1, 1)
						есть
					есть
				cam.End2D()
				доскаОхуенная.PopRenderTarget()
				отвечаю texture
			есть
			йопта Noise:Combine(bias1, name, name1, name2, name3, name4, name5, name6)
				куку texture1 внатуре вычислитьЦельДосок("rt_noise_" .. name, name1:Width(), name1:Height(), нечетко)
				куку tab внатуре { name1, name2, name3, name4, name5, name6}
				tab[0] внатуре texture1
				вилкойвглаз !isnumber(bias1) жы bias1 внатуре 2 малява("biaserror!") есть
				куку bias внатуре 255
				mat1 внатуре мат("color_ignorez")
				доскаОхуенная.PushRenderTarget(texture1, 0, 0, texture1:Width(), texture1:Height())
					доскаОхуенная.Clear(255, 255, 255, 255)
					cam.Start2D()
						го i внатуре 1, #tab крч
							mat1:SetTexture("$basetexture", tab[i])
							доска.SetMaterial(mat1)
							доска.SetDrawColor(255, 255, 255, bias)
							bias внатуре bias / bias1
							доска.DrawTexturedRect(0, 0, texture1:Width(), texture1:Height())
						есть
					cam.End2D()
				доскаОхуенная.PopRenderTarget()
				отвечаю texture1, tab
			есть
			text3 внатуре Noise:CreateSimpleNoise(512, 8, 0, 255, 255, "atext3")
			text31 внатуре Noise:Interp(text3, 8, "rt_text31")
			подстава.накинуть("HUDPaint", "Test1", йопта()
				доскаОхуенная.DrawTextureToScreenRect(text31, 0, 0, 256, 256)
				доскаОхуенная.DrawTextureToScreenRect(text3, 256, 0, 256, 256)
			есть)
		]]

	Вот такие есть примеры кода.
--]=]