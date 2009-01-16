#include "inc_atlas"
#include "inc_nbde"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   string pixieName = getPersistentString(oPC, VAR_ATLAS_PIXIENAME);

   return (pixieName != "");
}
