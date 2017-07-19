
// MP4InfoDlg.h : header file
//

#pragma once

#include "hexeditctrl.h"
#include <iostream>
#include <fstream>

#include ".\src\CodeTransport.h"
#include ".\src\Container.h"
#include ".\src\MPEG4Container.h"
#include "afxcmn.h"
#include "afxwin.h"
using namespace MP4;

// CMP4InfoDlg dialog
class CMP4InfoDlg : public CDialogEx
{
// Construction
public:
	CMP4InfoDlg(CWnd* pParent = NULL);	// standard constructor
	~CMP4InfoDlg();

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_MP4INFO_DIALOG };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
private:
	void Close();
	void ClearControl();
	void OpenMPEG(CString file);
	void ClearTree();
	void BuildTree();
	void PauseHeader(Box *box);
	void PauseContent(Box *box, char* buffer, uint64_t size);
	void ParseBox(Box *box);
private:
	CHexEdit m_edHexInfo;   // 显示十六进制
	CString File;
	std::fstream in;
	FileStream Stream;
	Mpeg4Container * container;
	BYTE *buffer;
// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CTreeCtrl m_tree;
	CStatic m_filePath;
	CListBox m_boxInfo;
	CEdit m_boxStruct;
	afx_msg void OnBnClickedBtnOpen();
	afx_msg void OnNMCustomdrawTreeBox(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnTvnItemChangedTreeBox(NMHDR *pNMHDR, LRESULT *pResult);
};
