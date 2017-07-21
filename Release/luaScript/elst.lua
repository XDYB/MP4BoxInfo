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

function parse(name,data)
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
  local entry_count = string.sub(data,index + 1,index + 4)
  result = result.."       entry_count: (0x"..HEX(entry_count,4)..") "..Integer(entry_count,4).."\r\n"
  index = index + 4
  entry_count = Integer(entry_count,4)

  if (version == 1)
  then
    for i = 1,entry_count do
      result = result .. "{\r\n"
      segment_duration = string.sub(data,index + 1,index + 8)
      index = index + 8
      result = result.."       segment_duration: (0x"..HEX(segment_duration,8)..") "..Integer(segment_duration,8).."\r\n"

      media_time = string.sub(data,index + 1,index + 8)
      index = index + 8
      result = result.."       media_time: (0x"..HEX(media_time,8)..") "..Integer(media_time,8).."\r\n"
      result = result .. "}\r\n"
    end
  else
    for i = 1,entry_count do
      result = result .. "{\r\n"
      segment_duration = string.sub(data,index + 1,index + 4)
      index = index + 4
      result = result.."       segment_duration: (0x"..HEX(segment_duration,4)..") "..Integer(segment_duration,4).."\r\n"

      media_time = string.sub(data,index + 1,index + 4)
      index = index + 4
      result = result.."       media_time: (0x"..HEX(media_time,4)..") "..Integer(media_time,4).."\r\n"
      result = result .. "}\r\n"
    end
  end

  local media_rate_integer = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       media_rate_integer: (0x"..HEX(media_rate_integer,2)..") "..Integer(media_rate_integer,2).."\r\n"

  local media_rate_fraction = string.sub(data,index + 1,index + 2)
  index = index + 2
  result = result.."       media_rate_fraction: (0x"..HEX(media_rate_fraction,2)..") "..Integer(media_rate_fraction,2).."\r\n"

  -- result = result.."       index:"..index.." size:"..size.."\r\n"
  result = result.."----------------------------------------------------------------\r\n"
  result = result.."Ω≤Ω‚µÿ÷∑\r\n"
  result = result.."http://l.web.umkc.edu/lizhu/teaching/2016sp.video-communication/ref/mp4.pdf\r\n"
  return {result}
end
