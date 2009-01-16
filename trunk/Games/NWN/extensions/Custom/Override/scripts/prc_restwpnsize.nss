//::///////////////////////////////////////////////
//:: Restrict Weapon Size
//:: prc_restwpnsize.nss
//::///////////////////////////////////////////////
/*
    Handles restrictions on weapon-wielding
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 31, 2008
//:://////////////////////////////////////////////

#include "prc_inc_wpnrest" // @DUG recompile only

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_restwpnsize running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;

    //needed to properly get creature size on the events
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("prc_restwpnsize: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_restwpnsize", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_restwpnsize", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_restwpnsize - OnEquip");

        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
        {
         DoWeaponEquip(oPC, oItem, ATTACK_BONUS_ONHAND);
        }

        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem))
        {
         DoWeaponEquip(oPC, oItem, ATTACK_BONUS_OFFHAND);
        }
    }

    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        //initialize variables
        int nRealSize = PRCGetCreatureSize(oPC);  //size for Finesse/TWF
        int nSize = nRealSize;                    //size for equipment restrictions
        int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nElfFinesse = nDexMod - nStrMod;
        int nTHFDmgBonus = nStrMod / 2;
        oItem = GetItemLastUnequipped();
        //Powerful Build bonus
        if(GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oPC))
            nSize++;

        if(DEBUG) DoDebug("prc_restwpnsize - OnUnEquip");

        // remove any TWF penalties
        //if weapon was a not light, and there's still something equipped in the main hand(meaning that an offhand item was de-equipped)
        if(GetWeaponSize(oItem) == nRealSize && GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
        {
            //remove any effects added
            SetCompositeAttackBonus(oPC, "OTWFPenalty", 0);
        }
        //remove any simulated finesse
        if(GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && GetIsWeapon(oItem))
        {
            //if left hand unequipped, clear
            //if right hand unequipped, left hand weapon goes to right hand, so should still be cleared
            SetCompositeAttackBonus(oPC, "ElfFinesseLH", 0, ATTACK_BONUS_OFFHAND);
            //if right hand weapon unequipped
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                SetCompositeAttackBonus(oPC, "ElfFinesseRH", 0, ATTACK_BONUS_ONHAND);
        }

        //remove any two-handed weapon bonus
        SetCompositeDamageBonusT(oItem, "THFBonus", 0);

        //clean elven thinblade-simulated bonuses
        DoWeaponFeatUnequip(oPC, oItem, ATTACK_BONUS_OFFHAND);
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                DoWeaponFeatUnequip(oPC, oItem, ATTACK_BONUS_ONHAND);

        //clean any nonproficient penalties
        SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_OFFHAND), 0, ATTACK_BONUS_OFFHAND);
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_ONHAND), 0, ATTACK_BONUS_ONHAND);

        ZEPGenderRestrict(oItem, oPC); // @DUG
    }
}