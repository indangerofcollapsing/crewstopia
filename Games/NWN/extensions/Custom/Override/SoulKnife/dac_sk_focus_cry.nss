/**
 * Starts the Soulknife Focus Crystal conversation.
 * @DUG
 */
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_sk_focus_cry", OBJECT_SELF);

   object oPC = GetItemActivator();
   //debugVarObject("oPC", oPC);

   if (! GetIsPC(oPC))
   {
      oPC = GetLastSpellCaster();
      //debugVarObject("oPC", oPC);
   }

   if (! GetIsPC(oPC))
   {
      oPC = OBJECT_SELF;
      //debugVarObject("oPC", oPC);
   }

   if (! GetIsPC(oPC))
   {
      logError("Invalid caster in dac_sk_focus_cry: " + objectToString(oPC));
      return;
   }

   AssignCommand(oPC, ClearAllActions(TRUE));
   AssignCommand(oPC, ActionStartConversation(OBJECT_SELF,
      "dac_sk_focus_cry", TRUE, FALSE));
}
