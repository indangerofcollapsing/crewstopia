//::///////////////////////////////////////////////
//:: Default: On User Defined
//:: NW_C2_DEFAULTD
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    on a user defined event.
*/
//:://////////////////////////////////////////////
//:: Created By: Don Moar
//:: Created On: April 28, 2002
//:://////////////////////////////////////////////

void onDialogue();

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;

#include "inc_doppelganger"
#include "inc_dialog"
#include "inc_debug_dac"

void main()
{
   //debugVarObject("nw_c2_defaultd", OBJECT_SELF);

   ExecuteScript("prc_onuserdef", OBJECT_SELF);

   if (isDoppelganger(OBJECT_SELF))
   {
      doppelgangerEvent(GetUserDefinedEventNumber());
   }

   switch(GetUserDefinedEventNumber())
   {
      case EVENT_HEARTBEAT: //HEARTBEAT
         break;
      case EVENT_PERCEIVE: // PERCEIVE
         break;
      case EVENT_END_COMBAT_ROUND: // END OF COMBAT
         break;
      case EVENT_DIALOGUE: // ON DIALOGUE
         onDialogue();
         break;
      case EVENT_ATTACKED: // ATTACKED
         break;
      case EVENT_DAMAGED: // DAMAGED
         break;
      case 1007: // DEATH  - do not use for critical code, does not fire reliably all the time
         break;
      case EVENT_DISTURBED: // DISTURBED
         break;
      case EVENT_USER_DEFINED_PRESPAWN:
         break;
      case EVENT_USER_DEFINED_POSTSPAWN:
         break;
      default:
         // Nothing
         break;
   }
}

void onDialogue()
{
   //debugVarObject("onDialogue()", OBJECT_SELF);
   int nMatch = GetListenPatternNumber();
   object oShouter = GetLastSpeaker();
   if (nMatch == -1) return;
   if (oShouter == OBJECT_INVALID || oShouter == OBJECT_SELF) return;
   if (GetIsPC(oShouter)) return;
   if (! GetIsFriend(oShouter)) return;

   switch(nMatch)
   {
      case LISTEN_DISARM:
         ActionSpeakString("Disarming");
         disarmSelf();
         break;
      case LISTEN_ESCAPE:
         ActionSpeakString("Thank you.  I will leave now.");
         tryToEscape();
         break;
      case LISTEN_SURRENDER:
         ActionSpeakString("I surrender.");
         SetLocalInt(OBJECT_SELF, VAR_NW_GENERIC_SURRENDER, TRUE); // see nw_i0_generic
         SurrenderToEnemies();
         break;
      case LISTEN_WORSHIP:
         ActionSpeakString("We're not worthy!");
         worship();
         break;
      case LISTEN_DROP_VALUABLES:
         ActionSpeakString("[grumble, grumble, grumble]");
         dropValuables();
         break;
      default:
         //debugVarInt("Heard a message, but don't understand it: ", nMatch);
         break;
   }
}
