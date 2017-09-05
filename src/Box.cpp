#include "stdafx.h"
#include "Box.h"
#include <iostream>

namespace MP4{

Box *Box::load(Stream &fs, uint64_t iPos, uint64_t iEnd)
{
	uint32_t iHeaderSize = 0;
	uint64_t iSize = 0LL;
	char name[BOX_NAME_LENGTH + 1] = {0};

	fs.seekg(iPos);

	iSize = (uint64_t)Stream::readUint32(fs);
	fs.read(name, BOX_NAME_LENGTH);

	iHeaderSize = sizeof(NormalBox);
	if (iSize == 1) {
		iSize = Stream::readUint64(fs);
		iHeaderSize += sizeof(uint64_t);
	}

	if (iSize < sizeof(NormalBox)) {
		std::cerr << "Error, invalid size " << iSize << " in " << name << " at " << iPos << std::endl;
		return NULL;
	}

	if (iPos + iSize > iEnd) {
		std::cerr << "Error: Leaf box size exceeds bounds." << std::endl;
		//return NULL;
		iSize = iEnd - iPos;
	}

	Box *newBox = new Box();
	memcpy(newBox->m_name, name, sizeof(name));
	newBox->m_iPosition = iPos;
	newBox->m_iHeaderSize = iHeaderSize;
	newBox->m_iContentSize = iSize - iHeaderSize;
	return newBox;
}

Box::Box()
{
	m_iType = constants::Box;

	memset((char *)m_name, 0, sizeof(m_name));
	m_iPosition = 0;
	m_iHeaderSize = 0;
	m_iContentSize = 0;
}

Box::~Box()
{
}

uint64_t  Box::size()
{
	return m_iHeaderSize + m_iContentSize;
}

uint32_t Box::header()
{
	return m_iHeaderSize;
}

const char *Box::name()
{
	return m_name;
}

uint64_t Box::position()
{
	return m_iPosition;
}

uint64_t Box::contentPosition()
{
	return m_iPosition + m_iHeaderSize;
}

uint64_t Box::contentSize()
{
	return m_iContentSize;
}

constants::Type Box::type()
{
	return m_iType;
}

}