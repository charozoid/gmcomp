result = io.open(arg[1], 'rb'):read'*a'
outfn = arg[1]:sub(1, -5) .. "_kripted.lua"

local mods = {
	["local_crypter"] = true,
	["string_functioner"] = true,
	["string_crypter"] = true,
	["localiser"] = true,
	["fix_bad_spellings"] = true
}

local pats = {
	"net",
	"hook",
	"util",
	"http",
	"game",
	"file"
}

local imp = {
	"RunString",
	"error"
}

function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

--IMP CRYPTER
for i=1,#imp do
	for data in string.gmatch(result,"("..imp[i]..")%(") do
		result = string.gsub(result,"("..imp[i]..")%(","_G[\""..imp[i].."\"](")
	end
end
--END

--STRING FUNCTIONER
local str_functioner = 0
if mods["string_functioner"] then
for data in string.gmatch(result,"\".-\"") do
	local should_continue = true

	if data:find("\\") or data:find("%%") then should_continue = false end

	if data:find(")") and should_continue then
		_data = string.gsub(data,"%)","\\x" .. string.tohex(")"))
		result = string.gsub(result,string.gsub(data, "(%W)", "%%%1"),_data,1)
	end
end

for data in string.gmatch(result,"(string%.%w+%((.-)%))") do
	local tab = {string.match(data,"string%.(%w+)")}
	local _tab = {string.match(data,"string%.%w+%((.-)[%,%)]")}
	local _2tab = {string.match(data,"string%.%w+%(".._tab[1]:gsub("(%W)", "%%%1").."%,(.-)%)")}
	local _data = string.gsub(data, "(%W)", "%%%1")

	--print(tab[1],_tab[1],_2tab[1])
	--print(_2tab[1])
	if not (string.match(result,"function ".._data)) then
		if tab[1] and _tab[1] and _tab[1]:len()>0 then
			if _tab[1]:find("\"") then

			else
				--print(_tab[1],tab[1],_2tab[1])
				--print(_tab[1]..":"..tab[1].."(".._2tab[1]..")")
				result = result:gsub(_data, _tab[1]..":"..tab[1].."("..(_2tab[1] or "")..")")
				str_functioner = str_functioner + 1
			end
		end
	end
end
end
--END