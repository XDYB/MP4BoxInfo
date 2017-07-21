#include "stdafx.h"
#include "Container.h"
#include <iostream>
#include "SA3D.h"

namespace MP4 {

inline int getPadding(char *name,Stream & fs)
{
	uint32_t iPadding = 0;
	if (constants::IS_PADDING_LIST(name))
		iPadding = 8;

	if (memcmp(name, constants::TAG_META, BOX_NAME_LENGTH) == 0)
	{
		iPadding = 4;
	}

	uint64_t iCurrentPos = fs.tellg();
	int16_t  iSampleDescVersion = 0;
	int32_t iArrSize = (int32_t)(sizeof(constants::SOUND_SAMPLE_DESCRIPTIONS) / sizeof(constants::SOUND_SAMPLE_DESCRIPTIONS[0]));
	for (int32_t i = 0; i<iArrSize; i++) {
		if (memcmp(name, constants::SOUND_SAMPLE_DESCRIPTIONS[i], BOX_NAME_LENGTH) == 0) {
			fs.seekg(iCurrentPos + 8);
			iSampleDescVersion = Stream::readInt16(fs);

			switch (iSampleDescVersion) {
			case 0:
				iPadding = 28;
				break;
			case 1:
				iPadding = 28 + 16;
				break;
			case 2:
				iPadding = 64;
				break;
			default:
				std::cerr << "Unsupported sample description version:" << iSampleDescVersion << std::endl;
				break;
			}
		}
	}
	fs.seekg(iCurrentPos);

	return iPadding;
}

Box *Container::load(Stream & fs, uint64_t iPos, uint64_t iEnd)
{
	fs.seekg(iPos);
	
	uint64_t iSize = (uint64_t)Stream::readUint32(fs);
	char name[BOX_NAME_LENGTH + 1] = { 0 };
	fs.read(name, 4);

	int32_t iArrSize = (int32_t)(sizeof(constants::CONTAINERS_LIST) / sizeof(constants::CONTAINERS_LIST[0]));
	bool bIsBox = true;
	for (int32_t i = 0; i < iArrSize; i++) {
		if (memcmp(name, constants::CONTAINERS_LIST[i], BOX_NAME_LENGTH) == 0) {
			bIsBox = false;
			break;
		}
	}

	// Handle the mp4a decompressor setting (wave -> mp4a).
	if (memcmp(name, constants::TAG_MP4A, 4) == 0 && iSize == 12)
		bIsBox = true;

	if (bIsBox) {
		if (memcmp(name, constants::TAG_SA3D, BOX_NAME_LENGTH) == 0)
			return SA3DBox::load(fs, iPos, iEnd);
		return Box::load(fs, iPos, iEnd);
	}

	uint32_t iHeaderSize = sizeof(NormalBox);
	if (iSize == 1) {
		iSize = (uint64_t)Stream::readUint64(fs);
		iHeaderSize += sizeof(uint64_t);
	}

	if (iSize < sizeof(NormalBox)) {
		std::cerr << "Error, invalid size " << iSize << " in " << name << " at " << iPos << std::endl;
		return NULL;
	}

	if (iPos + iSize > iEnd) {
		std::cerr << "Error: Container box size exceeds bounds." << std::endl;
		return NULL;
	}

	//ÄÚÈÝÆ«ÒÆ
	uint32_t iPadding = getPadding(name,fs);
	
	Container *newBox = new Container();
	memcpy(newBox->m_name, name, 4);
	newBox->m_iPosition = iPos;
	newBox->m_iHeaderSize = iHeaderSize;
	newBox->m_iContentSize = (uint32_t)(iSize - iHeaderSize);
	newBox->m_iContentPadding = iPadding;
	newBox->m_listContents = loadSubBox(fs, iPos + iHeaderSize + iPadding, iPos + iSize);

	if (newBox->m_listContents.empty()) {
		delete newBox;
		return NULL;
	}

	return newBox;
}

std::vector<Box *> Container::loadSubBox(Stream & fs, uint64_t iPos, uint64_t iEnd)
{
	std::vector<Box *> list, empty;
	while (iPos < iEnd) {
		Box *box = load(fs, iPos, iEnd);
		if (!box) {
			std::cerr << "Error, failed to load box." << std::endl;
			clear(list);
			return empty;
		}
		list.push_back(box);
		iPos = box->position() + box->size();
	}
	return list;
}

Container::Container(uint32_t iContentPadding)
{
	m_iType = constants::Container;
	m_iContentPadding = iContentPadding;
}

Container::~Container()
{
	clear(m_listContents);
}

void Container::resize()
{
	// Recomputes the box size and recurses on contents."""
	m_iContentSize = m_iContentPadding;
	std::vector<Box *>::iterator it = m_listContents.begin();
	while (it != m_listContents.end()) {
		Box *pBox = *it++;
		if (pBox->type() == constants::Container) {
			Container *p = (Container *)pBox;
			p->resize();
		}
		m_iContentSize += pBox->size();
	}
}

void Container::clear(std::vector<Box *> &list)
{
	std::vector<Box *>::iterator it = list.begin();
	while (it != list.end()) {
		delete *it++;
	}

	list.clear();
}

uint32_t Container::Padding()
{
	return m_iContentPadding;
}

std::vector<Box *> & Container::Contents()
{
	return m_listContents;
}

}