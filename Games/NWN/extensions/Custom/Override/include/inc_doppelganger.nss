#include "inc_debug_dac"
#include "inc_appearance"
#include "nw_i0_plot"
#include "NW_I0_GENERIC"

const string RESREF_YOUNG = "dac_dopp_05";
const string RESREF_YOUNG_ADULT = "dac_dopp_10";
const string RESREF_ADULT = "dac_dopp_15";
const string RESREF_ELDER = "dac_dopp_20";
const string RESREF_EPIC = "dac_dopp_25";
const string RESREF_WARRIOR = "dac_dopp_30";
const string RESREF_LORD = "dac_dopp_35";
const string RESREF_PRINCE = "dac_dopp_40";

const string VAR_APPEARANCE = "true_appearance";
const string VAR_TRUE_NAME = "true_name";
const string VAR_IS_CLOAKED = "DOPPELGANGER_IS_CLOAKED";
// What percentage of seemingly helpless civilians are actually doppelgangers?
const string VAR_DOPPELGANGER_CHANCE = "DOPPELGANGER_CHANCE";

void doppelgangerUncloak(object oPC = OBJECT_INVALID);
void takeShapeOf(object oAttacker = OBJECT_INVALID);
void revertToTrueForm();
int isDoppelganger(object oCreature = OBJECT_SELF);
void doppelgangerEvent(int nUserDefinedEventNumber);
void copyItem(int nInventorySlot, object oCreature);

// If disguised, revert to true form
void doppelgangerUncloak(object oPC = OBJECT_INVALID)
{
   //debugVarObject("doppelgangerUncloak()", OBJECT_SELF);

   // This is the PC (and party) that we'll key our CR off of.
   if (oPC == OBJECT_INVALID) oPC = GetNearestPC();

   if (GetStringLeft(GetResRef(OBJECT_SELF), 8) != "dac_dopp")
   {
      location lHere = GetLocation(OBJECT_SELF);
      string sResRef = RESREF_YOUNG;
      int nPartyCR = 0;
      object oPartyMember = GetFactionLeader(oPC);
      do
      {
         // GetChallengeRating does not seem to work for PCs
         nPartyCR += GetHitDice(oPartyMember);
         oPartyMember = GetNextFactionMember(oPartyMember);
      } while (oPartyMember != OBJECT_INVALID);
      // GAME_DIFFICULTY_VERY_EASY=0
      // GAME_DIFFICULTY_EASY=1
      // GAME_DIFFICULTY_NORMAL=2
      // GAME_DIFFICULTY_CORE_RULES=3
      // GAME_DIFFICULTY_DIFFICULT=4
      // Scale randomly between 60% and 150% of CR, depending on game difficulty
      nPartyCR = nPartyCR * (6 + GetGameDifficulty() + Random(5)) / 10;
      //debug("party CR = " + IntToString(nPartyCR));
      if (nPartyCR <= 5) sResRef = RESREF_YOUNG;
      else if (nPartyCR <= 10) sResRef = RESREF_YOUNG_ADULT;
      else if (nPartyCR <= 15) sResRef = RESREF_ADULT;
      else if (nPartyCR <= 20) sResRef = RESREF_ELDER;
      else if (nPartyCR <= 25) sResRef = RESREF_EPIC;
      else if (nPartyCR <= 30) sResRef = RESREF_WARRIOR;
      else if (nPartyCR <= 35) sResRef = RESREF_LORD;
      else sResRef = RESREF_PRINCE;
      //debug("spawning " + sResRef);
      object oDoppelganger = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lHere);
      // doppelganger princes can spawn in minions to scale up encounters
      nPartyCR -= 40; // we've already spawned the prince himself
      do
      {
         nPartyCR -= 10;
         if (nPartyCR > 0)
         {
            CreateObject(OBJECT_TYPE_CREATURE, RESREF_YOUNG_ADULT, lHere);
         }
      } while (nPartyCR > 0);

      // BESIE respawners will get confused if the original creature disappears
      object oSpawner = GetLocalObject(OBJECT_SELF, "re_oRandomEncounterSpawner");
      if (oSpawner != OBJECT_INVALID)
      {
         SetLocalObject(oSpawner, "re_oLastRandomEncounterSpawned", oDoppelganger);
      }

      SetPlotFlag(OBJECT_SELF, FALSE);
      SetIsDestroyable(TRUE, FALSE, FALSE);
      DestroyObject(OBJECT_SELF);
   }
   else
   {
      revertToTrueForm();
      SetIsTemporaryEnemy(GetLastPCRested());
      DetermineCombatRound();
   }
}

void takeShapeOf(object oCreature = OBJECT_INVALID)
{
   //debugVarObject("takeShapeOf()", OBJECT_SELF);
   //debugVarObject("oCreature", oCreature);
   if (oCreature == OBJECT_INVALID)
   {
      oCreature = GetNearestObject(OBJECT_TYPE_CREATURE);
   }
   //debugVarObject("oCreature", oCreature);

   // If names match, we are already mimicking this creature
   if (GetName(OBJECT_SELF) == GetName(oCreature)) return;

   // save original appearance for death
   int nAppearanceType = GetLocalInt(OBJECT_SELF, VAR_APPEARANCE);
   if (nAppearanceType == 0)
   {
      // still in original form, save for later
      SetLocalInt(OBJECT_SELF, VAR_APPEARANCE, GetAppearanceType(OBJECT_SELF));
   }
   nAppearanceType = GetAppearanceType(oCreature);
   //debugVarInt("nAppearanceType", nAppearanceType);

   if (nAppearanceType != APPEARANCE_TYPE_INVALID)
   {
      // PC appearances appear headless, so normalize to NPC.
      // Doppelganger model does not include customizable body parts,
      // so SetCreatureBodyPart() is not helpful.
      switch (nAppearanceType)
      {
         case APPEARANCE_TYPE_DWARF:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_DWARF_NPC_FEMALE : APPEARANCE_TYPE_DWARF_NPC_MALE);
            break;
         case APPEARANCE_TYPE_ELF:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_ELF_NPC_FEMALE : APPEARANCE_TYPE_ELF_NPC_MALE_02);
            break;
         case APPEARANCE_TYPE_HUMAN:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_HUMAN_NPC_FEMALE_07 :
               APPEARANCE_TYPE_HUMAN_NPC_MALE_04);
            break;
         case APPEARANCE_TYPE_HALFLING:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_HALFLING_NPC_FEMALE :
               APPEARANCE_TYPE_HALFLING_NPC_MALE);
            break;
         case APPEARANCE_TYPE_HALF_ELF:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02 :
               APPEARANCE_TYPE_HUMAN_NPC_MALE_02);
            break;
         case APPEARANCE_TYPE_HALF_ORC:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE :
               APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01);
            break;
         case APPEARANCE_TYPE_GNOME:
            nAppearanceType = (GetGender(oCreature) == GENDER_FEMALE ?
               APPEARANCE_TYPE_GNOME_NPC_FEMALE : APPEARANCE_TYPE_GNOME_NPC_MALE);
            break;
         default:
            // nothing
            break;
      }
/* Leaving this part in, just in case the doppelganger model gets dynamic.
      // Mimicking a PC creates a headless torso without these.
      SetCreatureBodyPart(CREATURE_PART_HEAD,
         GetCreatureBodyPart(CREATURE_PART_HEAD, oCreature));
      SetCreatureBodyPart(CREATURE_PART_PELVIS,
         GetCreatureBodyPart(CREATURE_PART_PELVIS, oCreature));
      SetCreatureBodyPart(CREATURE_PART_TORSO,
         GetCreatureBodyPart(CREATURE_PART_TORSO, oCreature));
      SetCreatureBodyPart(CREATURE_PART_BELT,
         GetCreatureBodyPart(CREATURE_PART_BELT, oCreature));
      SetCreatureBodyPart(CREATURE_PART_NECK,
         GetCreatureBodyPart(CREATURE_PART_NECK, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,
         GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,
         GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,
         GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,
         GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,
         GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,
         GetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, oCreature));
      SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,
         GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oCreature));
      SetCreatureBodyPart(CREATURE_PART_LEFT_HAND,
         GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oCreature));
*/
      // Copy items that change visible look
      copyItem(INVENTORY_SLOT_RIGHTHAND, oCreature);
      copyItem(INVENTORY_SLOT_LEFTHAND, oCreature);
//      copyItem(INVENTORY_SLOT_CHEST, oCreature);
//      copyItem(INVENTORY_SLOT_HEAD, oCreature);
//      copyItem(INVENTORY_SLOT_CLOAK, oCreature);
      SetCreatureAppearanceType(OBJECT_SELF, nAppearanceType);
      SetLocalString(OBJECT_SELF, VAR_TRUE_NAME, GetName(OBJECT_SELF));
      SetName(OBJECT_SELF, GetName(oCreature));
      SetLocalInt(OBJECT_SELF, VAR_IS_CLOAKED, TRUE);
   }
   else
   {
      logError("Appearance is invalid!");
   }
}

void revertToTrueForm()
{
   //debugVarObject("revertToTrueForm()", OBJECT_SELF);
   int nAppearanceType = GetLocalInt(OBJECT_SELF, VAR_APPEARANCE);
   SetCreatureAppearanceType(OBJECT_SELF, nAppearanceType);
   SetLocalInt(OBJECT_SELF, VAR_IS_CLOAKED, FALSE);
   SetName(OBJECT_SELF, GetLocalString(OBJECT_SELF, VAR_TRUE_NAME));
}

int isDoppelganger(object oCreature = OBJECT_SELF)
{
   //debugVarObject("isDoppelganger()", OBJECT_SELF);
   //debugVarString("resref", GetResRef(oCreature));
   // not perfect, but it'll have to do
   int bIsDopp = (FindSubString(GetResRef(oCreature), "dopp") != -1);
   //debugVarBoolean("bIsDopp", bIsDopp);
   return bIsDopp;
}

// called from on_user_event script (usually nw_c2_defaultd)
void doppelgangerEvent(int nUserDefinedEventNumber)
{
   //debugVarObject("doppelgangerEvent()", OBJECT_SELF);
   //debugVarInt("nUserDefinedEventNumber", nUserDefinedEventNumber);

   switch(nUserDefinedEventNumber)
   {
      case EVENT_ATTACKED:
//debug("doppelganger attacked!");
         takeShapeOf(GetLastAttacker());
         break;
      case EVENT_DAMAGED:
//debug("doppelganger damaged!");
         takeShapeOf(GetLastDamager());
         break;
      case EVENT_SPELL_CAST_AT:
         if (GetLastSpellHarmful()) doppelgangerUncloak();
         break;
      case EVENT_DIALOGUE:
      case EVENT_DISTURBED:
      case EVENT_END_COMBAT_ROUND:
      case EVENT_HEARTBEAT:
      case EVENT_PERCEIVE:
         // nothing
         break;
      default:
         logError("ERROR: undefined user event " +
            IntToString(GetUserDefinedEventNumber()) + " in doppelgangerEvent()");
   }
}

void copyItem(int nInventorySlot, object oCreature)
{
   object oItem = GetItemInSlot(nInventorySlot, oCreature);
   if (oItem != OBJECT_INVALID)
   {
      object oMyItem = CopyItem(oItem, OBJECT_SELF, TRUE);
      SetDroppableFlag(oMyItem, FALSE);
      ActionEquipItem(oMyItem, nInventorySlot);
   }
}

//void main() {} // compiling/testing purposes

