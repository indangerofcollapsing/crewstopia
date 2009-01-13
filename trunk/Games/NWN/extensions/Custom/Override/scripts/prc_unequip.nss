//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "prc_inc_function"
#include "inc_timestop"
#include "prc_inc_itmrstr"

void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONEQUIP",1);
     EvalPRCFeats(oPC);

     //this is to remove effect-related itemproperties
     //in here to take advantage of the local
     //I didnt put it in EvalPRCfeats cos I cant be bothered to wait for the compile
     //Ill probably move it at some point, dont worry
     //Primogenitor
     object oItem = GetItemLastUnequipped();
     CheckPRCLimitations(oItem, oPC);

     DeleteLocalInt(oPC,"ONEQUIP");
}

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004
void main()
{
    object oItem = GetItemLastUnequipped();
    object oPC   = GetItemLastUnequippedBy();

//if(DEBUG) DoDebug("Running OnUnEquip, creature = '" + GetName(oPC) + "' is PC: " + DebugBool2String(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    DoTimestopUnEquip();

    // Delay a bit to prevent TMI due to polymorph effect being braindead and running the unequip script for each and
    // bloody every item the character has equipped at the moment of effect application. Without detaching the script
    // executions from the script that does the effect application. So no instruction counter resets.
    // This will probably smash some scripts to pieces, at least when multiple unequips happen at once. Hatemail
    // to nwbugs@bioware.com please.

    DelayCommand(0.0f, PrcFeats(oPC));

    /* Does not seem to work, the effect is not listed yet when the unequip scripts get run
    if(PRCGetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {
        DoDebug("prc_unequip: delayed call");
        DelayCommand(0.0f, PrcFeats(oPC));
    }
    else
    {
        DoDebug("prc_unequip: direct call");
        PrcFeats(oPC);
    }*/


    ExecuteScript("on_unequip_cep", OBJECT_SELF); // @DUG

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERUNEQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYERUNEQUIPITEM);
}
