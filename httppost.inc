#if defined _HTTPPOST_included_
	#endinput
#endif
#define _HTTPPOST_included_


/**
 * Send A Message To QQ Bot
 *
 * @param Target					QQ Number you send to(QQ bOT)
 * @param Message					The Message you send 
 * @param Type						Type  0 == Send Private Message,1 == Send Group Message
 *
 * @noreturn
 */
 
native void HTTP_PostMsg(char[] Target, char[] Message, int Type);

/**
 * Restart CQhttpAPI plugin
 *
 *
 * @param delay					Restart delay( Min 0 Max 2000)
 * @noreturn
 */
 
native void HTTP_Restart(int delay);
