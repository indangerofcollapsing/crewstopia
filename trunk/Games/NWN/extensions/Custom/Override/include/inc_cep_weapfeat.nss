// CEP weapon missing feats
// Currently handled:
//   Weapon Focus/Epic Weapon Focus
//   Weapon Specialization/Epic WSpec
//   Improved Critical
//   Weapon of Choice
//      Superior Weapon Focus/Epic SWFoc
//   Overwhelming Critical
//   Devastating Critical
//   Massive Criticals
//   Thundering Rage
// There's much that can't be done without cracking open the game engine,
// so most of this is a crude approximation of the true Feat behaviors.

#include "inc_prc_npc"
#include "prc_x2_itemprop" //#include "x2_inc_itemprop"
#include "inc_debug_dac"
#include "inc_item_props" // @DUG

void onEquipCEPWeapon();
void onUnequipCEPWeapon();
void onHitCEPWeapon();
void handleCriticalHit(object oWeapon, object oTarget);

const int BASE_ITEM_CEP_TRIDENT = 300;
const int BASE_ITEM_CEP_HEAVYPICK = 301;
const int BASE_ITEM_CEP_LIGHTPICK = 302;
const int BASE_ITEM_CEP_SAI = 303;
const int BASE_ITEM_CEP_NUNCHUKAU = 304;
const int BASE_ITEM_CEP_FALCHION = 305;
const int BASE_ITEM_CEP_SAP = 308;
const int BASE_ITEM_CEP_ASSASSINDAGGER = 309;
const int BASE_ITEM_CEP_KATAR = 310;
const int BASE_ITEM_CEP_LIGHTMACE = 312;
const int BASE_ITEM_CEP_KUKRI = 313;
const int BASE_ITEM_CEP_FALCHION2 = 316;
const int BASE_ITEM_CEP_HEAVYMACE = 317;
const int BASE_ITEM_CEP_MAUL = 318;
const int BASE_ITEM_CEP_MERCLONGSWORD = 319;
const int BASE_ITEM_CEP_MERCGREATSWORD = 320;
const int BASE_ITEM_CEP_DOUBLESCIMITAR = 321;
const int BASE_ITEM_CEP_GOAD = 322;
const int BASE_ITEM_CEP_WINDFIREWHEEL = 323;
const int BASE_ITEM_CEP_MAUGDOUBLESWORD = 324;
const int BASE_ITEM_CEP_LONGSWORD2 = 330;
const int BASE_ITEM_CEP_SHORTSWORD2 = 331;
const int BASE_ITEM_CEP_BATTLEAXE2 = 332;
const int BASE_ITEM_CEP_BASTARDSWORD2 = 333;
const int BASE_ITEM_CEP_WARHAMMER2 = 334;
const int BASE_ITEM_CEP_LONGBOW2 = 335;
const int BASE_ITEM_CEP_MACE2 = 336;
const int BASE_ITEM_CEP_HALBERD2 = 337;
const int BASE_ITEM_CEP_SHORTBOW2 = 338;
const int BASE_ITEM_CEP_TWOBLADEDSWORD2 = 339;
const int BASE_ITEM_CEP_GREATSWORD2 = 340;
const int BASE_ITEM_CEP_GREATAXE2 = 342;
const int BASE_ITEM_CEP_RAPIER2 = 343;
const int BASE_ITEM_CEP_SCIMITAR2 = 344;
const int BASE_ITEM_CEP_SPEAR2 = 347;
const int BASE_ITEM_CEP_DWARVENWARAXE2 = 348;

const int IP_CONST_ONHIT_CEP_WEAPON = 210; // from iprp_onhitspell.2da

// item variables to track the new and previous bonii
const string VAR_IP_ATTACK_BONUS_VALUE = "CEP_WEAPON_FEAT_IP_ATTACK_BONUS";
const string VAR_IP_ATTACK_BONUS_PREV_VALUE = "CEP_WEAPON_FEAT_IP_ATTACK_BONUS_PREV";
const string VAR_IP_DAMAGE_BONUS_VALUE = "CEP_WEAPON_FEAT_IP_DAMAGE_BONUS";
const string VAR_IP_DAMAGE_BONUS_PREV_VALUE = "CEP_WEAPON_FEAT_IP_DAMAGE_BONUS_PREV";
const string VAR_OWNER_HAS_IMP_CRIT = "OWNER_HAS_IMP_CRIT";
const string VAR_OWNER_HAS_OVER_CRIT = "OWNER_HAS_OVER_CRIT";
const string VAR_OWNER_HAS_DEV_CRIT = "OWNER_HAS_DEV_CRIT"; // value = DC
const string VAR_OWNER_HAS_WOC = "OWNER_HAS_WOC"; // Weapon Master Weapon of Choice
const string VAR_OWNER_HAS_KI_CRITICAL = "OWNER_HAS_KI_CRITICAL";
const string VAR_OWNER_HAS_INC_MULTIPLIER = "OWNER_HAS_INC_MULTIPLIER";
const string VAR_CRIT_RANGE = "CRITICAL_RANGE";
const string VAR_CRIT_MULT = "CRITICAL_MULTIPLIER";
const string VAR_DAMAGE_DICE = "DAMAGE_DICE";
const string VAR_DAMAGE_DICE_TYPE = "DAMAGE_DICE_TYPE";
const string VAR_DAMAGE_TYPE = "DAMAGE_TYPE";

void onEquipCEPWeapon()
{
   //debugVarObject("onEquipCEPWeapon()", OBJECT_SELF);

   int bHasImpCrit = FALSE;
   int bHasWeaponFocus = FALSE;
   int bHasWeaponSpec = FALSE;
   int bHasEpicWeaponFocus = FALSE;
   int bHasEpicWeaponSpec = FALSE;
   int bHasOverCrit = FALSE;
   int bHasDevCrit = FALSE;
   int bHasWeaponOfChoice = FALSE;

   object oWeapon = GetPCItemLastEquipped();
   //debugVarObject("oWeapon", oWeapon);
   object oPC = GetPCItemLastEquippedBy();
   //debugVarObject("oPC", oPC);

   if (! IPGetIsRangedWeapon(oWeapon) && ! IPGetIsMeleeWeapon(oWeapon)) return;

/*
   int iSlot = -1;
   if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oWeapon)
   {
      iSlot = INVENTORY_SLOT_RIGHTHAND;
   }
   else if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == oWeapon)
   {
      iSlot = INVENTORY_SLOT_LEFTHAND;
   }

   if (iSlot == -1) return; // Not a weapon
*/
   debugVarObject("handling CEP weapon feats for", oWeapon);

   // used for weapon specialization; if this default value gets through, it
   // indicates a script error.
   int nDamageType = DAMAGE_TYPE_SONIC;

   switch(GetBaseItemType(oWeapon))
   {
      case BASE_ITEM_CEP_TRIDENT:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_TRIDENT, oPC);
            bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_TRIDENT, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_TRIDENT, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_TRIDENT, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_TRIDENT, oPC);
         break;
      case BASE_ITEM_CEP_GOAD:
      case BASE_ITEM_CEP_SPEAR2:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR, oPC);
            bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SPEAR, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSPEAR, oPC);
         break;
      case BASE_ITEM_CEP_HEAVYPICK:
      case BASE_ITEM_CEP_GREATAXE2:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_AXE, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_AXE, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_GREATAXE, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATAXE, oPC);
         break;
      case BASE_ITEM_CEP_LIGHTPICK:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_HAND_AXE, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HAND_AXE, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_HANDAXE, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_HANDAXE, oPC);
         break;
      case BASE_ITEM_CEP_NUNCHUKAU:
         nDamageType = DAMAGE_TYPE_BLUDGEONING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_KAMA, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_KAMA, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_KAMA, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_KAMA, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KAMA, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_KAMA, oPC);
         break;
      case BASE_ITEM_CEP_FALCHION:
      case BASE_ITEM_CEP_FALCHION2:
      case BASE_ITEM_CEP_SCIMITAR2:
         nDamageType = DAMAGE_TYPE_SLASHING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_SCIMITAR, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SCIMITAR, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SCIMITAR, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SCIMITAR, oPC);
         break;
      case BASE_ITEM_CEP_SAP:
         nDamageType = DAMAGE_TYPE_BLUDGEONING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL, oPC);
         break;
      case BASE_ITEM_CEP_ASSASSINDAGGER:
      case BASE_ITEM_CEP_SAI:
      case BASE_ITEM_CEP_WINDFIREWHEEL:
      case BASE_ITEM_CEP_KATAR:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_DAGGER, oPC);
         break;
      case BASE_ITEM_CEP_LIGHTMACE:
      case BASE_ITEM_CEP_HEAVYMACE:
      case BASE_ITEM_CEP_MACE2:
         nDamageType = DAMAGE_TYPE_BLUDGEONING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_MACE, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTMACE, oPC);
         break;
      case BASE_ITEM_CEP_KUKRI:
         nDamageType = DAMAGE_TYPE_SLASHING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_KUKRI, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_KUKRI, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_KUKRI, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_KUKRI, oPC);
         break;
      case BASE_ITEM_CEP_MAUL:
      case BASE_ITEM_CEP_WARHAMMER2:
         nDamageType = DAMAGE_TYPE_BLUDGEONING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_WAR_HAMMER, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_WARHAMMER, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_WARHAMMER, oPC);
         break;
      case BASE_ITEM_CEP_MERCLONGSWORD:
      case BASE_ITEM_CEP_LONGSWORD2:
         nDamageType = DAMAGE_TYPE_SLASHING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONG_SWORD, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGSWORD, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LONGSWORD, oPC);
         break;
      case BASE_ITEM_CEP_MERCGREATSWORD:
      case BASE_ITEM_CEP_GREATSWORD2:
         nDamageType = DAMAGE_TYPE_SLASHING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_GREATSWORD, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATSWORD, oPC);
         break;
      case BASE_ITEM_CEP_DOUBLESCIMITAR:
      case BASE_ITEM_CEP_MAUGDOUBLESWORD:
      case BASE_ITEM_CEP_TWOBLADEDSWORD2:
         nDamageType = DAMAGE_TYPE_SLASHING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD, oPC);
         bHasWeaponOfChoice = GetHasFeat(FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD, oPC);
         break;
      case BASE_ITEM_CEP_LONGBOW2:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGBOW, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW, oPC);
         break;
      case BASE_ITEM_CEP_SHORTBOW2:
         nDamageType = DAMAGE_TYPE_PIERCING;
         bHasImpCrit = GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW, oPC);
         bHasWeaponFocus = GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oPC);
         bHasWeaponSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW, oPC);
         bHasEpicWeaponFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTBOW, oPC);
         bHasEpicWeaponSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW, oPC);
         bHasOverCrit = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW, oPC);
         bHasDevCrit = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW, oPC);
         break;
      default:
         // Not a CEP weapon
         return;
   }

   //debugVarObject("handling CEP weapon feats for", oWeapon);

   SetLocalInt(oWeapon, VAR_DAMAGE_TYPE, nDamageType);

   //debugVarBoolean("bHasWeaponFocus", bHasWeaponFocus);
   //debugVarBoolean("bHasEpicWeaponFocus", bHasEpicWeaponFocus);
   //debugVarBoolean("bHasWeaponSpec", bHasWeaponSpec);
   //debugVarBoolean("bHasEpicWeaponSpec", bHasEpicWeaponSpec);
   //debugVarBoolean("bHasImpCrit", bHasImpCrit);
   //debugVarBoolean("bHasOverCrit", bHasOverCrit);
   //debugVarBoolean("bHasDevCrit", bHasDevCrit);
   //debugVarBoolean("bHasWeaponOfChoice", bHasWeaponOfChoice);

   if (bHasWeaponFocus)
   {
      //debugVarObject("hasWeaponFocus", oPC);
      int nBonus = 1;
      if (bHasEpicWeaponFocus) nBonus += 2;
      if (GetHasFeat(FEAT_SUPERIOR_WEAPON_FOCUS, oPC)) nBonus++;
      if (GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oPC))
      {
         nBonus += (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) - 10) / 3;
      }
      debugVarInt("weapon focus bonus", nBonus);

      SetCompositeBonusT(oWeapon, "CEPWeaponAtk", nBonus,
         ITEM_PROPERTY_ATTACK_BONUS);
/*
      SetLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_VALUE, nBonus);
      // For some reason, Attack Bonus does not stack with Enhancement Bonus,
      // but Weapon Focus should, so we have to adjust for it if present.
      int nEnhanceBonus = IPGetWeaponEnhancementBonus(oWeapon);
      if (nEnhanceBonus > 0) nBonus += nEnhanceBonus;

      itemproperty ip = ItemPropertyAttackBonus(nBonus);
      if (IPGetItemHasProperty(oWeapon, ip, DURATION_TYPE_PERMANENT, FALSE))
      {
         itemproperty ipExisting = GetFirstItemProperty(oWeapon);
         while (GetIsItemPropertyValid(ipExisting))
         {
            if (GetItemPropertyType(ipExisting) == ITEM_PROPERTY_ATTACK_BONUS)
            {
               int nExistingBonus = GetItemPropertyCostTableValue(ipExisting);
               SetLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_PREV_VALUE,
                  nExistingBonus);
               //debugVarInt("existing weap foc bonus", nExistingBonus);
               ip = ItemPropertyAttackBonus(nBonus + nExistingBonus);
               SetLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_VALUE, nBonus +
                  nExistingBonus);
            }
            ipExisting = GetNextItemProperty(oWeapon);
         }
      }
      IPSafeAddItemProperty(oWeapon, ip);

      effect eAttackIncrease = EffectAttackIncrease(nBonus);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC);
*/
   }

   if (bHasWeaponSpec)
   {
      //debugVarObject("hasWeaponSpec", oPC);
      int nBonus = 2;
      if (bHasEpicWeaponSpec) nBonus += 4;
      debugVarInt("weapon spec bonus", nBonus);
      //debugVarInt("IP constant", IPGetDamageBonusConstantFromNumber(nBonus));
      //debugVarInt("1", IPGetDamageBonusConstantFromNumber(1));
      //debugVarInt("2", IPGetDamageBonusConstantFromNumber(2));
      //debugVarInt("3", IPGetDamageBonusConstantFromNumber(3));
      //debugVarInt("4", IPGetDamageBonusConstantFromNumber(4));
      //debugVarInt("5", IPGetDamageBonusConstantFromNumber(5));
      //debugVarInt("6", IPGetDamageBonusConstantFromNumber(6));
      //debugVarInt("7", IPGetDamageBonusConstantFromNumber(7));
      //debugVarInt("8", IPGetDamageBonusConstantFromNumber(8));
      //debugVarInt("9", IPGetDamageBonusConstantFromNumber(9));
      //debugVarInt("10", IPGetDamageBonusConstantFromNumber(10));

      debugVarInt("nDamageType", nDamageType);
      SetCompositeBonusT(oWeapon, "CEPWeaponDam", nBonus,
         ITEM_PROPERTY_DAMAGE_BONUS, nDamageType);
/*
      SetLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_VALUE, nBonus);
      itemproperty ip = ItemPropertyDamageBonus(nDamageType,
         IPGetDamageBonusConstantFromNumber(nBonus));
      if (IPGetItemHasProperty(oWeapon, ip, DURATION_TYPE_PERMANENT, FALSE))
      {
         itemproperty ipExisting = GetFirstItemProperty(oWeapon);
         while (GetIsItemPropertyValid(ipExisting))
         {
            if (GetItemPropertyType(ipExisting) == ITEM_PROPERTY_DAMAGE_BONUS)
            {
               int nExistingBonus = GetItemPropertyCostTableValue(ipExisting);
               SetLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_PREV_VALUE,
                  nExistingBonus);
               //debugVarInt("existing damage bonus", nExistingBonus);
               ip = ItemPropertyDamageBonus(nDamageType,
                  IPGetDamageBonusConstantFromNumber(nBonus + nExistingBonus));
               //debugVarInt("nBonus+nExisting", nBonus + nExistingBonus);
               //debugVarInt("IP constant", IPGetDamageBonusConstantFromNumber(nBonus + nExistingBonus));
            }
            ipExisting = GetNextItemProperty(oWeapon);
         }
      }
      IPSafeAddItemProperty(oWeapon, ip);

      // Not sure what this does; it's cribbed from vaei_inc_feat.nss
      effect eDamageIncreaseIconFilter = EffectDamageIncrease(nBonus);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageIncreaseIconFilter, oPC, 0.1);
*/
   }

   if (bHasImpCrit) SetLocalInt(oWeapon, VAR_OWNER_HAS_IMP_CRIT, TRUE);
   if (bHasOverCrit) SetLocalInt(oWeapon, VAR_OWNER_HAS_OVER_CRIT, TRUE);
   if (bHasDevCrit)
   {
      int nDC = 10 + ((GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
         GetLevelByPosition(3, oPC)) / 2) + GetAbilityModifier(ABILITY_STRENGTH,
         oPC);
      SetLocalInt(oWeapon, VAR_OWNER_HAS_DEV_CRIT, nDC);
   }
   if (bHasWeaponOfChoice)
   {
      SetLocalInt(oWeapon, VAR_OWNER_HAS_WOC, TRUE);
      if (GetHasFeat(FEAT_KI_CRITICAL, oPC))
      {
         SetLocalInt(oWeapon, VAR_OWNER_HAS_KI_CRITICAL, TRUE);
      }
      if (GetHasFeat(FEAT_INCREASE_MULTIPLIER, oPC))
      {
         SetLocalInt(oWeapon, VAR_OWNER_HAS_INC_MULTIPLIER, TRUE);
      }
   }

   if (bHasImpCrit | bHasDevCrit | bHasOverCrit | bHasWeaponOfChoice)
   {
      debugVarObject("adding onhit event", oWeapon);
      itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CEP_WEAPON,
         1);
      debugVarItemProperty("ip", ip);
      IPSafeAddItemProperty(oWeapon, ip);
   }
}

void onUnequipCEPWeapon()
{
   debugVarObject("onUnequipCEPWeapon()", OBJECT_SELF);

   object oWeapon = GetPCItemLastUnequipped();
   debugVarObject("oWeapon", oWeapon);
   if (! IPGetIsMeleeWeapon(oWeapon) && ! IPGetIsRangedWeapon(oWeapon)) return;
   object oPC = GetPCItemLastUnequippedBy();
   debugVarObject("oPC", oPC);

   // Reset to original values as needed

   // [Epic] Weapon Focus
   int nAttackBonus = GetLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_VALUE);
   if (nAttackBonus)
   {
      debugVarInt("removing attack bonus", nAttackBonus);
      SetCompositeBonusT(oWeapon, "CEPWeaponAtk", 0,
         ITEM_PROPERTY_ATTACK_BONUS);
/*
      itemproperty ip = ItemPropertyAttackBonus(nAttackBonus);
      debugVarItemProperty("removing", ip);
      IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_ATTACK_BONUS,
         DURATION_TYPE_PERMANENT);
*/
      DeleteLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_VALUE);
   }

/*
   // Restore previous attack bonus
   nAttackBonus = GetLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_PREV_VALUE);
   if (nAttackBonus)
   {
      //debugVarInt("resetting attack bonus to", nAttackBonus);
      SetCompositeBonusT(oWeapon, "CEPWeaponAtk", 0,
         ITEM_PROPERTY_ATTACK_BONUS);
      itemproperty ip = ItemPropertyAttackBonus(nAttackBonus);
      IPSafeAddItemProperty(oWeapon, ip);
      DeleteLocalInt(oWeapon, VAR_IP_ATTACK_BONUS_PREV_VALUE);
   }
*/

   // [Epic] Weapon Specialization
   int nDamageType = GetLocalInt(oWeapon, VAR_DAMAGE_TYPE);
   debugVarObject("removing damage bonus", oWeapon);
   debugVarInt("nDamageType", nDamageType);
   SetCompositeBonusT(oWeapon, "CEPWeaponDam", 0,
      ITEM_PROPERTY_DAMAGE_BONUS, nDamageType);
/*
   int nDamageBonus = GetLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_VALUE);
   if (nDamageBonus)
   {
      //debugVarInt("removing damage bonus", nDamageBonus);
      itemproperty ip = ItemPropertyDamageBonus(nDamageType,
         IPGetDamageBonusConstantFromNumber(nDamageBonus));
      IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS,
         DURATION_TYPE_PERMANENT);
      DeleteLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_VALUE);
   }

   // Restore previous damage bonus
   nDamageBonus = GetLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_PREV_VALUE);
   if (nDamageBonus)
   {
      //debugVarInt("resetting damage bonus to", nDamageBonus);
      int nDamageType = GetLocalInt(oWeapon, VAR_DAMAGE_TYPE);
      itemproperty ip = ItemPropertyDamageBonus(nDamageType,
         IPGetDamageBonusConstantFromNumber(nDamageBonus));
      IPSafeAddItemProperty(oWeapon, ip);
      DeleteLocalInt(oWeapon, VAR_IP_DAMAGE_BONUS_PREV_VALUE);
   }
*/

   // Remove the on-hit-cast-spell for ImpCrit/OverCrit/DevCrit/etc.
   IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_ONHITCASTSPELL,
      DURATION_TYPE_PERMANENT, IP_CONST_ONHIT_CEP_WEAPON);

   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_IMP_CRIT);
   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_OVER_CRIT);
   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_DEV_CRIT);
   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_WOC);
   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_KI_CRITICAL);
   DeleteLocalInt(oWeapon, VAR_OWNER_HAS_INC_MULTIPLIER);
}


void onHitCEPWeapon()
{
   //debugVarObject("onHitCEPWeapon()", OBJECT_SELF);
   object oWeapon = GetSpellCastItem();
   object oTarget = PRCGetSpellTargetObject();

   // If the target is immune to critical hits, the rest of this does not apply!
   if (GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) return;

   // Cache the base item stats to avoid 2DA lookups whenever possible.
   int nBaseCritRange = GetLocalInt(oWeapon, VAR_CRIT_RANGE);
   int nCritRange = nBaseCritRange;
   if (nCritRange == 0)
   {
      nCritRange = StringToInt(Get2DAString("baseitems", "CritThreat",
         GetBaseItemType(oWeapon)));
      SetLocalInt(oWeapon, VAR_CRIT_RANGE, nCritRange);
   }

   if (GetLocalInt(oWeapon, VAR_OWNER_HAS_IMP_CRIT)) nCritRange *= 2;
   if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_KEEN)) nCritRange *= 2;
   if (GetLocalInt(oWeapon, VAR_OWNER_HAS_KI_CRITICAL)) nCritRange += 2;

   // Throttle back by standard threat range to account for the criticals
   // already handled by the game engine.
   nCritRange -= nBaseCritRange;
   //debugVarInt("nCritRange", nCritRange);

   // @NOTE: ignoring Threat Roll for simplicity

   int dice = d20();

   if (dice > 18 && GetLocalInt(oWeapon, VAR_OWNER_HAS_KI_CRITICAL))
   {
      // Handle extra damage which should have been done on Ki Critical
      FloatingTextStringOnCreature("Ki Critical", OBJECT_SELF);
      handleCriticalHit(oWeapon, oTarget);
   }
   else if (dice > 20 - nCritRange)
   {
      // Criticals outside the range handled by the game engine
      FloatingTextStringOnCreature("Critical Hit (" + IntToString(dice) + ")",
         OBJECT_SELF);
      handleCriticalHit(oWeapon, oTarget);
   }
}

void handleCriticalHit(object oWeapon, object oTarget)
{
   int nDamageType = GetLocalInt(oWeapon, VAR_DAMAGE_TYPE);
   int nDamage = 0;
   int n1, n2;
   object oOwner = GetItemPossessor(oWeapon);

   // Cache the base item stats to avoid 2DA lookups whenever possible.
   int nCritMult = GetLocalInt(oWeapon, VAR_CRIT_MULT);
   if (nCritMult == 0)
   {
      nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult",
         GetBaseItemType(oWeapon)));
      SetLocalInt(oWeapon, VAR_CRIT_MULT, nCritMult);
   }
   int nDamageDice = GetLocalInt(oWeapon, VAR_DAMAGE_DICE);
   if (nDamageDice == 0)
   {
      nDamageDice = StringToInt(Get2DAString("baseitems", "NumDice",
         GetBaseItemType(oWeapon)));
      SetLocalInt(oWeapon, VAR_DAMAGE_DICE, nDamageDice);
   }
   int nDamageDiceType = GetLocalInt(oWeapon, VAR_DAMAGE_DICE_TYPE);
   if (nDamageDiceType == 0)
   {
      nDamageDiceType = StringToInt(Get2DAString("baseitems", "DieToRoll",
         GetBaseItemType(oWeapon)));
      SetLocalInt(oWeapon, VAR_DAMAGE_DICE_TYPE, nDamageDiceType);
   }
   int nDamagePower = IPGetWeaponEnhancementBonus(oWeapon);

   // Weapon Master, Increased Multiplier
   if (GetLocalInt(oWeapon, VAR_OWNER_HAS_INC_MULTIPLIER)) nCritMult++;

   // weapon properties damage
   int nItemPropertyDamage = 0;
   itemproperty ip = GetFirstItemProperty(oWeapon);
   while (GetIsItemPropertyValid(ip))
   {
      if (GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS)
      {
         nItemPropertyDamage = 0;
         int nIPDamageType = GetItemPropertyParam1(ip);
         int nIPDamageBonus = GetItemPropertyCostTableValue(ip);
         switch(nIPDamageBonus)
         {
            case IP_CONST_DAMAGEBONUS_1:
               nItemPropertyDamage += (nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_2:
               nItemPropertyDamage += (2 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_3:
               nItemPropertyDamage += (3 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_4:
               nItemPropertyDamage += (4 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_5:
               nItemPropertyDamage += (5 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_6:
               nItemPropertyDamage += (6 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_7:
               nItemPropertyDamage += (7 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_8:
               nItemPropertyDamage += (8 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_9:
               nItemPropertyDamage += (9 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_10:
               nItemPropertyDamage += (10 * nCritMult);
               break;
            case IP_CONST_DAMAGEBONUS_1d10:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d10();
               }
               break;
            case IP_CONST_DAMAGEBONUS_1d12:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d12();
               }
               break;
            case IP_CONST_DAMAGEBONUS_1d4:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d4();
               }
               break;
            case IP_CONST_DAMAGEBONUS_1d6:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d6();
               }
               break;
            case IP_CONST_DAMAGEBONUS_1d8:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d8();
               }
               break;
            case IP_CONST_DAMAGEBONUS_2d10:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d10(2);
               }
               break;
            case IP_CONST_DAMAGEBONUS_2d12:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d12(2);
               }
               break;
            case IP_CONST_DAMAGEBONUS_2d4:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d4(2);
               }
               break;
            case IP_CONST_DAMAGEBONUS_2d6:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d6(2);
               }
               break;
            case IP_CONST_DAMAGEBONUS_2d8:
               for (n1 = 0; n1 < nCritMult; n1++)
               {
                  nItemPropertyDamage += d8(2);
               }
               break;
            default:
               logError("Invalid IP_CONST_DAMAGEBONUS " + IntToString(nIPDamageBonus) + " in onHitCEPWeapon()");
         }
         if (nItemPropertyDamage > 0)
         {
            //debugVarInt("nItemPropertyDamage", nItemPropertyDamage);
            if ((nDamageType == DAMAGE_TYPE_BLUDGEONING &&
                 nIPDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING) ||
                (nDamageType == DAMAGE_TYPE_PIERCING &&
                 nIPDamageType == IP_CONST_DAMAGETYPE_PIERCING) ||
                (nDamageType == DAMAGE_TYPE_SLASHING &&
                 nIPDamageType == IP_CONST_DAMAGETYPE_SLASHING))
            {
               // Bonus damage type matches base weapon
               nDamage += nItemPropertyDamage;
            }
            else
            {
               // Should really aggregate for same damage type, but it's
               // a rare case.
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamage(
                  nItemPropertyDamage, nDamageType, nDamagePower), oTarget);
            }
         }
      }
      else if (GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS)
      {
         int nIPDamageBonus = GetItemPropertyParam1(ip);
         //debugVarInt("Massive Criticals IP constant", nIPDamageBonus);
         switch(nIPDamageBonus)
         {
            case IP_CONST_DAMAGEBONUS_1: nDamage += 1; break;
            case IP_CONST_DAMAGEBONUS_10: nDamage += 10; break;
            case IP_CONST_DAMAGEBONUS_1d10: nDamage += d10(); break;
            case IP_CONST_DAMAGEBONUS_1d12: nDamage += d12(); break;
            case IP_CONST_DAMAGEBONUS_1d4: nDamage += d4(); break;
            case IP_CONST_DAMAGEBONUS_1d6: nDamage += d6(); break;
            case IP_CONST_DAMAGEBONUS_1d8: nDamage += d8(); break;
            case IP_CONST_DAMAGEBONUS_2: nDamage += 2; break;
            case IP_CONST_DAMAGEBONUS_2d10: nDamage += d10(2); break;
            case IP_CONST_DAMAGEBONUS_2d12: nDamage += d12(2); break;
            case IP_CONST_DAMAGEBONUS_2d4: nDamage += d4(2); break;
            case IP_CONST_DAMAGEBONUS_2d6: nDamage += d6(2); break;
            case IP_CONST_DAMAGEBONUS_2d8: nDamage += d8(2); break;
            case IP_CONST_DAMAGEBONUS_3: nDamage += 3; break;
            case IP_CONST_DAMAGEBONUS_4: nDamage += 4; break;
            case IP_CONST_DAMAGEBONUS_5: nDamage += 5; break;
            case IP_CONST_DAMAGEBONUS_6: nDamage += 6; break;
            case IP_CONST_DAMAGEBONUS_7: nDamage += 7; break;
            case IP_CONST_DAMAGEBONUS_8: nDamage += 8; break;
            case IP_CONST_DAMAGEBONUS_9: nDamage += 9; break;
            default:
               logError("Invalid IP_CONST_DAMAGEBONUS " + IntToString(nIPDamageBonus) + " in onHitCEPWeapon()");
         }
         //debugVarInt("after Massive Crits, nDamage", nDamage);
      }
      ip = GetNextItemProperty(oWeapon);
   }

   // Base weapon damage
   for (n1 = 0; n1 < nCritMult; n1++)
   {
      //debugVarInt("CritMult loop", n1);
      for (n2 = 0; n2 < nDamageDice; n2++)
      {
         nDamage += Random(nDamageDiceType) + 1;
      }
      //debugVarInt("after base weapon damage, nDamage", nDamage);
      // STR modifier
      nDamage += GetAbilityModifier(ABILITY_STRENGTH, oOwner);
      //debugVarInt("after ST mod, nDamage", nDamage);
      // Weapon magical enhancement
      nDamage += IPGetWeaponEnhancementBonus(oWeapon);
      //debugVarInt("after enhance bonus, nDamage", nDamage);
      // Weapon Specialization and its cousins are already handled
      // by adding bonus damage.
   }

   // Thundering Rage
   if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oOwner) &&
       GetHasSpellEffect(307, oOwner)) // spells.2da:307 BARBARIAN_RAGE
   {
      nDamage += d6(2);
      //debugVarInt("after ThunderRage, nDamage", nDamage);
      if (d2() > 1)
      {
         FloatingTextStringOnCreature("Thundering Rage!  Rrraaawwwwrrrr!",
            oOwner);
         int iVoice = VOICE_CHAT_BATTLECRY1;
         switch(d3())
         {
            case 1: iVoice = VOICE_CHAT_BATTLECRY1; break;
            case 2: iVoice = VOICE_CHAT_BATTLECRY2; break;
            case 3: iVoice = VOICE_CHAT_BATTLECRY3; break;
         }
         PlayVoiceChat(iVoice, oOwner);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget,
            RoundsToSeconds(3));
      }
   }

   // Overwhelming Critical
   if (GetLocalInt(oWeapon, VAR_OWNER_HAS_OVER_CRIT))
   {
      FloatingTextStringOnCreature("Overwhelming Critical!", OBJECT_SELF);
      nDamage += d6(nCritMult - 1);
      //debugVarInt("after OverCrit, nDamage", nDamage);
   }

   // Apply the damage
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamage(nDamage,
      nDamageType, nDamagePower), oTarget);

   // Devastating Critical
   if (GetLocalInt(oWeapon, VAR_OWNER_HAS_DEV_CRIT))
   {
      int nDC = GetLocalInt(oWeapon, VAR_OWNER_HAS_DEV_CRIT);
      if (FortitudeSave(oTarget, nDC) == 0)
      {
         FloatingTextStringOnCreature("Devastating Critical!", OBJECT_SELF);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
            VFX_IMP_DEATH), oTarget);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(TRUE),
            oTarget);
      }
   }
}

//void main() { onEquipCEPWeapon(); } // testing/compiling purposes
