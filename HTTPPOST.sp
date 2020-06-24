#include <sourcemod>
#include <ripext>

ConVar g_AccessToken;
ConVar g_listenip;

public Plugin myinfo =
{
    name        = "HTTP[Post]",
    author      = "neko",
    description = "HTTP and JSON natives",
    version     = "1.0.0",
    url         = "http://www.github.com/bklol"
};


public void OnPluginStart()
{
	g_AccessToken = CreateConVar( "AccessToken", "ACCESS-Token", "Your Access token ,leave blank if you dont have it");
	g_listenip = CreateConVar( "Postip", "127.0.0.1:80", "HTTPPostIpAddress");
	
	AutoExecConfig(true, "HTTPPSOT");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("HTTP_PostMsg",Native_SendMsg);
	CreateNative("HTTP_Restart",Native_SendRestart);
	
	RegPluginLibrary("QQhunlian");
	return APLRes_Success;
}

public any Native_SendMsg(Handle plugin, int numParams)
{
	char AccessToken[PLATFORM_MAX_PATH],
		 Target		[PLATFORM_MAX_PATH],
		 Message	[PLATFORM_MAX_PATH],
		 Domain		[PLATFORM_MAX_PATH];
	
	GetConVarString(g_AccessToken, AccessToken, sizeof(AccessToken));
	GetConVarString(g_listenip, Domain, sizeof(Domain));
	
	GetNativeString(1,Target, PLATFORM_MAX_PATH);
	GetNativeString(2,Message, PLATFORM_MAX_PATH);
	
	int type = GetNativeCell(3);
	Format(Domain,PLATFORM_MAX_PATH,"http://%s/send_msg?",Domain);
	HTTPClient hHTTPClient = new HTTPClient(Domain);
	if(!StrEqual(AccessToken,""))
	{
		Format(AccessToken,sizeof(AccessToken),"Bearer %s",AccessToken);
		hHTTPClient.SetHeader("Authorization",AccessToken);
	}
	JSONObject hJSONObject = new JSONObject();
	
	if( type == 1)
		hJSONObject.SetString("group_id",Target);
	else if( type == 0)
		hJSONObject.SetString("user_id",Target);
	else
		ThrowError("type missmatch");
	
	hJSONObject.SetString("message", Message);
	hHTTPClient.Post("post", hJSONObject, OnHTTPResponse, 1);
	delete hJSONObject;
}

public any Native_SendRestart(Handle plugin, int numParams)
{
	char AccessToken[PLATFORM_MAX_PATH],
		 Domain		[PLATFORM_MAX_PATH];
	
	GetConVarString(g_AccessToken, AccessToken, sizeof(AccessToken));
	GetConVarString(g_listenip, Domain, sizeof(Domain));

	int delay = GetNativeCell(1);
	if(delay < 0 || delay > 2000)
		ThrowError("delay too short or too long");
	
	Format(Domain,PLATFORM_MAX_PATH,"http://%s/set_restart_plugin?",Domain);
	
	HTTPClient hHTTPClient = new HTTPClient(Domain);
	if(!StrEqual(AccessToken,""))
	{
		Format(AccessToken,sizeof(AccessToken),"Bearer %s",AccessToken);
		hHTTPClient.SetHeader("Authorization",AccessToken);
	}
	JSONObject hJSONObject = new JSONObject();
	hJSONObject.SetInt("delay",delay);
	
	hHTTPClient.Post("post", hJSONObject, OnHTTPResponse, 1);
	delete hJSONObject;
}

public void OnHTTPResponse(HTTPResponse response, any value){
	if (response.Status != HTTPStatus_OK) {
        PrintToServer("[ERR] Status: %d",response.Status);
        return;
    }
	if (response.Data == null) {
        PrintToServer("[OK]  No response");
        return;
    }
	char sData[1024];
	response.Data.ToString(sData, sizeof(sData), JSON_INDENT(4));
	PrintToServer("[OK] Response:\n%s",sData);
	
}


