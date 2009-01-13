//::///////////////////////////////////////////////
//:: [PRC Feat Router]
//:: [inc_prc_function.nss]
//:://////////////////////////////////////////////
//:: This file serves as a hub for the various
//:: PRC passive feat functions.  If you need to
//:: add passive feats for a new PRC, link them here.
//::
//:: This file also contains a few multi-purpose
//:: PRC functions that need to be included in several
//:: places, ON DIFFERENT PRCS. Make local include files
//:: for any functions you use ONLY on ONE PRC.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////

//--------------------------------------------------------------------------
// This is the "event" that is called to re-evalutate PRC bonuses.  Currently
// it is fired by OnEquip, OnUnequip and OnLevel.  If you want to move any
// classes into this event, just copy the format below.  Basically, this function
// is meant to keep the code looking nice and clean by routing each class's
// feats to their own self-contained script
//--------------------------------------------------------------------------
void EvalPRCFeats(object oPC);

int BlastInfidelOrFaithHeal(object oCaster, object oTarget, int iEnergyType, int iDisplayFeedback);

void ScrubPCSkin(object oPC, object oSkin);

void DeletePRCLocalInts(object oSkin);

#include "prc_alterations"
// Generic includes
//#include "prcsp_engine"
//#include "inc_utility"
//#include "x2_inc_switches"
//#include "prc_feat_const"
//#include "prc_class_const"
//#include "prc_spell_const"
//#include "prc_racial_const"
//#include "prc_ipfeat_const"
//#include "prc_misc_const"
#include "prc_inc_stunfist"

// PRC Spell Engine Utility Functions
//#include "lookup_2da_spell"
//#include "prc_inc_spells"
//#include "prcsp_reputation"
//#include "prcsp_archmaginc"
//
//#include "prc_inc_clsfunc"
//#include "prc_inc_racial"
//#include "inc_abil_damage"
// 
//#include "prc_x2_itemprop"
//#include "pnp_shft_poly"
//
//#include "prc_inc_natweap"
//#include "true_inc_trufunc"


int nbWeaponFocus(object oPC);

void EvalPRCFeats(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //Elemental savant is sort of four classes in one, so we'll take care
    //of them all at once.
    int iElemSavant =  GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_COLD, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ACID, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESF, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESC, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESE, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESA, oPC);

    int iThrallOfGrazzt =  GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oPC);
        iThrallOfGrazzt += GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, oPC);

    // special add atk bonus equal to Enhancement
    ExecuteScript("ft_sanctmartial", oPC);

    //hook in the weapon size restrictions script
    ExecuteScript("prc_restwpnsize", oPC);

    //Route the event to the appropriate class specific scripts
    if(GetLevelByClass(CLASS_TYPE_DUELIST, oPC) > 0)             ExecuteScript("prc_duelist", oPC);
    if(GetLevelByClass(CLASS_TYPE_ACOLYTE, oPC) > 0)             ExecuteScript("prc_acolyte", oPC);
    if(GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) > 0)          ExecuteScript("prc_spellswd", oPC);
    if(GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) > 0)          ExecuteScript("prc_magekill", oPC);
    if(GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC) > 0)          ExecuteScript("prc_oozemstr", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_MEPH, oPC) > 0)    ExecuteScript("prc_discmeph", oPC);
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)                ExecuteScript("pnp_lich_level", oPC);
    if(iElemSavant > 0)                                          ExecuteScript("prc_elemsavant", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEARTWARDER,oPC) > 0)          ExecuteScript("prc_heartwarder", oPC);
    if(GetLevelByClass(CLASS_TYPE_STORMLORD,oPC) > 0)            ExecuteScript("prc_stormlord", oPC);
    if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER ,oPC) > 0)         ExecuteScript("prc_shifter", oPC);
    if(GetLevelByClass(CLASS_TYPE_FRE_BERSERKER, oPC) > 0)       ExecuteScript("prc_frebzk", oPC);
    if(GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oPC) > 0)  ExecuteScript("prc_eog", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPEST, oPC) > 0)             ExecuteScript("prc_tempest", oPC);
    if(GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC) > 0)          ExecuteScript("prc_foe_hntr", oPC);
    if(GetLevelByClass(CLASS_TYPE_VASSAL, oPC) > 0)              ExecuteScript("prc_vassal", oPC);
    if(GetLevelByClass(CLASS_TYPE_PEERLESS, oPC) > 0)            ExecuteScript("prc_peerless", oPC);
    if(GetLevelByClass(CLASS_TYPE_LEGENDARY_DREADNOUGHT,oPC)>0)  ExecuteScript("prc_legendread", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL,oPC) > 0)       ExecuteScript("prc_baalzebul", oPC);
    if(GetLevelByClass(CLASS_TYPE_IAIJUTSU_MASTER,oPC) >0)       ExecuteScript("prc_iaijutsu_mst", oPC);
    if(GetLevelByClass(CLASS_TYPE_FISTRAZIEL,oPC) > 0)           ExecuteScript("prc_fistraziel", oPC);
    if(GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC) > 0)           ExecuteScript("prc_sacredfist", oPC);
    if(GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST,oPC) > 0)      ExecuteScript("prc_enlfis", oPC);
    if(GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,oPC) > 0)    ExecuteScript("prc_initdraconic", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC) > 0)          ExecuteScript("prc_bladesinger", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEXTOR,oPC) > 0)               ExecuteScript("prc_hextor", oPC);
    if(GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0)               ExecuteScript("prc_bowman", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPUS,oPC) > 0)               ExecuteScript("prc_battletempus", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISPATER,oPC) > 0)             ExecuteScript("prc_dispater", oPC);
    if(GetLevelByClass(CLASS_TYPE_MANATARMS,oPC) > 0)            ExecuteScript("prc_manatarms", oPC);
    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,oPC) > 0)     ExecuteScript("prc_soldoflight", oPC);
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC,oPC) > 0)       ExecuteScript("prc_henshin", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER,oPC) > 0)       ExecuteScript("prc_drunk", oPC);
    if(GetLevelByClass(CLASS_TYPE_MASTER_HARPER,oPC) > 0)        ExecuteScript("prc_masterh", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHOU,oPC) > 0)                 ExecuteScript("prc_shou", oPC);
    if(GetLevelByClass(CLASS_TYPE_BFZ,oPC) > 0)                  ExecuteScript("prc_bfz", oPC);
    if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER,oPC) > 0)     ExecuteScript("prc_bondedsumm", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oPC) > 0)         ExecuteScript("prc_shadowadept", oPC);
    if(GetLevelByClass(CLASS_TYPE_BRAWLER,oPC) > 0)              ExecuteScript("prc_brawler", oPC);
    if(GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE,oPC) > 0)        ExecuteScript("prc_minstrel", oPC);
    if(GetLevelByClass(CLASS_TYPE_NIGHTSHADE,oPC) > 0)           ExecuteScript("prc_nightshade", oPC);
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED,oPC) > 0)          ExecuteScript("prc_runescarred", oPC);
    if(GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0)      ExecuteScript("prc_uranger", oPC);
    if(GetLevelByClass(CLASS_TYPE_WEREWOLF,oPC) > 0)             ExecuteScript("prc_werewolf", oPC);
    if(GetLevelByClass(CLASS_TYPE_JUDICATOR, oPC) > 0)           ExecuteScript("prc_judicator", oPC);
    if(GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) > 0)      ExecuteScript("prc_arcduel", oPC);
    if(GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oPC) > 0)       ExecuteScript("prc_thayknight", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPLE_RAIDER, oPC) > 0)       ExecuteScript("prc_templeraider", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLARCHER, oPC) > 0)            ExecuteScript("prc_bld_arch", oPC);
    if(GetLevelByClass(CLASS_TYPE_OUTLAW_CRIMSON_ROAD, oPC) > 0) ExecuteScript("prc_outlawroad", oPC);
    if(GetLevelByClass(CLASS_TYPE_ALAGHAR, oPC) > 0)             ExecuteScript("prc_alaghar", oPC);
    if(GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE,oPC) > 0)       DelayCommand(0.1,ExecuteScript("prc_knghtch", oPC));
    if(iThrallOfGrazzt > 0)                                      ExecuteScript("tog", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD,oPC) > 0)           ExecuteScript("prc_blightlord", oPC);
    if(GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN,oPC) > 0)       ExecuteScript("psi_zuoken", oPC);
    if(GetLevelByClass(CLASS_TYPE_NINJA, oPC) > 0)               ExecuteScript("prc_ninjca", oPC);
    if(GetLevelByClass(CLASS_TYPE_OLLAM,oPC) > 0)                ExecuteScript("prc_ollam", oPC);
    if(GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC) > 0)        ExecuteScript("prc_cbtmed", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC) > 0)      DelayCommand(0.1,ExecuteScript("prc_dradis", oPC));
    if(GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oPC) > 0) ExecuteScript("prc_warsling", oPC);
    if(GetLevelByClass(CLASS_TYPE_BAELNORN,oPC) > 0)             ExecuteScript("prc_baelnorn", oPC);
    if(GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0)         DelayCommand(0.1,ExecuteScript("prc_swashbuckler", oPC));
    if(GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE,oPC) > 0)        ExecuteScript("prc_contemplate", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS,oPC) > 0)          ExecuteScript("prc_bloodmagus", oPC);
    if(GetLevelByClass(CLASS_TYPE_LASHER,oPC) > 0)               ExecuteScript("prc_lasher", oPC);
    if(GetLevelByClass(CLASS_TYPE_WARCHIEF,oPC) > 0)             ExecuteScript("prc_warchief", oPC);
    if(GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER,oPC) > 0)   ExecuteScript("prc_gfkill", oPC);
    if(GetLevelByClass(CLASS_TYPE_WARMIND,oPC) > 0)              ExecuteScript("psi_warmind", oPC);
    if(GetLevelByClass(CLASS_TYPE_IRONMIND,oPC) > 0)             ExecuteScript("psi_ironmind", oPC);
    if(GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND,oPC) > 0)      ExecuteScript("psi_sancmind", oPC);
    if(GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE,oPC) > 0)   ExecuteScript("prc_ootbi", oPC);
    if(GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL,oPC) > 0)     ExecuteScript("prc_slayerdomiel", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS,oPC) > 0) ExecuteScript("prc_discasmodeus", oPC);
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) > 0)           ExecuteScript("psi_thrallherd", oPC);
    if(GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) > 0)           ExecuteScript("psi_sk_clseval", oPC);
    if(GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD,oPC) > 0) ExecuteScript("prc_contendkord", oPC);
    if(GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH,oPC) > 0)     ExecuteScript("prc_suelarchana", oPC);
    if(GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,oPC) > 0)        ExecuteScript("prc_favouredsoul", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHADOWBLADE, oPC) > 1)         ExecuteScript("prc_sb_shdstlth", oPC);
    if(GetLevelByClass(CLASS_TYPE_CW_SAMURAI, oPC) > 0)          ExecuteScript("prc_cwsamurai", oPC);
    if(GetLevelByClass(CLASS_TYPE_SKULLCLAN_HUNTER, oPC) > 0)    ExecuteScript("prc_skullclan", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC) > 0)            ExecuteScript("prc_hexblade", oPC);
    if(GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC) > 0)           ExecuteScript("true_truenamer", oPC);
    if(GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC) > 0)           ExecuteScript("prc_duskblade", oPC);
    if(GetLevelByClass(CLASS_TYPE_SCOUT, oPC) > 0)               ExecuteScript("prc_scout", oPC);
    if(GetLevelByClass(CLASS_TYPE_WARMAGE, oPC) > 0)             ExecuteScript("prc_warmage", oPC);
    if(GetLevelByClass(CLASS_TYPE_KNIGHT, oPC) > 0)              ExecuteScript("prc_knight", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHADOWMIND, oPC) > 0)          ExecuteScript("psi_shadowmind", oPC);
    if(GetLevelByClass(CLASS_TYPE_COC, oPC) > 0)                 ExecuteScript("prc_coc", oPC);
    if(GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON, oPC) > 0)      ExecuteScript("psi_diadra", oPC);
    if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 0)          ExecuteScript("prc_swiftwing", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRAGON_DEVOTEE, oPC) > 0)      ExecuteScript("prc_dragdev", oPC);
    if(GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC) > 0)     ExecuteScript("prc_talontiamat", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC) > 0)       ExecuteScript("prc_dragonshaman", oPC);
    if(GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC) > 0)      ExecuteScript("psi_pyro", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC) > 0)    ExecuteScript("inv_drgnfireadpt", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHAMAN, oPC) > 0)              ExecuteScript("prc_shaman", oPC);
    if(GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 0)           ExecuteScript("tob_swordsage", oPC);
    if(GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL, oPC) > 0)  ExecuteScript("tob_deepstone", oPC);
    if(GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) > 0)            ExecuteScript("tob_crusader", oPC);
    if(GetLevelByClass(CLASS_TYPE_WARBLADE, oPC) > 0)            ExecuteScript("tob_warblade", oPC);
    if(GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oPC) > 0)   ExecuteScript("tob_jadepm", oPC);
    if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0)             ExecuteScript("inv_warlock", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oPC) > 0)    ExecuteScript("tob_bloodclaw", oPC);

    // Bonus Domain check
    // If there is a bonus domain, it will always be in the first slot, so just check that.
    // It also runs things that clerics with those domains need
    if (GetPersistantLocalInt(oPC, "PRCBonusDomain1") > 0 ||
        GetLevelByClass(CLASS_TYPE_CLERIC, oPC))                  ExecuteScript("prc_domain_skin", oPC);

    // Templates
    //these go here so feats can be reused
    ExecuteScript("prc_templates", oPC);

    // Feats
    //these are here so if templates add them the if check runs after the template was applied
    ExecuteScript("prc_feats", oPC);

    if(GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 2
        && !GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW, oPC)
        && GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS))
    {
        //add the old feat to the hide
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FEAT_PRESTIGE_IMBUE_ARROW), 0.0f,
                              X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }

    // Add the teleport management feats.
    // 2005.11.03: Now added to all base classes on 1st level - Ornedan
//    ExecuteScript("prc_tp_mgmt_eval", oPC);

    //PnP Spell Schools
    if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD, oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_GENERAL,       oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_ABJURATION,    oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_CONJURATION,   oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_DIVINATION,    oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_ENCHANTMENT,   oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_EVOCATION,     oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_ILLUSION,      oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_NECROMANCY,    oPC)
        && !GetHasFeat(FEAT_PNP_SPELL_SCHOOL_TRANSMUTATION, oPC)
        && !GetIsPolyMorphedOrShifted(oPC)
        //&& !PRCGetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) //so it doesnt pop up on polymorphing
        //&& !GetLocalInt(oSkin, "nPCShifted") //so it doenst pop up on shifting
        )
    {
        ExecuteScript("prc_pnp_shcc_s", oPC);
    }

    // Switch convo feat
    //Now everyone gets it at level 1, but just to be on the safe side
    if(!GetHasFeat(2285, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(229), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    // Size changes
    int nLastSize = GetLocalInt(oPC, "PRCLastSize") + CREATURE_SIZE_FINE - 1;
    int nPRCSize = PRCGetCreatureSize(oPC);
    if(nPRCSize != nLastSize)
        ExecuteScript("prc_size", oPC);

    // Speed changes
    ExecuteScript("prc_speed", oPC);

    // ACP system
    if((GetIsPC(oPC) &&
        (GetPRCSwitch(PRC_ACP_MANUAL)   ||
         GetPRCSwitch(PRC_ACP_AUTOMATIC)
         )
        ) ||
       (!GetIsPC(oPC) &&
        GetPRCSwitch(PRC_ACP_NPC_AUTOMATIC)
        )
       )
        ExecuteScript("acp_auto", oPC);

// this is handled inside the PRC Options conversation now.
/*    // Epic spells
    if((GetCasterLvl(CLASS_TYPE_CLERIC,   oPC) >= 21 ||
        GetCasterLvl(CLASS_TYPE_DRUID,    oPC) >= 21 ||
        GetCasterLvl(CLASS_TYPE_SORCERER, oPC) >= 21 ||
        GetCasterLvl(CLASS_TYPE_FAVOURED_SOUL, oPC) >= 21 ||
        GetCasterLvl(CLASS_TYPE_HEALER, oPC) >= 21 ||
        GetCasterLvl(CLASS_TYPE_WIZARD,   oPC) >= 21
        ) &&
        !GetHasFeat(FEAT_EPIC_SPELLCASTING_REST, oPC)
       )
    {
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_REST), 0.0f,
                              X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }*/

    // Miscellaneous
    ExecuteScript("prc_sneak_att", oPC);
    ExecuteScript("race_skin", oPC);
    ExecuteScript("prc_mithral", oPC);
    if(GetPRCSwitch(PRC_ENFORCE_RACIAL_APPEARANCE))
        ExecuteScript("race_appear", oPC);


    //handle PnP sling switch
    if(GetPRCSwitch(PRC_PNP_SLINGS))
    {
        if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_SLING)
            IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC),
                ItemPropertyMaxRangeStrengthMod(20),
                999999.9);
    }

    // Handle alternate caster types gaining new stuff
    if(// Psionics
       GetLevelByClass(CLASS_TYPE_PSION,            oPC) ||
       GetLevelByClass(CLASS_TYPE_WILDER,           oPC) ||
       GetLevelByClass(CLASS_TYPE_PSYWAR,           oPC) ||
       GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN,   oPC) ||
       GetLevelByClass(CLASS_TYPE_WARMIND,          oPC) ||
       // New spellbooks
       GetLevelByClass(CLASS_TYPE_BARD,             oPC) ||
       GetLevelByClass(CLASS_TYPE_SORCERER,         oPC) ||
       GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oPC) ||
       GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,    oPC) ||
       GetLevelByClass(CLASS_TYPE_HEXBLADE,         oPC) ||
       GetLevelByClass(CLASS_TYPE_DUSKBLADE,        oPC) ||
       GetLevelByClass(CLASS_TYPE_WARMAGE,          oPC) ||
       GetLevelByClass(CLASS_TYPE_JUSTICEWW,        oPC) ||
       // Truenaming
       GetLevelByClass(CLASS_TYPE_TRUENAMER,        oPC) ||
       // Tome of Battle
       GetLevelByClass(CLASS_TYPE_CRUSADER,         oPC) ||
       GetLevelByClass(CLASS_TYPE_SWORDSAGE,        oPC) ||
       GetLevelByClass(CLASS_TYPE_WARBLADE,         oPC) ||
       // Invocations
       GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC) ||
       GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) ||
       // Racial casters
       (GetLevelByClass(CLASS_TYPE_OUTSIDER, oPC) && GetRacialType(oPC) == RACIAL_TYPE_RAKSHASA) 
        )
        DelayCommand(1.0, ExecuteScript("prc_amagsys_gain", oPC));

    // Gathers all the calls to UnarmedFists & Feats to one place.
    // Must be after all evaluationscripts that need said functions.
    if(GetLocalInt(oPC, "CALL_UNARMED_FEATS") || GetLocalInt(oPC, "CALL_UNARMED_FISTS")) // ExecuteScript() is pretty expensive, do not run it needlessly - 20060702, Ornedan
        ExecuteScript("unarmed_caller", oPC);

    // Gathers all the calls to SetBaseAttackBonus() to one place
    // Must be after all evaluationscripts that need said function.
    ExecuteScript("prc_bab_caller", oPC);
}

void DeletePRCLocalInts(object oSkin)
{
    // This will get rid of any SetCompositeAttackBonus LocalInts:
    object oPC = GetItemPossessor(oSkin);
    DeleteLocalInt(oPC, "CompositeAttackBonusR");
    DeleteLocalInt(oPC, "CompositeAttackBonusL");

    DeleteNamedComposites(oPC, "PRC_ComAttBon");

    // PRCGetClassByPosition and PRCGetLevelByPosition cleanup
    // not needed now that GetClassByPosition() works for custom classes
    // DeleteLocalInt(oPC, "PRC_ClassInPos1");
    // DeleteLocalInt(oPC, "PRC_ClassInPos2");
    // DeleteLocalInt(oPC, "PRC_ClassInPos3");
    // DeleteLocalInt(oPC, "PRC_ClassLevelInPos1");
    // DeleteLocalInt(oPC, "PRC_ClassLevelInPos2");
    // DeleteLocalInt(oPC, "PRC_ClassLevelInPos3");

    //persistant local token object cache
    //looks like logging off then back on without the server rebooting breaks it
    //I guess because the token gets a new ID, but the local still points to the old one
    DeleteLocalObject(oPC, "PRC_HideTokenCache");

    // In order to work with the PRC system we need to delete some locals for each
    // PRC that has a hide

    DeleteNamedComposites(oSkin, "PRC_CBon");

    if (DEBUG) DoDebug("Clearing class flags");

    // Elemental Savants
    DeleteLocalInt(oSkin,"ElemSavantResist");
    DeleteLocalInt(oSkin,"ElemSavantPerfection");
    DeleteLocalInt(oSkin,"ElemSavantImmMind");
    DeleteLocalInt(oSkin,"ElemSavantImmParal");
    DeleteLocalInt(oSkin,"ElemSavantImmSleep");
    // HeartWarder
    DeleteLocalInt(oSkin,"FeyType");
    // OozeMaster
    DeleteLocalInt(oSkin,"IndiscernibleCrit");
    DeleteLocalInt(oSkin,"IndiscernibleBS");
    DeleteLocalInt(oSkin,"OneOozeMind");
    DeleteLocalInt(oSkin,"OneOozePoison");
    // Storm lord
    DeleteLocalInt(oSkin,"StormLResElec");
    // Spell sword
    DeleteLocalInt(oSkin,"SpellswordSFBonusNormal");
    DeleteLocalInt(oSkin,"SpellswordSFBonusEpic");
    // Acolyte of the skin
    DeleteLocalInt(oSkin,"AcolyteSymbBonus");
    DeleteLocalInt(oSkin,"AcolyteResistanceCold");
    DeleteLocalInt(oSkin,"AcolyteResistanceFire");
    DeleteLocalInt(oSkin,"AcolyteResistanceAcid");
    DeleteLocalInt(oSkin,"AcolyteResistanceElectric");
    // Battleguard of Tempus
    DeleteLocalInt(oSkin,"FEAT_WEAP_TEMPUS");
    // Bonded Summoner
    DeleteLocalInt(oSkin,"BondResEle");
    DeleteLocalInt(oSkin,"BondSubType");
    // Disciple of Meph
    DeleteLocalInt(oSkin,"DiscMephResist");
    DeleteLocalInt(oSkin,"DiscMephGlove");
    // Initiate of Draconic Mysteries
    DeleteLocalInt(oSkin,"IniSR");
    DeleteLocalInt(oSkin,"IniStunStrk");
    // Man at Arms
    DeleteLocalInt(oSkin,"ManArmsCore");
    // Telflammar Shadowlord
    DeleteLocalInt(oSkin,"ShaDiscorp");
    // Vile Feats
    DeleteLocalInt(oSkin,"DeformGaunt");
    DeleteLocalInt(oSkin,"DeformObese");
    // Sneak Attack
    DeleteLocalInt(oSkin,"RogueSneakDice");
    DeleteLocalInt(oSkin,"BlackguardSneakDice");
    // Sacred Fist
    DeleteLocalInt(oSkin,"SacFisMv");
    // Minstrel
    DeleteLocalInt(oSkin,"MinstrelSFBonus"); /// @todo Make ASF reduction compositable
    // Nightshade
    DeleteLocalInt(oSkin,"ImmuNSWeb");
    DeleteLocalInt(oSkin,"ImmuNSPoison");
    // Soldier of Light
    DeleteLocalInt(oSkin,"ImmuPF");
    // Ultimate Ranger
    DeleteLocalInt(oSkin,"URImmu");
    // Thayan Knight
    DeleteLocalInt(oSkin,"ThayHorror");
    DeleteLocalInt(oSkin,"ThayZulkFave");
    DeleteLocalInt(oSkin,"ThayZulkChamp");
    // Black Flame Zealot
    DeleteLocalInt(oSkin,"BFZHeart");
    // Henshin Mystic
    DeleteLocalInt(oSkin,"Happo");
    DeleteLocalInt(oSkin,"HMSight");
    DeleteLocalInt(oSkin,"HMInvul");
    //Blightlord
    DeleteLocalInt(oSkin, "WntrHeart");
    DeleteLocalInt(oSkin, "BlightBlood");
    // Contemplative
    DeleteLocalInt(oSkin, "ContempDisease");
    DeleteLocalInt(oSkin, "ContempPoison");
    DeleteLocalInt(oSkin, "ContemplativeDR");
    DeleteLocalInt(oSkin, "ContemplativeSR");

    // Blood Magus
    DeleteLocalInt(oSkin, "ThickerThanWater");

    // Feats
    DeleteLocalInt(oPC, "ForceOfPersonalityWis");
    DeleteLocalInt(oPC, "ForceOfPersonalityCha");
    DeleteLocalInt(oPC, "InsightfulReflexesInt");
    DeleteLocalInt(oPC, "InsightfulReflexesDex");
    DeleteLocalInt(oSkin, "TactileTrapsmithSearchIncrease");
    DeleteLocalInt(oSkin, "TactileTrapsmithDisableIncrease");
    DeleteLocalInt(oSkin, "TactileTrapsmithSearchDecrease");
    DeleteLocalInt(oSkin, "TactileTrapsmithDisableDecrease");

    // Warmind
    DeleteLocalInt(oSkin, "EnduringBody");

    // Ironmind
    DeleteLocalInt(oSkin, "IronMind_DR");

    // Suel Archanamach
    DeleteLocalInt(oSkin, "SuelArchanamachSpellFailure");

    // Favoured Soul
    DeleteLocalInt(oSkin, "FavouredSoulResistElementAcid");
    DeleteLocalInt(oSkin, "FavouredSoulResistElementCold");
    DeleteLocalInt(oSkin, "FavouredSoulResistElementElec");
    DeleteLocalInt(oSkin, "FavouredSoulResistElementFire");
    DeleteLocalInt(oSkin, "FavouredSoulResistElementSonic");

    // Domains
    DeleteLocalInt(oSkin, "StormDomainPower");

    // Skullclan Hunter
    DeleteLocalInt(oSkin, "SkullClanFear");
    DeleteLocalInt(oSkin, "SkullClanDisease");
    DeleteLocalInt(oSkin, "SkullClanProtectionEvil");
    DeleteLocalInt(oSkin, "SkullClanSwordLight");
    DeleteLocalInt(oSkin, "SkullClanParalysis");
    DeleteLocalInt(oSkin, "SkullClanAbilityDrain");
    DeleteLocalInt(oSkin, "SkullClanLevelDrain");

    // Hexblade
    DeleteLocalInt(oSkin, "HexbladeArmourCasting");

    // Sohei
    DeleteLocalInt(oSkin, "SoheiDamageResist");

    // Duskblade
    DeleteLocalInt(oSkin, "DuskbladeArmourCasting");


    DeleteLocalInt(oPC, "ScoutFreeMove");
    DeleteLocalInt(oPC, "ScoutFastMove");
    DeleteLocalInt(oPC, "ScoutBlindsight");
    
    // Enlightened Fist
    DeleteLocalInt(oPC, "EnlightenedFistSR");
    
    //Truenamer
    int UtterID;
    for(UtterID = 3526; UtterID <= 3639; UtterID++) // All utterances
        DeleteLocalInt(oPC, "PRC_LawOfResistance" + IntToString(UtterID));
    for(UtterID = 3418; UtterID <= 3431; UtterID++) // Syllable of Detachment to Word of Heaven, Greater
        DeleteLocalInt(oPC, "PRC_LawOfResistance" + IntToString(UtterID));

    //clear Dragonfriend/Dragonthrall flag so effect properly reapplies
    DeleteLocalInt(oSkin, "DragonThrall");

    //Invocations
    DeleteLocalInt(oPC, "ChillingFogLock");
    //Endure Exposure wearing off
    array_delete(oPC, "BreathProtected");
    DeleteLocalInt(oPC, "DragonWard");


    // future PRCs Go below here
}

void ScrubPCSkin(object oPC, object oSkin)
{
    int iCode = GetHasFeat(FEAT_SF_CODE,oPC);
    int st;
    itemproperty ip = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ip)) {
        // Insert Logic here to determine if we spare a property
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {
            // Check for specific Bonus Feats
            // Reference iprp_feats.2da
            st = GetItemPropertySubType(ip);

            // Spare 400 through 570 and 398 -- epic spells & spell effects
            //also spare the new spellbook feats (1000-12000)
            //also spare the psionic, trunaming, tob, invocation feats (12000-16000)
            // spare template, tob stuff (16300-17700)
            //also spare Pnp spellschool feats (231-249)
            // changed by fluffyamoeba so that iprp weapon specialization, dev crit, epic weapon focus, epic weapon spec
            // overwhelming crit and weapon of choice are no longer skipped.
            if ((st < 400 || st > 570)
                && st != 398
                && (st < 1000 || st > 15999)
                && (st < 16300 || st > 17700)
                && (st < 231 || st > 249)
                && ((st == FEAT_POWER_ATTACK_QUICKS_RADIAL) ? // Remove the PRC Power Attack radial if the character no longer has Power Attack
                     !GetHasFeat(FEAT_POWER_ATTACK, oPC) :
                     TRUE // If the feat is not relevant to this clause, always pass
                    )
                )
                RemoveItemProperty(oSkin, ip);
        }
        else
            RemoveItemProperty(oSkin, ip);

        // Get the next property
        ip = GetNextItemProperty(oSkin);
    }
    if (iCode)
      AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(381),oSkin);

    // Schedule restoring the unhealable ability damage
    DelayCommand(0.0f, ReApplyUnhealableAbilityDamage(oPC));

    // Remove all natural weapons too
    // ClearNaturalWeapons(oPC);
    // Done this way to remove prc_inc_natweap and prc_inc_combat from the include
    // Should help with compile speeds and the like
    array_delete(oPC, "ARRAY_NAT_SEC_WEAP_RESREF");
    array_delete(oPC, "ARRAY_NAT_PRI_WEAP_RESREF");
    array_delete(oPC, "ARRAY_NAT_PRI_WEAP_ATTACKS");
}

int BlastInfidelOrFaithHeal(object oCaster, object oTarget, int iEnergyType, int iDisplayFeedback)
{
    //Don't bother doing anything if iEnergyType isn't either positive/negative energy
    if(iEnergyType != DAMAGE_TYPE_POSITIVE && iEnergyType != DAMAGE_TYPE_NEGATIVE)
        return FALSE;

    //If the target is undead and damage type is negative
    //or if the target is living and damage type is positive
    //then we're healing.  Otherwise, we're harming.
    int iHeal = ( iEnergyType == DAMAGE_TYPE_NEGATIVE && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) ||
                ( iEnergyType == DAMAGE_TYPE_POSITIVE && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD );
    int iRetVal = FALSE;
    int iAlignDif = CompareAlignment(oCaster, oTarget);
    string sFeedback = "";

    if(iHeal){
        if((GetHasFeat(FEAT_FAITH_HEALING, oCaster) && iAlignDif < 2)){
            iRetVal = TRUE;
            sFeedback = "Faith Healing";
        }
    }
    else{
        if((GetHasFeat(FEAT_BLAST_INFIDEL, oCaster) && iAlignDif >= 2)){
            iRetVal = TRUE;
            sFeedback = "Blast Infidel";
        }
    }

    if(iDisplayFeedback) FloatingTextStringOnCreature(sFeedback, oCaster);
    return iRetVal;
}

int GetShiftingFeats(object oPC)
{
    int nNumFeats;
    nNumFeats +=   GetHasFeat(FEAT_DREAMSIGHT_ELITE, oPC) +
            GetHasFeat(FEAT_GOREBRUTE_ELITE, oPC) +
            GetHasFeat(FEAT_LONGSTRIDE_ELITE, oPC) +
            GetHasFeat(FEAT_LONGTOOTH_ELITE, oPC) +
            GetHasFeat(FEAT_RAZORCLAW_ELITE, oPC) +
            GetHasFeat(FEAT_WILDHUNT_ELITE, oPC) +
            GetHasFeat(FEAT_EXTRA_SHIFTER_TRAIT, oPC) +
            GetHasFeat(FEAT_HEALING_FACTOR, oPC) +
            GetHasFeat(FEAT_SHIFTER_AGILITY, oPC) +
            GetHasFeat(FEAT_SHIFTER_DEFENSE, oPC) +
            GetHasFeat(FEAT_GREATER_SHIFTER_DEFENSE, oPC) +
            GetHasFeat(FEAT_SHIFTER_FEROCITY, oPC) +
            GetHasFeat(FEAT_SHIFTER_INSTINCTS, oPC) +
            GetHasFeat(FEAT_SHIFTER_SAVAGERY, oPC);
            
     return nNumFeats;
}

void FeatUsePerDay(object oPC,int iFeat, int iAbiMod = ABILITY_CHARISMA, int iMod = 0)
{

    if (!GetHasFeat(iFeat,oPC)) return;

    int iAbi= GetAbilityModifier(iAbiMod,oPC)>0 ? GetAbilityModifier(iAbiMod,oPC):0 ;
        if ( iAbiMod == -1) iAbi =0;
        iAbi+=iMod;
        iAbi = (iAbi >85) ? 85 :iAbi;



    int iLeftUse = 0;
    while (GetHasFeat(iFeat,oPC))
    {
      DecrementRemainingFeatUses(oPC,iFeat);
      iLeftUse++;
    }

    if (!iAbi) return;

    iLeftUse = (iLeftUse>88) ? iAbi : iLeftUse;

    while (iLeftUse)
    {
      IncrementRemainingFeatUses(oPC,iFeat);
      iLeftUse--;
    }

}

void SpellShadow(object oPC)
{

   int Sha = GetLevelByClass(CLASS_TYPE_SHADOWLORD,oPC);
   int iInt = GetAbilityScore(oPC,ABILITY_INTELLIGENCE);

   if (!Sha) return ;

   int iLvl1 = (Sha/2) + (iInt<12 ? 0 :(iInt-4)/8) ;
   int iLvl2 = (Sha-2)/2 + (iInt<14 ? 0 :(iInt-6)/8) ;
   int iLvl3 = (Sha-5)   + (iInt<16 ? 0 :(iInt-8)/8) ;

   if (Sha == 6) iLvl1--;

   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV01,-1,iLvl1);
   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV21,-1,iLvl2);
   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV31,-1,iLvl3);

}

void SpellKotMC(object oPC)
{

   int KotMC = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,oPC);
   int iWis = GetAbilityScore(oPC,ABILITY_WISDOM);

   if (!KotMC) return;

   int iLvl1 = (KotMC+2)/5 + (iWis<12 ? 0 :(iWis-4)/8) ;
   int iLvl2 = (KotMC-2)/5 + (iWis<14 ? 0 :(iWis-6)/8) ;
   int iLvl3 = (KotMC-4)/5 + (iWis<16 ? 0 :(iWis-8)/8) ;

   FeatUsePerDay(oPC,FEAT_KOTMC_SL_1,-1,iLvl1);
   FeatUsePerDay(oPC,FEAT_KOTMC_SL_2,-1,iLvl2);
   FeatUsePerDay(oPC,FEAT_KOTMC_SL_3,-1,iLvl3);
}

void FeatDiabolist(object oPC)
{
   int Diabol = GetLevelByClass(CLASS_TYPE_DIABOLIST, oPC);

   if (!Diabol) return;

   int iUse = (Diabol + 3)/3;

   FeatUsePerDay(oPC,FEAT_DIABOL_DIABOLISM_1,-1,iUse);
   FeatUsePerDay(oPC,FEAT_DIABOL_DIABOLISM_2,-1,iUse);
   FeatUsePerDay(oPC,FEAT_DIABOL_DIABOLISM_3,-1,iUse);
}

void FeatAlaghar(object oPC)
{
    int iAlagharLevel = GetLevelByClass(CLASS_TYPE_ALAGHAR, oPC);

    if (!iAlagharLevel) return;

    int iClangStrike = iAlagharLevel/3;
    int iClangMight = (iAlagharLevel - 1)/3;
    int iRockburst = (iAlagharLevel + 2)/4;

    FeatUsePerDay(oPC, FEAT_CLANGEDDINS_STRIKE, -1, iClangStrike);
    FeatUsePerDay(oPC, FEAT_CLANGEDDINS_MIGHT, -1, iClangMight);
    FeatUsePerDay(oPC, FEAT_ALAG_ROCKBURST, -1, iRockburst);
}

void FeatNinja (object oPC)
{
    int nUsesLeft = (GetLevelByClass(CLASS_TYPE_NINJA, oPC)/ 2);
    if (nUsesLeft < 1)
        nUsesLeft = 1;

    while(GetHasFeat(FEAT_KI_POWER, oPC))
        DecrementRemainingFeatUses(oPC, FEAT_KI_POWER);
    while(GetHasFeat(FEAT_GHOST_STEP, oPC))
        DecrementRemainingFeatUses(oPC, FEAT_GHOST_STEP);
    while(GetHasFeat(FEAT_GHOST_STRIKE, oPC))
        DecrementRemainingFeatUses(oPC, FEAT_GHOST_STRIKE);
    while(GetHasFeat(FEAT_GHOST_WALK, oPC))
        DecrementRemainingFeatUses(oPC, FEAT_GHOST_WALK);
    while(GetHasFeat(FEAT_KI_DODGE, oPC))
        DecrementRemainingFeatUses(oPC, FEAT_KI_DODGE);

    if (GetAbilityModifier(ABILITY_WISDOM, oPC) > 0)
        nUsesLeft += GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nUses = 0;
    for (;nUses < nUsesLeft;nUses++)
    {
        IncrementRemainingFeatUses(oPC, FEAT_KI_POWER);
        IncrementRemainingFeatUses(oPC, FEAT_GHOST_STEP);
        IncrementRemainingFeatUses(oPC, FEAT_GHOST_STRIKE);
        IncrementRemainingFeatUses(oPC, FEAT_GHOST_WALK);
        IncrementRemainingFeatUses(oPC, FEAT_KI_DODGE);
    }
    SetLocalInt(oPC, "prc_ninja_ki", nUsesLeft);
}

void FeatContender(object oPC)
{
    int iContenderLevel = GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC);
    int iMod;

if(iContenderLevel > 0)
    iMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
else
    iMod = 1;

    FeatUsePerDay(oPC, FEAT_STRENGTH_DOMAIN_POWER, -1, iMod);
}

void BardSong(object oPC)
{
    // This is used to set the number of bardic song uses per day, as bardic PrCs can increase it
    // or other classes can grant it on their own
    int nTotal = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    nTotal += GetLevelByClass(CLASS_TYPE_DIRGESINGER, oPC);
    nTotal += GetLevelByClass(CLASS_TYPE_VIRTUOSO, oPC);

    if(GetHasFeat(FEAT_EXTRA_MUSIC, oPC)) nTotal += 4;

    FeatUsePerDay(oPC, FEAT_BARD_SONGS, -1, nTotal);
}

void FeatVirtuoso(object oPC)
{
    int nUses = GetLevelByClass(CLASS_TYPE_BARD, oPC) + GetLevelByClass(CLASS_TYPE_VIRTUOSO, oPC);
    if(GetHasFeat(FEAT_EXTRA_MUSIC, oPC)) nUses += 4;
    SetPersistantLocalInt(oPC, "Virtuoso_Performance_Uses", nUses);
    int nFeat, nTemp;
    for(nFeat = FEAT_VIRTUOSO_SUSTAINING_SONG; nFeat <= FEAT_VIRTUOSO_PERFORMANCE; nFeat++)
    {   //OMG nested loops!
        nTemp = nUses;
        while(GetHasFeat(nFeat, oPC))
            DecrementRemainingFeatUses(oPC, nFeat);
        for(; nTemp > 0; nTemp--)
            IncrementRemainingFeatUses(oPC, nFeat);
    }
}

void HexCurse(object oPC)
{
    int nUses = (GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC) + 3) / 4; // every 4 levels get 1 more use
    FeatUsePerDay(oPC, FEAT_HEXCURSE, ABILITY_CHARISMA, nUses);
}

void FeatShadowblade(object oPC)
{
        int nUses = (GetLevelByClass(CLASS_TYPE_SHADOWBLADE, oPC));
        FeatUsePerDay(oPC, FEAT_UNSEEN_WEAPON_ACTIVATE, -1, nUses);
}        

void FeatRacial(object oPC)
{
    //Shifter bonus shifting uses
    if(GetRacialType(oPC) == RACIAL_TYPE_SHIFTER)
    {
        int nShiftFeats = GetShiftingFeats(oPC);
        if(nShiftFeats > 1)
        {
            int nBonusShiftUses = nShiftFeats / 2;
            FeatUsePerDay(oPC, FEAT_SHIFTER_SHIFTING, -1, nBonusShiftUses);
        }
    }
    
    //Add daily Uses of Fiendish Resilience for epic warlock
    if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_I))
    {
        int nFeatAmt = 0;
        int bDone = FALSE;
        while(!bDone)
        {   if(nFeatAmt >= 9) 
                bDone = TRUE;
            else if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_II + nFeatAmt))
            {
                IncrementRemainingFeatUses(oPC, FEAT_FIENDISH_RESILIENCE);
                nFeatAmt++;
            }
            else
                bDone = TRUE;
        }
    }
    
    if(GetRacialType(oPC) == RACIAL_TYPE_FORESTLORD_ELF)
    {
        int nUses = GetHitDice(oPC) / 5 + 1;
        FeatUsePerDay(oPC, FEAT_FORESTLORD_TREEWALK, -1, nUses);
    }
}

void FeatSpecialUsePerDay(object oPC)
{
    FeatUsePerDay(oPC,FEAT_FIST_OF_IRON, ABILITY_WISDOM, 3);
    FeatUsePerDay(oPC,FEAT_SMITE_UNDEAD, ABILITY_CHARISMA, 3);
    SpellKotMC(oPC);
    SpellShadow(oPC);
    FeatDiabolist(oPC);
    FeatAlaghar(oPC);
    FeatUsePerDay(oPC,FEAT_SA_SHIELDSHADOW,-1,GetPrCAdjustedCasterLevelByType(TYPE_ARCANE,oPC));
    FeatUsePerDay(oPC, FEAT_HEALING_KICKER_1, ABILITY_WISDOM, GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC));
    FeatUsePerDay(oPC, FEAT_HEALING_KICKER_2, ABILITY_WISDOM, GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC));
    FeatUsePerDay(oPC, FEAT_HEALING_KICKER_3, ABILITY_WISDOM, GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC));
    FeatNinja(oPC);
    FeatContender(oPC);
    FeatUsePerDay(oPC, FEAT_LASHER_STUNNING_SNAP, -1, GetLevelByClass(CLASS_TYPE_LASHER, oPC));
    FeatUsePerDay(oPC, FEAT_AD_FALSE_KEENNESS, -1, GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC));
    FeatUsePerDay(oPC, FEAT_AD_BLUR, -1, GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC));
    FeatUsePerDay(oPC, FEAT_MOS_UNDEAD_1, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_MOS_UNDEAD_2, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_MOS_UNDEAD_3, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_MOS_UNDEAD_4, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_DOMAIN_POWER_BLIGHTBRINGER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_AIR_DOMAIN_POWER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_EARTH_DOMAIN_POWER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_FIRE_DOMAIN_POWER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_WATER_DOMAIN_POWER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_DOMAIN_POWER_SLIME, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_DOMAIN_POWER_SPIDER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_DOMAIN_POWER_SCALEYKIND, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_PLANT_DOMAIN_POWER, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_WWOC_WIDEN_SPELL, ABILITY_CHARISMA, GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oPC));
    FeatUsePerDay(oPC, FEAT_COC_WRATH, ABILITY_CHARISMA, 3);
    FeatUsePerDay(oPC, FEAT_FIST_DAL_QUOR_STUNNING_STRIKE, -1, GetLevelByClass(CLASS_TYPE_FIST_DAL_QUOR, oPC));
    HexCurse(oPC);
    FeatRacial(oPC);
    FeatShadowblade(oPC);

    if(GetPersistantLocalInt(oPC, "PRC_SLA_Uses_1"))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_1, -1, GetPersistantLocalInt(oPC, "PRC_SLA_Uses_1"));
    else if(GetHasFeat(FEAT_SPELL_LIKE_ABILITY_1, oPC))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_1, -1, 1);

    if(GetPersistantLocalInt(oPC, "PRC_SLA_Uses_2"))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_2, -1, GetPersistantLocalInt(oPC, "PRC_SLA_Uses_2"));
    else if(GetHasFeat(FEAT_SPELL_LIKE_ABILITY_2, oPC))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_2, -1, 1);

    if(GetPersistantLocalInt(oPC, "PRC_SLA_Uses_3"))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_3, -1, GetPersistantLocalInt(oPC, "PRC_SLA_Uses_3"));
    else if(GetHasFeat(FEAT_SPELL_LIKE_ABILITY_3, oPC))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_3, -1, 1);

    if(GetPersistantLocalInt(oPC, "PRC_SLA_Uses_4"))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_4, -1, GetPersistantLocalInt(oPC, "PRC_SLA_Uses_4"));
    else if(GetHasFeat(FEAT_SPELL_LIKE_ABILITY_4, oPC))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_4, -1, 1);

    if(GetPersistantLocalInt(oPC, "PRC_SLA_Uses_5"))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_5, -1, GetPersistantLocalInt(oPC, "PRC_SLA_Uses_5"));
    else if(GetHasFeat(FEAT_SPELL_LIKE_ABILITY_5, oPC))
        FeatUsePerDay(oPC, FEAT_SPELL_LIKE_ABILITY_5, -1, 1);

    BardSong(oPC);
    FeatVirtuoso(oPC);
    ResetExtraStunfistUses(oPC);
}
