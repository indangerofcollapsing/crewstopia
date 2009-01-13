#include "inc_recallrune"
void main()
{
   object oPC = GetPCSpeaker();
   location lLoc = getRecallLoc(GetLocalInt(oPC, VAR_CURRENT_DLG_LOC), oPC);
   createRecallRunePortal(lLoc);
   DeleteLocalInt(oPC, VAR_CURRENT_DLG_LOC);
}
