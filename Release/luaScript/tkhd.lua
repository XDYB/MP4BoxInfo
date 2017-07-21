
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
  local version = string.sub(data,index + 1,index + 1);
  result = result.."       Version:(0x"..HEX(version,1)..") "..Integer(version,1).."\r\n"
  index = index + 1
  version = Integer(version,1)

  local flags = string.sub(data,index + 1,index + 3)
  flags = "0x"..HEX(flags,3)
  result = result.."       Flag:"..flags.."\r\n"
  index = index + 3
  --Box Data
  result = result.."Box Data:\r\n"

  if(version ~= 1)
  then
    creation_time = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       creation_time: (0x"..HEX(creation_time,4)..") "..Integer(creation_time,4).."\r\n"

    modification_time = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       modification_time: (0x"..HEX(modification_time,4)..") "..Integer(modification_time,4).."\r\n"

    track_ID = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       track_ID: (0x"..HEX(track_ID,4)..") "..Integer(track_ID,4).."\r\n"

    reserved = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       reserved: (0x"..HEX(reserved,4)..") "..Integer(reserved,4).."\r\n"

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

    track_ID = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       track_ID: (0x"..HEX(track_ID,4)..") "..Integer(track_ID,4).."\r\n"

    reserved = string.sub(data,index + 1,index + 4)
    index = index + 4
    result = result.."       reserved: (0x"..HEX(reserved,4)..") "..Integer(reserved,4).."\r\n"

    duration = string.sub(data,index + 1,index + 8)
    index = index + 8
    result = result.."       duration: (0x"..HEX(duration,8)..") "..Integer(duration,8).."\r\n"
  end

  reserved = string.sub(data,index + 1,index + 4*2)
  index = index + 4*2
  result = result.."       reserved: (0x"..HEX(reserved,4*2)..") "..Integer(reserved,4*2).."\r\n"

  layer  = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       layer: (0x"..HEX(layer,2)..") "..Integer(layer,2).."\r\n"

  alternate_group  = string.sub(data,index + 1,index + 2)
  result = result.."       alternate_group: (0x"..HEX(alternate_group,2)..") ".."\r\n"
  index = index + 2

  volume  = string.sub(data,index + 1,index + 2)
  result = result.."       volume: (0x"..HEX(volume,2)..") ".."\r\n"
  index = index + 2

  reserved  = string.sub(data,index + 1,index + 2)
  result = result.."       reserved: (0x"..HEX(reserved,2)..") ".."\r\n"
  index = index + 2

  matrix  = string.sub(data,index + 1,index + 4*9)
  result = result.."       matrix: (0x"..HEX(matrix,4*9)..") ".."\r\n"
  index = index + 4*9

  width = string.sub(data,index + 1,index + 4)
  result = result.."       float(16.16) width: (0x"..HEX(width,4)..") "..Integer(width,4).."\r\n"
  index = index + 4

  height = string.sub(data,index + 1,index + 4)
  result = result.."       float(16.16) height: (0x"..HEX(height,4)..") "..Integer(height,4).."\r\n"
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
  -- RawWrite(name,data)
  return Parse(name,data)
end

local name = "tkhd"
-- local data = RawRead(name)
-- Parse(name,data)
