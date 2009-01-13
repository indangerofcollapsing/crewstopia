// The PC appears to accept surrender.  Prisoners are disarmed.
// No XP awarded; this is a preliminary dialog step.
#include "inc_dialog"
void main()
{
   disarmSelf();
   SpeakString(SHOUT_DISARM, TALKVOLUME_SILENT_TALK);
}
