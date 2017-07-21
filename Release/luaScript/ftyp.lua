
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

-- http://www.ftyps.com/
local table_ftyp = {
  {"3g2a","3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-0 V1.0","video/3gpp2"},
  {"3g2b","3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-A V1.0.0","video/3gpp2"},
  {"3g2c","3GPP2 Media (.3G2) compliant with 3GPP2 C.S0050-B v1.0","video/3gpp2"},
  {"3ge6","3GPP (.3GP) Release 6 MBMS Extended Presentations","video/3gpp"},
  {"3ge7","3GPP (.3GP) Release 7 MBMS Extended Presentations","video/3gpp"},
  {"3gg6","3GPP Release 6 General Profile","video/3gpp"},
  {"3gp1","3GPP Media (.3GP) Release 1 (probably non-existent)","video/3gpp"},
  {"3gp2","3GPP Media (.3GP) Release 2 (probably non-existent)","video/3gpp"},
  {"3gp3","3GPP Media (.3GP) Release 3 (probably non-existent)","video/3gpp"},
  {"3gp4","3GPP Media (.3GP) Release 4","video/3gpp"},
  {"3gp5","3GPP Media (.3GP) Release 5","video/3gpp"},
  {"3gp6","3GPP Media (.3GP) Release 6 Basic Profile","video/3gpp"},
  {"3gp6","3GPP Media (.3GP) Release 6 Progressive Download","video/3gpp"},
  {"3gp6","3GPP Media (.3GP) Release 6 Streaming Servers","video/3gpp"},
  {"3gs7","3GPP Media (.3GP) Release 7 Streaming Servers","video/3gpp"},
  {"avc1","MP4 Base w/ AVC ext [ISO 14496-12:2005]","video/mp4"},
  {"CAEP","Canon Digital Camera","unknown"},
  {"caqv","Casio Digital Camera","unknown"},
  {"CDes","Convergent Design","unknown"},
  {"da0a","DMB MAF w/ MPEG Layer II aud, MOT slides, DLS, JPG/PNG/MNG images","unknown"},
  {"da0b","DMB MAF, extending DA0A, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"da1a","DMB MAF audio with ER-BSAC audio, JPG/PNG/MNG images","unknown"},
  {"da1b","DMB MAF, extending?da1a, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"da2a","DMB MAF aud w/ HE-AAC v2 aud, MOT slides, DLS, JPG/PNG/MNG images","unknown"},
  {"da2b","DMB MAF, extending?da2a, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"da3a","DMB MAF aud with HE-AAC aud, JPG/PNG/MNG images","unknown"},
  {"da3b","DMB MAF, extending?da3a?w/ BIFS, 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"dmb1","DMB MAF supporting all the components defined in the specification","unknown"},
  {"dmpf","Digital Media Project","various"},
  {"drc1","Dirac (wavelet compression), encapsulated in ISO base media (MP4)","unknown"},
  {"dv1a","DMB MAF vid w/ AVC vid, ER-BSAC aud, BIFS, JPG/PNG/MNG images, TS","unknown"},
  {"dv1b","DMB MAF, extending?dv1a, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"dv2a","DMB MAF vid w/ AVC vid, HE-AAC v2 aud, BIFS, JPG/PNG/MNG images, TS","unknown"},
  {"dv2b","DMB MAF, extending?dv2a, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"dv3a","DMB MAF vid w/ AVC vid, HE-AAC aud, BIFS, JPG/PNG/MNG images, TS","unknown"},
  {"dv3b","DMB MAF, extending?dv3a, with 3GPP timed text, DID, TVA, REL, IPMP","unknown"},
  {"dvr1","DVB (.DVB) over RTP","video/vnd.dvb.file"},
  {"dvt1","DVB (.DVB) over MPEG-2 Transport Stream","video/vnd.dvb.file"},
  {"F4V","Video for Adobe Flash Player 9+ (.F4V)","video/mp4"},
  {"F4P","Protected Video for Adobe Flash Player 9+ (.F4P)","video/mp4"},
  {"F4A","Audio for Adobe Flash Player 9+ (.F4A)","audio/mp4"},
  {"F4B","Audio Book for Adobe Flash Player 9+ (.F4B)","audio/mp4"},
  {"isc2","ISMACryp 2.0 Encrypted File","?/enc-isoff-generic"},
  {"iso2","MP4 Base Media v2 [ISO 14496-12:2005]","video/mp4"},
  {"isom","MP4? Base Media v1 [IS0 14496-12:2003]","video/mp4"},
  {"JP2","JPEG 2000 Image (.JP2) [ISO 15444-1 ?]","image/jp2"},
  {"JP20","Unknown, from GPAC samples (prob non-existent)","unknown"},
  {"jpm","JPEG 2000 Compound Image (.JPM) [ISO 15444-6]","image/jpm"},
  {"jpx","JPEG 2000 w/ extensions (.JPX) [ISO 15444-2]","image/jpx"},
  {"KDDI","3GPP2 EZmovie for KDDI 3G cellphones","video/3gpp2"},
  {"M4A","Apple iTunes AAC-LC (.M4A) Audio","audio/x-m4a"},
  {"M4B","Apple iTunes AAC-LC (.M4B) Audio Book","audio/mp4"},
  {"M4P","Apple iTunes AAC-LC (.M4P) AES Protected Audio","audio/mp4"},
  {"M4V","Apple iTunes Video (.M4V) Video","video/x-m4v"},
  {"M4VH","Apple TV (.M4V)","video/x-m4v"},
  {"M4VP","Apple iPhone (.M4V)","video/x-m4v"},
  {"mj2s","Motion JPEG 2000 [ISO 15444-3] Simple Profile","video/mj2"},
  {"mjp2","Motion JPEG 2000 [ISO 15444-3] General Profile","video/mj2"},
  {"mmp4","MPEG-4/3GPP Mobile Profile (.MP4 / .3GP) (for NTT)","video/mp4"},
  {"mp21","MPEG-21 [ISO/IEC 21000-9]","various"},
  {"mp41","MP4 v1 [ISO 14496-1:ch13]","video/mp4"},
  {"mp42","MP4 v2 [ISO 14496-14]","video/mp4"},
  {"mp71","MP4 w/ MPEG-7 Metadata [per ISO 14496-12]","various"},
  {"MPPI","Photo Player, MAF [ISO/IEC 23000-3]","various"},
  {"mqt","Sony / Mobile QuickTime (.MQV)? US Patent 7,477,830 (Sony Corp)","video/quicktime"},
  {"MSNV","MPEG-4 (.MP4) for SonyPSP","audio/mp4"},
  {"NDAS","MP4 v2 [ISO 14496-14] Nero Digital AAC Audio","audio/mp4"},
  {"NDSC","MPEG-4 (.MP4) Nero Cinema Profile","video/mp4"},
  {"NDSH","MPEG-4 (.MP4) Nero HDTV Profile","video/mp4"},
  {"NDSM","MPEG-4 (.MP4) Nero Mobile Profile","video/mp4"},
  {"NDSP","MPEG-4 (.MP4) Nero Portable Profile","video/mp4"},
  {"NDSS","MPEG-4 (.MP4) Nero Standard Profile","video/mp4"},
  {"NDXC","H.264/MPEG-4 AVC (.MP4) Nero Cinema Profile","video/mp4"},
  {"NDXH","H.264/MPEG-4 AVC (.MP4) Nero HDTV Profile","video/mp4"},
  {"NDXM","H.264/MPEG-4 AVC (.MP4) Nero Mobile Profile","video/mp4"},
  {"NDXP","H.264/MPEG-4 AVC (.MP4) Nero Portable Profile","video/mp4"},
  {"NDXS","H.264/MPEG-4 AVC (.MP4) Nero Standard Profile","video/mp4"},
  {"odcf","OMA DCF DRM Format 2.0 (OMA-TS-DRM-DCF-V2_0-20060303-A)","various"},
  {"opf2","OMA PDCF DRM Format 2.1 (OMA-TS-DRM-DCF-V2_1-20070724-C)","unknown"},
  {"opx2","OMA PDCF?DRM + XBS extensions (OMA-TS-DRM_XBS-V1_0-20070529-C)","unknown"},
  {"pana","Panasonic Digital Camera","unknown"},
  {"qt","Apple QuickTime (.MOV/QT)","video/quicktime"},
  {"ROSS","Ross Video","unknown"},
  {"sdv","SD Memory Card Video","various?"},
  {"ssc1","Samsung stereoscopic, single stream (patent pending, see notes)","unknown"},
  {"ssc2","Samsung stereoscopic, dual stream (patent pending, see notes)","unknown"}
}

function FindDescription(major_brand)
  local size = table.maxn(table_ftyp)
  for i = 1 , size do
      local ftypDes = table_ftyp[i]
      if(string.find(major_brand,ftypDes[1]) ~= nil)
      then
        return ftypDes;
      end
  end
  return nil
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

-- http://www.ftyps.com/composite.htm#6.3
-- http://blog.csdn.net/dxpqxb/article/details/42266779
function Parse(data)
  local result = {}
  local size = string.len(data)
  --Box Header
  local index = 8
  --Box Data
  -- 标示 major_brand
  if (index < size)
  then
    local major_brand = string.sub(data,index + 1,index + 4)
    print("标示:  ".. major_brand)
    table.insert(result,"标示:  ".. major_brand)
    local ftypDes = FindDescription(major_brand)
    print("         描述:  ".. ftypDes[2])
    table.insert(result,"         描述:  ".. ftypDes[2])
    print("         MIME类型:  ".. ftypDes[3])
    table.insert(result,"         MIME类型:  ".. ftypDes[3])
    index = index + 4
  end
  -- 版本 minor_version
  if (index < size)
  then
    local minor_version = string.sub(data,index + 1,index + 4)
    index = index + 4;
    print("版本:  0x"..HEX(minor_version,4))
    table.insert(result,"版本:  0x"..HEX(minor_version,4))
  end
  -- 兼容标示 compatible_brands
  if (index < size)
  then
    local str = "兼容标示:  "
    while(true) do
      if (index < size)
      then
        local compatible_brand = string.sub(data,index + 1,index + 4)
        index = index + 4;
        str = str .." ".. compatible_brand .. " "
      else
        break
      end
    end
    print(str)
    table.insert(result,str)
  end

  table.insert(result,"----------------------------------------------------------------")
  table.insert(result,"讲解地址")
  table.insert(result,"http://www.ftyps.com/")
  table.insert(result,"http://www.ftyps.com/composite.htm#6.3")
  table.insert(result,"http://blog.csdn.net/dxpqxb/article/details/42266779")

  return result;
end

function parse(name,data)
	-- RawWrite(name,data)
  return Parse(data);
end

-- local data = RawRead("ftyp")
-- Parse(data)
