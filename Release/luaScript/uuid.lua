
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
  --Full Box
  --Box Header
  local index = 8
  --Box Data
  result = result.."Box Data:\r\n"

  uuid = string.sub(data,index + 1,index + 16)
  index = index + 16
  result = result.."       uuid: (0x"..HEX(uuid,16)..") ".."\r\n"

  data  = string.sub(data,index + 1,size)
  result = result.."       size: "..string.len(data).."\r\n"
  result = result.."       data: ".."\r\n"..data.."\r\n"
  -- result = result.."       index:"..index.." size:"..size.."\r\n"
  result = result.."\r\n----------------------------------------------------------------\r\n"
  result = result.."Ω≤Ω‚µÿ÷∑\r\n"
  result = result.."http://l.web.umkc.edu/lizhu/teaching/2016sp.video-communication/ref/mp4.pdf\r\n"
  result = result.."http://blog.chinaunix.net/uid-20424888-id-3190160.html\r\n"
  result = result.."http://blog.csdn.net/dxpqxb/article/details/42266811\r\n"
  result = result.."http://blog.csdn.net/pirateleo/article/details/7590056/\r\n"
  return {result}
end

function parse(name,data)
  -- RawWrite(name,data)
  return Parse(name,data)
end

local name = "uuid"
-- local data = RawRead(name)
-- Parse(name,data)
