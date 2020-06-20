
#include <sourcemod>
#include <httppost>

public void OnPluginStart()
{
    RegConsoleCmd("sm_t",test);
}

public Action test(int client, int arges)
{
	HTTP_PostMsg("1308734055","test",0);
}
