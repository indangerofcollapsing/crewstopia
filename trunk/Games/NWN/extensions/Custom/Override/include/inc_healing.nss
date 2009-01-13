int useHealingKit(object oTarget);
int talentHealSelf(int bForce = FALSE);
int useUndeadHealing(object oTarget);
void fakeUseScroll(int spell, object target, object scroll);
int tryResurrect(object oTarget);
int talentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF);

#include "nw_i0_generic"
#include "prc_inc_racial"
#include "inc_debug_dac"

// Wrapper for TalentCureCondition()
int talentCure();

// Credit to He Who Watches, this is stolen from
// http://nwn.bioware.com/forums/viewtopic.html?chl=fr&forum=63&topic=322110
//
// HWW/ENTROPY JAN 2004: - Do I have a healing kit? If so use it.
// This just grabs any kit found, assuming that an NPC hasn't hoarded
// about 500 of them like players do.
// maybe a check for the strength of the kit could be added, using
// weakest ones first if high heal skill, highest first if low heal skill
int useHealingKit(object oTarget)
{
   object kit = GetFirstItemInInventory();
   int found = FALSE;
   while (!found && GetIsObjectValid(kit))
   {
      if (GetBaseItemType(kit) == BASE_ITEM_HEALERSKIT)
      {
         found = TRUE;
      } else kit = GetNextItemInInventory();
   }
   if (GetIsObjectValid(kit))
   {
      ClearAllActions();
      ActionSpeakString("This healing kit should help you.");
      ActionUseSkill(SKILL_HEAL, oTarget, 0, kit);
      return TRUE;
   }
   return FALSE;
}

// HEAL SELF WITH POTIONS AND SPELLS
// * July 14 2003: If bForce=TRUE then force a heal
int talentHealSelf(int bForce = FALSE)
{
   // HWW/ENTROPY JAN 2004: checks for healing kits and heal ability
   // BK: Sep 2002
   // * Moved the racial type filter into here instead of having it
   // * out everyplace that this talent is called
   // * Will have to keep an eye out to see if this breaks anything
   // entropy i bet you it does - magical beasts can't self-heal but constructs can??
   // commented constructs back in, they're not alive
   // changed || to && - useless otherwise
   int r = MyPRCGetRacialType(OBJECT_SELF);
   if (r != RACIAL_TYPE_BEAST &&
//@DUG      r != RACIAL_TYPE_ABERRATION &&
//@DUG      r != RACIAL_TYPE_ELEMENTAL &&
      r != RACIAL_TYPE_VERMIN &&
      r != RACIAL_TYPE_MAGICAL_BEAST &&
//@DUG      r != RACIAL_TYPE_UNDEAD &&
//@DUG      r != RACIAL_TYPE_DRAGON    &&
      r != RACIAL_TYPE_CONSTRUCT &&
      r != 29 && //oozes
      r != RACIAL_TYPE_ANIMAL)
   {
      //debugMsg("talentHealSelf Enter");
      talent tUse;
      int nCurrent = GetCurrentHitPoints(OBJECT_SELF) * 2;
      int nBase = GetMaxHitPoints(OBJECT_SELF);
      if( (nCurrent < nBase) || (bForce == TRUE) )
      {
         // entropy - try spell
         tUse = GetCreatureTalentRandom(
            TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH);
         if(GetIsTalentValid(tUse))
         {
            //debugMsg("Talent\ Successful Exit");
            ActionUseTalentOnObject(tUse, OBJECT_SELF);
            ActionSpeakString("Ah, that's better.");
            return TRUE;
         }
         // try healing kit
         if ((GetSkillRank(SKILL_HEAL) >= 0))
         {
            if (useHealingKit(OBJECT_SELF))
            {
               ActionSpeakString("Ah, that's better.");
               return TRUE;
            }
         }
         // try potion
         tUse = GetCreatureTalentRandom(
            TALENT_CATEGORY_BENEFICIAL_HEALING_POTION);
         if (GetIsTalentValid(tUse))
         {
            //debugMsg("talentHealSelf Successful Exit");
            ActionSpeakString("Ah, that's better.");
            ActionUseTalentOnObject(tUse, OBJECT_SELF);
            return TRUE;
         }
      }
   }
   //debugMsg("talentHealSelf Failed Exit");
   return FALSE;
}

// HWW/ENTROPY JAN 2004:  see if you have any negative energy spells to heal undead with
int useUndeadHealing(object oTarget)
{
   if (GetHasSpell(SPELL_NEGATIVE_ENERGY_RAY))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_NEGATIVE_ENERGY_RAY,oTarget);
      return TRUE;
   }
   if (GetHasSpell(SPELL_INFLICT_LIGHT_WOUNDS))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_INFLICT_LIGHT_WOUNDS,oTarget);
      return TRUE;
   }
   if (GetHasSpell(SPELL_INFLICT_MODERATE_WOUNDS))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_INFLICT_MODERATE_WOUNDS,oTarget);
      return TRUE;
   }
   if (GetHasSpell(SPELL_INFLICT_SERIOUS_WOUNDS))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_INFLICT_SERIOUS_WOUNDS,oTarget);
      return TRUE;
   }
   if (GetHasSpell(SPELL_INFLICT_CRITICAL_WOUNDS))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_INFLICT_CRITICAL_WOUNDS,oTarget);
      return TRUE;
   }
   if (GetHasSpell(SPELL_HARM))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_HARM,oTarget);
      return TRUE;
   }
   // try minor last because it is so useless
   if (GetHasSpell(SPELL_INFLICT_MINOR_WOUNDS))
   {
      ClearAllActions();
      ActionSpeakString("Feed on negative energy.");
      ActionCastSpellAtObject(SPELL_INFLICT_MINOR_WOUNDS,oTarget);
      return TRUE;
   }
   // try negative energy burst if no non-undead friendlies within RADIUS_SIZE_HUGE
   if (GetHasSpell(SPELL_NEGATIVE_ENERGY_BURST))
   {
      int nNth = 1;
      object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oTarget, nNth, CREATURE_TYPE_IS_ALIVE, TRUE);
      while (GetIsObjectValid(oCreature))
      {
         if (MyPRCGetRacialType(oCreature) != RACIAL_TYPE_UNDEAD &&
             GetDistanceBetween(oTarget, oCreature) <= RADIUS_SIZE_HUGE)
         {
            ClearAllActions();
            ActionSpeakString("Feed on negative energy.");
            ActionCastSpellAtObject(SPELL_NEGATIVE_ENERGY_BURST, oTarget);
            return TRUE;
         }
         oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION,
            REPUTATION_TYPE_FRIEND, OBJECT_SELF, ++nNth, CREATURE_TYPE_IS_ALIVE,
            TRUE);
      }
   }
   // had nothing appropriate to cast
   return FALSE;
}

// FAKE USE SCROLL
// HWW/ENTROPY FEB 2004: "fake" the use of a scroll
void fakeUseScroll(int spell, object target, object scroll)
{
   //debugVarObject("fakeUseScroll()", OBJECT_SELF);
   //debugVarInt("spell", spell);
   //debugVarObject("target", target);
   //debugVarObject("scroll", scroll);
   int ss = GetNumStackedItems(scroll);
   ActionDoCommand(SetFacingPoint(GetPosition(target)));
   ActionMoveToObject(target, TRUE, 3.0);
   ActionSpeakString("This " + GetName(scroll) + " should help you.");
   ActionPlayAnimation(ANIMATION_FIREFORGET_READ);
   ActionCastSpellAtObject(spell, target, METAMAGIC_NONE, TRUE, 0,
      PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
   if (ss==1) ActionDoCommand(DestroyObject(scroll));
   else ActionDoCommand(SetItemStackSize(scroll, ss - 1));
   ActionDoCommand(SetCommandable(TRUE));
   SetCommandable(FALSE);
}

// TRY RESURRECT
// HWW/ENTROPY FEB 2004: try casting raise or res on target
int tryResurrect(object oTarget)
{
   //debugVarObject("tryResurrect()", OBJECT_SELF);
   //debugVarObject("oTarget", oTarget);
   //SpeakString("RESURRECT TARGET FOUND");
   if (GetLocalInt(oTarget, "BEINGREZZED")) return FALSE;
   if (GetHasSpell(SPELL_RAISE_DEAD))
   {
      ClearAllActions();
      SetLocalInt(oTarget, "BEINGREZZED", TRUE);
      string sDeity = GetDeity(OBJECT_SELF);
      if (sDeity == "")
      {
         ActionSpeakString("I call you back from the realm of the dead!");
      }
      else
      {
         FloatingTextStringOnCreature("In the name of " + sDeity +
            " I call you back from the realm of the dead!", OBJECT_SELF);
      }
      ActionCastSpellAtObject(SPELL_RAISE_DEAD, oTarget);
      DelayCommand(8.0, DeleteLocalInt(oTarget, "BEINGREZZED"));
      return TRUE;
   }
   // Rod of Resurrection
   object oRoR = GetItemPossessedBy(OBJECT_SELF, "nw_wmgmrd002");
   if (GetIsObjectValid(oRoR))
   {
      ClearAllActions();
      SetLocalInt(oTarget, "BEINGREZZED", TRUE);
      ActionMoveToObject(oTarget, TRUE);
      string sDeity = GetDeity(OBJECT_SELF);
      if (sDeity == "")
      {
         ActionSpeakString("I call you back from the realm of the dead!");
      }
      else
      {
         FloatingTextStringOnCreature("In the name of " + sDeity +
            " I call you back from the realm of the dead!", OBJECT_SELF);
      }
      AssignCommand(OBJECT_SELF, SignalEvent(OBJECT_SELF, EventActivateItem(oRoR, 
         GetLocation(oTarget), oTarget)));
      DelayCommand(8.0, DeleteLocalInt(oTarget, "BEINGREZZED"));
      return TRUE;
   }
   if (GetHasSpell(SPELL_RESURRECTION))
   {
      ClearAllActions();
      SetLocalInt(oTarget, "BEINGREZZED", TRUE);
      string sDeity = GetDeity(OBJECT_SELF);
      if (sDeity == "")
      {
         ActionSpeakString("I call you back from the realm of the dead!");
      }
      else
      {
         FloatingTextStringOnCreature("In the name of " + sDeity +
            " I call you back from the realm of the dead!", OBJECT_SELF);
      }
      ActionCastSpellAtObject(SPELL_RESURRECTION, oTarget);
      DelayCommand(8.0, DeleteLocalInt(oTarget, "BEINGREZZED"));
      return TRUE;
   }
   // got raise dead scroll?
   object rdscr = GetItemPossessedBy(OBJECT_SELF, "NW_IT_SPDVSCR501");
   if (GetIsObjectValid(rdscr) && ((GetHitDice(OBJECT_SELF) >= 3) ||
       (GetSkillRank(SKILL_USE_MAGIC_DEVICE) >= 10)))
   {
      ClearAllActions();
      SetLocalInt(oTarget, "BEINGREZZED", TRUE);
      fakeUseScroll(SPELL_RAISE_DEAD, oTarget, rdscr);
      DelayCommand(8.0, DeleteLocalInt(oTarget, "BEINGREZZED"));
      return TRUE;
   }
   // Scroll of Resurrection
   rdscr = GetItemPossessedBy(OBJECT_SELF, "NW_IT_SPDVSCR702");
   if (GetIsObjectValid(rdscr) && ((GetHitDice(OBJECT_SELF) >= 4) ||
       (GetSkillRank(SKILL_USE_MAGIC_DEVICE) >= 11)))
   {
      ClearAllActions();
      SetLocalInt(oTarget, "BEINGREZZED", TRUE);
      fakeUseScroll(SPELL_RESURRECTION, oTarget, rdscr);
      DelayCommand(8.0, DeleteLocalInt(oTarget, "BEINGREZZED"));
      return TRUE;
   }

   // Token of Sacrifice
   ActionSpeakString("You must live!", TALKVOLUME_SHOUT);
   ClearAllActions();
   AssignCommand(OBJECT_SELF, ActionMoveToObject(oTarget));
   AssignCommand(OBJECT_SELF, ActionSpeakString("You must live!"));
   object oToken = GetItemPossessedBy(OBJECT_SELF, "dac_sacritoken");
   if (oToken == OBJECT_INVALID)
   {
      oToken = CreateItemOnObject("dac_sacritoken", OBJECT_SELF);
   }
   
   if (oToken != OBJECT_INVALID)
   {
      AssignCommand(OBJECT_SELF, SignalEvent(OBJECT_SELF, EventActivateItem(oToken, 
         GetLocation(oTarget), oTarget)));
      AssignCommand(OBJECT_SELF, ActionSpeakString("Ouch!"));
      return TRUE;
   }
   

   //debugMsg("resurrect failed");
   return FALSE;
}

// HEAL ALL ALLIES
// BK: Added an optional parameter for object.
// HWW/ENTROPY JAN 2004: added support for healing kits and most negative energy spells
int talentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF)
{
   //debugVarObject("talentHeal()", OBJECT_SELF);
   //debugVarBoolean("nForce", nForce);
   //debugVarObject("oTarget", oTarget);
   int nCurrent = GetCurrentHitPoints(oTarget);
   // look for people that are 50% wounded unless told to force heal
   if (!nForce) nCurrent *= 2;
   int nBase = GetMaxHitPoints(oTarget);
   talent tUse = GetCreatureTalentBest(
      TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 99);
   int bValid = GetIsTalentValid(tUse);
   //debugVarBoolean("bValid", bValid);
   // ENTROPY - resurrect or raise dead PCs below -10 or NPCs below 0
   if ((MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD) &&
       (oTarget != OBJECT_SELF) &&
// @DUG       GetCurrentHitPoints(oTarget) <= GetIsPC(oTarget) ? -10 : 0)
       GetCurrentHitPoints(oTarget) <= 0)
   {
      if (tryResurrect(oTarget)) return TRUE;
   }
   // entropy - cast inflict wounds on other undeads
   if ((MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) &&
       (oTarget != OBJECT_SELF) && (GetCurrentHitPoints(oTarget) < nBase))
   {
      if (useUndeadHealing(oTarget)) return TRUE;
   }
   // entropy - use healing spell or ability on specified target if possible
   if (bValid && oTarget != OBJECT_SELF && GetCurrentHitPoints(oTarget) < nBase)
   {
      ActionSpeakString("Here you go.");
      ActionUseTalentOnObject(tUse, oTarget);
      //debugMsg("talentHeal (MASTER) Successful Exit");
      return TRUE;
   }
   // entropy - otherwise try to use kit on other target if have healing skill
   if ((oTarget != OBJECT_SELF) && (GetSkillRank(SKILL_HEAL) >= 0) &&
       GetCurrentHitPoints(oTarget) < nBase)
   {
      if (useHealingKit(oTarget)) return TRUE;
   }
   // entropy - try using spell or ability on self
   // don't do this if i am undead (kits = bad and inflict wounds / negray can't be self-cast)
   if ((nCurrent < nBase) && (oTarget == OBJECT_SELF) &&
       (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD))
   {
      // try spell or ability on self
      if (bValid)
      {
         ActionUseTalentOnObject(tUse, oTarget);
         ActionSpeakString("Ah, that's better.");
         return TRUE;
      }
      // try healing kit on self
      if (GetSkillRank(SKILL_HEAL) >= 0)
      {
         if (useHealingKit(oTarget))
         {
            ActionSpeakString("Ah, that's better.");
            return TRUE;
         }
      }
   }
   // * change target - couldn't heal specified target or self
   // * find nearest friend to heal.
   //oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
   //debugMsg("looking for friends to heal");
   int nNth = 1;
   oTarget = GetNearestObject(OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oTarget))
   {
      //debugVarObject("oTarget", oTarget);
      if ((GetIsFriend(oTarget) || GetIsNeutral(oTarget)) &&
         GetObjectSeen(oTarget) && GetDistanceBetween(oTarget, OBJECT_SELF) <= 30.0)
      {
         if (nForce == TRUE) nCurrent = GetCurrentHitPoints(oTarget);
         else nCurrent = GetCurrentHitPoints(oTarget) * 2;
         //debugVarInt("nCurrent", nCurrent);
         nBase = GetMaxHitPoints(oTarget);
         //debugVarInt("nBase", nBase);
         int nRace = MyPRCGetRacialType(oTarget);
         //debugVarInt("nRace", nRace);
         // ENTROPY - resurrect or raise dead PCs below -10 or NPCs below 0
         if ((nRace != RACIAL_TYPE_UNDEAD) && (oTarget != OBJECT_SELF) &&
// @DUG             GetCurrentHitPoints(oTarget) <= (GetIsPC(oTarget) ? -10 : 0))
             (GetCurrentHitPoints(oTarget) <= 0 || GetIsDead(oTarget)))
         {
            if (tryResurrect(oTarget)) return TRUE;
         }
         // entropy - look out for dying PCs (remove GetIsPC check if you have no bleeding in mod)
         if (nCurrent < nBase && (! GetIsDead(oTarget))) // @DUG ||
// @DUG                (GetIsPC(oTarget) && (GetCurrentHitPoints(oTarget) > -10))))
         {
            //debugVarObject("needs healing", oTarget);
            if (nRace == RACIAL_TYPE_UNDEAD)
            {
               // entropy - try casting inflict wounds on undead
               if ((nCurrent < nBase) && (! GetIsDead(oTarget))) // @DUG ||
// @DUG                (GetIsPC(oTarget) && (GetCurrentHitPoints(oTarget) > -10))))
               {
                  if (useUndeadHealing(oTarget)) return TRUE;
               }
            }
            else
            {
               // try spells
               if (bValid)
               {
                  //debugMsg("talentHeal spell Successful Exit");
                  string sDeity = GetDeity(OBJECT_SELF);
                  if (sDeity == "")
                  {
                     ActionSpeakString("Here you go.");
                  }
                  else
                  {
                     ActionSpeakString("In the name of " + sDeity +
                        " you are healed.");
                  }
                  ActionUseTalentOnObject(tUse, oTarget);
                  return TRUE;
               }
               // try kit
               if ((GetSkillRank(SKILL_HEAL) >= 0))
               {
                  if (useHealingKit(oTarget))
                  {
                     //debugMsg("talentHeal kit Successful Exit");
                     return TRUE;
                  }
               }
            }
         }
      }
      oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, ++nNth);
   }
   //debugMsg("talentHeal Failed Exit");
   return FALSE;
}

int talentCure()
{
   //debugVarObject("talentCure()", OBJECT_SELF);
   int nCured = TalentCureCondition();
   //debugVarInt("nCured", nCured);
   if (nCured)
   {
      string sDeity = GetDeity(OBJECT_SELF);
      if (sDeity == "")
      {
         FloatingTextStringOnCreature("You are cured.", OBJECT_SELF);
      }
      else
      {
         FloatingTextStringOnCreature("In the name of " + sDeity + " you are cured.",
            OBJECT_SELF);
      }
   }
   return nCured;
}

//void main() {} // Testing/compiling purposes
