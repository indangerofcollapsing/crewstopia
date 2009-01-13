#include "NW_I0_GENERIC"
#include "inc_debug_dac"
#include "inc_dialog"
void main()
{
   object oNPC = getNPCSpeaker();
   object oPC = GetPCSpeaker();
   //debugVarObject("going hostile", oNPC);
   if (GetIsPC(oNPC))
   {
      logError("ERROR: PC is attacking himself.");
      return;
   }
   AdjustReputation(oPC, oNPC, -100);
   AssignCommand(oNPC, WrapperActionAttack(oNPC));
   DetermineCombatRound();
}
