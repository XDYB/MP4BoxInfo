
// MP4InfoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MP4Info.h"
#include "MP4InfoDlg.h"
#include "afxdialogex.h"
#include <list>
#include "luaFunction.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CMP4InfoDlg dialog



CMP4InfoDlg::CMP4InfoDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(IDD_MP4INFO_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	container = NULL;
	buffer = new BYTE[1024*1024];
}

CMP4InfoDlg::~CMP4InfoDlg()
{
	Close();
	delete []buffer;
}

void CMP4InfoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_HEX, m_edHexInfo);
	DDX_Control(pDX, IDC_TREE_BOX, m_tree);
	DDX_Control(pDX, IDC_FILE_PATH, m_filePath);
	DDX_Control(pDX, IDC_LIST_BOX, m_boxInfo);
	DDX_Control(pDX, IDC_LIST_STRUCT, m_boxStruct);
}

BEGIN_MESSAGE_MAP(CMP4InfoDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BTN_OPEN, &CMP4InfoDlg::OnBnClickedBtnOpen)
	ON_NOTIFY(NM_CUSTOMDRAW, IDC_TREE_BOX, &CMP4InfoDlg::OnNMCustomdrawTreeBox)
	ON_NOTIFY(TVN_ITEMCHANGED, IDC_TREE_BOX, &CMP4InfoDlg::OnTvnItemChangedTreeBox)
END_MESSAGE_MAP()


// CMP4InfoDlg message handlers

BOOL CMP4InfoDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	m_edHexInfo.SetOptions(1, 1, 1, 1);
	m_edHexInfo.SetBPR(16); // 16字节

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMP4InfoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMP4InfoDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMP4InfoDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CMP4InfoDlg::OnBnClickedBtnOpen()
{
	CFileDialog dlg(TRUE,NULL,NULL,6,_T("mp4|*.mp4||"));
	if (dlg.DoModal())
	{
		CString filename = dlg.GetPathName();
		OpenMPEG(filename);
		ClearTree();
		if (container != NULL)
		{
			BuildTree();
		}
	}
}

void CMP4InfoDlg::ClearControl()
{
	ClearTree();

	m_edHexInfo.SetData(buffer, 0);
	::SendMessage(GetDlgItem(IDC_EDIT_HEX)->m_hWnd, WM_KILLFOCUS, -1, 0); // 不要控件焦点

	size_t count = m_boxInfo.GetCount();
	for (size_t i = 0; i < count; i++) {
		m_boxInfo.DeleteString(0);
	}
}

void CMP4InfoDlg::Close()
{
	in.close();
	in.clear();
	if (container != NULL)
	{
		delete container;
		container = NULL;
	}
}

void CMP4InfoDlg::OpenMPEG(CString file)
{
	if (File == file)
	{
		return;
	}

	ClearControl();
	Close();
	
	m_filePath.SetWindowText(file);
	std::string name = toString(file.GetBuffer());
	in = std::fstream(name.c_str(), std::ios::in | std::ios::binary | std::ios::ate);
	Stream.FromFStream(&in);
	container = Mpeg4Container::load(Stream);
}

void CMP4InfoDlg::ClearTree()
{
	m_tree.DeleteAllItems();
}

void CMP4InfoDlg::BuildTree()
{
	if (container != NULL)
	{
		std::list<HTREEITEM> list;

		std::vector<Box *>& contents = container->Contents();
		std::vector<Box *>::iterator it = contents.begin();
		for (; it != contents.end(); ++it)
		{
			Box * box = *it;
			HTREEITEM  item = m_tree.InsertItem(AToString(box->name()).c_str());
			m_tree.SetItemData(item,(DWORD_PTR)box);
			list.push_back(item);
		}

		while (list.size() > 0)
		{
			HTREEITEM item = list.front();
			list.pop_front();
			Box * box = (Box*)m_tree.GetItemData(item);
			if (box->type() == constants::Container)
			{
				Container *container = (Container*)box;
				std::vector<Box *>& contents = container->Contents();
				it = contents.begin();
				for (; it != contents.end(); ++it)
				{
					Box * box = *it;
					HTREEITEM  subItem = m_tree.InsertItem(AToString(box->name()).c_str(), item);
					m_tree.SetItemData(subItem, (DWORD_PTR)box);
					list.push_back(subItem);
				}
			}
		}
	}
}

void CMP4InfoDlg::PauseHeader(Box *box)
{
	size_t count = m_boxInfo.GetCount();
	for (size_t i = 0; i < count; i++) {
		m_boxInfo.DeleteString(0);
	}

	CString str;
	str = _T("Name:");
	str += AToString(box->name()).c_str();
	m_boxInfo.AddString(str);

	constants::Type type = box->type();
	str = _T("Type:");
	str += AToString(constants::TypeName(type)).c_str();
	m_boxInfo.AddString(str);

	if (type == constants::Container)
	{
		Container * container = (Container*)box;
		if (container->Padding() > 0)
		{
			str.Format(_T("    Content Padding:%d"), container->Padding());
			m_boxInfo.AddString(str);
		}

		std::vector<Box *>& contents = container->Contents();
		str.Format(_T("    Contents:%d"), contents.size());

		m_boxInfo.AddString(str);
		str = _T("    Contents:");

		for (size_t i = 0; i < contents.size(); i++)
		{
			str.AppendFormat(_T(" %s "), AToString(contents[i]->name()).c_str());
		}
		m_boxInfo.AddString(str);
	}
	str.Format(_T("Position:%lld"), box->position());
	m_boxInfo.AddString(str);
	
	str.Format(_T("Size:%lld (%08X)"), box->size(), box->size());
	m_boxInfo.AddString(str);

	str.Format(_T("Header Size:%d"), box->header());
	m_boxInfo.AddString(str);

	str.Format(_T("ContentPosition:%lld"), box->contentPosition());
	m_boxInfo.AddString(str);

	str.Format(_T("ContentSize:%lld (%08X)"), box->contentSize(), box->contentSize());
	m_boxInfo.AddString(str);
}

void CMP4InfoDlg::PauseContent(Box *box,char* buffer,uint64_t size)
{
	m_boxStruct.SetWindowText(_T(""));

	CString strResult;
	std::vector<std::string > result = LuaParseBoxContent(box->name(),buffer,size);
	if (result.size() > 0)
	{
		for (size_t i = 0; i < result.size(); i++)
		{
			strResult.AppendFormat(_T("%s\r\n"), AToString(result[i]).c_str());
		}
	}
	m_boxStruct.SetWindowText(strResult);
}

void CMP4InfoDlg::ParseBox(Box *box)
{
	PauseHeader(box);
	Stream.seekg(box->position());
	uint64_t size = box->size();
	if (size > 1024 * 1024)
	{
		m_edHexInfo.SetData(buffer, 0);
		::SendMessage(GetDlgItem(IDC_EDIT_HEX)->m_hWnd, WM_KILLFOCUS, -1, 0); // 不要控件焦点

		m_boxStruct.SetWindowText(_T(""));

		return;
	}
	Stream.read((char*)buffer,size);
	m_edHexInfo.SetData(buffer,size);
	::SendMessage(GetDlgItem(IDC_EDIT_HEX)->m_hWnd, WM_KILLFOCUS, -1, 0); // 不要控件焦点

	PauseContent(box, (char*)buffer, size);
}

void CMP4InfoDlg::OnNMCustomdrawTreeBox(NMHDR *pNMHDR, LRESULT *pResult)
{
	COLORREF clrNewTextColor;
	//COLORREF clrNewBkColor;
	LPNMCUSTOMDRAW pNMCD = reinterpret_cast<LPNMCUSTOMDRAW>(pNMHDR);
	LPNMTVCUSTOMDRAW lpnmcd = (LPNMTVCUSTOMDRAW)pNMCD;
	// Take the default processing unless we set this to something else below.
	*pResult = CDRF_DODEFAULT;

	// First thing - check the draw stage. If it's the control's prepaint
	// stage, then tell Windows we want messages for every item.
	if (CDDS_PREPAINT == lpnmcd->nmcd.dwDrawStage)
	{
		*pResult = CDRF_NOTIFYITEMDRAW;
	}
	else if ((CDDS_ITEMPREPAINT) == lpnmcd->nmcd.dwDrawStage)
	{
		// This is the notification message for an item.  We'll request
		// notifications before each subitem's prepaint stage.

		clrNewTextColor = RGB(0, 0, 0);
		//clrNewBkColor = RGB(255, 255, 255);

		CRect rcItem(pNMCD->rc);          // Item的区域  
		POINT ptItem;
		ptItem.x = rcItem.left + 1;
		ptItem.y = rcItem.top + 1;
		UINT uFlags;
		HTREEITEM hItem = m_tree.HitTest(ptItem, &uFlags);  // Item 句柄  
		if (!hItem)
		{
			*pResult = CDRF_DODEFAULT;
			return;
		}

		Box * box = (Box*)m_tree.GetItemData(hItem);
		if (box == NULL)
		{
			*pResult = CDRF_DODEFAULT;
			return;
		}
		Container *container = NULL;
		if (box->type() == constants::Container)
		{
			container = (Container*)box;
		}

		const char * name = box->name();
		if (strncmp(name, "mdat", 5) == 0)
		{
			clrNewTextColor = RGB(0, 255, 255);       //青色
		}
		else if (strncmp(name, "moov", 3) == 0)
		{
			clrNewTextColor = RGB(255, 0, 255);        //紫色
		}
		else if (strncmp(name, "trak", 3) == 0)
		{
			clrNewTextColor = RGB(255, 125, 0);        //橘黄色
		}
		else if(strncmp(name, "ftyp", 3) == 0)
		{
			clrNewTextColor = RGB(255, 153, 0);        //咖啡色
		}
		else if (container != NULL && container->Padding() > 0)
		{
			clrNewTextColor = RGB(128, 128, 192);       //灰色
		}
		else if (constants::IS_LEAF(name))
		{
			clrNewTextColor = RGB(255, 0, 0);			// Red
		}
		else if (constants::IS_CONTAINERS(name))
		{
			clrNewTextColor = RGB(0, 0, 255);			// Blue	
		}
		else if (constants::IS_SOUND_SAMPLE(name))
		{
			clrNewTextColor = RGB(0, 255, 0);			// Green
		}
		
		lpnmcd->clrText = clrNewTextColor;
		//lpnmcd->clrTextBk = clrNewBkColor;

		// Tell Windows to paint the control itself.
		*pResult = CDRF_DODEFAULT;
	}
}

void CMP4InfoDlg::OnTvnItemChangedTreeBox(NMHDR *pNMHDR, LRESULT *pResult)
{
	NMTVITEMCHANGE *pNMTVItemChange = reinterpret_cast<NMTVITEMCHANGE*>(pNMHDR);
	HTREEITEM hItem = m_tree.GetSelectedItem();
	if (!hItem)
	{
		*pResult = CDRF_DODEFAULT;
		return;
	}

	Box * box = (Box*)m_tree.GetItemData(hItem);
	if (box == NULL)
	{
		*pResult = CDRF_DODEFAULT;
		return;
	}
	ParseBox(box);

	*pResult = CDRF_DODEFAULT;
}
