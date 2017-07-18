#include "stdafx.h"
#include "Stream.h"
#include "endian.h"

namespace MP4{

double Stream::readDouble(Stream &fs)
{
	union {
		double  fVal;
		int64_t iVal;
		char bytes[8];
	} buf;
	fs.read(buf.bytes, 8);
	// BigEndian to Host
	buf.iVal = be64toh(buf.iVal);
	return buf.fVal;
}

uint8_t Stream::readUint8(Stream &fs)
{
	union {
		uint8_t iVal;
		char bytes[1];
	} buf;
	fs.read(buf.bytes, 1);
	// BigEndian to Host
	return buf.iVal; //be8toh ( buf.iVal );
}

int8_t Stream::readInt8(Stream &fs)
{
	union {
		int8_t iVal;
		char bytes[1];
	} buf;
	fs.read(buf.bytes, 1);
	// BigEndian to Host
	return buf.iVal; //be8toh ( buf.iVal );
}

int16_t Stream::readInt16(Stream &fs)
{
	union {
		int16_t iVal;
		char bytes[2];
	} buf;
	fs.read(buf.bytes, 2);
	// BigEndian to Host
	return be16toh(buf.iVal);
}

int32_t Stream::readInt32(Stream &fs)
{
	union {
		int32_t iVal;
		char bytes[4];
	} buf;
	fs.read(buf.bytes, 4);
	// BigEndian to Host
	return be16toh(buf.iVal);
}

uint32_t Stream::readUint32(Stream &fs)
{
	union {
		uint32_t iVal;
		char bytes[4];
	} buf;
	fs.read(buf.bytes, 4);
	// BigEndian to Host
	return be32toh(buf.iVal);
}

uint64_t Stream::readUint64(Stream &fs)
{
	union {
		uint64_t iVal;
		char bytes[8];
	} buf;
	fs.read(buf.bytes, 8);
	// BigEndian to Host
	return be64toh(buf.iVal);
}

void Stream::writeUint8(Stream &fs, uint8_t iVal)
{
	union {
		uint8_t iVal;
		char bytes[1];
	} buf;
	buf.iVal = iVal; // htobe8 ( iVal );
	fs.write((char *)buf.bytes, 1);
}

void Stream::writeInt16(Stream &fs, int16_t iVal)
{
	union {
		int16_t iVal;
		char bytes[2];
	} buf;
	buf.iVal = htobe16(iVal);
	fs.write((char *)buf.bytes, 2);
}

void Stream::writeInt32(Stream &fs, int32_t iVal)
{
	union {
		int32_t iVal;
		char bytes[4];
	} buf;
	buf.iVal = htobe32(iVal);
	fs.write((char *)buf.bytes, 4);
}

void Stream::writeUint32(Stream &fs, uint32_t iVal)
{
	union {
		uint32_t iVal;
		char bytes[4];
	} buf;
	buf.iVal = htobe32(iVal);
	fs.write((char *)buf.bytes, 4);
}

void Stream::writeUint64(Stream &fs, uint64_t iVal)
{
	union {
		uint64_t iVal;
		char bytes[8];
	} buf;
	buf.iVal = htobe64(iVal);
	fs.write((char *)buf.bytes, 8);
}


FileStream::FileStream()
	:stream(NULL)
{
}

void FileStream::FromFStream(std::fstream *fstream)
{
	stream = fstream;
}

void FileStream::seekg(uint64_t pos)
{
	if (stream != NULL) stream->seekg(pos);
}

uint64_t FileStream::tellg()
{
	if (stream != NULL) return stream->tellg();
	return 0;
}

void FileStream::read(char * data, int size)
{
	if(stream != NULL) stream->read(data,size);
}

void FileStream::write(char * data, int size)
{
	if(stream != NULL) stream->write(data,size);
}

}