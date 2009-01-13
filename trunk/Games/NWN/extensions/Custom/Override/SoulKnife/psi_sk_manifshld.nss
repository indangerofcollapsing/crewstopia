//::///////////////////////////////////////////////
//:: Soulknife: Manifest Shield of Thought
//:: psi_sk_manifshld
//::///////////////////////////////////////////////
/**
    Handles the manifesting of a Kalashtar Soulknife's
    Shield of Thought.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_soulkn"

int LOCAL_DEBUG = DEBUG;

// @DUG duplicated from psi_sk_manifmbld.nss
const string VAR_USE_DUAL_MINDBLADES = "SOULKNIFE_DUAL_WIELD";
const int MBLADE_SHAPE_QUARTERSTAFF = 31; // prc_sk_mblade_qs     4  SDMoRW
const int MBLADE_SHAPE_HALBERD = 15; // prc_sk_mblade_ha          14 M
const int MBLADE_SHAPE_HEAVYFLAIL = 18; // prc_sk_mblade_hf       15 M
const int MBLADE_SHAPE_KATANA = 19; // prc_sk_mblade_ka           15 E
const int MBLADE_SHAPE_GREATAXE = 9; // prc_sk_mblade_ga          16 M
const int MBLADE_SHAPE_GREATSWORD = 6; // prc_sk_mblade_gs        17 M
const int MBLADE_SHAPE_SCYTHE = 22; // prc_sk_mblade_sy           19 E
const int MBLADE_SHAPE_DIREMACE = 16; // prc_sk_mblade_dm         20 E
const int MBLADE_SHAPE_DOUBLEAXE = 17; // prc_sk_mblade_da        20 E
const int MBLADE_SHAPE_2BLADESWORD = 7; // prc_sk_mblade_2b       20 E
const int MBLADE_SHAPE_HEAVYPICK = 41; // prc_sk_mblade_hp        12 M
const int MBLADE_SHAPE_MAUL = 44; // prc_sk_mblade_ma             15 M
const int MBLADE_SHAPE_DOUBLESCIMITAR = 37; // prc_sk_mblade_ds   20 E
const int MBLADE_SHAPE_MERCGREATSWORD = 45; // prc_sk_mblade_mg   21 E

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oShield    mindblade item
void BuildMindShield(object oPC, object oShield);


void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting psi_sk_manifshld");
    object oPC = OBJECT_SELF;
    object oShield;
    int nMbldType = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    int nHand = INVENTORY_SLOT_LEFTHAND;

    // Check the item based on type selection

    // @DUG if dual-wielding, no shield
    if (GetPersistantLocalInt(oPC, VAR_USE_DUAL_MINDBLADES)) return;

    switch(nMbldType)
    {
//        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
//            //if dual-wielding, no shield
//            return;
//            break;
        case MBLADE_SHAPE_BASTARDSWORD:
        case MBLADE_SHAPE_KATANA:
            //bastard sword is 2-hander if you lack proficiency
            if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD)) return;
            break;
        // @DUG two-hand weapons
        case MBLADE_SHAPE_QUARTERSTAFF:
        case MBLADE_SHAPE_HALBERD:
        case MBLADE_SHAPE_HEAVYFLAIL:
        case MBLADE_SHAPE_GREATAXE:
        case MBLADE_SHAPE_GREATSWORD:
        case MBLADE_SHAPE_SCYTHE:
        case MBLADE_SHAPE_DIREMACE:
        case MBLADE_SHAPE_DOUBLEAXE:
        case MBLADE_SHAPE_2BLADESWORD:
        case MBLADE_SHAPE_HEAVYPICK:
        case MBLADE_SHAPE_MAUL:
        case MBLADE_SHAPE_DOUBLESCIMITAR:
        case MBLADE_SHAPE_MERCGREATSWORD:
            return;
    }

    oShield = CreateItemOnObject("psi_sk_tshield_0", oPC);

    // Construct the bonuses
    /*DelayCommand(0.25f, */BuildMindShield(oPC, oShield)/*)*/;

    // Force equip
    AssignCommand(oPC, ActionEquipItem(oShield, nHand));

    // Make even more sure the mindshield cannot be dropped
    SetDroppableFlag(oShield, FALSE);
    SetItemCursedFlag(oShield, TRUE);

    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished psi_sk_manifshld")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}


void BuildMindShield(object oPC, object oShield)
{
    /* Add normal stuff and VFX */

    /* Apply the enhancements */
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

    if(nFlags & MBLADE_FLAG_SHIELD_1)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_2)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_3)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_4)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_5)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_6)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(6), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_7)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(7), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_8)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(8), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_9)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(9), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_10)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(10), oShield);
    }

    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(
       GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
       ITEM_VISUAL_SONIC), oShield);
}