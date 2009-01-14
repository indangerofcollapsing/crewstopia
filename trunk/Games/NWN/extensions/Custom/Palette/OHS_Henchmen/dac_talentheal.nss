//#include "nw_i0_generic"
#include "inc_healing"
#include "inc_debug_dac"
const string VAR_HEALED = "dac_talentheal";
void main()
{
   //debugVarObject("dac_talentheal", OBJECT_SELF);
   //ClearAllActions();
   //ActionPauseConversation();
   int bHealed = talentHeal();
   //debugVarBoolean("nHealed", bHealed);
   if (bHealed)
   {
      SetLocalInt(OBJECT_SELF, VAR_HEALED, TRUE);
      DelayCommand(7.0f, ExecuteScript(VAR_HEALED, OBJECT_SELF));
   }
   else
   {
      bHealed = GetLocalInt(OBJECT_SELF, VAR_HEALED);
      DeleteLocalInt(OBJECT_SELF, VAR_HEALED);
      if (bHealed)
      {
         ActionSpeakString("I've done all I can for now.");
      }
      else
      {
         ActionSpeakString("I can't help anyone here.");
      }
   }
}
