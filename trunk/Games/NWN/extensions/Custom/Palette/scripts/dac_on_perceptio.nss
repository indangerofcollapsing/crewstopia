// Speak a greeting to passersby upon perceiving them
#include "inc_dialog"
void main()
{
   string sMsg = GetLocalString(OBJECT_SELF, VAR_MY_GREETING);
   if (sMsg == "")
   {
      sMsg = "You need to set my custom greeting in variable " + VAR_MY_GREETING;
   }

   PlayVoiceChat(VOICE_CHAT_STOP, OBJECT_SELF);
   SpeakString(sMsg, TALKVOLUME_TALK);

   ExecuteScript("nw_c2_default2", OBJECT_SELF); // standard on-perception script
}
