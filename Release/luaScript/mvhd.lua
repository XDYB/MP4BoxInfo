
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
    result = (result*0xFF) + byte
    index = index + 1
  end
  return result;
end

function Parse(name,data)
  local size = string.len(data)
  local result = "Full Box:\r\n"
  --Full Box
  --Box Header
  local index = 8
  local version = string.byte(data,index + 1);
  result = result.."       Version:"..version.."\r\n"
  index = index + 1
  local flags = string.sub(data,index + 1,index + 3)
  flags = "0x"..HEX(flags,3)
  result = result.."       Flag:"..flags.."\r\n"
  index = index + 3
  --Box Data
  result = result.."Box Data:\r\n"
  if(version == 0)
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

  rate = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       rate: (0x"..HEX(rate,4)..") "..Integer(rate,4).."\r\n"

  volume  = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       volume: (0x"..HEX(volume,2)..") "..Integer(volume,2).."\r\n"

  -- const bit(16)  reserved = 0;
  reserved  = string.sub(data,index + 1,index + 2)
  result = result.."       reserved: (0x"..HEX(reserved,2)..") ".."\r\n"
  index = index + 2

  -- const unsigned int(32)[2]  reserved = 0;
  reserved  = string.sub(data,index + 1,index + 4*2)
  result = result.."       reserved: (0x"..HEX(reserved,4*2)..") ".."\r\n"
  index = index + 4*2

  -- template int(32)[9]  matrix = { 0x00010000,0,0,0,0x00010000,0,0,0,0x40000000 };
  matrix  = string.sub(data,index + 1,index + 4*9)
  result = result.."       matrix: (0x"..HEX(matrix,4*9)..") ".."\r\n"
  index = index + 4*9

  -- bit(32)[6]  pre_defined = 0;
  pre_defined  = string.sub(data,index + 1,index + 4*6)
  result = result.."       pre_defined: (0x"..HEX(pre_defined,4*6)..") ".."\r\n"
  index = index + 4*6

  next_track_ID = string.sub(data,index + 1,index + 4)
  result = result.."       next_track_ID: (0x"..HEX(next_track_ID,4)..") "..Integer(next_track_ID,4).."\r\n"
  index = index + 4

  -- result = result.."       index:"..index.." size:"..size.."\r\n"
  result = result.."----------------------------------------------------------------\r\n"
  result = result.."Ω≤Ω‚µÿ÷∑\r\n"
  result = result.."http://blog.chinaunix.net/uid-20424888-id-3190160.html\r\n"
  result = result.."http://blog.csdn.net/dxpqxb/article/details/42266811\r\n"
  result = result.."http://blog.csdn.net/pirateleo/article/details/7590056/\r\n"
  return {result}
end

function parse(name,data)
  RawWrite(name,data)
  return Parse(name,data)
end

local name = "mvhd"
-- local data = RawRead(name)
-- Parse(name,data)
