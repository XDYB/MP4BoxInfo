#pragma once

#include "Box.h"
#include <vector>

namespace MP4{

class Container : public Box
{
public:
	static Box *load(Stream &, uint64_t iPos, uint64_t iEnd);
	static std::vector<Box *>loadSubBox(Stream &, uint64_t iPos, uint64_t iEnd);
	static void clear(std::vector<Box *> &list);
public:
	Container(uint32_t iContentPadding = 0);
	virtual ~Container();
	void resize();
	uint32_t Padding();
	std::vector<Box *> & Contents();
public:
	uint32_t m_iContentPadding;
	std::vector<Box *> m_listContents;
};

}