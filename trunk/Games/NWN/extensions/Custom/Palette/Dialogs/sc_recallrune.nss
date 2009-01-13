#include "inc_recallrune"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   return isRecallLocValid(GetLocalInt(oPC, VAR_CURRENT_DLG_LOC), oPC);
}
