#include "inc_recallrune"
void main()
{
   object oPC = GetPCSpeaker();
   deleteRecallLoc(GetLocalInt(oPC, VAR_CURRENT_DLG_LOC), oPC);
   DeleteLocalInt(oPC, VAR_CURRENT_DLG_LOC);
}
