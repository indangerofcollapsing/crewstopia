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
#include "x2_i0_spells"
#include "inc_debug_dac"
#include "nw_i0_plot"

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

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole modified    //
// or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////
