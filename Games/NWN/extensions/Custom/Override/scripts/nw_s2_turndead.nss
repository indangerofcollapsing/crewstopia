//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
/*
These classes all stack for determining turning:
Cleric
Paladin-2
Anti-Paladin-2
Blackguard-2
True Necromancer
Soldier of Light
Hospitalier-2
Balenorm  //Baelnorn technically doesn't stack; all levels of all classes count -Tenjac
Drow Judicator
*/

#include "prc_inc_domain"
#include "prc_inc_turning"
//#include "inc_debug_dac" // @DUG

/*
//gets the number of class levels that count for turning
int GetTurningClassLevel(int bUndeadOnly = FALSE);

//this does the check and adjusts the highest HD of undead turned
int GetTurningCheckResult(int nLevel, int nChaMod);

//this creates the list of targets that are affected
//use the inc_target_list functions
void MakeTurningTargetList(int nTurningMaxHD, int nTurningTotalHD);

//tests if the target can be turned by self
//includes race, domains, etc.
int GetCanTurn(object oTarget);

//gets the equivalent HD total for turning purposes
//includes turn resistance and SR for outsiders
int GetHitDiceForTurning(object oTarget);

//the main turning function once targets have been listed
//routs to turn/destroy/rebuke/command as appropaite
void DoTurnAttempt(object oTarget, int nTurningMaxHD, int nLevel);

int GetCommandedTotalHD();

//various sub-turning effect funcions

void DoTurn(object oTarget);
void DoDestroy(object oTarget);
void DoRebuke(object oTarget);
void DoCommand(object oTarget, int nLevel);
*/
void main()
{

    // Because Turn Undead isn't from a domain, skip this check
    if (GetSpellId() != SPELL_TURN_UNDEAD)
    {
        // Used by the uses per day check code for bonus domains
        if (!DecrementDomainUses(GetTurningDomain(GetSpellId()), OBJECT_SELF)) return;
    }

    //casters level for turning
    int nLevel = GetTurningClassLevel();

    //casters charisma modifier
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA);
    //Heartwarder adds two to cha checks
    if (GetHasFeat(FEAT_HEART_PASSION))
        nChaMod +=2;

    //key values for turning
    int nTurningTotalHD = d6(2)+nLevel+nChaMod;
    int nTurningMaxHD = GetTurningCheckResult(nLevel, nChaMod);

    //these stack but dont multiply
    //so use a bonus amount and then add that on later
    int nBonusTurningTotalHD;
    int nBonusTurningMaxHD;
    //apply maximize turning
    //+100% if good
    if(GetHasFeat(FEAT_MAXIMIZE_TURNING)
        && GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
        nBonusTurningTotalHD += nTurningTotalHD;
    //apply empowered turning
    //+50%
    //only if maximize doesnt apply
    else if(GetHasFeat(FEAT_EMPOWER_TURNING))
        nBonusTurningTotalHD += nTurningTotalHD/2;
    //sun domain
    //+d6 total +d4 max
    //Nope, now its PnP :)
    //Destroys any undead that would be turned/rebuked/dominated
    //Usable once per day
    /*
    if(GetHasFeat(FEAT_SUN_DOMAIN_POWER))
    {
        nBonusTurningTotalHD +=d6();
        nBonusTurningMaxHD +=d4();
    }*/

    // @DUG Holy Symbol
    int bUsingHolySymbol = FALSE;
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (oItem != OBJECT_INVALID &&
        GetStringLeft(GetName(oItem), 15) == "Holy Symbol of ")
    {
       bUsingHolySymbol = TRUE;
    }
    else
    {
       oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
       if (oItem != OBJECT_INVALID &&
           GetStringLeft(GetName(oItem), 15) == "Holy Symbol of ")
       {
          bUsingHolySymbol = TRUE;
       }
    }
    if (bUsingHolySymbol)
    {
       string sPCDeity = GetDeity(OBJECT_SELF);
       //debugVarString("sPCDeity", sPCDeity);
       string sSymbolDeity = GetSubString(GetName(oItem), 15, 100);
       //debugVarString("sSymbolDeity", sSymbolDeity);
       if (sPCDeity != "")
       {
          if (sPCDeity == sSymbolDeity)
          {
             nBonusTurningMaxHD += nChaMod;
             int nVfx = VFX_IMP_GOOD_HELP;
             if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
             {
                nVfx = VFX_IMP_EVIL_HELP;
             }
             ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectVisualEffect(nVfx), OBJECT_SELF);
          }
          else
          {
             FloatingTextStringOnCreature("YOU DARE to use ANOTHER deity's " +
                "holy symbol?", OBJECT_SELF);
             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
                VFX_IMP_DOOM), OBJECT_SELF);
          }
       }
       else
       {
          SendMessageToPC(OBJECT_SELF, "Only worshippers of " + sSymbolDeity +
             " gain benefits from this holy symbol.");
       }
    }

    //add bonus HD
    nTurningTotalHD += nBonusTurningTotalHD;
    nTurningMaxHD   += nBonusTurningMaxHD;

    FloatingTextStringOnCreature("You are turning "+IntToString(nTurningTotalHD)+"HD of creatures whose HD is equal or less than "+IntToString(nTurningMaxHD), OBJECT_SELF, FALSE);
    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    // Evil clerics rebuke, not turn, and have a different VFX
    if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL) eImpactVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));


    //zone of animation effect
    //"You can use a rebuke or command undead attempt to animate
    //corpses within range of your rebuke or command attempt.
    //You animate a total number of HD of undead equal to the
    //number of undead that would be commanded by your result
    //(though you can’t animate more undead than there are available
    //corpses within range). You can’t animate more undead with
    //any single attempt than the maximum number you can command
    //(including any undead already under your command). These
    //undead are automatically under your command, though your
    //normal limit of commanded undead still applies. If the
    //corpses are relatively fresh, the animated undead are zombies.
    //Otherwise, they are skeletons. "
    //currently implemented ignoring corpses & what the corpses are of.
    if(GetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"))
    {
        //Undead Mastery multiplies total HD by 10
        //non-undead have their HD score multiplied by 10 to compensate
        if(GetHasFeat(FEAT_UNDEAD_MASTERY))
            nLevel *= 10;
        //create the effect
        effect eCommand2 = EffectDominated();
        effect eCommand = EffectCutsceneDominated();
        effect eLink = EffectLinkEffects(eCommand, eCommand2);
        eLink = SupernaturalEffect(eLink);
        effect eVFXCom = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
        //keep creating stuff
        int nCommandedTotalHD = GetCommandedTotalHD();
        while(nCommandedTotalHD < nTurningTotalHD)
        {
            location lLoc = GetLocation(OBJECT_SELF);
            //skeletal blackguard
            string sResRef = "x2_s_bguard_18";
            object oCreated = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);


            int nTargetHD = GetHitDiceForTurning(oCreated);
            //undead mastery only applies to undead
            //so non-undead have thier HD multiplied by 10
            if(MyPRCGetRacialType(oCreated) != RACIAL_TYPE_UNDEAD
                && GetHasFeat(FEAT_UNDEAD_MASTERY))
                nTargetHD *= 10;

            if(nCommandedTotalHD + nTargetHD <= nLevel)
            {
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oCreated));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreated);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXCom, oCreated);
            }
            //cant be commanded, clean it up
            else
                DestroyObject(oCreated);

            nCommandedTotalHD += nTargetHD;
        }
        //send feedback
        int nCommandLevel = nLevel;
        if(GetHasFeat(FEAT_UNDEAD_MASTERY))
            nCommandLevel *= 10;
        FloatingTextStringOnCreature("Currently commanding "
            +IntToString(GetCommandedTotalHD())
            +"HD out of "+IntToString(nCommandLevel)
            +"HD.", OBJECT_SELF);
        return;
    }

    //assemble the list of targets to try to turn
    MakeTurningTargetList(nTurningMaxHD, nTurningTotalHD, PRCGetSpellId());

    //cycle through target list
    object oTarget = GetTargetListHead(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        DoTurnAttempt(oTarget, nTurningMaxHD, nLevel, PRCGetSpellId());
        oTarget = GetTargetListHead(OBJECT_SELF);
    }
}
