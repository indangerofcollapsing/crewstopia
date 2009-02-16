/////////////////////////////////////////////////
// ACP_S3_diffstyle
// Author: Ariel Kaiser
// Modified by: Adam Anden
// Creation Date: 13 May 2005
// Modified Date: 28 January 2008
////////////////////////////////////////////////
/*
  In combination with the right feat.2da and spells.2da entries, this script
  allows a player (or possessed NPC with the right feat, I guess) to change
  their fighting style and trade it for different animations. Part of the ACP pack.
*/

const int PHENO_NORMAL = 0;
const int PHENO_LARGE = 2;
const int PHENO_KENSAI = 15;
const int PHENO_ASSASSIN = 16;
const int PHENO_HEAVY = 17;
const int PHENO_FENCING = 18;
const int PHENO_ARCANE = 19;
const int PHENO_DEMONBLADE = 20;
const int PHENO_WARRIOR = 21;
const int PHENO_TIGERFANG = 30;
const int PHENO_SUNFIST = 31;
const int PHENO_DRAGONPALM = 32;
const int PHENO_BEARCLAW = 33;

#include "inc_debug_dac"

object oPC = GetPCSpeaker(); //this script is always called by one person.

void ResetFightingStyle() //Resets the character phenotype to PHENO_NORMAL
{
    //If we are at phenotype PHENO_KENSAI-PHENO_DEMONBLADE we want to reset it to neutral.
    if (GetPhenoType(oPC) == PHENO_KENSAI || 
        GetPhenoType(oPC) == PHENO_ASSASSIN || 
        GetPhenoType(oPC) == PHENO_HEAVY || 
        GetPhenoType(oPC) == PHENO_FENCING || 
        GetPhenoType(oPC) == PHENO_ARCANE || 
        GetPhenoType(oPC) == PHENO_DEMONBLADE || 
        GetPhenoType(oPC) == PHENO_TIGERFANG || 
        GetPhenoType(oPC) == PHENO_SUNFIST || 
        GetPhenoType(oPC) == PHENO_DRAGONPALM|| 
        GetPhenoType(oPC) == PHENO_BEARCLAW)
    {
        SetPhenoType(PHENO_NORMAL, oPC);
    }

    //else, warn that the player doesn't have a phenotype which can be reset right now
    else
    {
        SendMessageToPC(oPC, "This may not work for you...");
        SetPhenoType(PHENO_NORMAL, oPC);
    }

}

// Sets character phenotype to PHENO_KENSAI,PHENO_ASSASSIN,PHENO_HEAVY or PHENO_FENCING
void SetCustomFightingStyle(int iStyle) 
{
   //debugVarObject("SetCustomFightingStyle()", OBJECT_SELF);
   //debugVarInt("iStyle", iStyle);
   
    //Maybe we're already using this fighting style? Just warn the player.
    if (GetPhenoType(oPC) == iStyle)
        SendMessageToPC(oPC, "You're already using this fighting style!");

    //If we are at phenotype 0 or one of the styles themselves, we go ahead
    //and set the creature's phenotype accordingly! (safe thanks to previous 'if')
    else if (GetPhenoType(oPC) == PHENO_NORMAL || 
       GetPhenoType(oPC) == PHENO_KENSAI || 
       GetPhenoType(oPC) == PHENO_ASSASSIN || 
       GetPhenoType(oPC) == PHENO_HEAVY || 
       GetPhenoType(oPC) == PHENO_FENCING || 
       GetPhenoType(oPC) == PHENO_ARCANE || 
       GetPhenoType(oPC) == PHENO_DEMONBLADE || 
       GetPhenoType(oPC) == PHENO_TIGERFANG || 
       GetPhenoType(oPC) == PHENO_SUNFIST || 
       GetPhenoType(oPC) == PHENO_DRAGONPALM || 
       GetPhenoType(oPC) == PHENO_BEARCLAW)
    {
        SetPhenoType(iStyle, oPC);
    }

    //At phenotype 2? Tell the player they're too fat!
    else if (GetPhenoType(oPC) == PHENO_LARGE)
        SendMessageToPC(oPC, "You're too fat to use a different fighting style!");

    //...we didn't fulfil the above conditions? Warn the player.
    else
    {
        SendMessageToPC(oPC, "Your phenotype is non-standard / this may not work...");
        SetPhenoType(iStyle, oPC);
    }
   //debugVarInt("Phenotype is", GetPhenoType(oPC));
}
