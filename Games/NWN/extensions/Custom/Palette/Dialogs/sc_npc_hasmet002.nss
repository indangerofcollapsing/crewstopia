// NPC has met PC, knows PC's name?
#include "inc_plot"
#include "inc_dialog"
#include "inc_debug_dac"
int StartingConditional()
{
   int nFlags = dlgFlags(GetPCSpeaker(), getNPCSpeaker());
   //debugMsg("Has met PC: " + (nFlags & HAS_MET_PC ? "true" : "false"));
   //debugMsg("Knows PC name: " + (nFlags & KNOWS_PC_NAME ? "true" : "false"));
   return
      (nFlags & HAS_MET_PC) &&
      (nFlags & KNOWS_PC_NAME);
}
