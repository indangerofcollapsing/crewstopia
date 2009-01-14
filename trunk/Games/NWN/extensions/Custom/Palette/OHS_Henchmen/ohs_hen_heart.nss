//::///////////////////////////////////////////////
//:: Name ohs_hen_heart
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnHeartbeat Event Handler for OHS Henchmen.
   Simplified version of x0_ch_hen_heart + nw_ch_ac1
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-12-10
//:: Last Modified: 2004-04-02
//:://////////////////////////////////////////////

#include "ohs_i0_combat"
#include "ohs_i0_toolkit"
#include "inc_sacritoken"
#include "inc_debug_dac"
#include "nw_i0_plot"
#include "inc_healing"

void main()
{
   //debugVarObject("ohs_hen_heart", OBJECT_SELF);

   // Used by inc_ropebridge to determine whether I should follow master or not.
   SetLocalInt(OBJECT_SELF, "MODE_STAND_GROUND", GetAssociateState(NW_ASC_MODE_STAND_GROUND));
   SetLocalInt(OBJECT_SELF, "MODE_DEFEND_MASTER", GetAssociateState(NW_ASC_MODE_DEFEND_MASTER));
   
   object oMaster = GetMaster();
   //debugVarObject("oMaster", oMaster);
   if (oMaster == OBJECT_INVALID)
   {
      object oPC = GetNearestPC();
      //debugVarObject("setting friendly to", oPC);
      SetIsTemporaryFriend(oPC);
      ClearPersonalReputation(oPC);
      AdjustReputation(oPC, OBJECT_SELF, 100);
      //debugVarBoolean("is enemy", GetIsEnemy(oPC));
      //debugVarInt("reputation", GetReputation(oPC, OBJECT_SELF));
   }

   if (GetIsPC(oMaster) && !OHS_GetIsCompanion(OBJECT_SELF))
   {
      OHS_SetCompanion(OBJECT_SELF,TRUE,oMaster);
   }

   object oEnemySeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

   if (GetIsHenchmanDying())
   {
      if (GetCommandable())
      {
         ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0, 65.0);
         SetCommandable(FALSE);
      }
      return;
   }

   if(GetAssociateState(NW_ASC_IS_BUSY) || GetIsResting()) return;

   // Okay. Decide what to do next.
   if (!GetIsInCombat())
   {
      if (!GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
      {
         // Check to see if should re-enter stealth mode
         int nStealth=GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE");
         if(nStealth == 1 || nStealth == 2)
         {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
         }
      }

      // @DUG Heal and/or resurrect master
      if (GetIsObjectValid(oMaster) && GetIsDead(oMaster))
      {
         if (GetCurrentAction(OBJECT_SELF) != ACTION_FOLLOW &&
            GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP &&
            GetCurrentAction(OBJECT_SELF) != ACTION_OPENLOCK &&
            GetCurrentAction(OBJECT_SELF) != ACTION_REST &&
            GetCurrentAction(OBJECT_SELF) != ACTION_ATTACKOBJECT &&
            !GetIsObjectValid(GetAttackTarget()) &&
            !GetIsObjectValid(GetAttemptedSpellTarget()) &&
            !GetIsObjectValid(GetAttemptedAttackTarget()) &&
            !GetIsObjectValid(oEnemySeen) &&
            !GetIsFighting(OBJECT_SELF))
         {
            // Fighting is over, resurrect master
            talentHeal();
/*
            // Rod of Resurrection
            object oResurrect = GetItemPossessedBy(OBJECT_SELF,
               "nw_wmgmrd002");
            if (oResurrect == OBJECT_INVALID)
            {
               // Scroll of Resurrect
               oResurrect = GetItemPossessedBy(OBJECT_SELF,
                  "nw_it_spdvscr702");
               if (oResurrect == OBJECT_INVALID)
               {
                  oResurrect = CreateItemOnObject("dac_sacritoken",
                     OBJECT_SELF);
                  // Scroll of Raise Dead
                  oResurrect = GetItemPossessedBy(OBJECT_SELF,
                     "nw_it_spdvscr501");
                  if (oResurrect == OBJECT_INVALID)
                  {
                     // Token of Sacrifice
                     oResurrect = GetItemPossessedBy(OBJECT_SELF,
                        "dac_sacritoken");
                     if (oResurrect == OBJECT_INVALID)
                     {
                        oResurrect = CreateItemOnObject("dac_sacritoken",
                           OBJECT_SELF);
                     }
                  }
               }
            }
            //debugVarObject("oResurrect", oResurrect);
            ActionSpeakString("You must live!", TALKVOLUME_SHOUT);
            ClearAllActions();
            AssignCommand(OBJECT_SELF, ActionMoveToObject(oMaster));
            AssignCommand(OBJECT_SELF, ActionSpeakString("I'll do my best to heal you."));
            if (GetResRef(oResurrect) == "dac_sacritoken")
            {
               useTokenOfSacrifice(oMaster, OBJECT_SELF);
            }
            else
            {
               ActionSpeakString("I hope this " + GetName(oResurrect) +
                  " works!");
               AssignCommand(OBJECT_SELF, SignalEvent(OBJECT_SELF,
                  EventActivateItem(oResurrect, GetLocation(oMaster),
                  oMaster)));
               //debugMsg("Well, did it work?");
            }
            AssignCommand(OBJECT_SELF, ActionSpeakString("Ouch!"));
*/
         }
      }

      if (bkAttemptToDisarmTrap(GetNearestTrapToObject())) return ;
      if (!IsInConversation(OBJECT_SELF)) EquipFavouriteWeapons(OBJECT_INVALID);
   }

   if (GetIsObjectValid(oMaster) && (GetCurrentHitPoints(oMaster) * 2) < GetMaxHitPoints(oMaster))
   {
      // Stop fighting and heal master
      AssignCommand(OBJECT_SELF, ActionSpeakString("I'll do my best to heal you."));
      AssignCommand(OBJECT_SELF, ActionMoveToObject(oMaster));
      talentHeal();
      //AssignCommand(OBJECT_SELF, ActionUseTalentOnObject(TalentHeal(), oMaster));
      AssignCommand(OBJECT_SELF, ActionSpeakString("I hope that was enough."));
      return;
   }

   if (GetIsObjectValid(oMaster) &&
      GetCurrentAction(OBJECT_SELF) != ACTION_FOLLOW &&
      GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP &&
      GetCurrentAction(OBJECT_SELF) != ACTION_OPENLOCK &&
      GetCurrentAction(OBJECT_SELF) != ACTION_REST &&
      GetCurrentAction(OBJECT_SELF) != ACTION_ATTACKOBJECT &&
      !GetIsObjectValid(GetAttackTarget()) &&
      !GetIsObjectValid(GetAttemptedSpellTarget()) &&
      !GetIsObjectValid(GetAttemptedAttackTarget()) &&
      !GetIsObjectValid(oEnemySeen) &&
      GetDistanceToObject(oMaster) > 6.0 &&
      GetAssociateState(NW_ASC_HAVE_MASTER) &&
      !GetIsFighting(OBJECT_SELF) &&
      !GetAssociateState(NW_ASC_MODE_STAND_GROUND) &&
      GetDistanceToObject(oMaster) > GetFollowDistance())
   {
      ClearActions(CLEAR_NW_CH_AC1_49);
      if (GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH))
      {
         ActionUseSkill(SKILL_SEARCH, OBJECT_SELF);
      }
      ActionForceFollowObject(oMaster, GetFollowDistance());
   }

   if (GetHasEffect(EFFECT_TYPE_DOMINATED, OBJECT_SELF)) SendForHelp();
}

////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole
// modified or unmodified without the express consent of the copyright holder.        //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////
