//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "inc_timestop"


void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONEQUIP",2);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONEQUIP");
}

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004
//Removed the delay. It was messing up evaluation scripts that use GetItemLastEquipped(By)
//  Ornedan - 07.03.2005

void main()
{
    object oItem = GetItemLastEquipped();
    object oPC   = GetItemLastEquippedBy();

   if (!GetIsObjectValid(oPC))
      return;

//if(DEBUG) DoDebug("Running OnEquip, creature = '" + GetName(oPC) + "' is PC: " + DebugBool2String(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    //DelayCommand(0.3, PrcFeats(oPC));
    PrcFeats(oPC);

    // Handle custom limitation itemproperties and other itemproperties that trigger when equipped, like PnP Holy Avenger and speed modifications
    SetLocalInt(oPC, "ONEQUIP", 2); // Ugly hack to work around event detection in CheckPRCLimitations() - Ornedan
    ExecuteScript("prc_equip_rstr", OBJECT_SELF);
    DeleteLocalInt(oPC, "ONEQUIP");

    //timestop noncombat equip
    DoTimestopEquip();

    //Handle lack of fingers/hands
    if(GetPersistantLocalInt(oPC, "LEFT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), INVENTORY_SLOT_LEFTHAND);
        SendMessageToPC(oPC, "You cannot use your left hand");
    }

    if(GetPersistantLocalInt(oPC, "RIGHT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), INVENTORY_SLOT_RIGHTHAND);
        SendMessageToPC(oPC, "You cannot use your right hand");
    }

    ExecuteScript("on_equip_cep", OBJECT_SELF); // @DUG

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYEREQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYEREQUIPITEM);
}
