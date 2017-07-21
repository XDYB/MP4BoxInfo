function RawWrite(name,data)
  local filename = "./luaScript/data/"..name..".raw";
	local file = io.open(filename, "wb");
	assert(file);
	file:write(data);
	file:close();
end

function RawRead(name)
  local filename = "./data/"..name..".raw";
	local file = io.open(filename, "rb");
	assert(file);
	local data = file:read("*a");
	file:close();
  return data;
end

function HEX(data,count)
  local charHEX = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
  local index = 1
  local result = ""
  while (count >= index)  do
    local byte = string.byte(data,index)
    result = result .. charHEX[math.floor(byte / 0x10) + 1]
    result = result .. charHEX[(byte % 0x10) + 1]
    index = index + 1
  end
  return result;
end

function Integer(data,count)
  local index = 1
  local result = 0
  while (count >= index)  do
    local byte = string.byte(data,index)
    result = (result*0x100) + byte
    index = index + 1
  end
  return result;
end

function Parse(name,data)
  local size = string.len(data)
  local result = ""
  --Box Header
  local index = 8
  local version = string.sub(data,index + 1,index + 1);
  result = result.."       Version:(0x"..HEX(version,1)..") "..Integer(version,1).."\r\n"
  index = index + 1
  version = Integer(version,1)

  local flags = string.sub(data,index + 1,index + 3)
  flags = "0x"..HEX(flags,3)
  result = result.."       Flag:"..flags.."\r\n"
  index = index + 3
  --Box Data
  if (version == 0)
  then
    creation_time = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       creation_time: (0x"..HEX(creation_time,4)..") "..Integer(creation_time,4).."\r\n"

    modification_time = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       modification_time: (0x"..HEX(modification_time,4)..") "..Integer(modification_time,4).."\r\n"

    timescale = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       timescale: (0x"..HEX(timescale,4)..") "..Integer(timescale,4).."\r\n"

    duration = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       duration: (0x"..HEX(duration,4)..") "..Integer(duration,4).."\r\n"
  else
    creation_time = string.sub(data,index + 1,index + 8)
    index = index + 8
    result = result.."       creation_time: (0x"..HEX(creation_time,8)..") "..Integer(creation_time,8).."\r\n"

    modification_time = string.sub(data,index + 1,index + 8)
    index = index + 8
    result = result.."       modification_time: (0x"..HEX(modification_time,8)..") "..Integer(modification_time,8).."\r\n"

    timescale = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       timescale: (0x"..HEX(timescale,4)..") "..Integer(timescale,4).."\r\n"

    duration = string.sub(data,index + 1,index + 8)
    index = index + 8
    result = result.."       duration: (0x"..HEX(duration,8)..") "..Integer(duration,8).."\r\n"
  end

  local language = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       language: (0x"..HEX(language,2)..") "..Integer(language,2).."\r\n"

  result = result.."       {\r\n"
  language = Integer(language,2)
  local pad = bit32.rshift(bit32.band(language,0x00008000),15)
  local language1 = bit32.rshift(bit32.band(language,0x00007C00),10)
  local language2 = bit32.rshift(bit32.band(language,0x000003E0),5)
  local language3 = bit32.band(language,0x0000001F)
  result = result .."       pad(1b):" .. pad .."\r\n"
  result = result .."       language1(5b):" .. language1 .."\r\n"
  result = result .."       language2(5b):" .. language2 .."\r\n"
  result = result .."       language3(5b):" .. language3 .."\r\n"
  result = result.."       }\r\n"


  local pre_defined = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       pre_defined: (0x"..HEX(pre_defined,2)..") "..Integer(pre_defined,2).."\r\n"
  --
  -- -- result = result.."       index:"..index.." size:"..size.."\r\n"
  result = result.."----------------------------------------------------------------\r\n"
  result = result.."Ω≤Ω‚µÿ÷∑\r\n"
  result = result.."http://l.web.umkc.edu/lizhu/teaching/2016sp.video-communication/ref/mp4.pdf\r\n"
  return {result}
end

function parse(name,data)
  -- RawWrite(name,data)
  return Parse(name,data)
end

local name = "mdhd"
-- local data = RawRead(name)
-- print(Parse(name,data)[1])
