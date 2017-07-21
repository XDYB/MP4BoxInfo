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

  balance = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       balance: (0x"..HEX(balance,2)..") "..Integer(balance,2).."\r\n"

  reserved = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       reserved: (0x"..HEX(reserved,2)..") "..Integer(reserved,2).."\r\n"

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

local name = "smhd"
-- local data = RawRead(name)
-- print(Parse(name,data)[1])
