#include "inc_bindstone"
#include "inc_nbde"
#include "inc_travel"
#include "inc_persistworld"
#include "x3_inc_horse"
#include "inc_debug_dac"

void main()
{
   //debugVarObject("_mod_on_enter", OBJECT_SELF);

   ExecuteScript("prc_onenter", OBJECT_SELF);

   object oPC = GetEnteringObject();
   //debugVarObject("oPC", oPC);

   if (! GetIsPC(oPC)) return;

   if (GetXP(oPC) == 0)
   {
      GiveXPToCreature(oPC, 1);
      GiveGoldToCreature(oPC, 500);
      CreateItemOnObject("dac_recallrune", oPC, 10);
   }

   object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
   if (oSkin == OBJECT_INVALID) oSkin = CreateItemOnObject("base_prc_skin",oPC);
   // Player Tools
   if (! GetHasFeat(IP_CONST_FEAT_PLAYER_TOOL_08, oPC))
   {
      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(
         IP_CONST_FEAT_PLAYER_TOOL_08));
   }
   if (! GetHasFeat(IP_CONST_FEAT_PLAYER_TOOL_09, oPC))
   {
      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(
         IP_CONST_FEAT_PLAYER_TOOL_09));
   }
   if (! GetHasFeat(IP_CONST_FEAT_PLAYER_TOOL_10, oPC))
   {
      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(
         IP_CONST_FEAT_PLAYER_TOOL_10));
   }
   // Climb
   if (! GetHasFeat(3112, oPC))
   {
      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(3112));
   }

   ExecuteScript("get_pc_startpt", OBJECT_SELF);
   location lStart = GetLocation(GetWaypointByTag(GetLocalString(oPC, "START_POINT")));
   if (! isLocationValid(lStart)) lStart = GetStartingLocation();

   if (GetLocalInt(GetModule(), "PRC_PW_LOCATION_TRACKING"))
   {
      debugMsg("Using PrC location tracking.");
   }
   else
   {
      location lLast = getPersistentLocation(oPC, "LOCATION");
      //debugVarLoc("lLast", lLast);
      location lLastRest = getLastRestLoc(oPC);
      //debugVarLoc("lLastRest", lLastRest);
      location lBindstone = getBindLoc(oPC);
      //debugVarLoc("lBindstone", lBindstone);
/* This can seriously hassle spellcasters who need to buff before combat
      if (isLocationValid(lLast))
      {
         //debugVarLoc(GetName(oPC) + " returning to last location", lLast);
         lStart = lLast;
      }
      else
*/    if (isLocationValid(lLastRest))
      {
         //debugVarLoc(GetName(oPC) + " returning to last rest location", lLastRest);
         setPersistentLocation(oPC, "LOCATION", lLastRest);
         lStart = lLastRest;
      }
      else if (isLocationValid(lBindstone))
      {
         //debugVarLoc(GetName(oPC) + " returning to bindstone location", lBindstone);
         setPersistentLocation(oPC, "LOCATION", lBindstone);
         setLastRestLoc(oPC, lBindstone);
         lStart = lBindstone;
      }
      else
      {
         //debugVarLoc(GetName(oPC) + " returning to start location", lStart);
         setPersistentLocation(oPC, "LOCATION", lStart);
         setLastRestLoc(oPC, lStart);
      }
   }
   if (isLocationValid(lStart))
   {
      //AssignCommand(oPC, ClearAllActions(TRUE));
      DelayCommand(6.0, AssignCommand(oPC, JumpToLocation(lStart)));
      DelayCommand(10.0, AssignCommand(oPC, JumpToLocation(lStart)));
   }
   else
   {
      logError("Invalid location " + LocationToString(lStart) + " in mod_on_enter for " +
         objectToString(oPC));
   }

   // Glyph of Sacrifice:  Harm yourself to ressurect a friend.
   object oToken = GetItemPossessedBy(oPC, "dac_sacritoken");
   if (oToken == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "Use the Token of Sacrifice to aid a fallen comrade.");
      CreateItemOnObject("dac_sacritoken", oPC);
   }

   // @HACK
   // Sometimes creatures are invisible and *untargettable* for combat.
   // Nothing you do can make them visible.
   // This does not, unfortunately, prevent them from attacking you.
   // As a workaround, give the PC a token to initiate combat.  Once
   // initiated, combat will continue until either combatant dies or
   // runs away.
   /* This has been moved to a Feat
   object oInitCombat = GetItemPossessedBy(oPC, "dac_init_combat");
   if (oInitCombat == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "Use this token when attacked by ethereal creatures.");
      CreateItemOnObject("dac_init_combat", oPC);
   } */

   // Holy Symbols for those who need them.
   if (GetHasFeat(FEAT_TURN_UNDEAD, oPC) && GetDeity(oPC) != "")
   {
      if (GetItemPossessedBy(oPC, "dac_holysymbol") == OBJECT_INVALID)
      {
         object oHolySymbol = CreateItemOnObject("dac_holysymbol", oPC);
         SetName(oHolySymbol, "Holy Symbol of " + GetDeity(oPC));
      }
   }

   // Psionic Status for psionic characters.
   /* hopefully using psionic points available is less brittle than class
   if (GetLevelByClass(145, oPC) + GetLevelByClass(146, oPC) +
       GetLevelByClass(147, oPC) + GetLevelByClass(148, oPC) +
       GetLevelByClass(210, oPC) + GetLevelByClass(211, oPC) +
       GetLevelByClass(212, oPC) + GetLevelByClass(213, oPC) +
       GetLevelByClass(218, oPC) > 0)
   */
   if (GetLocalInt(oPC, "PRC_PowerPoints") > 0)
   {
      if (GetItemPossessedBy(oPC, "dac_psi_status") == OBJECT_INVALID)
      {
         SendMessageToPC(oPC, "Use this to show your psionic status.");
         CreateItemOnObject("dac_psi_status", oPC);
      }
   }

// This is handled by an on-rest event now
   // OHS Henchman system
//   if (GetItemPossessedBy(oPC, "dac_ohs_lbsummon") == OBJECT_INVALID)
//   {
//      CreateItemOnObject("dac_ohs_lbsummon", oPC);
//   }

   // Snow Globe!
   if (GetItemPossessedBy(oPC, "dac_snowglobe") == OBJECT_INVALID)
   {
      CreateItemOnObject("dac_snowglobe", oPC);
   }

   ExecuteScript("save_pc", oPC);

   // x3_mod_def_enter contents
   ExecuteScript("x3_mod_pre_enter",OBJECT_SELF); // Override for other skin systems
   if ((GetIsPC(oPC)||GetIsDM(oPC))&&!GetHasFeat(FEAT_HORSE_MENU,oPC))
   { // add horse menu
      HorseAddHorseMenu(oPC);
      if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB"))
      { // restore PC horse status from database
         DelayCommand(2.0,HorseReloadFromDatabase(oPC,X3_HORSE_DATABASE));
      } // restore PC horse status from database
   } // add horse menu
   if (GetIsPC(oPC))
   { // more details
      // restore appearance in case you export your character in mounted form, etc.
      if (!GetSkinInt(oPC,"bX3_IS_MOUNTED")) HorseIfNotDefaultAppearanceChange(oPC);
      // pre-cache horse animations for player as attaching a tail to the model
      HorsePreloadAnimations(oPC);
      DelayCommand(3.0,HorseRestoreHenchmenLocations(oPC));
   } // more details
}
