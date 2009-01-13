// The PC has reneged on a perceived agreement.
// XP awarded for Chaotic characters.
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   AdjustReputation(oPC, OBJECT_SELF, -5);
   giveXPByAlignment(oPC, getDialogXP(OBJECT_SELF, oPC), ALIGNMENT_CHAOTIC);
   AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 1);
   SpeakString(SHOUT_DROP_VALUABLES, TALKVOLUME_SILENT_TALK);
   dropValuables();
}
