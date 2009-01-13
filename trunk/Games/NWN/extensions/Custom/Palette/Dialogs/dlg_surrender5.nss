// The PC accepts surrender.  Prisoners are released.
// XP awarded for neutrality.
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   giveXPByAlignment(oPC, getDialogXP(OBJECT_SELF, oPC), ALIGNMENT_NEUTRAL);
   SpeakString(SHOUT_ESCAPE, TALKVOLUME_SILENT_TALK);
   tryToEscape();
}
