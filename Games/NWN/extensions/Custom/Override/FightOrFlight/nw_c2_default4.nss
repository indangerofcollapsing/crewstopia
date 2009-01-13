//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT4
/*
  Default OnConversation event handler for NPCs.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
#include "nw_i0_generic"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("nw_c2_default4 (on-conv)", OBJECT_SELF);

   // * if petrified, jump out
   if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF)) return;

   // * If dead, exit directly.
   if (GetIsDead(OBJECT_SELF)) return;

   // See if what we just 'heard' matches any of our
   // predefined patterns
   int nMatch = GetListenPatternNumber();
   //debugVarInt("nMatch", nMatch);
   object oShouter = GetLastSpeaker();
   //debugVarObject("oShouter", oShouter);

   if (nMatch == -1)
   {
      // Not a match -- start an ordinary conversation
      if (GetCommandable(OBJECT_SELF))
      {
         ClearActions(CLEAR_NW_C2_DEFAULT4_29);
         BeginConversation();
      }
      else
      // * July 31 2004
      // * If only charmed then allow conversation
      // * so you can have a better chance of convincing
      // * people of lowering prices
      if (GetHasEffect(EFFECT_TYPE_CHARMED) == TRUE)
      {
         ClearActions(CLEAR_NW_C2_DEFAULT4_29);
         BeginConversation();
      }
   }
   // Respond to shouts from friendly non-PCs only
   else if (GetIsObjectValid(oShouter) && ! GetIsPC(oShouter) &&
      GetIsFriend(oShouter))
   {
      object oIntruder = OBJECT_INVALID;
      // Determine the intruder if any
      if (nMatch == 4)
      {
          oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
      }
      else if (nMatch == 5)
      {
         oIntruder = GetLastHostileActor(oShouter);
         if (! GetIsObjectValid(oIntruder))
         {
            oIntruder = GetAttemptedAttackTarget();
            if (! GetIsObjectValid(oIntruder))
            {
               oIntruder = GetAttemptedSpellTarget();
               if (! GetIsObjectValid(oIntruder))
               {
                  oIntruder = OBJECT_INVALID;
               }
            }
         }
      }

       // Actually respond to the shout
       RespondToShout(oShouter, nMatch, oIntruder);
   }

   // Send the user-defined event if appropriate
   if (GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
   {
      SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
   }

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
