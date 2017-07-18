/*****************************************************************************
 *
 * Copyright 2016 Varol Okan. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ****************************************************************************/
#include "stdafx.h"
#include <iostream>
#include <string.h>
#include <stdlib.h>

#include "MPEG4Container.h"

namespace MP4 {

Mpeg4Container::Mpeg4Container ( )
  : Container ( )
{
}

Mpeg4Container::~Mpeg4Container ( )
{

}

Mpeg4Container *Mpeg4Container::load ( Stream &fsIn )
{
	int64_t iSize = fsIn.tellg ( );
	std::vector<Box *> list = loadSubBox ( fsIn, 0, iSize );

	if ( list.empty ( ) )  {
		std::cerr << "Error, failed to load .mp4 file." << std::endl;
		return NULL;
	}

	Mpeg4Container *newBox = new Mpeg4Container ( );

	newBox->m_listContents = list;
	newBox->m_iContentSize   = 0;
	std::vector<Box *>::iterator it = newBox->m_listContents.begin ( );
	while ( it != newBox->m_listContents.end ( ) )  {
		Box *pBox = *it++;
		newBox->m_iContentSize += pBox->size ( );
	}
	return newBox;
}

}