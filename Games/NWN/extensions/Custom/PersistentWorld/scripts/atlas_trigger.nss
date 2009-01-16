// On Enter event for a trigger which allows the PC to permanently map this area.
#include "inc_atlas"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("atlas_trigger", OBJECT_SELF);

   object oPC = GetEnteringObject();
   if (! GetIsPC(oPC)) return;

   addMap(oPC, GetTag(GetArea(oPC)));
}
