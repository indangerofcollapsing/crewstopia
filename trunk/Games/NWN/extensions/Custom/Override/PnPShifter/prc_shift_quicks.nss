//:://////////////////////////////////////////////
//:: Shifter - Quickslot use
//:: prc_shift_quicks
//:://////////////////////////////////////////////
/** @file
    Fires when one of the PnP Shifter quickslots
    is used. Determines which of the slots was
    used based on spellID and, if that slot is not
    empty, shifts to the form listed in the slot.


    @author Ornedan
    @date   Created  - 2006.10.07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting" // @DUG recompile only


const int QUICK_SLOT_1  = 1921;
const int QUICK_SLOT_2  = 1922;
const int QUICK_SLOT_3  = 1923;
const int QUICK_SLOT_4  = 1924;
const int QUICK_SLOT_5  = 1925;
const int QUICK_SLOT_6  = 1926;
const int QUICK_SLOT_7  = 1927;
const int QUICK_SLOT_8  = 1928;
const int QUICK_SLOT_9  = 1929;
const int QUICK_SLOT_10 = 1930;

void main()
{
    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case QUICK_SLOT_1:  nSlot = 1;  break;
        case QUICK_SLOT_2:  nSlot = 2;  break;
        case QUICK_SLOT_3:  nSlot = 3;  break;
        case QUICK_SLOT_4:  nSlot = 4;  break;
        case QUICK_SLOT_5:  nSlot = 5;  break;
        case QUICK_SLOT_6:  nSlot = 6;  break;
        case QUICK_SLOT_7:  nSlot = 7;  break;
        case QUICK_SLOT_8:  nSlot = 8;  break;
        case QUICK_SLOT_9:  nSlot = 9;  break;
        case QUICK_SLOT_10: nSlot = 10; break;

        default:
            if(DEBUG) DoDebug("prc_shift_quicks: ERROR: Unknown nSpellID value: " + IntToString(nSpellID));
            return;
    }

    // Read the data from this slot
    string sResRef = GetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_ResRef");
    int bEpic      = GetPersistantLocalInt   (oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Epic");

    // Make sure the slot wasn't empty
    if(sResRef == "")
    {
        FloatingTextStrRefOnCreature(16828382, oPC, FALSE); // "This Quick Shift Slot is empty!"
        return;
    }

    // Make sure the character has uses left for shifting
    if(!bEpic) // Normal shapechange
    {
        // First try paying using Greater Wildshape uses
        if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC))
        {
            DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);

            // If we would reach 0 uses this way, see if we could pay with Druid Wildshape uses instead
            if(!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC)    &&
               GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
               GetHasFeat(FEAT_WILD_SHAPE, oPC)
               )
            {
                IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
             DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
            }

            bPaid = TRUE;
        }
        // Otherwise try paying with Druid Wildshape uses
        else if(GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
                GetHasFeat(FEAT_WILD_SHAPE, oPC)
                )
        {
          DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
          bPaid = TRUE;
        }
    }
    // Epic shift, uses Epic Greater Wildshape
    else if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1, oPC))
    {
        DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
        bPaid = TRUE;
    }

    // If the user could pay for the shifting, do it
    if(bPaid)
    {
        // See if the shifting starts successfully
        if(!ShiftIntoResRef(oPC, SHIFTER_TYPE_SHIFTER, sResRef, bEpic))
        {
            // In case of shifting failure, refund the shifting use
            if(bEpic)
                IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
            else
                IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
        }
    }
    // Otherwise, whine
    else
        FloatingTextStrRefOnCreature(16828373, oPC, FALSE); // "You didn't have (Epic) Greater Wildshape uses available."
}
