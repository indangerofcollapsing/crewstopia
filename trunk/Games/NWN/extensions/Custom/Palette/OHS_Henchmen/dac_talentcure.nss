#include "inc_healing"
#include "inc_debug_dac"
const string VAR_CURED = "dac_talentcure";
void main()
{
   //debugVarObject("dac_talentcure", OBJECT_SELF);
   //ActionPauseConversation();
   int bCured = talentCure();
   //debugVarInt("nCured", nCured);
   if (bCured)
   {
      SetLocalInt(OBJECT_SELF, VAR_CURED, TRUE);
      DelayCommand(7.0f, ExecuteScript("dac_talentcure", OBJECT_SELF));
   }
   else
   {
      bCured = GetLocalInt(OBJECT_SELF, VAR_CURED);
      DeleteLocalInt(OBJECT_SELF, VAR_CURED);
      if (bCured)
      {
         ActionSpeakString("I've done all I can for now.");
      }
      else
      {
         ActionSpeakString("I can't help anyone here.");
      }
   }
}
