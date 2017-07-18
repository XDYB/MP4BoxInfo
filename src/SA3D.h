#pragma once

#include "Box.h"
#include <map>
#include <vector>

namespace MP4
{

class SA3DBox : public Box
{
public:
	static Box *load(Stream &fs, uint64_t iPos, uint64_t iEnd);
	static Box *create(int32_t iNumChannels);
public:
	enum ePosition { None };
	SA3DBox(Box *);
	virtual ~SA3DBox();
private:
	SA3DBox() {};
private:
	std::map<std::string, int32_t> m_AmbisonicTypes;
	std::map<std::string, int32_t> m_AmbisonicOrderings;
	std::map<std::string, int32_t> m_AmbisonicNormalizations;

	uint8_t  m_iVersion;
	uint8_t  m_iAmbisonicType;
	uint32_t m_iAmbisonicOrder;
	uint8_t  m_iAmbisonicChannelOrdering;
	uint8_t  m_iAmbisonicNormalization;
	uint32_t m_iNumChannels;
	std::vector<uint32_t> m_ChannelMap;

};


}