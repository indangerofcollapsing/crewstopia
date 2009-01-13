#include "prc_alterations"
#include "prc_feat_const"
#include "prc_x2_itemprop" //#include "x2_inc_itemprop"

// @DUG My god was this way too long and hardcoded!

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

const string VAR_CRIT_RANGE = "CRITICAL_RANGE";

void main()
{
   object oWeapon = GetSpellCastItem();
   object oTarget = PRCGetSpellTargetObject();
   int nThreat = 20;
   int dice = d20();
   int bHealInt = GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) |
      GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK);
   int bCritImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT);

   // If the target is immune to either Sneak attacks or Critical hits, heal
   // the players INT bonus to them to balance the int damage problem.
   if (bHealInt)
   {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetAbilityModifier(
         ABILITY_INTELLIGENCE, OBJECT_SELF)), oTarget);
   }


   // If the target is immune to critical hits, the rest of this does not apply!
   // However, it still applies if they are immune to sneak attack.
   if (bCritImmune) return;

   // Cache the critical range to avoid 2DA lookups whenever possible.
   int nCritRange = GetLocalInt(oWeapon, VAR_CRIT_RANGE);
   if (nCritRange == 0)
   {
      nCritRange = StringToInt(Get2DAString("baseitems", "CritThreat",
         GetBaseItemType(oWeapon)));
      SetLocalInt(oWeapon, VAR_CRIT_RANGE, nCritRange);
   }

   if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_KEEN))
   {
      nThreat -= nCritRange;
   }

   int nImprovedCriticalFeat = -1;
   int nOverwhelmingCriticalFeat = -1;
   int nDevastatingCriticalFeat = -1;
   int nWeaponSpecializationFeat = -1;
   int nEpicWeaponFocusFeat = -1;
   int nEpicWeaponSpecializationFeat = -1;
   int nWeaponOfChoiceFeat = -1;

   switch (GetBaseItemType(oWeapon))
   {
      case BASE_ITEM_SHORTSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SHORT_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SHORTSWORD;
         break;
      case BASE_ITEM_LONGSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LONG_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LONG_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LONGSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LONGSWORD;
         break;
      case BASE_ITEM_BASTARDSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_BASTARD_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_BASTARDSWORD;
         break;
      case BASE_ITEM_DAGGER:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DAGGER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
         break;
      case BASE_ITEM_GREATSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_GREATSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_GREATSWORD;
         break;
      case BASE_ITEM_TWOBLADEDSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;
         break;
      case BASE_ITEM_BATTLEAXE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_BATTLE_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_BATTLEAXE;
         break;
      case BASE_ITEM_GREATAXE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_GREAT_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_GREATAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_GREATAXE;
         break;
      case BASE_ITEM_SCIMITAR:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SCIMITAR;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SCIMITAR;
         break;
      case BASE_ITEM_RAPIER:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_RAPIER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_RAPIER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_RAPIER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_RAPIER;
         break;
      case BASE_ITEM_SHORTSPEAR:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SPEAR;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SPEAR;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
         break;
      case BASE_ITEM_LIGHTMACE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
         break;
      case BASE_ITEM_LIGHTFLAIL:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
         break;
      case BASE_ITEM_HALBERD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_HALBERD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_HALBERD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_HALBERD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_HALBERD;
         break;
      case BASE_ITEM_DIREMACE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DIRE_MACE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DIRE_MACE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DIREMACE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DIREMACE;
         break;
      case BASE_ITEM_DOUBLEAXE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DOUBLE_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DOUBLEAXE;
         break;
      case BASE_ITEM_HEAVYFLAIL:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;
         break;
      case BASE_ITEM_KATANA:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_KATANA;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_KATANA;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_KATANA;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_KATANA;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_KATANA;
         break;
      case BASE_ITEM_KUKRI:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_KUKRI;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_KUKRI;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_KUKRI;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_KUKRI;
         break;
      case BASE_ITEM_MORNINGSTAR:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_MORNING_STAR;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_MORNING_STAR;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_MORNINGSTAR;
         break;
      case BASE_ITEM_SCYTHE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SCYTHE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SCYTHE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SCYTHE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SCYTHE;
         break;
      case BASE_ITEM_CLUB:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_CLUB;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_CLUB;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_CLUB;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_CLUB;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_CLUB;
         break;
      case BASE_ITEM_WARHAMMER:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_WARHAMMER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_WARHAMMER;
         break;
      case BASE_ITEM_WHIP:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_WHIP;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_WHIP;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_WHIP;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_WHIP;
         break;
      case BASE_ITEM_DWARVENWARAXE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DWAXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DWAXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DWAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DWAXE;
         break;
      case BASE_ITEM_HANDAXE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_HAND_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_HANDAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_HANDAXE;
         break;
      case BASE_ITEM_KAMA:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_KAMA;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_KAMA;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_KAMA;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_KAMA;
         break;
      case BASE_ITEM_LIGHTHAMMER:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER;
         break;
      case BASE_ITEM_SICKLE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SICKLE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SICKLE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SICKLE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SICKLE;
         break;
      case BASE_ITEM_QUARTERSTAFF:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_STAFF;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_STAFF;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;
         break;
      case BASE_ITEM_DART:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DART;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DART;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DART;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DART;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DART;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DART;
         nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons)
         break;
      case BASE_ITEM_SHURIKEN:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SHURIKEN;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SHURIKEN;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SHURIKEN;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN;
         nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons)
         break;
      case BASE_ITEM_CEP_ASSASSINDAGGER:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DAGGER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
         break;
      case BASE_ITEM_CEP_DOUBLESCIMITAR:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;
         break;
      case BASE_ITEM_CEP_FALCHION:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SCIMITAR;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SCIMITAR;
         break;
      case BASE_ITEM_CEP_GOAD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_RAPIER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_RAPIER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_RAPIER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_RAPIER;
         break;
      case BASE_ITEM_CEP_HEAVYMACE:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
         break;
      case BASE_ITEM_CEP_HEAVYPICK:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_GREAT_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_GREATAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_GREATAXE;
         break;
      case BASE_ITEM_CEP_KATAR:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DAGGER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
         break;
      case BASE_ITEM_CEP_LIGHTPICK:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_HAND_AXE;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_HANDAXE;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_HANDAXE;
         break;
      case BASE_ITEM_CEP_MAUL:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_WARHAMMER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_WARHAMMER;
         break;
      case BASE_ITEM_CEP_MERCGREATSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_GREATSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_GREATSWORD;
         break;
      case BASE_ITEM_CEP_MERCLONGSWORD:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LONG_SWORD;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LONG_SWORD;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LONGSWORD;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LONGSWORD;
         break;
      case BASE_ITEM_CEP_NUNCHUKAU:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_KAMA;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_KAMA;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_KAMA;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_KAMA;
         break;
      case BASE_ITEM_CEP_SAI:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DAGGER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
         break;
      case BASE_ITEM_CEP_SAP:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
         break;
      case BASE_ITEM_CEP_TRIDENT:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_SPEAR;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_SPEAR;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
         break;
      case BASE_ITEM_CEP_WINDFIREWHEEL:
         nImprovedCriticalFeat = FEAT_IMPROVED_CRITICAL_DAGGER;
         nOverwhelmingCriticalFeat = FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
         nDevastatingCriticalFeat = FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
         nWeaponSpecializationFeat = FEAT_WEAPON_SPECIALIZATION_DAGGER;
         nEpicWeaponFocusFeat = FEAT_EPIC_WEAPON_FOCUS_DAGGER;
         nEpicWeaponSpecializationFeat = FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
         nWeaponOfChoiceFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
         break;

         default:
         WriteTimestampedLogEntry("Invalid BASE_ITEM value in prc_swashweak " +
            "for " + ObjectToString(oWeapon) + ": " + IntToString(
            GetBaseItemType(oWeapon)));
         return;
   }
   if (GetHasFeat(nImprovedCriticalFeat)) nThreat -= nCritRange;
   if (GetHasFeat(nImprovedCriticalFeat) && GetHasFeat(FEAT_KI_CRITICAL))
   {
      nThreat -= nCritRange;
   }

   if (dice >= nThreat)
   {
      FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);
      if (GetHasFeat(WEAKENING_CRITICAL, OBJECT_SELF))
      {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
            VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(
            ABILITY_STRENGTH, 2), oTarget);
      }
      if (GetHasFeat(WOUNDING_CRITICAL,OBJECT_SELF))
      {
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(
            ABILITY_CONSTITUTION, 2), oTarget);
      }
   }
}
