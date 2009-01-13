// The PC has acted honorably.
// XP awarded for Lawful characters.
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   AdjustReputation(oPC, OBJECT_SELF, -5);
   giveXPByAlignment(oPC, getDialogXP(OBJECT_SELF, oPC), ALIGNMENT_LAWFUL);
   AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 1);
   SpeakString(SHOUT_DROP_VALUABLES, TALKVOLUME_SILENT_TALK);
   dropValuables();
}
