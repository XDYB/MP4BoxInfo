#pragma once

#include <stdint.h>
#include <fstream>
#include "Stream.h"
#include "constants.h"

namespace MP4{

#define UUID_LENGTH 16

#pragma pack(1) 

	//MP4∫–◊”÷÷¿‡
	struct NormalBox
	{
		uint32_t size;
		uint32_t type;
	};

	struct LargeBox
	{
		uint32_t size;      // == 1
		uint32_t type;
		uint64_t largesize;
	};

	struct FullBox
	{
		uint32_t size;
		uint32_t type;
		uint32_t version : 8;
		uint32_t flag : 24;
	};

	struct LargeFullBox
	{
		uint32_t size;      // == 1
		uint32_t type;
		uint64_t largesize;
		uint32_t version : 8;
		uint32_t flag : 24;
	};

#pragma pack() 

#define BOX_NAME_LENGTH 4

class Box
{
public:
	static Box *load(Stream &, uint64_t, uint64_t);
public:
	Box();
	virtual ~Box();
	uint64_t  size();
	const char *name();
	uint64_t position();
	uint32_t header();
	uint64_t contentSize();
	virtual uint64_t contentPosition();
	virtual constants::Type type();
protected:
	constants::Type m_iType;

	uint64_t  m_iPosition;
	char      m_name[BOX_NAME_LENGTH + 1];
	uint32_t  m_iHeaderSize;
	uint64_t  m_iContentSize;
};


}