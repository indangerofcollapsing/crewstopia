// Underwater areas
// Air breathing creatures will drown without help
#include "inc_heartbeat"
#include "prc_alterations"
#include "inc_debug_dac"

void takeDeepBreath(object oCreature);
void doBreathHold(object oCreature);
void doUnderwaterEffects(object oCreature, int nOpacity = 0);
void showBreathsLeft(object oCreature);
int isWaterBreather(object oCreature);
int isAquatic(object oCreature);

const string VAR_BREATH_HOLD = "BREATHS_LEFT";

// Gnomish SCUBA Helmet
const string TAG_SCUBA_HELMET = "dac_scuba";
// Gnomish aquatic suits
const string TAG_AQUATIC_SUIT = "dac_aquaticsuit";
// Gnomish flippers
const string TAG_FLIPPERS = "dac_flippers";
// Gnomish Amulet of Water Breathing
const string TAG_WATER_BREATHER = "dac_h2o_breather";

// token (undroppable, unpickpocketable) to put in water breather inventory
const string RESREF_WATER_BREATHER_TOKEN = "dac_h2o_breather";
// token (undroppable, unpickpocketable) to put in aquatic creature inventory
const string RESREF_AQUATIC_TOKEN = "dac_i_am_aquatic";

void takeDeepBreath(object oCreature)
{
   if (isWaterBreather(oCreature)) return;

   //debugMsg(GetName(oCreature) + " takes a deep breath.");
   // take a breath and hold it as long as you can
   int nBreaths = GetAbilityModifier(ABILITY_CONSTITUTION, oCreature) + 4;
   SetLocalInt(oCreature, VAR_BREATH_HOLD, nBreaths);
   showBreathsLeft(oCreature);
}

// each round
void doBreathHold(object oCreature)
{
   //debugVarObject("doBreathHold", oCreature);
   if (isWaterBreather(oCreature)) return;

   //debugVarObject("holding breath", oCreature);

   // number of rounds the creature can hold his breath
   int nBreaths = GetLocalInt(oCreature, VAR_BREATH_HOLD);
   //debugMsg("nBreaths = " + IntToString(nBreaths) + " for " + GetName(oCreature));
   if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
   {
      switch (nBreaths)
      {
         case 5:
            FloatingTextStringOnCreature("Running low on breath.", oCreature);
            break;
         case 3:
            FloatingTextStringOnCreature("Running out of breath!", oCreature);
            break;
         case 1:
            FloatingTextStringOnCreature("I'm almost out of breath!", oCreature);
            break;
         case 0:
         case -1:
         case -2:
         case -3:
         case -4:
         case -5:
            FloatingTextStringOnCreature(">>> I'm drowning! <<<", oCreature);
            break;
         default:
            break;
      }
   }
   else
   {
      // if the creature has a SCUBA helmet, use it
      if ((GetLocalInt(oCreature, VAR_BREATH_HOLD) <= 1) &&
          (GetTag(GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature)) == TAG_SCUBA_HELMET)
         )
      {
         //debugMsg(GetName(oCreature) + " uses their SCUBA helmet.");
         FloatingTextStringOnCreature("  o", oCreature);
         FloatingTextStringOnCreature("o  ", oCreature);
         FloatingTextStringOnCreature(" o ", oCreature);
         FloatingTextStringOnCreature("o  ", oCreature);
         FloatingTextStringOnCreature(" o ", oCreature);
         takeDeepBreath(oCreature);
         nBreaths = GetLocalInt(oCreature, VAR_BREATH_HOLD);
      }
   }
   if (nBreaths < 0)
   {
      FloatingTextStringOnCreature("I'm drowning!", oCreature);
      // anyone will drown in 6 rounds (unless they regenerate)
      int nMaxHP = GetMaxHitPoints(oCreature);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nMaxHP / 6),
         oCreature);
      // lingering effects after being pulled out of the water
/*
      int nCNMod = GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
         EffectAbilityDecrease(ABILITY_CONSTITUTION, -1), oCreature,
         (0 - nBreaths) * DURATION_1_ROUND);
*/
   }

   //debugMsg("decrementing breaths for " + GetName(oCreature));
   SetLocalInt(oCreature, VAR_BREATH_HOLD, --nBreaths);

   //debugMsg("calling ShowBreathsLeft for " + GetName(oCreature));
   showBreathsLeft(oCreature);
}

// each round
void doUnderwaterEffects(object oCreature, int nOpacity = 0)
{
   //debugVarObject("doUnderwaterEffects", oCreature);
   if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
   if (GetIsDead(oCreature)) return;

//   effect eConceal = EffectConcealment(nOpacity);
//   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oCreature, DURATION_1_ROUND);

   if (! isAquatic(oCreature))
   {
      effect eSlow = EffectSlow();
      if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
      {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oCreature, DURATION_1_ROUND);
      }
   }

   if (! isWaterBreather(oCreature))
   {
      doBreathHold(oCreature);
   }
}

void showBreathsLeft(object oCreature)
{
   //debugMsg(GetName(oCreature) + " show breaths yet:");
   // do a visual representation of your breath-holding capacity
   int nBreaths = GetLocalInt(oCreature, VAR_BREATH_HOLD);
   //debugMsg(GetName(oCreature) + " breaths left = " + IntToString(nBreaths));
   string sIndicator = "";
   for (; nBreaths > 0; nBreaths--)
   {
      sIndicator += "*";
   }
   //debugMsg(GetName(oCreature) + " breaths left: " + sIndicator);
   AssignCommand(oCreature, SpeakString(sIndicator, TALKVOLUME_WHISPER));
}

int isWaterBreather(object oCreature)
{
   // PrC Feats
   if (GetHasFeat(4641, oCreature)) return TRUE; // Nixie_Waterbreathing
   if (GetHasFeat(4793, oCreature)) return TRUE; // Water_Breathing
   
   // water breathers should have this token in their inventory
   if (GetItemPossessedBy(oCreature, RESREF_WATER_BREATHER_TOKEN) != OBJECT_INVALID)
   {
      //debugMsg(GetName(oCreature) + " is a water breather.");
      return TRUE;
   }

   object oAmulet = GetItemInSlot(INVENTORY_SLOT_NECK, oCreature);
   if (GetTag(oAmulet) == TAG_WATER_BREATHER) return TRUE;

   // these races are immune to drowning
   int nRacialType = MyPRCGetRacialType(oCreature);
   if ((nRacialType == RACIAL_TYPE_CONSTRUCT) ||
       (nRacialType == RACIAL_TYPE_ELEMENTAL) ||
       (nRacialType == RACIAL_TYPE_OOZE) ||
       (nRacialType == RACIAL_TYPE_UNDEAD)
      )
   {
      //debugMsg(GetName(oCreature) + "'s race is immune to drowning.");
      return TRUE;
   }

   // Finally, check for standard creatures
   string sResRef = GetResRef(oCreature);
   string sName = GetName(oCreature);
   if (FindSubString(sResRef, "_crab") != -1 ||
       FindSubString(sResRef, "_otter") != -1 ||
       FindSubString(sResRef, "_shark") != -1 ||
       FindSubString(sResRef, "_fish") != -1 ||
       FindSubString(sResRef, "_clam") != -1 ||
       FindSubString(sResRef, "_lobster") != -1 ||
       FindSubString(sResRef, "_aquatic") != -1 ||
       FindSubString(sResRef, "_sahuagin") != -1 ||
       FindSubString(sResRef, "_kuotoa") != -1 ||
       FindSubString(sResRef, "_frog") != -1 ||
       FindSubString(sResRef, "_turtle") != -1 ||
       FindSubString(sResRef, "_leviathan") != -1 ||
       FindSubString(sResRef, "_croc") != -1 ||
       FindSubString(sResRef, "gator") != -1 ||
       FindSubString(sResRef, "_nixie") != -1 ||
       FindSubString(sName, "quatic") != -1
      )
   {
      return TRUE;
   }

   // water breathers should all have this feat on their skin:
   // Immunity, Specific Spell: Drown
   // But tracking it down is a hassle and expensive CPU-wise

   //debugMsg(GetName(oCreature) + " is not a water breather.");
   return FALSE;
}

int isAquatic(object oCreature)
{
   // aquatic creatures should have this token in their inventory
   if (GetItemPossessedBy(oCreature, RESREF_AQUATIC_TOKEN) != OBJECT_INVALID)
   {
      //debugMsg(GetName(oCreature) + " is aquatic.");
      return TRUE;
   }

   object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
   if (GetTag(oArmor) == TAG_AQUATIC_SUIT) return TRUE;
   if (FindSubString(GetName(oArmor), "Aquatic") != -1) return TRUE;

   object oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
   if (GetTag(oBoots) == TAG_FLIPPERS) return TRUE;

   // Finally, check for standard creatures
   string sResRef = GetResRef(oCreature);
   string sName = GetName(oCreature);
   if (FindSubString(sResRef, "_crab") != -1 ||
       FindSubString(sResRef, "_otter") != -1 ||
       FindSubString(sResRef, "_shark") != -1 ||
       FindSubString(sResRef, "_fish") != -1 ||
       FindSubString(sResRef, "_clam") != -1 ||
       FindSubString(sResRef, "_lobster") != -1 ||
       FindSubString(sResRef, "_aquatic") != -1 ||
       FindSubString(sResRef, "_sahuagin") != -1 ||
       FindSubString(sResRef, "_kuotoa") != -1 ||
       FindSubString(sResRef, "_frog") != -1 ||
       FindSubString(sResRef, "_turtle") != -1 ||
       FindSubString(sResRef, "_leviathan") != -1 ||
       FindSubString(sResRef, "_croc") != -1 ||
       FindSubString(sResRef, "gator") != -1 ||
       FindSubString(sResRef, "_nixie") != -1 ||
       FindSubString(sName, "quatic") != -1
      )
   {
      return TRUE;
   }

   //debugMsg(GetName(oCreature) + " is not aquatic.");
   return FALSE;
}

//void main() {} // testing/compiling purposes
