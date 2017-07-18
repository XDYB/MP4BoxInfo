
// MP4Info.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CMP4InfoApp:
// See MP4Info.cpp for the implementation of this class
//

class CMP4InfoApp : public CWinApp
{
public:
	CMP4InfoApp();

// Overrides
public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CMP4InfoApp theApp;