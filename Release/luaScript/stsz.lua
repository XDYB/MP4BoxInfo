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
  sample_size = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       sample_size: (0x"..HEX(sample_size,4)..") "..Integer(sample_size,4).."\r\n"
  sample_size = Integer(sample_size,4)
  
  sample_count = string.sub(data,index + 1,index + 4)
  index = index + 4
  result = result.."       sample_count: (0x"..HEX(sample_count,4)..") "..Integer(sample_count,4).."\r\n"
  sample_count = Integer(sample_count,4)

  if sample_size == 0 then
    for i = 1,sample_count do
      entry_size = string.sub(data,index + 1,index + 4)
      index = index + 4
      result = result.."       entry_size: (0x"..HEX(entry_size,4)..") "..Integer(entry_size,4).."\r\n"
    end
  end
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

local name = "stsz"
-- local data = RawRead(name)
-- print(Parse(name,data)[1])
