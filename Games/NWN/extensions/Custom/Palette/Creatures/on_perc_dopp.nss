#include "inc_doppelganger"
#include "nw_i0_generic"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_perc_dopp", OBJECT_SELF);
   object oPerc = GetLastPerceived();
   // If in original shape, take shape of creature perceived.
   if (GetLocalInt(OBJECT_SELF, VAR_IS_CLOAKED) == FALSE)
   {
      takeShapeOf(oPerc);
   }

   if (GetIsPC(oPerc) &&
       ! GetIsInCombat() &&
       GetName(OBJECT_SELF) == "Captive"
      )
   {
      if (GetDistanceBetween(OBJECT_SELF, oPerc) > 2.0f && GetIsEnemy(oPerc))
      {
         // Pretend to need help
         SetIsTemporaryFriend(oPerc, OBJECT_SELF, TRUE, 5.0f);
         int bSpawnConv = GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);
         SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION, TRUE);
         ActionStartConversation(oPerc, "captive_default");
         SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION, bSpawnConv);
         DelayCommand(5.0f, revertToTrueForm());
         DelayCommand(5.1f, takeShapeOf(oPerc));
         DetermineCombatRound();
      }
      else
      {
         DelayCommand(0.1f, revertToTrueForm());
         DelayCommand(0.2f, takeShapeOf(oPerc));
         DetermineCombatRound();
      }
   }


   ExecuteScript("nw_c2_default2", OBJECT_SELF);
}
