//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: prc_onhitcast
//:://////////////////////////////////////////////
/*
    This file holds all the OnHitCastSpell events
    used by PRC.
    It was created to replace x2_s3_onhitcast so that
    it wouldn't override module-specific onhitcast events.

    Add your own entries after the previous ones. Try to
    keep variable scope as little as possible. ie, no top-
    level variables if you just can avoid it.
    If your entry is long (over 20 lines), consider placing
    the guts of it outside the main to improve readability
    for the rest of us :D


    Please remember comment your entry.
    At least mention what class ability / spell / whatever
    it is part of.
*/
//:://////////////////////////////////////////////
//:: Created By: Various people
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_grapple"
#include "psi_inc_onhit"
#include "inc_rend"
#include "psi_inc_ac_const"
#include "prc_inc_onhit"
#include "tob_inc_tobfunc"
#include "inc_debug_dac" // @DUG

void SetRancorVar(object oPC);
void SetImprovedRicochetVar(object oPC);
void DoImprovedRicochet(object oPC, object oTarget);


void main()
{
   debugVarObject("prc_onhitcast", OBJECT_SELF);
   object oSpellOrigin = OBJECT_SELF; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
   debugVarObject("oSpellOrigin", oSpellOrigin);

    // Call the normal OnHitCastSpell: Unique script
    if (DEBUG) DoDebug("prc_onhitcast: entered, executing normal onhitcastspell unique power script x2_s3_onhitcast for "+GetName(oSpellOrigin));
    ExecuteScript("x2_s3_onhitcast", oSpellOrigin);

    // motu99: setting a local int, so that onhitcast impact spell scripts can find out, whether they were called from prc_onhitcast
    // or from somewhere else (presumably the aurora engine). This local int will be deleted just before we exit prc_onhitcast
    // Note that any scripts that are called by a DelayCommand (or AssignCommand) from prc_onhitcast will not find this local int
    SetLocalInt(oSpellOrigin, "prc_ohc", TRUE);

    object oSpellTarget = PRCGetSpellTargetObject(oSpellOrigin); // On a weapon: The one being hit. On an armor: The one hitting the armor
    debugVarObject("oSpellTarget", oSpellTarget);

    // motu99: replacing call to Bioware's GetSpellCastItem with new PRC wrapper function
    // will ensure that we retrieve a valid item when we are called from scripted combat (prc_inc_combat) or
    object oItem = PRCGetSpellCastItem(oSpellOrigin); // The item casting triggering this spellscript
    debugVarObject("oItem", oItem);
    int iItemBaseType = GetBaseItemType(oItem);


// DEBUG code, remove
    if (DEBUG)
    {
        if(!GetIsOnHitCastSpell(oSpellTarget, oItem, oSpellOrigin))
            DoDebug("prc_onhitcast: Warning, the currently running instance of prc_onhitcast was not recognized as an onhitcastspell");
    }
// DEBUG code, remove

    if (DEBUG) DoDebug("prc_onhitcast: now executing prc specific routines with item = "+ GetName(oItem)+", target = "+GetName(oSpellTarget)+", caller = "+GetName(oSpellOrigin));

    int nVassal;         //Vassal Level
    int nBArcher;        // Blood Archer level
    int nFoeHunter;      // Foe Hunter Level
    //int bItemIsWeapon;

    nVassal    = GetLevelByClass(CLASS_TYPE_VASSAL, oSpellOrigin);
    nBArcher   = GetLevelByClass(CLASS_TYPE_BLARCHER, oSpellOrigin);
    nFoeHunter = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oSpellOrigin);

    //// Swashbuckler Weakening and Wounding Criticals
    if(GetHasFeat(INSIGHTFUL_STRIKE, oSpellOrigin))
    { // @DUG
        //debugMsg("calling prc_swashweak");
        ExecuteScript("prc_swashweak", oSpellOrigin);
    } // @DUG

    //// Champion of Corellon damage healing for sneak/critical immune creatures
    if(GetHasFeat(FEAT_COC_ELEGANT_STRIKE, oSpellOrigin))
    { // @DUG
        //debugMsg("calling coc_heal");
        ExecuteScript("prc_coc_heal", oSpellOrigin);
    } // @DUG

    //// Stormlord Shocking & Thundering Spear

    if(GetHasFeat(FEAT_THUNDER_WEAPON, oSpellOrigin))
    { // @DUG
        //debugMsg("calling ft_shockweap");
        ExecuteScript("ft_shockweap", oSpellOrigin);
    } // @DUG

    if (GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON, oItem))
    {
        if((GetLocalInt(oSpellOrigin, "WeapEchant1") == TEMPUS_ABILITY_VICIOUS &&
             MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace1")) ||
           (GetLocalInt(oSpellOrigin,"WeapEchant2")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace2")) ||
           (GetLocalInt(oSpellOrigin,"WeapEchant3")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace3"))
          )
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d6()),oSpellOrigin);
    }

    if (GetIsPC(oSpellOrigin))
        SetLocalInt(oSpellOrigin,"DmgDealt",GetTotalDamageDealt());

    /// Vassal of Bahamut Dragonwrack
    if (nVassal > 3)
    {
        if (iItemBaseType == BASE_ITEM_ARMOR)
        {
            ExecuteScript("prc_vb_dw_armor", oSpellOrigin);
        }
        else
        {
            ExecuteScript("prc_vb_dw_weap", oSpellOrigin);
        }
    }
    /// Blood Archer Acidic Blood
    if (nBArcher >= 2)
    {
        if (iItemBaseType == BASE_ITEM_ARMOR)
        {
            ExecuteScript("prc_bldarch_ab", oSpellOrigin);
        }
    }

    // Blood Archer Poison Blood
    if (nBArcher > 0 && iItemBaseType != BASE_ITEM_ARMOR)
    {
        // poison number based on archer level
        // gives proper DC for poison
        int iPoison = 104 + nBArcher;
        effect ePoison = EffectPoison(iPoison);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oSpellTarget);
    }

    // Frenzied Berserker Auto Frenzy
    if(iItemBaseType == BASE_ITEM_ARMOR && GetHasFeat(FEAT_FRENZY, oSpellOrigin))
    {
        if(!GetHasFeatEffect(FEAT_FRENZY, oSpellOrigin))
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_auto_fre", oSpellOrigin) );
        }
        else if(GetCurrentHitPoints(oSpellOrigin) == 1 && GetHasFeat(FEAT_DEATHLESS_FRENZY, oSpellOrigin))
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_deathless", oSpellOrigin) );
        }
    }

    // Warsling Sniper Improved Ricochet
    if (iItemBaseType == BASE_ITEM_BULLET
        && GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oSpellOrigin) == 6
        && GetLocalInt(oSpellOrigin, "CanRicochet") != 2)
    {
        DoImprovedRicochet(oSpellOrigin, oSpellTarget);

        // Deactivates Ability
        SetLocalInt(oSpellOrigin, "CanRicochet", 2);

        // Prevents the heartbeat script from running multiple times
        if(GetLocalInt(oSpellOrigin, "ImpRicochetVarRunning") != 1)
        {
            DelayCommand(6.0, SetImprovedRicochetVar(oSpellOrigin) );
            SetLocalInt(oSpellOrigin, "ImpRicochetVarRunning", 1);
        }
    }

    // Warchief Devoted Bodyguards
    if(iItemBaseType == BASE_ITEM_ARMOR && GetLevelByClass(CLASS_TYPE_WARCHIEF, oSpellOrigin) >= 8)
    {
        // Warchief must make a reflex save
        if (!GetLocalInt(oSpellOrigin, "WarChiefDelay"))
        {
            // Done this way for formatting reasons in game
            if (ReflexSave(oSpellOrigin, 15) > 0) DelayCommand(0.01, ExecuteScript("prc_wchf_bodygrd",oSpellOrigin));
        }
        // He can only do this once a round, so put a limit on it
        // Also have to make sure its only set once a round
        if (!GetLocalInt(oSpellOrigin, "WarChiefDelay"))
        {
            SetLocalInt(oSpellOrigin, "WarChiefDelay", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oSpellOrigin, "WarChiefDelay"));
        }
    }


    // Foe Hunter Damage Resistance
    if(iItemBaseType == BASE_ITEM_ARMOR && nFoeHunter > 1)
    {
        DelayCommand(0.01, ExecuteScript("prc_fh_dr",oSpellOrigin) );
    }

    // Foe Hunter Rancor Attack
    if(iItemBaseType != BASE_ITEM_ARMOR && nFoeHunter > 0)
    {
        if( GetLocalInt(oSpellOrigin, "PRC_CanUseRancor") != 2
            && GetLocalInt(oSpellOrigin, "HatedFoe") == MyPRCGetRacialType(oSpellTarget) )
        {
            int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oSpellOrigin);
            int iRancorDice = FloatToInt( (( iFHLevel + 1.0 ) /2) );

            int iDamage = d6(iRancorDice);
            int iDamType = GetWeaponDamageType(oItem);
            int iDamPower = GetDamagePowerConstant(oItem, oSpellTarget, oSpellOrigin);

            effect eDam = EffectDamage(iDamage, iDamType, iDamPower);

            string sMess = "*Rancor Attack*";
            FloatingTextStringOnCreature(sMess, oSpellOrigin, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);

            // Deactivates Ability
            SetLocalInt(oSpellOrigin, "PRC_CanUseRancor", 2);

            // Prevents the heartbeat script from running multiple times
            if(GetLocalInt(oSpellOrigin, "PRC_RancorVarRunning") != 1)
            {
                DelayCommand(6.0, SetRancorVar(oSpellOrigin) );
                SetLocalInt(oSpellOrigin, "PRC_RancorVarRunning", 1);
            }
        }
    }

    //Creatures with a necrotic cyst take +1d6 damage from natural attacks of undead

    if(GetHasNecroticCyst(oSpellOrigin))
    {
        //if enemy is undead
        if(MyPRCGetRacialType(oSpellTarget) == RACIAL_TYPE_UNDEAD)
        {
            //and unarmed
            if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget)) &&
                !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget)))

                {
                effect eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellOrigin);
            }
         }
     }


    /*//////////////////////////////////////////////////
    //////////////// PSIONICS //////////////////////////
    //////////////////////////////////////////////////*/

    // SweepingStrike OnHit
    if(iItemBaseType != BASE_ITEM_ARMOR && GetLocalInt(oItem, "SweepingStrike"))
    {
        SweepingStrike(oSpellOrigin, oSpellTarget);
    }

    // Mind Stab OnHit
    if(iItemBaseType != BASE_ITEM_ARMOR && GetLocalInt(oItem, "ShadowMindStab") && !GetLocalInt(oSpellOrigin, "MindStabDelay"))
    {
        // Only works when able to sneak attack a target
        if (GetCanSneakAttack(oSpellTarget, oSpellOrigin))
        {
            MindStab(oSpellOrigin, oSpellTarget);
            // Only once per round
            SetLocalInt(oSpellOrigin, "MindStabDelay", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oSpellOrigin, "MindStabDelay"));
        }
    }

    // Astral Construct's Poison Touch special ability
    if(GetLocalInt(oSpellOrigin, ASTRAL_CONSTRUCT_POISON_TOUCH))
    {
        ExecuteScript("psi_ast_con_ptch", oSpellOrigin);
    }

    // Pyrokineticist bonus damage
    int nPyroLevel = GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oSpellOrigin);
    if(nPyroLevel)
    {
        int iElement = GetPersistantLocalInt(oSpellOrigin, "PyroDamageType");
        int nDam1 = 0;
        int nDam2 = 0;
        int nDam = 0;
        int nDice = 0;

        if(iItemBaseType == BASE_ITEM_ARMOR)
        {   //Nimbus Onhit
            if(nPyroLevel >= 5 && GetHasSpellEffect(SPELL_NIMBUS, oSpellOrigin))
            {
                nDice = 2;
                nDam = (iElement == DAMAGE_TYPE_SONIC) ? d4(nDice) : d6(nDice);    //reduced damage dice
                if((iElement == DAMAGE_TYPE_COLD) || (iElement == DAMAGE_TYPE_ELECTRICAL) || (iElement == DAMAGE_TYPE_ACID))
                    nDam = max(nDice, nDam - nDice);   //minimum of 1 per die
            }
        }
        else
        {   //Assume unarmed/weapon damage
            if(nPyroLevel >= 2)
            {
                nDice = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oSpellOrigin) >= 8) ? 4 : 2;
                nDam1 = (iElement == DAMAGE_TYPE_SONIC) ? d4(nDice) : d6(nDice);    //reduced damage dice
                if((iElement == DAMAGE_TYPE_COLD) || (iElement == DAMAGE_TYPE_ELECTRICAL) || (iElement == DAMAGE_TYPE_ACID))
                    nDam1 = max(nDice, nDam1 - nDice);   //minimum of 1 per die
            }
            if(GetTag(oItem) == "PRC_PYRO_LASH_WHIP")
            {   //Extra damage from whip
                nDam2 += (iElement == DAMAGE_TYPE_SONIC) ? d6(1) : d8(1);   //reduced damage dice
                if((iElement == DAMAGE_TYPE_COLD) || (iElement == DAMAGE_TYPE_ELECTRICAL) || (iElement == DAMAGE_TYPE_ACID))
                    nDam2 = max(1, nDam2 - 1);   //minimum of 1
            }
            nDam = nDam1 + nDam2;
        }
        if(nDam > 0)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, iElement), oSpellTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(GetPersistantLocalInt(oSpellOrigin, "PyroImpactVFX")), oSpellTarget);
        }
    }


    /*//////////////////////////////////////////////////
    //////////////// END PSIONICS //////////////////////
    //////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////
    //////////////// Blade Magic ///////////////////////
    //////////////////////////////////////////////////*/

    // Martial Spirit
    if(GetHasSpellEffect(MOVE_DS_MARTIAL_SPIRIT, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        object oHealTarget = GetCrusaderHealTarget(oSpellOrigin, 30.0);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(2), oHealTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHealTarget);
    }

    // Blood in the Water
    if(GetHasSpellEffect(MOVE_TC_BLOOD_WATER, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        // Fake critical hit check
        if (d20() >= GetWeaponCriticalRange(oSpellOrigin, oItem))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1), oSpellOrigin);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(1), oSpellOrigin);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_YELLOW_HEAD), oSpellOrigin);
    }
    }

    // Fire Riposte
    if(GetHasSpellEffect(MOVE_DW_FIRE_RIPOSTE, oSpellOrigin) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        int nTouchAttack = PRCDoMeleeTouchAttack(oSpellTarget);
        if(nTouchAttack > 0)
        {
                // Apply the damage and VFX
                ApplyTouchAttackDamage(oSpellOrigin, oSpellTarget, nTouchAttack, d6(4), DAMAGE_TYPE_FIRE);
                effect eVis = EffectVisualEffect(VFX_COM_HIT_FIRE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSpellTarget);
                FloatingTextStringOnCreature("Fire Riposte Hit", oSpellOrigin, FALSE);
                // Clean up
                PRCRemoveSpellEffects(MOVE_DW_FIRE_RIPOSTE, oSpellOrigin, oSpellOrigin);
        }
    }

    // Holocaust Cloak
    if(GetHasSpellEffect(MOVE_DW_HOLOCAUST_CLOAK, oSpellOrigin) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        if(GetIsInMeleeRange(oSpellOrigin, oSpellTarget))
        {
                // Apply the damage and VFX
                effect eVis = EffectVisualEffect(VFX_COM_HIT_FIRE);
                effect eDam = EffectDamage(5, DAMAGE_TYPE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSpellTarget);
                FloatingTextStringOnCreature("Holocaust Cloak Hit", oSpellOrigin, FALSE);
        }
    }
    // Defensive Rebuke
    if(GetHasSpellEffect(MOVE_DS_DEFENSIVE_REBUKE, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        SetLocalObject(oSpellTarget, "DefensiveRebuke", oSpellOrigin);
        DelayCommand(3.0, ExecuteScript("tob_dvsp_defrbka", oSpellTarget));
    }
    // Defensive Rebuke
    if(GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oSpellOrigin) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        // Will reset to 0.
        DeleteLocalInt(oSpellOrigin, "PearlOfBlackDoubtBonus");
    }
    // Tactics of the Wolf
    if(GetHasSpellEffect(MOVE_WR_TACTICS_WOLF, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        if (GetIsFlanked(oSpellTarget, oSpellOrigin))
        {
            int nWolfDam = GetLocalInt(oSpellOrigin, "TacticsWolf");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nWolfDam), oSpellTarget);
        }
    }

    // Aura of Triumph
    if(GetHasSpellEffect(MOVE_DS_AURA_TRIUMPH, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        // Heal both
        object oHealTarget = GetLocalObject(oSpellOrigin, "DSTriumph");
        // Must be within 10 feet
        if (10.0 >= FeetToMeters(GetDistanceBetween(oSpellOrigin, oSpellOrigin)))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(4), oHealTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHealTarget);
    }
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(4), oSpellOrigin);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oSpellOrigin);
    }

    // Immortal Fortitude
    if(GetHasSpellEffect(MOVE_DS_IMMORTAL_FORTITUDE, oSpellOrigin) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        // He's immortal, so now we run a script to see if he should/would have died (Saving, etc)
    if(GetCurrentHitPoints(oSpellOrigin) == 1)
        {
            DelayCommand(0.01, ExecuteScript("tob_dvsp_imfrtoh", oSpellOrigin));
        }
    }
    // Immortal Fortitude
    if(GetHasSpellEffect(MOVE_WR_CLARION_CALL, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        // Check to see if the target is dead, triggers each time
    if(GetIsDead(oSpellTarget))
        {
            location lTarget = GetLocation(oSpellOrigin);
            object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oAreaTarget))
            {
                if(GetIsFriend(oAreaTarget, oSpellOrigin))
                {
                    // Apply extra attack for one round
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectModifyAttacks(1)), oAreaTarget, 6.0);
                }
                oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }
        }
    }

    /*//////////////////////////////////////////////////
    //////////////// Blade Magic ///////////////////////
    //////////////////////////////////////////////////*/

    if(iItemBaseType != BASE_ITEM_ARMOR && GetLocalInt(oSpellOrigin,"doarcstrike"))
    {
        int nDice = GetLocalInt(oSpellOrigin,"curentspell");
        int nDamage = d4(nDice);
        effect eDam = EffectDamage(nDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oSpellTarget);
    }

    //spellsword & arcane archer
    //will also fire for other OnHit:UniquePower items that have a SpellSequencer property (such as Duskblade)
    if(GetLocalInt(oItem, "X2_L_NUMTRIGGERS"))
    {
        if (DEBUG) DoDebug("prc_onhitcast: Triggering Sequencer Discharge");
        ExecuteScript("x2_s3_sequencer", oSpellOrigin);
    }

    // Handle Rend. Creature weapon damage + 1.5x STR bonus.
    // Only happens when attacking with a creature weapon
    if(GetIsCreatureWeaponType(iItemBaseType) && GetHasFeat(FEAT_REND, oSpellOrigin))
    {
        DoRend(oSpellTarget, oSpellOrigin, oItem);
    }

    // now cycle through all onhitcast spells on the item
    // we must exclude unique power (which is associated with prc_onhitcast), because otherwise we would get infinite recursions
    // it is of utmost importance to devise a *safe* way to cycle through all onhitcast spells on the item. The safe way is provided
    // by the function ApplyAllOnHitCastSpellsOnItemExcludingSubType defined in prc_inc_spells

    // There are two ways to call this function: Either with all necessary parameters passed explicitly to the function
    // or with no parameters passed to the function (in this case default values are used, which also works, at least in prc_onhitcast)

    // VERSION 1:
    // generally it is more efficient to call ApplyAllOnHitCastSpellsOnItemExcludingSubType by explicitly passing the parameters to the function
    // this will set up the overrides in the PRC-wrappers for the spell information functions, which generally is much faster
    // ApplyAllOnHitCastSpellsOnItemExcludingSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, oSpellTarget, oItem, oSpellOrigin);

    // VERSION 2:
    // motu99: It might be safer to call this only with defaults in order disallow overrides being set.
    // (they could have been set beforehand, though - in fact they *are* if we were called from prc_inc_combat)
    // VERSION 2 has also been tested to work; however, if Bioware changes its implementation the code below is more likely to break
    ApplyAllOnHitCastSpellsOnItemExcludingSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER);

    // ONLY FOR TESTING
    // if(GetPRCSwitch(PRC_TIMESTOP_LOCAL)) CastSpellAtLocation(SPELL_FIREBALL, GetLocation(oSpellTarget) /*, METAMAGIC_ANY, GetLevelByTypeArcane(oSpellOrigin), CLASS_TYPE_WIZARD */);
    // if(GetPRCSwitch(PRC_PNP_TRUESEEING)) CastSpellAtObject(SPELL_FIREBALL, oSpellTarget /*, METAMAGIC_ANY, GetLevelByTypeArcane(oSpellOrigin), CLASS_TYPE_WIZARD */);
/*
// motu99: This is the old (unsafe) way to cycle through the onhitcast spells.
// This method fails, whenever one of the called impact spell script cycles through the item properties of the SpellCastItem on its own
// (or calls a function that cycles through the item properties - such as PRCGetMetaMagicFeat)
// The safe way to do things is to use the functions ApplyAllOnHitCastSpells* to be found in prc_inc_spells
// Left the piece of code here as an example and a warning, how perfectly reasonable code can break without the fault of the scripter
// Such an "error" can easily happen to any of us. It is quite difficult to spot an error, caused by nested loops
// over item properties in *different* scripts. Runtime behavior is erratic. If you are lucky, you get an
// infinite recursion (then you will notice that something is wrong). If you are not lucky, the loop will just skip over
// some item properties. And this simply because you put a completely harmless looking function like PRCGetMetaMagicFeat
// into your Spell script. How could you possibly know that you just broke your script, because of an unsafe implementation
// in a *different* script (here: prc_onhitcast)? You might not even know, that this different scripts exists.

    //handle other OnHit:CastSpell properties
DoDebug("prc_onhitcast: now doing other OnHitCastSpell properties on item = "+GetName(oItem));
    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_ONHITCASTSPELL)
        {
            int nIPSpell = GetItemPropertySubType(ipTest);
            if(nIPSpell == 125)
            {
                ipTest = GetNextItemProperty(oItem);
                continue; //abort if its OnHit:CastSpell:UniquePower otherwise it would TMI.
            }
            int nSpell   = StringToInt(Get2DACache("iprp_onhitspell", "SpellIndex", nIPSpell));
            // int nLevel   = GetItemPropertyCostTableValue(ipTest);
            string sScript = Get2DACache("spells", "ImpactScript", nSpell);
DoDebug("prc_onhitcast: Now executing Impact spell script "+sScript);
            // motu99: Never execute complicated scripts within an GetFirst* / GetNext* loop !!!
            // The code will break, whenever the script does a loop over item properties (or effects) on its own
            // rather store all found scripts in a local array, and execute the scripts in a separate loop
            ExecuteScript(sScript,oSpellOrigin);
        }
        ipTest = GetNextItemProperty(oItem);
    }
*/

    /*//////////////////////////////////////////////////
    ///////////////////  SPELLFIRE  ////////////////////
    //////////////////////////////////////////////////*/

    int nSpellfire = GetLevelByClass(CLASS_TYPE_SPELLFIRE, oSpellOrigin);
    if(nSpellfire && (iItemBaseType == BASE_ITEM_ARMOR))
    {
        int nStored = GetPersistantLocalInt(oSpellOrigin, "SpellfireLevelStored");
        int nCON = GetAbilityScore(oSpellOrigin, ABILITY_CONSTITUTION);
        int nFlare = 0;
        int bFlare = FALSE;
        if(nStored > 4 * nCON)
        {
            nFlare = d6(2);
            bFlare = TRUE;
        }
        else if(nStored > 3 * nCON)
        {
            nFlare = d6();
            bFlare = TRUE;
        }
        else if(nStored > 2 * nCON)
            nFlare = d4();
        else if(nStored > nCON)
            nFlare = 1;
        if(nFlare)
        {
            nStored -= nFlare;
            if(nStored < 0) nStored = 0;
            SetPersistantLocalInt(oSpellOrigin, "SpellfireLevelStored", nStored);
        }
        if(bFlare)
        {
            int nDC = 10 + nFlare;
            location lTarget = GetLocation(oSpellOrigin);
            object oFlareTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oFlareTarget))
            {
                if(spellsIsTarget(oFlareTarget, SPELL_TARGET_STANDARDHOSTILE, oSpellOrigin))
                {
                    if(!PRCDoResistSpell(oSpellOrigin, oFlareTarget, nSpellfire))
                    {
                        if (PRCMySavingThrow(SAVING_THROW_FORT, oFlareTarget, nDC))
                        {
                if (GetHasMettle(oFlareTarget, SAVING_THROW_FORT))
                // This script does nothing if it has Mettle, bail
                    return;
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oFlareTarget);
                            //EffectDazzled from race_hb
                            effect eAttack = EffectAttackDecrease(1);
                            effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 1);
                            effect eSpot   = EffectSkillDecrease(SKILL_SPOT,   1);
                            effect eLink   = EffectLinkEffects(eAttack, eSearch);
                            eLink          = EffectLinkEffects(eLink,   eSpot);
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFlareTarget, 60.0);
                        }
                    }
                }
                oFlareTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }
        }
        if(GetLocalInt(oSpellOrigin, "SpellfireCrown"))  //melts non-magical melee weapons
        {   //can't really get which weapon hit you, so...
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
            if(GetIsObjectValid(oWeapon))
            {
                if(IPGetIsMeleeWeapon(oWeapon) && !GetIsMagicItem(oWeapon))
                {
                    DestroyObject(oWeapon);
                    FloatingTextStringOnCreature("*Your weapon has melted!*", oSpellTarget);
                }
            }
            else
            {
                oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
                if(GetIsObjectValid(oWeapon))
                {
                    if(IPGetIsMeleeWeapon(oWeapon) && !GetIsMagicItem(oWeapon))
                    {
                        DestroyObject(oWeapon);
                        FloatingTextStringOnCreature("*Your weapon has melted!*", oSpellTarget);
                    }
                }
                else    //You're putting your arms and legs through something that melts weapons?
                {       //Silly monk/brawler/fool with molten weapons!
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20()), oSpellTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(), DAMAGE_TYPE_FIRE), oSpellTarget);
                }
            }
        }
    }

    /*//////////////////////////////////////////////////
    ////////////////// END SPELLFIRE ///////////////////
    //////////////////////////////////////////////////*/

    // Handle poisoned weapons
    /*
    if(GetLocalInt(oItem, "pois_wpn_uses"))
    {
        ExecuteScript("poison_wpn_onhit", OBJECT_SELF);
    }
    */
    // Execute scripts hooked to this event for the player triggering it
    if (DEBUG) DoDebug("prc_onhitcast: executing all scripts hooked to onhit events of attacker and item");
    ExecuteAllScriptsHookedToEvent(oSpellOrigin, EVENT_ONHIT);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONHIT);

    DeleteLocalInt(oSpellOrigin, "prc_ohc");

}

void SetRancorVar(object oPC)
{
    // Turn Rancor on
    SetLocalInt(oPC, "PRC_CanUseRancor", 1);
    //FloatingTextStringOnCreature("Rancor Attack Possible", oPC, FALSE);

    int iMain = GetMainHandAttacks(oPC);
    float fDelay = 6.0 / IntToFloat(iMain);

    // Turn Rancor off after one attack is made
    DelayCommand(fDelay, SetLocalInt(oPC, "PRC_CanUseRancor", 2));
    //DelayCommand((fDelay + 0.01), FloatingTextStringOnCreature("Rancor Attack Not Possible", oPC, FALSE));

    // Call again if the character is still in combat.
    // this allows the ability to keep running even if the
    // player does not score a rancor hit during the allotted time
    if( PRCGetIsFighting(oPC) )
    {
        DelayCommand(6.0, SetRancorVar(oPC) );
    }
    else
    {
        DelayCommand(2.0, SetLocalInt(oPC, "PRC_CanUseRancor", 1));
        DelayCommand(2.1, SetLocalInt(oPC, "PRC_RancorVarRunning", 2));
        //DelayCommand(2.2, FloatingTextStringOnCreature("Rancor Enabled After Combat", oPC, FALSE));
    }
}

void DoImprovedRicochet(object oPC, object oTarget)
{
    int nTargetsLeft = 1;
    effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);

    location lTarget = GetLocation(oTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    //Cycle through the targets within the spell shape until you run out of targets.
    while (GetIsObjectValid(oAreaTarget) && nTargetsLeft > 0)
    {
        if (spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oAreaTarget != OBJECT_SELF && oAreaTarget != oTarget)
        {
            PerformAttack(oAreaTarget, oPC, eVis, 0.0, -2, 0, 0, "*Improved Ricochet Hit*", "*Improved Ricochet Missed*");
             // Use up a target slot only if we actually did something to it
            nTargetsLeft -= 1;
        }

    //Select the next target within the spell shape.
    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void SetImprovedRicochetVar(object oPC)
{
    // Turn Retort on
    SetLocalInt(oPC, "CanRicochet", 1);

    // Turn Retort off after one attack is made
    DelayCommand(0.01, SetLocalInt(oPC, "CanRicochet", 0));

    // Call again if the character is still in combat.
    // this allows the ability to keep running even if the
    // player does not score a retort hit during the allotted time
    if( PRCGetIsFighting(oPC) )
    {
        DelayCommand(6.0, SetImprovedRicochetVar(oPC));
    }
    else
    {
        DelayCommand(2.0, SetLocalInt(oPC, "CanRicochet", 1));
        DelayCommand(2.1, SetLocalInt(oPC, "ImpRicochetVarRunning", 2));
    }
}
