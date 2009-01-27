//::///////////////////////////////////////////////
//:: Name ohs_hen_spell
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnSpellCastAt Event Handler for OHS Henchmen.
   Simplified version of x0_ch_hen_spell + nw_ch_acb.
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-12-10
//:: Last Modified: 2004-12-14
//:://////////////////////////////////////////////

#include "ohs_i0_combat"
//#include "x2_i0_spells"
#include "inc_debug_dac"
#include "nw_i0_plot"
//#include "x0_inc_henai" // @DUG
#include "x2_inc_switches" // @DUG

// @DUG Cribbed from x2_i0_spells
const int X2_SPELL_AOEBEHAVIOR_FLEE = 0;
const int X2_SPELL_AOEBEHAVIOR_IGNORE = 1;
const int X2_SPELL_AOEBEHAVIOR_GUST = 2;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_L = SPELL_LESSER_DISPEL;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_N = SPELL_DISPEL_MAGIC;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_G = SPELL_GREATER_DISPELLING;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_M = SPELL_MORDENKAINENS_DISJUNCTION;
const int X2_SPELL_AOEBEHAVIOR_DISPEL_C = 727;
int GetBestAOEBehavior(int nSpellID);
int spellsIsFlying(object oCreature);

void main()
{
  //debugVarObject("ohs_hen_spell", OBJECT_SELF);

  int nId = GetLastSpell();
  object oCaster = GetLastSpellCaster();
  object oMyMaster = GetMaster(OBJECT_SELF);

  if (GetIsHenchmanDying())
  {
    if (nId == SPELL_CURE_LIGHT_WOUNDS || nId == SPELL_CURE_CRITICAL_WOUNDS ||
        nId == SPELL_CURE_MINOR_WOUNDS || nId == SPELL_CURE_MODERATE_WOUNDS ||
        nId == SPELL_CURE_SERIOUS_WOUNDS || nId == SPELL_HEAL ||
        nId == 506 || // * Healing Kits
        nId == SPELLABILITY_LAY_ON_HANDS || // * Lay on Hands
        nId == 309 ||   // * Wholeness of Body
        nId == SPELL_HEALING_CIRCLE || nId == SPELL_RAISE_DEAD ||
        nId == SPELL_RESURRECTION || nId == SPELL_MASS_HEAL ||
        nId == SPELL_GREATER_RESTORATION || nId == SPELL_REGENERATE ||
        nId == SPELL_AID || nId == SPELL_VIRTUE
       )
    {
      SetLocalInt(OBJECT_SELF, "X0_L_WAS_HEALED",10);
      WrapCommandable(TRUE, OBJECT_SELF);
      DoRespawn(GetLastSpellCaster(), OBJECT_SELF);
      return;
    }
  }

  if(GetLastSpellHarmful())
  {
    SetCommandable(TRUE);

        // * GZ Oct 3, 2003
        // * Really, the engine should handle this, but hey, this world is not perfect...
        // * If I was hurt by my master or the creature hurting me has
        // * the same master
        // * Then clear any hostile feelings I have against them
        // * After all, we're all just trying to do our job here
        // * if we singe some eyebrow hair, oh well.
    if (GetIsObjectValid(oMyMaster) && (oMyMaster == oCaster || oMyMaster == GetMaster(oCaster)))
    {
      ClearPersonalReputation(oCaster, OBJECT_SELF);
      return;
    }

    int bAttack = TRUE;
    if (!GetIsHenchmanDying() && MatchAreaOfEffectSpell(GetLastSpell()))
    {

      //* GZ 2003-Oct-02 : New AoE Behavior AI
      int nAI = GetBestAOEBehavior(GetLastSpell());
      switch (nAI)
      {
        case X2_SPELL_AOEBEHAVIOR_DISPEL_L:
        case X2_SPELL_AOEBEHAVIOR_DISPEL_N:
        case X2_SPELL_AOEBEHAVIOR_DISPEL_M:
        case X2_SPELL_AOEBEHAVIOR_DISPEL_G:
        case X2_SPELL_AOEBEHAVIOR_DISPEL_C:
          bAttack = FALSE;
          ActionCastSpellAtLocation(nAI, GetLocation(OBJECT_SELF));
          ActionDoCommand(SetCommandable(TRUE));
          SetCommandable(FALSE);
          break;

        case X2_SPELL_AOEBEHAVIOR_FLEE:
          ClearActions(CLEAR_NW_C2_DEFAULTB_GUSTWIND);
          ActionForceMoveToObject(oCaster, TRUE, 2.0);
          ActionMoveToObject(GetMaster(), TRUE, 1.1);
          DelayCommand(1.2, ActionDoCommand(HenchmenCombatRound(OBJECT_INVALID)));
          bAttack = FALSE;
          break;

        case X2_SPELL_AOEBEHAVIOR_IGNORE:
          // well ... nothing
          break;

        case X2_SPELL_AOEBEHAVIOR_GUST:
          ActionCastSpellAtLocation(SPELL_GUST_OF_WIND, GetLocation(OBJECT_SELF));
          ActionDoCommand(SetCommandable(TRUE));
          SetCommandable(FALSE);
          bAttack = FALSE;
          break;
      }
    }

    if(
        bAttack &&
       !GetIsObjectValid(GetAttackTarget()) &&
       !GetIsObjectValid(GetAttemptedSpellTarget()) &&
       !GetIsObjectValid(GetAttemptedAttackTarget()) &&
       !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)) &&
       !GetIsFriend(oCaster)
      )
    {
      SetCommandable(TRUE);
      //Shout Attack my target, only works with the On Spawn In setup
      SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
      //Shout that I was attacked
      SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
      OHSCombatRound(oCaster);
    }
  }
}

int GetBestAOEBehavior(int nSpellID)
{
        if (nSpellID == SPELL_GREASE)
        {
           if (spellsIsFlying(OBJECT_SELF))
           return X2_SPELL_AOEBEHAVIOR_IGNORE;
        }

//        if (GetHasSpell(SPELL_GUST_OF_WIND) == TRUE)
        if (GetHasSpell(SPELL_GUST_OF_WIND))
            return X2_SPELL_AOEBEHAVIOR_GUST;

        if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_AI_DISPEL_AOE) == 0 )
        {
            if (d100() > GetLocalInt(GetModule(),MODULE_VAR_AI_NO_DISPEL_AOE_CHANCE))
            {
//                if (GetHasSpell(SPELL_LESSER_DISPEL) == TRUE)
                if (GetHasSpell(SPELL_LESSER_DISPEL))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_L;
//                if (GetHasSpell(SPELL_DISPEL_MAGIC) == TRUE)
                if (GetHasSpell(SPELL_DISPEL_MAGIC))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_N;
//                if (GetHasSpell(SPELL_GREATER_DISPELLING) == TRUE)
                if (GetHasSpell(SPELL_GREATER_DISPELLING))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_G;
//                if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION) == TRUE)
                if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION))
                    return X2_SPELL_AOEBEHAVIOR_DISPEL_M;
            }
        }

    return X2_SPELL_AOEBEHAVIOR_FLEE;
}

int spellsIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother
        case 291: // @DUG Seagull flying
        case 455: // @DUG Wyvern
        case 456: // @DUG Wyvern
        case 457: // @DUG Wyvern
        case 458: // @DUG Wyvern
        case 1046: // @DUG CEP creatures, see appearance.2da
        case 1050: // @DUG
        case 1073: // @DUG
        case 1171: // @DUG
        case 1172: // @DUG
        case 1275: // @DUG
        case 1281: // @DUG
        case 1282: // @DUG
        case 1342: // @DUG
        case 1343: // @DUG
        case 1344: // @DUG
        case 1345: // @DUG
        case 1346: // @DUG
        case 1347: // @DUG
        case 1366: // @DUG
        case 1367: // @DUG
        case 1368: // @DUG
        case 1372: // @DUG
        case 1373: // @DUG
        case 1374: // @DUG
        case 1375: // @DUG
        case 1376: // @DUG
        case 1377: // @DUG
        case 1387: // @DUG
        case 1388: // @DUG
        case 1389: // @DUG
        case 1425: // @DUG
        case 1426: // @DUG
        case 1431: // @DUG
        case 1432: // @DUG
        case 1435: // @DUG
        case 1436: // @DUG
        case 1437: // @DUG
        case 1493: // @DUG
        case 1494: // @DUG
        case 1508: // @DUG
        case 1515: // @DUG
        case 1516: // @DUG
        case 1517: // @DUG
        case 1518: // @DUG
        case 1527: // @DUG
        case 1528: // @DUG
        case 1556: // @DUG
        case 1557: // @DUG
        case 1558: // @DUG
        case 1559: // @DUG
        case 1560: // @DUG
        case 1561: // @DUG
        case 1562: // @DUG
        case 1563: // @DUG
        case 1564: // @DUG
        case 1565: // @DUG
        case 1584: // @DUG
        case 1596: // @DUG
        case 1608: // @DUG
        case 1620: // @DUG
        case 1632: // @DUG
        case 1644: // @DUG
        case 1656: // @DUG
        case 1668: // @DUG
        case 1680: // @DUG
        case 1692: // @DUG
        case 1807: // @DUG
        case 1808: // @DUG
        case 1809: // @DUG
        case 1810: // @DUG
        case 1812: // @DUG
        case 1813: // @DUG
        case 1814: // @DUG
        case 1815: // @DUG
        case 1816: // @DUG
        case 1817: // @DUG
        case 1818: // @DUG
        case 1819: // @DUG
        case 1850: // @DUG
        case 1874: // @DUG
        case 1875: // @DUG
        case 1891: // @DUG
        case 1892: // @DUG
        case 1893: // @DUG
        case 1947: // @DUG
        case 1948: // @DUG
        case 1949: // @DUG
        case 1950: // @DUG
        case 1951: // @DUG
        case 1952: // @DUG
        case 1956: // @DUG
        case 1957: // @DUG
        case 1958: // @DUG
        case 1959: // @DUG
        case 1960: // @DUG
        case 1961: // @DUG
        case 1962: // @DUG
        case 1963: // @DUG
        case 1964: // @DUG
        case 1965: // @DUG
        case 1975: // @DUG
        case 1976: // @DUG
        case 1977: // @DUG
        case 1978: // @DUG
        case 1979: // @DUG
        case 1988: // @DUG
        case 1990: // @DUG
        case 1991: // @DUG
        case 1992: // @DUG
        case 1993: // @DUG
        case 1994: // @DUG
        case 1995: // @DUG
        case 1996: // @DUG
        case 1997: // @DUG
        case 1998: // @DUG
        case 2079: // @DUG
        case 2080: // @DUG
        case 2081: // @DUG
        case 2082: // @DUG
        case 3120: // @DUG
        case 1321: // @DUG
        case 3122: // @DUG
        case 3123: // @DUG
        case 3124: // @DUG
        case 3125: // @DUG
        case 3130: // @DUG
           bFlying = TRUE;
    }
    if(!bFlying
        && GetCreatureWingType(oCreature) != CREATURE_WING_TYPE_NONE)
        bFlying = TRUE;
    return bFlying;
}

////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole
// modified or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////
