#include "stdafx.h"
#include "SA3D.h"
#include <iostream>

namespace MP4
{

	// Loads the SA3D box located at position pos in a mp4 file.
	Box *SA3DBox::load(Stream &fs, uint64_t iPos, uint64_t iEnd)
	{
		if (iPos < 0) iPos = (uint32_t)fs.tellg();
		char name[BOX_NAME_LENGTH + 1] = { 0 };

		fs.seekg(iPos);
		uint32_t iSize = Stream::readUint32(fs);
		fs.read(name, 4);
		
		// Added for 360Tube to have load and save in-sync.
		if (iSize == 1) {
			iSize = (int32_t)Stream::readUint64(fs);
		}

		if (0 != memcmp(name, constants::TAG_SA3D, sizeof(constants::TAG_SA3D))) {
			std::cerr << "Error: box is not an SA3D box." << std::endl;
			return NULL;
		}

		if (iPos + iSize > iEnd) {
			std::cerr << "Error: SA3D box size exceeds bounds." << std::endl;
			return NULL;
		}

		SA3DBox *newBox = new SA3DBox();
		memcpy(newBox->m_name, name, sizeof(name));
		newBox->m_iPosition = iPos;
		newBox->m_iContentSize = iSize - newBox->m_iHeaderSize;
		newBox->m_iVersion = Stream::readUint8(fs);
		newBox->m_iAmbisonicType = Stream::readUint8(fs);
		newBox->m_iAmbisonicOrder = Stream::readUint32(fs);
		newBox->m_iAmbisonicChannelOrdering = Stream::readUint8(fs);
		newBox->m_iAmbisonicNormalization = Stream::readUint8(fs);
		newBox->m_iNumChannels = Stream::readUint32(fs);
		
		for (uint32_t i = 0; i< newBox->m_iNumChannels; i++) {
			uint32_t iVal = Stream::readUint32(fs);
			newBox->m_ChannelMap.push_back(iVal);
		}
		return newBox;
	}

	Box *SA3DBox::create(int32_t iNumChannels)
	{
		// audio_metadata: dictionary ('ambisonic_type': string, 'ambisonic_order': int),

		SA3DBox *pNewBox = new SA3DBox();
		pNewBox->m_iHeaderSize = sizeof(NormalBox);
		memcpy(pNewBox->m_name, constants::TAG_SA3D, 4);
		pNewBox->m_iVersion = 0; // # uint8
		pNewBox->m_iContentSize += 1; // # uint8
									  //  pNewBox->m_iAmbisonicType= pNewBox->m_AmbisonicTypes[amData["ambisonic_type"]]; 
		pNewBox->m_iContentSize += 1; // # uint8
									  //  pNewBox->m_iAmbisonicOrder = amData["ambisonic_order"];
		pNewBox->m_iContentSize += 4; // # uint32
									  //  pNewBox->m_iAmbisonicChannelOrdering = pNewBox->m_AmbisonicOrderings[ amData["ambisonic_channel_ordering"]]
		pNewBox->m_iContentSize += 1; // # uint8
									  //  pNewBox->m_iAmbisonicNormalization = pNewBox->m_AmbisonicNormalizations[ amData["ambisonic_normalization"]]
		pNewBox->m_iContentSize += 1; // # uint8
		pNewBox->m_iNumChannels = iNumChannels;
		pNewBox->m_iContentSize += 4; // # uint32

		std::vector<int> map; // = amData["channel_map"];
		std::vector<int>::iterator it = map.begin();
		while (it != map.end()) {
			pNewBox->m_ChannelMap.push_back(*it++);
			pNewBox->m_iContentSize += 4;
		}
		return pNewBox;
	}

	SA3DBox::SA3DBox(Box *)
	{
		memcpy(m_name, constants::TAG_SA3D, 4);
		m_iHeaderSize = sizeof(NormalBox);
		m_iPosition = 0;
		m_iContentSize = 0;
		m_iVersion = 0;
		m_iAmbisonicType = 0;
		m_iAmbisonicOrder = 0;
		m_iAmbisonicChannelOrdering = 0;
		m_iAmbisonicNormalization = 0;
		m_iNumChannels = 0;

		m_AmbisonicTypes["periphonic"] = 0;
		m_AmbisonicOrderings["ACN"] = 0;
		m_AmbisonicNormalizations["SN3D"] = 0;
	}

	SA3DBox::~SA3DBox()
	{
	}

}