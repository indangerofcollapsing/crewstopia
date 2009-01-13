#include "inc_atlas"
#include "inc_debug_dac"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   return hasMap(oPC, GetTag(GetArea(oPC)));
}

