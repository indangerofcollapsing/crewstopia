// CEP Mounts and Flying phenotypes (with ACP support)
// Based on zep_inc_phenos

#include "zep_inc_constant"
#include "prc_alterations"
#include "inc_variables"
#include "inc_nbde"
#include "inc_debug_dac"

// Constants (DO NOT CHANGE)
const float DEFAULT_SPEED = 1000.0;
const int NO_CHANGE = -1;
const int PHENO_SWITCH_RESET = -1;
const int PHENO_SWITCH_TOGGLE = 0;
const int PHENO_SWITCH_FLY = 1;
const string VAR_TRUE_APPEARANCE = "TRUE_APPEARANCE";
const string VAR_TRUE_PHENO = "TRUE_PHENOTYPE";
const string VAR_TRUE_WINGTYPE = "TRUE_WINGTYPE";
const string VAR_TRUE_SPEED = "TRUE_SPEED";
const string VAR_APPEARANCE_MODIFIED = "APPEARANCE_IS_MODIFIED";
const string VAR_PHENO_MODIFIED = "PHENO_IS_MODIFIED";
const string VAR_WINGTYPE_MODIFIED = "WINGTYPE_IS_MODIFIED";
const string VAR_SPEED_MODIFIED = "SPEED_IS_MODIFIED";

// Phenotypes (see phenotype.2da)
const int PHENO_NORMAL = 0;
const int PHENO_LARGE = 2;
const int PHENO_KENSAI = 5;
const int PHENO_ASSASSIN = 6;
const int PHENO_HEAVY = 7;
const int PHENO_FENCING = 8;
const int PHENO_HORSE_WHITE = 10;
const int PHENO_HORSE_BLACK = 11;
const int PHENO_NIGHTMARE = 12;
const int PHENO_AURENTHIL = 13;
const int PHENO_PONY_BROWN = 14;
const int PHENO_PONY_LIGHT = 15;
const int PHENO_FLYING = 16;
const int PHENO_HORSE_BROWN = 17;
const int PHENO_PONY_S = 18;
const int PHENO_FLYING_LARGE = 25;
const int PHENO_HORSE_BROWN_LARGE = 27;
const int PHENO_PONY_S_LARGE = 28;
const int PHENO_HORSE_WHITE_LARGE = 30;
const int PHENO_HORSE_BLACK_LARGE = 31;
const int PHENO_NIGHTMARE_LARGE = 32;
const int PHENO_AURENTHIL_LARGE = 33;
const int PHENO_PONY_BROWN_LARGE = 34;
const int PHENO_PONY_LIGHT_LARGE = 35;

// Constants (CAN BE CHANGED by Users)
const float fSPEED_AURENTHIL = 2.5;
const float fSPEED_HORSE_BLACK = 2.2;
const float fSPEED_HORSE_BROWN = 2.2;
const float fSPEED_HORSE_NIGHTMARE = 2.4;
const float fSPEED_HORSE_WHITE = 2.2;
const float fSPEED_PONY_BROWN = 1.9;
const float fSPEED_PONY_LTBROWN = 1.9;
const float fSPEED_PONY_SPOT = 1.9;

/**
 * Toggle "fly" phenotype
 * @param nWingType
 *    nCEP_WG_ANGEL nCEP_WG_ANGEL_ARMORED nCEP_WG_ANGEL_FALLEN
 *    nCEP_WG_ANGEL_SKIN
 *    nCEP_WG_BAT nCEP_WG_BAT_SKIN
 *    nCEP_WG_BIRD nCEP_WG_BIRD_BLUE nCEP_WG_BIRD_DARK nCEP_WG_BIRD_KENKU
 *    nCEP_WG_BIRD_RAVEN nCEP_WG_BIRD_RED nCEP_WG_BIRD_SKIN
 *    nCEP_WG_BUTTERFLY nCEP_WG_BUTTERFLY_BLACK nCEP_WG_BUTTERFLY_BLUE
 *    nCEP_WG_BUTTERFLY_BRGBLUE nCEP_WG_BUTTERFLY_DKFOREST
 *    nCEP_WG_BUTTERFLY_FOREST nCEP_WG_BUTTERFLY_GREENGOLD
 *    nCEP_WG_BUTTERFLY_ICEGREEN nCEP_WG_BUTTERFLY_MAUVE
 *    nCEP_WG_BUTTERFLY_ORANGE nCEP_WG_BUTTERFLY_RED nCEP_WG_BUTTERFLY_SIENNA
 *    nCEP_WG_BUTTERFLY_SKIN nCEP_WG_BUTTERFLY_VIOLET
 *    nCEP_WG_BUTTERFLY_VIOLETGOLD nCEP_WG_BUTTERFLY_YELLOW
 *    nCEP_WG_DEMON nCEP_WG_DEMON_BALOR nCEP_WG_DEMON_BLUE_TRANS
 *    nCEP_WG_DEMON_ERINYES nCEP_WG_DEMON_MEPHISTO nCEP_WG_DEMON_RED_TRANS
 *    nCEP_WG_DEMON_SKIN
 *    nCEP_WG_DRAGON_BIG nCEP_WG_DRAGON_BLACK nCEP_WG_DRAGON_BLUE
 *    nCEP_WG_DRAGON_BRASS nCEP_WG_DRAGON_BRONZE nCEP_WG_DRAGON_COPPER
 *    nCEP_WG_DRAGON_DRACOLICH nCEP_WG_DRAGON_GOLD nCEP_WG_DRAGON_GREEN
 *    nCEP_WG_DRAGON_PRISMATIC nCEP_WG_DRAGON_RED nCEP_WG_DRAGON_SHADOW
 *    nCEP_WG_DRAGON_SILVER nCEP_WG_DRAGON_SKIN nCEP_WG_DRAGON_WHITE
 *    nCEP_WG_FLYING_ANGEL
 *    nCEP_WG_FLYING_DEMON_1 nCEP_WG_FLYING_DEMON_2
 *    nCEP_WG_GARGOYLE
 *    nCEP_WG_HALFDRAGON_GOLD nCEP_WG_HALFDRAGON_SILVER
 * @param fSpeed Speed in meters/s (Human = 1.6)
 * @param sResRef Object to create or remove after phenotype change
 */
void setPhenoFly(object oCreature, int nSwitchType = PHENO_SWITCH_TOGGLE,
   int nWingType = NO_CHANGE, float fSpeed = DEFAULT_SPEED,
   string sResRef = "");
void setWings(object oCreature, int nWingType = NO_CHANGE);
void setSpeed(object oCreature, float fSpeed = DEFAULT_SPEED);

void setPhenoFly(object oCreature, int nSwitchType = PHENO_SWITCH_TOGGLE,
   int nWingType = NO_CHANGE, float fSpeed = DEFAULT_SPEED,
   string sResRef = "")
{

// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
if (! GetIsPC(oCreature)) return; // @FIX
// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
// *** *** *** *** *** *** *** *** *** *** *** *** *** ***

   debugVarObject("setPhenoFly()", OBJECT_SELF);
   debugVarObject("oCreature", oCreature);
   if (! GetIsObjectValid(oCreature))
   {
      debugMsg("not valid");
      return;
   }
   if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
   {
      debugMsg("not creature");
      return;
   }

   int nAppearance = GetAppearanceType(oCreature);
   if (nAppearance == APPEARANCE_TYPE_INVALID)
   {
      debugMsg("appearance invalid");
      return;
   }

   int nPheno = GetPhenoType(oCreature);
   debugVarInt("nPheno", nPheno);

   int nNewPheno = NO_CHANGE;
   int nNewAppearance = NO_CHANGE;
   switch (nAppearance)
   {
      case nCEP_APP_ERINYES:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_ERINYES : nCEP_APP_ERINYES_FLY);
         break;
      case nCEP_APP_ERINYES_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_ERINYES_FLY : nCEP_APP_ERINYES);
         break;
      case nCEP_APP_KOBOLD_A:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_A : nCEP_APP_KOBOLD_A_FLY);
         break;
      case nCEP_APP_KOBOLD_A_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_A_FLY : nCEP_APP_KOBOLD_A);
         break;
      case nCEP_APP_KOBOLD_B:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_B : nCEP_APP_KOBOLD_B_FLY);
         break;
      case nCEP_APP_KOBOLD_B_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_B_FLY : nCEP_APP_KOBOLD_B);
         break;
      case nCEP_APP_KOBOLD_CH_A:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_CH_A : nCEP_APP_KOBOLD_CH_A_FLY);
         break;
      case nCEP_APP_KOBOLD_CH_A_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_CH_A_FLY : nCEP_APP_KOBOLD_CH_A);
         break;
      case nCEP_APP_KOBOLD_CH_B:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_CH_B : nCEP_APP_KOBOLD_CH_B_FLY);
         break;
      case nCEP_APP_KOBOLD_CH_B_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_CH_B_FLY : nCEP_APP_KOBOLD_CH_B);
         break;
      case nCEP_APP_KOBOLD_SH_A:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_SH_A : nCEP_APP_KOBOLD_SH_A_FLY);
         break;
      case nCEP_APP_KOBOLD_SH_A_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_SH_A_FLY : nCEP_APP_KOBOLD_SH_A);
         break;
      case nCEP_APP_KOBOLD_SH_B:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_KOBOLD_SH_B : nCEP_APP_KOBOLD_SH_B_FLY);
         break;
      case nCEP_APP_KOBOLD_SH_B_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_KOBOLD_SH_B_FLY : nCEP_APP_KOBOLD_SH_B);
         break;
      case nCEP_APP_SUCCUBUS:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_SUCCUBUS : nCEP_APP_SUCCUBUS_FLY);
         break;
      case nCEP_APP_SUCCUBUS_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_SUCCUBUS_FLY : nCEP_APP_SUCCUBUS);
         break;
      case nCEP_APP_VAMPIRE_F:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_VAMPIRE_F : nCEP_APP_VAMPIRE_F_FLY);
         break;
      case nCEP_APP_VAMPIRE_F_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_VAMPIRE_F_FLY : nCEP_APP_VAMPIRE_F);
         break;
      case nCEP_APP_VAMPIRE_M:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_RESET ?
            nCEP_APP_VAMPIRE_M : nCEP_APP_VAMPIRE_M_FLY);
         break;
      case nCEP_APP_VAMPIRE_M_FLY:
         nNewAppearance = (nSwitchType == PHENO_SWITCH_FLY ?
            nCEP_APP_VAMPIRE_M_FLY : nCEP_APP_VAMPIRE_M);
         break;
      case nCEP_APP_BROWNIE_DYN:
      case nCEP_APP_SKELETON_DYN:
      case APPEARANCE_TYPE_DWARF:
      case APPEARANCE_TYPE_ELF:
      case APPEARANCE_TYPE_GNOME:
      case APPEARANCE_TYPE_HALF_ELF:
      case APPEARANCE_TYPE_HALF_ORC:
      case APPEARANCE_TYPE_HALFLING:
      case APPEARANCE_TYPE_HUMAN:
         switch(nPheno)
         {
            case PHENO_NORMAL:
            case PHENO_KENSAI:
            case PHENO_ASSASSIN:
            case PHENO_HEAVY:
            case PHENO_FENCING:
               nNewPheno = (nSwitchType == PHENO_SWITCH_RESET ? nPheno :
                  PHENO_FLYING);
               setPersistentInt(oCreature, VAR_TRUE_PHENO, nPheno);
               break;
            case PHENO_LARGE:
               nNewPheno = (nSwitchType == PHENO_SWITCH_RESET ? nPheno :
                  PHENO_FLYING_LARGE);
               break;
            case PHENO_FLYING_LARGE:
               // Large phenos can't use ACP
               nNewPheno = (nSwitchType == PHENO_SWITCH_FLY ? nPheno :
                  PHENO_LARGE);
               break;
            case PHENO_FLYING:
               // Restore the chosen ACP fighting style.
               // "variable not set" returns PHENO_NORMAL; no need for failsafe
               nNewPheno = (nSwitchType == PHENO_SWITCH_FLY ? nPheno :
                  getPersistentInt(oCreature, VAR_TRUE_PHENO));
               break;
            case PHENO_HORSE_WHITE:
            case PHENO_HORSE_BLACK:
            case PHENO_NIGHTMARE:
            case PHENO_AURENTHIL:
            case PHENO_PONY_BROWN:
            case PHENO_PONY_LIGHT:
            case PHENO_HORSE_BROWN:
            case PHENO_PONY_S:
            case PHENO_HORSE_BROWN_LARGE:
            case PHENO_PONY_S_LARGE:
            case PHENO_HORSE_WHITE_LARGE:
            case PHENO_HORSE_BLACK_LARGE:
            case PHENO_NIGHTMARE_LARGE:
            case PHENO_AURENTHIL_LARGE:
            case PHENO_PONY_BROWN_LARGE:
            case PHENO_PONY_LIGHT_LARGE:
               if (GetIsPC(oCreature))
               {
                  SendMessageToPC(oCreature, "You must dismount first.");
               }
               break;
            default:
               logError("Unrecognized phenotype " + IntToString(nPheno) +
                  " in setPhenoFly() for " + objectToString(oCreature));
               break;
         } // switch(nPheno)
   } // switch(nAppearance)

   debugVarInt("nNewAppearance", nNewAppearance);
   if (nNewAppearance != NO_CHANGE)
   {
      debugVarObject("oCreature changing appearance", oCreature);
      SetCreatureAppearanceType(oCreature, nNewAppearance == ZERO_FLAG ? 0 :
         nNewAppearance);
      debugVarInt("oCreature's new appearance",
         GetAppearanceType(oCreature));
   }

   debugVarInt("nNewPheno", nNewPheno);
   if (nNewPheno != NO_CHANGE)
   {
      debugVarObject("oCreature changing pheno", oCreature);
      SetPhenoType(nNewPheno, oCreature);
      debugVarInt("oCreature's new pheno", GetPhenoType(oCreature));
   }

   if (nWingType != NO_CHANGE) setWings(oCreature, nWingType);

   if (fSpeed != DEFAULT_SPEED) setSpeed(oCreature, fSpeed);

   if (sResRef != "" &&
       GetItemPossessedBy(oCreature, sResRef) == OBJECT_INVALID)
   {
      object oItem = CreateItemOnObject(sResRef, oCreature);
      if (GetIsObjectValid(oItem)==FALSE)
      {
         logError("ERROR: in togglePhenoFLY: Create Item failed. Blueprint " +
            "with sResRef: " + sResRef + " does not exist or could not be " +
            "given to: " + objectToString(oCreature));
      }
  }
  debugVarInt("current pheno", GetPhenoType(oCreature));
}

void setWings(object oCreature, int nWingType = NO_CHANGE)
{
   debugVarObject("setWings()", oCreature);
   debugVarInt("nWingType", nWingType);
   if (nWingType == NO_CHANGE) return;

   int nCurrentWingType = GetCreatureWingType(oCreature);
   debugVarInt("nCurrentWingType", nCurrentWingType);
   int nTrueWingType = StringToInt(getPersistentString(oCreature,
      VAR_TRUE_WINGTYPE));
   debugVarInt("nTrueWingType", nTrueWingType);
   if (! nTrueWingType)
   {
      setPersistentString(oCreature, VAR_TRUE_WINGTYPE,
         IntToString(nCurrentWingType));
   }
   if (nCurrentWingType == nTrueWingType)
   {
      debugVarObject("keeping current wings", oCreature);
      return;
   }
   SetCreatureWingType(nWingType == 0 ? CREATURE_WING_TYPE_NONE : nWingType,
      oCreature);
}

void setSpeed(object oCreature, float fSpeed = DEFAULT_SPEED)
{
   debugVarObject("setSpeed", oCreature);
   debugVarFloat("fSpeed", fSpeed);
   if (fSpeed != DEFAULT_SPEED) return;

   int nAppearance = GetAppearanceType(oCreature);
   float fRaceSpeed = StringToFloat(Get2DAString("appearance", "WALKDIST",
      nAppearance));
   if (fRaceSpeed == 0.0)
   {
      SetLocalInt(oCreature, "nCEP_SPEED_EFFECT_C", 0);
      return;
   }

   if (getPersistentInt(oCreature, VAR_SPEED_MODIFIED))
   {
      int nSpeedAdjusted = GetLocalInt(oCreature, "nCEP_SPEED_EFFECT_C");
      int nEffType = (nSpeedAdjusted > 0 ? EFFECT_TYPE_MOVEMENT_SPEED_INCREASE :
         EFFECT_TYPE_MOVEMENT_SPEED_DECREASE);
      setPersistentInt(oCreature, VAR_SPEED_MODIFIED, FALSE);
      int bContinue = TRUE;
      effect eEff = GetFirstEffect(oCreature);
      while (GetIsEffectValid(eEff) && bContinue)
      {
         if (GetEffectType(eEff) == nEffType &&
             GetEffectDurationType(eEff) == DURATION_TYPE_PERMANENT &&
             GetEffectSpellId(eEff) == -1 &&
             GetEffectCreator(eEff) == OBJECT_SELF)
         {
            RemoveEffect(oCreature, eEff);
            bContinue = FALSE;
         }
         eEff = GetNextEffect(oCreature);
      }
      return;
   }

   // Modify for Haste/Slow
   int nHasteSlowMod = 0;
   effect eEff = GetFirstEffect(oCreature);
   while (GetIsEffectValid(eEff))
   {
      if (GetEffectType(eEff) == EFFECT_TYPE_HASTE) nHasteSlowMod++;
      if (GetEffectType(eEff) == EFFECT_TYPE_SLOW) nHasteSlowMod--;
      eEff = GetNextEffect(oCreature);
   }

   if (nHasteSlowMod > 0)
   {
      fRaceSpeed *= 1.5;
   }
   else
   {
      fRaceSpeed *= 0.5;
   }

   float fSpeedPercent = (fSpeed / fRaceSpeed) - 1.0;

   int nSpeedChange = FloatToInt(100 * fSpeedPercent);

   if (nSpeedChange < 0)
   {
      eEff = EffectMovementSpeedDecrease(-nSpeedChange);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oCreature);
      SetLocalInt(oCreature, "nCEP_SPEED_EFFECT_C", -1);
   }
   if (nSpeedChange > 0)
   {
      eEff = EffectMovementSpeedIncrease(nSpeedChange);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oCreature);
      SetLocalInt(oCreature, "nCEP_SPEED_EFFECT_C", 1);
   }

   setPersistentInt(oCreature, VAR_SPEED_MODIFIED, TRUE);
}

//void main() {} // Testing/compiling purposes
