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

  pre_defined = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       pre_defined: (0x"..HEX(pre_defined,4)..") "..Integer(pre_defined,4).."\r\n"

  handler_type = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       handler_type: (0x"..HEX(handler_type,4)..") "..Integer(handler_type,4).."\r\n"

  reserved0 = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       reserved0: (0x"..HEX(reserved0,4)..") "..Integer(reserved0,4).."\r\n"

  reserved1 = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       reserved1: (0x"..HEX(reserved1,4)..") "..Integer(reserved1,4).."\r\n"

  reserved2 = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       reserved2: (0x"..HEX(reserved2,4)..") "..Integer(reserved2,4).."\r\n"

  if (index < size) then
    name = string.sub(data,index+1,size)
    result = result.."       name: "..name.."\r\n"
  end
  -- -- result = result.."       index:"..index.." size:"..size.."\r\n"
  result = result.."----------------------------------------------------------------\r\n"
  result = result.."½²½âµØÖ·\r\n"
  result = result.."http://l.web.umkc.edu/lizhu/teaching/2016sp.video-communication/ref/mp4.pdf\r\n"
  return {result}
end

function parse(name,data)
  -- RawWrite(name,data)
  return Parse(name,data)
end

local name = "hdlr"
-- local data = RawRead(name)
-- print(Parse(name,data)[1])
