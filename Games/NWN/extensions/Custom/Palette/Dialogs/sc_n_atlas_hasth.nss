#include "inc_atlas"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   return (! hasMap(oPC, GetTag(GetArea(oPC))));
}

