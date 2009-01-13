#include "inc_plot"
#include "inc_dialog"
void main()
{
   object oNPC = getNPCSpeaker();
   object oPC = GetPCSpeaker();
   setFlags(oNPC, getPlotVarName(oPC), HAS_MET_PC);
}
