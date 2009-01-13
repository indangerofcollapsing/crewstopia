//:://////////////////////////////////////////////
//:: Doppelganger return to true form
//:: Based on pnp_shft_true
//:://////////////////////////////////////////////

#include "prc_inc_shifting"

void main()
{
   object oPC = OBJECT_SELF;

   // Attempt to unshift and if it fails, inform the user with a message so
   // they don't wonder whether something is happening or not.
   if (UnShift(oPC, TRUE) == UNSHIFT_FAIL)
   {
      FloatingTextStrRefOnCreature(16828383, oPC, FALSE); // "Failed to return to true form!"
   }
}
