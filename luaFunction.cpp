#include "stdafx.h"
#include "luaFunction.h"

#include <iostream>
extern "C"
{
#include "lua.h"  
#include "lauxlib.h"  
#include "lualib.h"  
}

#pragma comment(lib,"lua.lib")

const char * LUA_TypeName[] =
{
	"LUA_TNONE",
	"LUA_TNIL",
	"LUA_TBOOLEAN",
	"LUA_TLIGHTUSERDATA",
	"LUA_TNUMBER",
	"LUA_TSTRING",
	"LUA_TTABLE",
	"LUA_TFUNCTION",
	"LUA_TUSERDATA",
	"LUA_TTHREAD",
	"LUA_NUMTAGS"
};

inline const char * GetLuaTypeName(int type)
{
	return LUA_TypeName[type + 1];
}

std::vector<std::string > LuaParseBoxContent(const char * name, char * buffer, uint64_t size)
{
	std::vector<std::string > result;

	lua_State *L = luaL_newstate();
	if (L == NULL)
	{
		return result;
	}
	luaL_openlibs(L);

	int nTop = lua_gettop(L);

	std::string luaFile = "./luaScript/";
	luaFile += name;
	luaFile += ".lua";

	int bRet = luaL_loadfile(L, luaFile.c_str());
	if (bRet)
	{
		const char *errorString = lua_tostring(L, -1);
		result.push_back(std::string("Error:") + errorString);
		lua_close(L);
		return result;
	}
	//3.运行Lua文件  
	bRet = lua_pcall(L, 0, 0, 0);
	if (bRet)
	{
		const char *errorString = lua_tostring(L, -1);
		result.push_back(std::string("Error:") + errorString);
		lua_close(L);
		return result;
	}
	

	lua_getglobal(L, "parse");			// 获取函数，压入栈中
	lua_pushlstring(L, name,4);			// 压入第一个参数
	lua_pushlstring(L, buffer, size);		// 压入第二个参数
	int iRet = lua_pcall(L, 2, 1, 0);	// 调用函数，调用完成以后，会将返回值压入栈中，2表示参数个数，1表示返回结果个数。  
	if (iRet)							// 调用出错  
	{
		const char *errorString = lua_tostring(L, -1);
		result.push_back(std::string("Error:") + errorString);
		lua_close(L);
		return result;
	}

	if (lua_type(L, 1) == LUA_TTABLE)
	{
		int count = luaL_len(L, 1);
		for (int i = 0; i < count; i++)
		{
			lua_rawgeti(L, 1, i + 1);
			const char *strName = lua_tostring(L, -1);
			result.push_back(strName);
			lua_pop(L, 1);
		}
	}
	else
	{
		int index = 1;
		int type = lua_type(L, index);
		if (type == LUA_TNUMBER)
		{
			lua_Number number = lua_tonumber(L, index);
			char buffer[64];
			sprintf(buffer,"%lf",number);
			result.push_back(std::string("Error Result Type: ") + GetLuaTypeName(type) + " (" + buffer + ") ,Not LUA_TTABLE");
		}
		else if (type == LUA_TSTRING)
		{
			const char * str = lua_tostring(L, index);
			result.push_back(std::string("Error Result Type: ") + GetLuaTypeName(type) + " (" + str + ") ,Not LUA_TTABLE");
		}
		else if (type == LUA_TBOOLEAN)
		{
			bool bl = lua_toboolean(L, index);
			result.push_back(std::string("Error Result Type: ") + GetLuaTypeName(type) + " " + (bl?"true":"false") + " ,Not LUA_TTABLE");
		}
		else
		{
			result.push_back(std::string("Error Result Type: ") + GetLuaTypeName(type) + " ,Not LUA_TTABLE");
		}
		lua_pop(L, 1);
	}
	nTop = lua_gettop(L);
	//7.关闭state  
	lua_close(L);
	return result;
}