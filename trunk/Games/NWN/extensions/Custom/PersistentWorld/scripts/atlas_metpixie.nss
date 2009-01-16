#include "inc_nbde"
#include "inc_atlas"
void main()
{
   object oPC = GetPCSpeaker();
   setPersistentString(oPC, VAR_ATLAS_PIXIENAME, GetName(OBJECT_SELF));
}
