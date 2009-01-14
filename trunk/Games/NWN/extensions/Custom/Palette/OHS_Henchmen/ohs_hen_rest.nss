//::///////////////////////////////////////////////
//:: Name ohs_hen_rest
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnRested script for henchmen in the OHS system.
   Top up XP to minimum of Master's or half (DM option)
   Level up if you need to. Policies available so far:
   -1: Do not automatically level up, just accumulate XP
   0: Prefer most recently-added class possible (default)
   1: Prefer class 1, failing back to 3 then 2 if they exist
   2: Prefer class 2, failing back to 3 then 1 if they exist
   3: Prefer class 3, failing back to 2 then 1 if they exist
   4: Try to make all classes equal level (balance)
   Romance may deepen during rest periods (dreaming of love)
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-11-25
//:: Last Modified: 2006-03-26
//:://////////////////////////////////////////////

void spawnEquipment();
void dropOldArmor();
void markHenchmanEquipment(object oItem);

// #include "ohs_i0_toolkit"  V1.4.4: included in ohs_i0_goals
#include "ohs_i0_goals"
#include "ohs_i0_messages"
#include "inc_equip" // @DUG
#include "inc_debug_dac"
#include "nw_i0_plot"

void main()
{
  //debugVarObject("ohs_hen_rest", OBJECT_SELF);

  object oMaster = GetMaster();
  int nPolicy, nIndex, nClass, nClasses;
  int b2lt1, b3lt1, b3lt2, b1le2, b1le3, b2le3;
  string sAmNow  = OHS_GetStringByLanguage(1,oMaster);
  string sCannot = OHS_GetStringByLanguage(2,oMaster);

  if (GetIsDead(OBJECT_SELF) || !GetIsObjectValid(oMaster)) return;

  // Top up XP if necessary
  int nMinXP = GetXP(oMaster);
  int nMaster = GetHitDice(oMaster);
  int nLag = OHS_GetXPLag();
  if (nMaster<=nLag)
  {
    nMinXP = 0;
  }
  else
  {
    nMinXP = nMinXP*(nMaster-nLag)/nMaster*(nMaster-nLag+1)/(nMaster+1);
  }
  if (GetXP(OBJECT_SELF)<nMinXP) SetXP(OBJECT_SELF,nMinXP);

  int nHD = GetHitDice(OBJECT_SELF);
  int bAutoLevelUp = nHD<40 && GetLocalInt(OBJECT_SELF,"OHS_LEVELUP_POLICY")>=0;
  if (bAutoLevelUp && GetXP(OBJECT_SELF)>=nHD*(nHD+1)*500) // Enough to level up
  {
    // Count how many valid classes you have
    nClasses = 0;
    while (nClasses<3 && GetClassByPosition(nClasses+1)!=CLASS_TYPE_INVALID) nClasses++;

    // Get your current policy
    nPolicy = GetLocalInt(OBJECT_SELF,"OHS_LEVELUP_POLICY");

    // Work out which class position to try first
    nIndex = 0;
    switch (nPolicy)
    {
      case 1:
        nIndex = 1;
        break;
      case 2:
        nIndex = (nClasses>1)?2:1;
        break;
      case 4:
        // This algorithm is tricksy. Don't fiddle with it!
        nIndex = 1;
        if (nClasses>1 && GetLevelByPosition(nIndex+1)<GetLevelByPosition(nIndex)) nIndex = 2;
        if (nClasses==3 && GetLevelByPosition(nClasses)<GetLevelByPosition(nIndex)) nIndex = 3;
        break;
      case 0:
      case 3:
      default:
        nIndex = nClasses;
        break;
    }

    while (nIndex>0 && GetXP(OBJECT_SELF)>=nHD*(nHD+1)*500)
    {
      nClass = GetClassByPosition(nIndex);
      // Try levelling up in nClass
      if (LevelUpHenchman(OBJECT_SELF,nClass,TRUE))
      {
        SpeakString(sAmNow+OHS_GetClassNameString(nClass,oMaster)+" "+IntToString(GetLevelByClass(nClass)));
        if (nPolicy==4) // Balance. Check if you should now switch to another class
        {
          // This algorithm is tricksy. Don't fiddle with it!
          if (nIndex==3)
          {
            if (GetLevelByPosition(2)==GetLevelByPosition(3)) nIndex = 2;
            if (GetLevelByPosition(1)==GetLevelByPosition(3)) nIndex = 1;
          }
          else if (nIndex==2)
          {
            if (GetLevelByPosition(1)==GetLevelByPosition(2)) nIndex = 1;
            if (GetLevelByPosition(3)==GetLevelByPosition(2)-1) nIndex = 3;
          }
          else if (nIndex==1)
          {
            if (GetLevelByPosition(3)==GetLevelByPosition(1)-1) nIndex = 3;
            if (GetLevelByPosition(2)==GetLevelByPosition(1)-1) nIndex = 2;
          }
        }
      }
      else
      {
        SpeakString(sCannot+OHS_GetClassNameString(nClass,oMaster));
        switch (nPolicy)
        {
          // That class failed; work out a fall-back nIndex if possible
          // If you can't find one, set it nIndex to 0 to stop trying
          case 1:
            if (nIndex==2) nIndex = 0;
            if (nIndex==3) nIndex = 2;
            if (nIndex==1) nIndex = (nClasses>1)?nClasses:0;
            break;
          case 2:
            if (nIndex==1) nIndex = 0;
            if (nIndex==3) nIndex = 1;
            if (nIndex==2) nIndex = (nClasses==3)?3:1;
            break;
          case 4:
            // This algorithm is tricksy. Don't fiddle with it!
            if (nIndex==1)
            {
              b2lt1 = GetLevelByPosition(2)<GetLevelByPosition(1);
              b3lt1 = GetLevelByPosition(3)<GetLevelByPosition(1);
              b3lt2 = GetLevelByPosition(3)<GetLevelByPosition(2);
              if (b2lt1 && b3lt1) nIndex = 0;
              else if (b2lt1) nIndex = 3;
              else if (b3lt1) nIndex = 2;
              else nIndex = (b3lt2)?3:2;
            }
            else if (nIndex==2)
            {
              b1le2 = GetLevelByPosition(1)<=GetLevelByPosition(2);
              b3lt2 = GetLevelByPosition(3)<GetLevelByPosition(2);
              b3lt1 = GetLevelByPosition(3)<GetLevelByPosition(1);
              if (b1le2 && b3lt2) nIndex = 0;
              else if (b1le2) nIndex = 3;
              else if (b3lt2) nIndex = 1;
              else nIndex = (b3lt1)?3:1;
            }
            else if (nIndex==3)
            {
              b1le3 = GetLevelByPosition(1)<=GetLevelByPosition(3);
              b2le3 = GetLevelByPosition(2)<=GetLevelByPosition(3);
              b1le2 = GetLevelByPosition(1)<=GetLevelByPosition(2);
              if (b1le3 && b2le3) nIndex = 0;
              else if (b1le3) nIndex = 2;
              else if (b2le3) nIndex = 1;
              else nIndex = (b1le2)?1:2;
            }
            break;
          case 0:
          case 3:
          default:
            nIndex--;
            break;
        } // switch (nPolicy)
      } // else

      nHD = GetHitDice(OBJECT_SELF);
    } // while (nIndex>0 && GetXP(OBJECT_SELF)>=nHD*(nHD+1)*500)
    // After levelup, get new equipment
    spawnEquipment(); // @DUG
  } // if (bAutoLevelUp && GetXP(OBJECT_SELF)>=nHD*(nHD+1)*500)

  // Romance may deepen during rest periods (dreaming of love)
  int iFlirt = OHS_GetFlirtLevel(OBJECT_SELF,oMaster);
  string sStrokeVarName = "OHS_STROKES_TODAY_"+GetName(oMaster);
  int nStrokesToday = GetLocalInt(OBJECT_SELF,sStrokeVarName);
  if (iFlirt==1 && nStrokesToday>0)
  {
    if (GetAbilityScore(oMaster,ABILITY_CHARISMA)+nStrokesToday >= d20())
    {
      iFlirt++;
      OHS_SetFlirtLevel(OBJECT_SELF,oMaster,iFlirt);
    }
  }

  if (iFlirt>=2)
  {
    OHS_SetGoal(OBJECT_SELF,OHS_GOAL_SEX);
    // Lawful companions are faithful to their first loves
    if (GetLocalString(OBJECT_SELF,"OHS_S_ENAMOUR")==""
        || GetAlignmentLawChaos(OBJECT_SELF)!=ALIGNMENT_LAWFUL)
    {
      SetLocalString(OBJECT_SELF,"OHS_S_ENAMOUR",GetName(oMaster));
    }
  }
  SetLocalInt(OBJECT_SELF,sStrokeVarName,0);
}

// @DUG Spawn in appropriate gear.
void spawnEquipment()
{
   string DAC_SPAWN = GetLocalString(OBJECT_SELF, VAR_SPAWN_CODE);
   if (DAC_SPAWN == "")
   {
      DAC_SPAWN = SPAWN_ARMOR + SPAWN_WEAPON + SPAWN_SHIELD + SPAWN_BELT +
         SPAWN_CLOAK + SPAWN_HELM + SPAWN_FOOTWEAR + SPAWN_GLOVES +
         SPAWN_RINGS + SPAWN_AMULET + SPAWN_POTIONS + SPAWN_WIZARD_ITEMS;
      SetLocalString(OBJECT_SELF, VAR_SPAWN_CODE, DAC_SPAWN);
   }
   object oItem;
   int nSlot = INVENTORY_SLOT_CHEST;
   object oArmor = spawnArmor(OBJECT_SELF);
   if (oArmor != OBJECT_INVALID)
   {
      ActionSpeakString("I got a " + GetName(oArmor));
      markHenchmanEquipment(oArmor);
      AssignCommand(OBJECT_SELF, ActionEquipMostEffectiveArmor());
      //debugMsg("assigning dropOldArmor() command");
      DelayCommand(10.0, dropOldArmor());
      //debugMsg("dropOldArmor() command assigned");
   }
   nSlot = INVENTORY_SLOT_RIGHTHAND;
   object oWeapon = spawnWeapons(OBJECT_SELF);
   if (oWeapon != OBJECT_INVALID)
   {
      ActionSpeakString("I got a " + GetName(oWeapon));
      markHenchmanEquipment(oWeapon);
//      AssignCommand(OBJECT_SELF, ActionEquipItem(oWeapon, nSlot));
      // As a side effect, a second weapon may have been equipped
//      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
//      if (oItem != OBJECT_INVALID)
//      {
//         markHenchmanEquipment(oItem);
//      }
   }
   nSlot = INVENTORY_SLOT_LEFTHAND;
   object oShield = spawnShield(OBJECT_SELF);
   if (oShield != OBJECT_INVALID)
   {
      ActionSpeakString("I got a " + GetName(oShield));
      markHenchmanEquipment(oShield);
   }
   nSlot = INVENTORY_SLOT_BELT;
   object oBelt = spawnBelt(OBJECT_SELF);
   if (oBelt != OBJECT_INVALID)
   {
      markHenchmanEquipment(oBelt);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oBelt, nSlot));
   }
   nSlot = INVENTORY_SLOT_CLOAK;
   object oCloak = spawnCloak(OBJECT_SELF);
   if (oCloak != OBJECT_INVALID)
   {
      markHenchmanEquipment(oCloak);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oCloak, nSlot));
   }
   nSlot = INVENTORY_SLOT_HEAD;
   object oHelm = spawnHelm(OBJECT_SELF);
   if (oHelm != OBJECT_INVALID)
   {
      markHenchmanEquipment(oHelm);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oHelm, nSlot));
   }
   nSlot = INVENTORY_SLOT_BOOTS;
   object oBoots = spawnBoots(OBJECT_SELF);
   if (oBoots != OBJECT_INVALID)
   {
      markHenchmanEquipment(oBoots);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oBoots, nSlot));
   }
   nSlot = INVENTORY_SLOT_ARMS;
   object oGauntlets = spawnGauntlets(OBJECT_SELF);
   if (oGauntlets != OBJECT_INVALID)
   {
      markHenchmanEquipment(oGauntlets);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oGauntlets, nSlot));
   }
   nSlot = INVENTORY_SLOT_LEFTRING;
   object oRing = spawnRing(OBJECT_SELF);
   if (oRing != OBJECT_INVALID)
   {
      markHenchmanEquipment(oRing);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oRing, nSlot));
   }
   nSlot = INVENTORY_SLOT_RIGHTRING;
   oRing = spawnRing(OBJECT_SELF);
   if (oRing != OBJECT_INVALID)
   {
      markHenchmanEquipment(oRing);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oRing, nSlot));
   }
   nSlot = INVENTORY_SLOT_NECK;
   object oAmulet = spawnAmulet(OBJECT_SELF);
   if (oAmulet != OBJECT_INVALID)
   {
      markHenchmanEquipment(oAmulet);
      AssignCommand(OBJECT_SELF, ActionEquipItem(oAmulet, nSlot));
   }
}

// Too much armor weighs you down.  Just keep the last.
void dropOldArmor()
{
   //debugVarObject("dropOldArmor()", OBJECT_SELF);
   object oItem = GetFirstItemInInventory();
   while (oItem != OBJECT_INVALID)
   {
      if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
      {
         if (GetLocalInt(oItem, "HENCHMAN_EQUIPMENT"))
         {
            //debugVarObject("destroying", oItem);
            //ActionSpeakString("Destroying " + GetName(oItem));
            SetPlotFlag(oItem, FALSE);
            SetItemCursedFlag(oItem, FALSE);
            DestroyObject(oItem);
         }
      }
   }
}

// Mark spawned equipment as non-droppable so the PC can't steal it.
void markHenchmanEquipment(object oItem)
{
   //debugVarObject("markHenchmanEquipment", OBJECT_SELF);
   //debugVarObject("oItem", oItem);
   SetPlotFlag(oItem, TRUE);
   SetItemCursedFlag(oItem, TRUE);
   SetIdentified(oItem, TRUE);
   SetLocalInt(oItem, "HENCHMAN_EQUIPMENT", TRUE);
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
