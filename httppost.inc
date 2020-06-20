#if defined _HTTPPOST_included_
	#endinput
#endif
#define _HTTPPOST_included_


/**
 * Sets checkpoint data at the given index for the given client
 *
 * @param Target					QQ Number you send to
 * @param Message					Message you send to
 * @param Type						Type  0 = Send Private Message,1 = Send Group Message
 *
 * @noreturn
 */
 
native void HTTP_PostMsg(char[] Target, char[] Message, int Type);
