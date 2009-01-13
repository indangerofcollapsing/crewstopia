// The PC demands worship.  Prisoners are converted to minions.
// XP awarded for anyone.
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   AdjustReputation(oPC, OBJECT_SELF, 100);
   giveXPByAlignment(oPC, getDialogXP(OBJECT_SELF, oPC), ALIGNMENT_ALL);
   SpeakString(SHOUT_WORSHIP, TALKVOLUME_SILENT_TALK);
   // Worship lasts 30 seconds
   DelayCommand(31.0f, ActionSpeakString(SHOUT_ESCAPE, TALKVOLUME_SILENT_TALK));
   worship(oPC);
}
