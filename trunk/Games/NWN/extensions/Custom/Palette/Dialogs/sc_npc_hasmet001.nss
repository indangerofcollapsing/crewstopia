// NPC has met PC, does not know PC's name?
#include "inc_plot"
#include "inc_dialog"
int StartingConditional()
{
   int nFlags = dlgFlags(GetPCSpeaker(), getNPCSpeaker());
   return
      (nFlags & HAS_MET_PC) &&
      !(nFlags & KNOWS_PC_NAME);
}
