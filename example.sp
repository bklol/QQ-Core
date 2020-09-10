
#include <sourcemod>
#include <httppost>

public void OnPluginStart()
{
    RegConsoleCmd("sm_t",test);
}

public Action test(int client, int arges)
{
	HTTP_PostMsg("1308734055","test",0); //发送对象qq 号为 1308734055 发送消息为单人消息
	HTTP_PostMsg("1308734055","test",1); //发送对象qq 号为 1308734055 发送消息为单人消息
}
