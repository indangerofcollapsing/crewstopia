// On Used event for a gong or other alarm
#include "inc_faction"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_used_alarm", OBJECT_SELF);

   PlaySound("as_cv_gongring2");

   object oPC = GetLastUsedBy();
   if (! GetIsPC(oPC))
   {
      oPC = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF,
         1, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   }
   guardMeAgainst(oPC);
}

