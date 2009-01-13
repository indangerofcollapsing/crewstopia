// The PC accepts surrender.  Prisoners are released.
// XP awarded for Good characters.
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   AdjustReputation(oPC, OBJECT_SELF, 5);
   giveXPByAlignment(oPC, getDialogXP(OBJECT_SELF, oPC), ALIGNMENT_GOOD);
   AdjustAlignment(oPC, ALIGNMENT_GOOD, 1);
   SpeakString(SHOUT_ESCAPE, TALKVOLUME_SILENT_TALK);
   tryToEscape();
}
