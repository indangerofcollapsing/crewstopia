//::///////////////////////////////////////////////
//:: Name ohs_hen_spawn
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
    OnSpawn event handler for clones in OldMansBeard's Henchman System.
    Simplified version of Bioware x0_ch_hen_spawn.
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-10-17
//:: Last Modified: 2006-02-07
//:://////////////////////////////////////////////

#include "x0_inc_henai"
#include "ohs_i0_toolkit"
#include "inc_debug_dac"
#include "nw_i0_plot"
#include "inc_equip"

void RectifyInventory();

void main()
{
  //debugVarObject("ohs_hen_spawn", OBJECT_SELF);
  //debugVarInt(GetName(GetFirstPC()) + " reaction", GetReputation(GetFirstPC(), OBJECT_SELF));

  //Sets up the special henchmen listening patterns
  SetAssociateListenPatterns();

  // Set additional henchman listening patterns
  bkSetListeningPatterns();

  // Default behavior for henchmen at start
  SetAssociateState(NW_ASC_POWER_CASTING);
  SetAssociateState(NW_ASC_HEAL_AT_50);
  SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, FALSE);
  SetAssociateState(NW_ASC_DISARM_TRAPS, FALSE);
  SetAssociateState(NW_ASC_MODE_STAND_GROUND,FALSE);
  SetAssociateState(NW_ASC_DISTANCE_2_METERS);

  // Use melee weapons by default
  if (GetLocalString(OBJECT_SELF, "DAC_BATTLE_STYLE") == BATTLE_STYLE_RANGED)
  {
     SetAssociateState(NW_ASC_USE_RANGED_WEAPON, TRUE);
  }
  else
  {
     SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);
  }

  // Set starting location
  SetAssociateStartLocation();

  // Set respawn location
  SetRespawnLocation();

  // Leave a permanent, raiseable corpse if you die
  SetIsDestroyable(FALSE, TRUE, TRUE);

  object oPC = GetNearestPC();
  //debugVarObject("oPC", oPC);
  // Join the "Merchant" Faction
  //debugMsg("changing to Merchant faction");
  ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_MERCHANT);
  if (GetIsEnemy(oPC))
  {
     //debugMsg("changing to Commoner faction");
     ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_COMMONER);
  }
  // V1.4.4: Exceptionally, if Defenders are hostile to Merchants
  // (e.g. in PotSC) join the Defenders instead
  if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER) <= 10)
  {
    //debugMsg("changing to Defender faction");
    ChangeToStandardFaction(OBJECT_SELF,STANDARD_FACTION_DEFENDER);
  }

  spawnItemsFor(OBJECT_SELF);
  
  // Delay this so there is time for the Companion flag to be set
  ActionDoCommand(RectifyInventory());
  AssignCommand(OBJECT_SELF, ActionStartConversation(oPC));

}

void RectifyInventory()
{
   //debugVarObject("RectifyInventory()", OBJECT_SELF);

   // Only do the inventory adjustments below for non-companions,
   // that is, henchmen from the registry who have not yet been hired
   if (OHS_GetIsCompanion(OBJECT_SELF)) return;

   //debugVarObject("not already hired", OBJECT_SELF);

   // Total the net worth (in GP) of the character's wealth
   int NetWorth = 0;

   // Scan through all equipped items and make sure they
   // are identified and none is a plot item.
   // Total the NetWorth as GetGoldPieceValue().
   int i = 0;
   object oItem;
   for (i = 0; i<=NUM_INVENTORY_SLOTS; i++)
   {
      oItem = GetItemInSlot(i, OBJECT_SELF);
      if (GetIsObjectValid(oItem) == TRUE)
      {
         if (GetPlotFlag(oItem)==TRUE)
         {
            DestroyObject(oItem);
         }
         else
         {
            SetIdentified(oItem, TRUE);
            NetWorth += GetGoldPieceValue(oItem);
         }
      }
   }

   // Likewise all inventory items
   oItem = GetFirstItemInInventory();
   while (GetIsObjectValid(oItem))
   {
      if (GetPlotFlag(oItem)==TRUE)
      {
         DestroyObject(oItem);
      }
      else
      {
         SetIdentified(oItem, TRUE);
         NetWorth += GetGoldPieceValue(oItem);
         SetItemCursedFlag(oItem, TRUE); // @DUG
         SetPlotFlag(oItem, TRUE); // @DUG
      }
      oItem = GetNextItemInInventory();
   }

   SetLocalInt(OBJECT_SELF,"OHS_HIRE_PRICE",NetWorth);
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