#ifndef ENDIAN_H
#define ENDIAN_H

#include <winsock.h>

inline ULONG64  hl64ton(ULONG64   host)
{
	ULONG64   ret = 0;
	ULONG   high, low;
	low = host & 0xFFFFFFFF;
	high = (host >> 32) & 0xFFFFFFFF;
	low = htonl(low);
	high = htonl(high);
	ret = low;
	ret <<= 32;
	ret |= high;
	return   ret;
}

inline ULONG64  n64tohl(ULONG64   host)
{
	ULONG64   ret = 0;
	ULONG   high, low;
	low = host & 0xFFFFFFFF;
	high = (host >> 32) & 0xFFFFFFFF;
	low = ntohl(low);
	high = ntohl(high);
	ret = low;
	ret <<= 32;
	ret |= high;
	return   ret;
}

#define be32toh ntohl
#define be16toh ntohs
#define be64toh n64tohl

#define htobel16 htons
#define htobe16 htons
#define htobe32 htonl
#define htobe64 hl64ton

#endif