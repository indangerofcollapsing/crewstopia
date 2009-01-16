// Call from NW_C2_DEFAULT4
// ExecuteScript("fof_c2_default4", OBJECT_SELF);

#include "nw_i0_generic"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("fof_c2_default4 (on-conv)", OBJECT_SELF);

   // See if what we just 'heard' matches any of our
   // predefined patterns
   int nMatch = GetListenPatternNumber();
   //debugVarInt("nMatch", nMatch);
   object oShouter = GetLastSpeaker();
   //debugVarObject("oShouter", oShouter);

   // FIGHT_OR_FLIGHT: Actions on listen pattern recognition
   // Case 5000: if the caller heard a RETREAT_CHECK
   if (nMatch == 5000)
   {
      SetLocalInt(OBJECT_SELF, "HEARD_THE_CALL", 1);
      ExecuteScript("fight_or_flight", OBJECT_SELF);
   }
   // Case 5001: if the caller heard a "GUARD_ME" from a leader
   if (nMatch == 5001)
   {
      object oEnemy = GetLastHostileActor(oShouter);
      if (oEnemy == OBJECT_INVALID)
      {
         oEnemy = GetNearestEnemy(oShouter);
      }
      //debugVarObject("oEnemy", oEnemy);
      int nCheck = GetLocalInt(OBJECT_SELF, "RETREATED");
      if (nCheck != 1)
      {
         ClearAllActions();
         RespondToShout(oShouter, NW_FLAG_SHOUT_ATTACK_MY_TARGET, oEnemy);
         DetermineCombatRound(oEnemy);
      }
   }
}
