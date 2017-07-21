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
  local result = {}
  --Box Header
  local index = 8
  local version = string.sub(data,index + 1,index + 1);
  table.insert(result , "       Version:(0x"..HEX(version,1)..") "..Integer(version,1))
  index = index + 1
  version = Integer(version,1)

  local flags = string.sub(data,index + 1,index + 3)
  flags = "0x"..HEX(flags,3)
  table.insert(result , "       Flag:"..flags)
  index = index + 3
  --Box Data
  entry_count = string.sub(data,index + 1,index + 4)
  index = index + 4
  table.insert(result , "       entry_count: (0x"..HEX(entry_count,4)..") "..Integer(entry_count,4))
  entry_count = Integer(entry_count,4)


  for i = 1,entry_count do
    chunk_offset = string.sub(data,index + 1,index + 4)
    index = index + 4
    table.insert(result , "       chunk_offset: (0x"..HEX(chunk_offset,4)..") "..Integer(chunk_offset,4))
  end

  -- -- result = result.."       index:"..index.." size:"..size.."\r\n"
  table.insert(result , "----------------------------------------------------------------")
  table.insert(result , "�����ַ")
  table.insert(result , "http://l.web.umkc.edu/lizhu/teaching/2016sp.video-communication/ref/mp4.pdf")
  local ret = table.concat(result,"\r\n")
  return {ret}
end

function parse(name,data)
  -- RawWrite(name,data)
  return Parse(name,data)
end

local name = "stco"
-- local data = RawRead(name)
-- print(Parse(name,data)[1])
