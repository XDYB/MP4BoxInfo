#pragma once

#include <stdint.h>
#include <fstream>

namespace MP4 {


	class Stream
	{
	public:
		static   int8_t readInt8(Stream &fs);
		static  int16_t readInt16(Stream &fs);
		static  int32_t readInt32(Stream &fs);
		static  uint8_t readUint8(Stream &fs);
		static uint32_t readUint32(Stream &fs);
		static uint64_t readUint64(Stream &fs);
		static double   readDouble(Stream &fs);

		static void  writeInt16(Stream &fs, int16_t);
		static void  writeInt32(Stream &fs, int32_t);
		static void  writeUint8(Stream &fs, uint8_t);
		static void  writeUint32(Stream &fs, uint32_t);
		static void  writeUint64(Stream &fs, uint64_t);
	public:
		virtual ~Stream() {}
		virtual void seekg(uint64_t pos) = 0;
		virtual uint64_t tellg() = 0;
		virtual void read(char * data, int size) = 0;
		virtual void write(char * data,int size) = 0;
	};

	class FileStream
		:public Stream
	{
	public:
		FileStream();
		void FromFStream(std::fstream *fstream);

		virtual void seekg(uint64_t pos);
		virtual uint64_t tellg();
		virtual void read(char * data, int size);
		virtual void write(char * data, int size);
	private:
		std::fstream *stream;
	};

}