// has NPC not met PC yet?
#include "inc_plot"
#include "inc_dialog"
int StartingConditional()
{
   object oNPC = getNPCSpeaker();
   object oPC = GetPCSpeaker();
   return !(plotFlags(oNPC, getPlotVarName(oPC)) & HAS_MET_PC);
}
