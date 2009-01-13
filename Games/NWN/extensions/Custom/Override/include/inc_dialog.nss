int scDialog(string sDialogID, int nFlags);
void setDialogFlags(string sDialogID, int nFlags);
void attemptSkill(int nSkill, int nDC);
int lastSkillSuccessful();
object getNPCSpeaker();
void attemptBribe(int nSkill, int nDC, int nDCBonus, int nBribeAmount);
void setPCSpeaker(object oPC);
object getPCSpeaker(object oShouter);
void disarmSelf();
void tryToEscape();
void dropValuables();
void worship(object oPC = OBJECT_INVALID);
int countNearbyFriends();
void surrender();
void giveXPByAlignment(object oPC, int nXP, int nQuestAlignment = ALIGNMENT_ALL);
int getDialogXP(object oCreature, object oPC);

// Variable names
const string VAR_SKILL_CHECK = "LAST_SKILL_SUCCESSFUL";
const string VAR_BRIBE_FAILED = "LAST_BRIBE_FAILED";
const string VAR_MY_GREETING = "MY_GREETING";
const string VAR_PC_SPEAKER = "PC_SPEAKER";
// This one seems to be a NWN standard (see nw_i0_generic)
const string VAR_NW_GENERIC_SURRENDER = "Generic_Surrender";

// Actions which NPCs might shout to their followers
// See "x2_def_userdef" and http://nwn.bioware.com/builders/sctutorial22.html
const string SHOUT_SURRENDER = "SURRENDER";
const int LISTEN_SURRENDER = 100;
const string SHOUT_DISARM = "DISARM";
const int LISTEN_DISARM = 101;
const string SHOUT_WORSHIP = "WORSHIP";
const int LISTEN_WORSHIP = 102;
const string SHOUT_ESCAPE = "ESCAPE";
const int LISTEN_ESCAPE = 103;
const string SHOUT_DROP_VALUABLES = "DROP_VALUABLES";
const int LISTEN_DROP_VALUABLES = 104;

// See nw_i0_plot for some INT/CHA/WIS checks (i.e., CheckIntelligenceLow())

#include "zep_inc_main"
#include "inc_fof"
//#include "inc_debug_dac"

/**
 * Returns TRUE if any of the flags (bits) are set for the given dialog.
 * Example:
 * int StartingConditional()
 * { return SCDialog(DIALOG_NECROMANCER_SEWER_GRATE, NSG_SEEN_BARS | NSG_SEEN_HINGE);
 * }
 */
int scDialog(string sDialogID, int nFlags)
{
   object oPC = GetPCSpeaker();
   return (GetLocalInt(oPC, sDialogID) & nFlags);
}

/**
 * Sets bitwise flags for dialog milestones.
 * Example:
 * SetDialogFlags(DIALOG_NECROMANCER_SEWER_GRATE, NSG_SEEN_HINGE);
 */
void setDialogFlags(string sDialogID, int nFlags)
{
   object oPC = GetPCSpeaker();
   int nExistingFlags = GetLocalInt(oPC, sDialogID);
   SetLocalInt(oPC, sDialogID, nExistingFlags | nFlags);
}

void attemptSkill(int nSkill, int nDC)
{
   int nSuccess = GetIsSkillSuccessful(GetPCSpeaker(), nSkill, nDC);
   SetLocalInt(getNPCSpeaker(), VAR_SKILL_CHECK, nSuccess);
}

int lastSkillSuccessful()
{
   return GetLocalInt(getNPCSpeaker(), VAR_SKILL_CHECK);
}

object getNPCSpeaker()
{
   // Try the owner of the dialog
   object oNPC = OBJECT_SELF;

   // next, find the nearest object that could have a dialog
   if (GetIsPC(oNPC))
   {
      // GetLastSpeaker() only sets its value *after* the conversation
      // concludes, which makes it useless within the conversation.  Feh.
      // Try to guess the NPC we're talking to by finding the nearest
      // creature or placeable that's not a PC or henchman.  Not perfect,
      // but hopefully good enough.
      int nNth = 1;
      object oFound = GetNearestObject();
      int bExitLoop = (oFound != OBJECT_INVALID);
      while (! bExitLoop)
      {
         if (GetObjectType(oFound) == OBJECT_TYPE_CREATURE ||
             GetObjectType(oFound) == OBJECT_TYPE_DOOR ||
             GetObjectType(oFound) == OBJECT_TYPE_PLACEABLE
            )
         {
            if (! GetIsPC(oFound) && !GetIsPC(GetMaster(oFound)))
            {
               oNPC = oFound;
               bExitLoop == TRUE;
            }
         }
         oFound = GetNearestObject(OBJECT_TYPE_ALL, OBJECT_SELF, ++nNth);
         bExitLoop = (bExitLoop || (oFound != OBJECT_INVALID));
      }
   }

   return oNPC;
}

void attemptBribe(int nSkill, int nDC, int nDCBonus, int nBribeAmount)
{
   object oPC = GetPCSpeaker();
   if (GetGold(oPC) < nBribeAmount)
   {
      SetLocalInt(getNPCSpeaker(), VAR_BRIBE_FAILED, TRUE);
   }
   else
   {
      // They take the bribe even if the persuade fails.  You can't trust anyone.
      TakeGoldFromCreature(nBribeAmount, GetPCSpeaker(), FALSE);
      attemptSkill(SKILL_PERSUADE, nDC - nDCBonus);
   }
}

// Save the PC who is the object of our dialogue.
void setPCSpeaker(object oPC)
{
   SetLocalObject(OBJECT_SELF, VAR_PC_SPEAKER, GetPCSpeaker());
}

// Get the PC who was the object of our dialogue.
object getPCSpeaker(object oShouter)
{
   return GetLocalObject(oShouter, VAR_PC_SPEAKER);
}

void disarmSelf()
{
   object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   if (oWeapon != OBJECT_INVALID) ActionPutDownItem(oWeapon);
   oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
   if (oWeapon != OBJECT_INVALID) ActionPutDownItem(oWeapon);
   oWeapon = GetFirstItemInInventory();
   while (oWeapon != OBJECT_INVALID)
   {
      switch(GetBaseItemType(oWeapon))
      {
         case BASE_ITEM_ARROW:
         case BASE_ITEM_BASTARDSWORD:
         case BASE_ITEM_BATTLEAXE:
         case BASE_ITEM_BOLT:
         case BASE_ITEM_CLUB:
         case BASE_ITEM_DAGGER:
         case BASE_ITEM_DART:
         case BASE_ITEM_DIREMACE:
         case BASE_ITEM_DOUBLEAXE:
         case BASE_ITEM_DWARVENWARAXE:
         case BASE_ITEM_GREATAXE:
         case BASE_ITEM_GREATSWORD:
         case BASE_ITEM_GRENADE:
         case BASE_ITEM_HALBERD:
         case BASE_ITEM_HANDAXE:
         case BASE_ITEM_HEAVYCROSSBOW:
         case BASE_ITEM_HEAVYFLAIL:
         case BASE_ITEM_KAMA:
         case BASE_ITEM_KATANA:
         case BASE_ITEM_KUKRI:
         case BASE_ITEM_LIGHTCROSSBOW:
         case BASE_ITEM_LIGHTFLAIL:
         case BASE_ITEM_LIGHTHAMMER:
         case BASE_ITEM_LIGHTMACE:
         case BASE_ITEM_LONGBOW:
         case BASE_ITEM_LONGSWORD:
         case BASE_ITEM_MAGICROD:
         case BASE_ITEM_MAGICSTAFF:
         case BASE_ITEM_MAGICWAND:
         case BASE_ITEM_MORNINGSTAR:
         case BASE_ITEM_QUARTERSTAFF:
         case BASE_ITEM_RAPIER:
         case BASE_ITEM_SCIMITAR:
         case BASE_ITEM_SCYTHE:
         case BASE_ITEM_SHORTBOW:
         case BASE_ITEM_SHORTSPEAR:
         case BASE_ITEM_SHORTSWORD:
         case BASE_ITEM_SHURIKEN:
         case BASE_ITEM_SICKLE:
         case BASE_ITEM_SLING:
         case BASE_ITEM_THROWINGAXE:
         case BASE_ITEM_TRIDENT:
         case BASE_ITEM_TWOBLADEDSWORD:
         case BASE_ITEM_WARHAMMER:
         case BASE_ITEM_WHIP:
         case BASE_ITEM_DAGGERASSASSIN:
         case BASE_ITEM_DOUBLESCIMITAR:
         case BASE_ITEM_FALCHION1:
         case BASE_ITEM_FALCHION2:
         case BASE_ITEM_GOAD:
         case BASE_ITEM_HEAVYMACE:
         case BASE_ITEM_HEAVYPICK:
         case BASE_ITEM_KATAR:
         case BASE_ITEM_KUKRI2:
         case BASE_ITEM_LIGHTMACE2:
         case BASE_ITEM_LIGHTPICK:
         case BASE_ITEM_MAUL:
         case BASE_ITEM_MERCURIALGREATSWORD:
         case BASE_ITEM_MERCURIALLONGSWORD:
         case BASE_ITEM_NUNCHAKU:
         case BASE_ITEM_SAI:
         case BASE_ITEM_SAP:
         case BASE_ITEM_WINDFIREWHEEL:
            ActionPutDownItem(oWeapon);
            break;
         default:
            // Nothing
            break;
      }
      oWeapon = GetNextItemInInventory();
   }
}

// Don't use this for generic fight-or-flight behavior, as it rewards XP for good PCs
void tryToEscape()
{
   ClearAllActions();
   object oShouter = GetLastSpeaker();
   object oPC = getPCSpeaker(oShouter);
   if (GetIsPC(oPC))
   {
      ActionMoveAwayFromObject(oPC, FALSE, 1.0f);
   }
   else
   {
      ActionMoveAwayFromLocation(GetLocation(OBJECT_SELF), FALSE, 1.0f);
   }
   SetLocalInt(OBJECT_SELF, "RETREATED", 1);
   ActionDoCommand(SetLocalInt(OBJECT_SELF, "RETREATED", 0));
   ActionDoCommand(DestroyObject(OBJECT_SELF));
   SetCommandable(FALSE, OBJECT_SELF);
}

void dropValuables()
{
   object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_BELT);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_HEAD);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_NECK);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING);
   if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);

   oItem = GetFirstItemInInventory();
   while (oItem != OBJECT_INVALID)
   {
      if (GetGoldPieceValue(oItem) > 0) ActionPutDownItem(oItem);
      oItem = GetNextItemInInventory();
   }
}

void worship(object oPC = OBJECT_INVALID)
{
   //debugVarObject("worship()", oPC);
   if (oPC == OBJECT_INVALID)
   {
      object oShouter = GetLastSpeaker();
      object oPC = getPCSpeaker(oShouter);
   }
   //debugVarObject(GetName(OBJECT_SELF) + " worshipping", oPC);
   SpeakString("Hail " + GetName(oPC));
   ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
   ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 0.5, 30.0);
   // Minions will spread the word
   AdjustReputation(oPC, OBJECT_SELF, 1);
}

int countNearbyFriends()
{
   int nCount = 0;
   int nNth = 1;
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_NOT_PC, OBJECT_SELF, nNth, CREATURE_TYPE_IS_ALIVE, TRUE,
      CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
   while (oCreature != OBJECT_INVALID &&
          GetDistanceBetween(OBJECT_SELF, oCreature) <= 10.0f)
   {
      nCount++;
      nNth++;
      object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
         PLAYER_CHAR_NOT_PC, OBJECT_SELF, nNth, CREATURE_TYPE_IS_ALIVE, TRUE,
         CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
   }
   return nCount;
}

void surrender()
{
   //debug(GetName(OBJECT_SELF) + " surrendering");
   SpeakString("Surrender!", TALKVOLUME_TALK);
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_IS_ALIVE,
      TRUE, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
   //debugVarObject("oPC", oPC);
   setPCSpeaker(oPC);
   SurrenderToEnemies();
   SetLocalInt(OBJECT_SELF, VAR_NW_GENERIC_SURRENDER, TRUE); // see nw_i0_generic
   SpeakString(SHOUT_SURRENDER, TALKVOLUME_SILENT_TALK);
   ActionStartConversation(oPC, "surrender");
}

void giveXPByAlignment(object oPC, int nXP, int nQuestAlignment = ALIGNMENT_ALL)
{
   if (oPC == OBJECT_INVALID) return;
   int nAlignValue = 100;
   switch(nQuestAlignment)
   {
      case ALIGNMENT_ALL:
         nAlignValue = 100;
         break;
      case ALIGNMENT_NEUTRAL:
         nAlignValue = 100 - abs(GetLawChaosValue(oPC) - 50) -
            abs(GetGoodEvilValue(oPC) - 50);
         break;
      case ALIGNMENT_CHAOTIC:
         nAlignValue = 100 - GetLawChaosValue(oPC);
         break;
      case ALIGNMENT_EVIL:
         nAlignValue = 100 - GetGoodEvilValue(oPC);
         break;
      case ALIGNMENT_GOOD:
         nAlignValue = GetGoodEvilValue(oPC);
         break;
      case ALIGNMENT_LAWFUL:
         nAlignValue = GetLawChaosValue(oPC);
         break;
      default:
         logError("Unknown alignment in giveXPByAlignment: " + IntToString(nQuestAlignment));
         nAlignValue = 100;
         break;
   }
   // Scale XP based on how you're following your alignment
   GiveXPToCreature(oPC, nXP * nAlignValue / 100);
}

// XP awarded for "surrender" dialog actions which allow oCreature to live.
// This may be awarded twice, once for Law/Chaos actions and once for Good/Evil.
// In general, the Evil action will generate its own XP by resuming combat.
int getDialogXP(object oCreature, object oPC)
{
   int nCreatureHD = GetHitDice(oCreature);
   int nPCHD = GetHitDice(oPC);

   // For now, a very simple scale that will make XP relevant for all levels
   int nXP = nCreatureHD * nPCHD * 10 * GetModuleXPScale() / 100;

   return nXP;
}

//void main() {} // testing/compiling purposes
