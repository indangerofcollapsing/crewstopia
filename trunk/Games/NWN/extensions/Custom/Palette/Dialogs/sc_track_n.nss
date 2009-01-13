// Attempt a normal difficulty Track
#include "inc_dialog"
#include "inc_skill"
int StartingConditional()
{
   ExecuteScript("dlg_track_n", OBJECT_SELF);
   return GetLocalInt(getNPCSpeaker(), VAR_SKILL_CHECK);
}
