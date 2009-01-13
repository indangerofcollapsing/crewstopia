//:://////////////////////////////////////////////
//:: Shifter - Greater Wildshape use
//:: pnp_shft_gwshape
//:://////////////////////////////////////////////
/** @file
    Targets some creature to have it be stored
    as a known template and attempts to shift
    into it.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting" // @DUG recompile only


void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget))
    {
        StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTarget);

        // If we reached 0 Greater Wildshape uses, see if we could pay with Druid Wildshape uses instead
        if(!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC)    &&
           GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
           GetHasFeat(FEAT_WILD_SHAPE, oPC)
           )
        {
            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
            DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
        }

        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget, FALSE))
        {
            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
        }
    }
    // Couldn't shift, refund the feat use
    else
        IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
}
