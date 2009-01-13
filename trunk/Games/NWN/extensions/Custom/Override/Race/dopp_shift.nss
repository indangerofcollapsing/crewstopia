//:://////////////////////////////////////////////
//:: Doppelganger shapeshift
//:: Based on pnp_shft_gwshape
//:://////////////////////////////////////////////

#include "prc_inc_shifting"

void main()
{
   object oPC     = OBJECT_SELF;
   object oTarget = PRCGetSpellTargetObject();

   // Store the PC's current appearance as true appearance
   /// @note This may be a bad idea, we have no way of knowing if the
   /// current appearance really is the "true appearance" - Ornedan
   StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

   // If the creature is shiftable to, store it as a template and shift.
   if (GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget))
   {
      StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTarget);
      ShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget, FALSE);
   }
}
