//::///////////////////////////////////////////////
//:: Name ohs_i0_treehawk
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   Include file of utility functions to support
   "Treehawk's Miraculous Device" and the OHUM command
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2005-01-15
//:://////////////////////////////////////////////

/************************/
/* Forward Declarations */
/************************/

// Attempt to level up oDest, class by class, to match oSource
int TransferLevels(object oSource, object oDest);

// Empty oOwner's inventory and equipment slots using
// DestroyObject on everything with implicit delay 0.0
void ClearInventory(object oOwner);

// Move everything from oSource's inventory to oDest
void MoveInventory(object oSource, object oDest);

// Copy oSource's equipped items into oDest's equipment slots
void CopyEquippedItems(object oSource, object oDest);

// Do the Treehawk Miracle, updating oDest from oSource
int DoTreehawkMiracle(object oSource, object oDest);

/******************/
/* Implementation */
/******************/

// Attempt to level up oDest, class by class, to match oSource
// Returns FALSE if the class patterns are incompatible
int TransferLevels(object oSource, object oDest)
{
  // Check that oDest's classes are a subset of oSources
  int nPosition, nSourceClass, nDestClass;
  int bOkay = TRUE;
  for (nPosition=1; nPosition<=3; nPosition++)
  {
    nSourceClass = GetClassByPosition(nPosition,oSource);
    nDestClass   = GetClassByPosition(nPosition,oDest);
    if (nDestClass!=CLASS_TYPE_INVALID && nDestClass!=nSourceClass) bOkay=FALSE;
  }
  if (!bOkay) return FALSE;

  // Reckon up the total levels that will result from merging up
  int nTopLevel = 0;
  int nSourceLevel, nDestLevel;
  for (nPosition=1; nPosition<=3; nPosition++)
  {
    nSourceLevel = GetLevelByPosition(nPosition,oSource);
    nDestLevel   = GetLevelByPosition(nPosition,oDest);
    nTopLevel += (nSourceLevel>nDestLevel)?nSourceLevel:nDestLevel;
  }

  // Raise oDest's XP to oSource's if it is lower
  if (GetXP(oSource)>GetXP(oDest)) SetXP(oDest,GetXP(oSource));
  // Then top up oDest's XP if necessary; levelups will fail otherwise
  int nMinXP = 500*nTopLevel*(nTopLevel-1);
  if (GetXP(oDest)<nMinXP) SetXP(oDest,nMinXP);

  // Okay. Now bring the levels up one by one. Drop out if anything fails.
  int nDifference;
  for (nPosition=1; nPosition<=3; nPosition++)
  {
    nSourceClass = GetClassByPosition(nPosition,oSource);
    if (nSourceClass!=CLASS_TYPE_INVALID)
    {
      nDifference  = GetLevelByPosition(nPosition,oSource)-GetLevelByPosition(nPosition,oDest);
      while (nDifference>0 && bOkay)
      {
        bOkay = LevelUpHenchman(oDest,nSourceClass);
        nDifference--;
      }
    }
  }
  return bOkay;
}

// Empty oOwner's inventory and equipment slots using
// DestroyObject on everything with implicit delay 0.0
void ClearInventory(object oOwner)
{
  object oItem = GetFirstItemInInventory(oOwner);
  while (GetIsObjectValid(oItem))
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(oOwner);
  }
  int nSlot;
  for (nSlot=0; nSlot<=NUM_INVENTORY_SLOTS; nSlot++)
  {
    oItem = GetItemInSlot(nSlot,oOwner);
    if (GetIsObjectValid(oItem)) DestroyObject(oItem);
  }
}

// Move everything from oSource's inventory to oDest
void MoveInventory(object oSource, object oDest)
{
  int bCommandable = GetCommandable(oDest);
  SetCommandable(TRUE,oDest);
  object oItem;
  oItem = GetFirstItemInInventory(oSource);
  while (GetIsObjectValid(oItem))
  {
    AssignCommand(oDest,ActionTakeItem(oItem,oSource));
    oItem = GetNextItemInInventory(oSource);
  }
  SetCommandable(bCommandable,oDest);
}

// Copy oSource's equipped items into oDest's equipment slots
void CopyEquippedItems(object oSource, object oDest)
{
  int bCommandable = GetCommandable(oDest);
  SetCommandable(TRUE,oDest);
  int nSlot;
  object oItem, oDestItem;
  for (nSlot=0; nSlot<=NUM_INVENTORY_SLOTS; nSlot++)
  {
    oItem = GetItemInSlot(nSlot,oSource);
    if (GetIsObjectValid(oItem))
    {
      oDestItem = CopyItem(oItem,oDest,TRUE);
      AssignCommand(oDest,ActionEquipItem(oDestItem,nSlot));
      AssignCommand(oDest,ActionWait(0.35));
    }
  }
  SetCommandable(bCommandable,oDest);
}

// Do the Treehawk Miracle, updating oDest from oSource
// Return FALSE if the level-up fails for some reason.
int DoTreehawkMiracle(object oSource, object oDest)
{
  if (!TransferLevels(oSource,oDest)) return FALSE;

  // Empty oDest's inventory and equipment slots
  DelayCommand(1.0f,ClearInventory(oDest));

  // Copy oSource's equipped items into oDest's's equipment slots
  DelayCommand(1.5,CopyEquippedItems(oSource,oDest));

  // Move everything in oSource's inventory into oDest's.
  // The delay is to give time for the DestroyObjects to happen
  DelayCommand(2.0f,MoveInventory(oSource,oDest));

  return TRUE;
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

