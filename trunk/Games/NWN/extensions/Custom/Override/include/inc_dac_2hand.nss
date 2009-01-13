#include "prc_x2_itemprop" //#include "x2_inc_itemprop"
#include "inc_nbde"
#include "prc_alterations"
#include "inc_debug_dac"

// Give the 1.5 strength damage bonus for medium sized weapons
// (relative to the wielder) or larger when used one handed.
void handleTwoHandEquip(object oPC = OBJECT_INVALID);
// Remove the strength bonus damage when the weapon is unequipped.
void handleTwoHandUnequip(object oPC = OBJECT_INVALID);
// Weapons can be slashing/piercing or bludgeoning/piercing, but
// bonus damage can only be slashing or piercing or bludgeoning.
int bonusDamageType(int nDamageType);
// Returns the appropriate IP_CONST_DAMAGETYPE_* constant.
int weaponBonusDamageType(object oWeapon);
// Converts a raw damage bonus into the appropriate
// IP_CONST_DAMAGEBONUS_* constant.
int getIPConstDamageBonus(int nDamageBonus);
// Adds the damage bonus to the weapon.
void addTwoHandDamageBonus(object oWeapon, int nDamageBonus, int nIPDamageType);
// Removes the damage bonus on the weapon.
void removeTwoHandDamageBonus(object oWeapon, int nDamageBonus, int nIPDamageType);
// Converts an Item Property Constant into a raw number.
int getRawBonus(int nIPDamageBonus);

const string VAR_TWO_HAND_DAMAGE_BONUS = "TWO_HAND_DAMAGE_BONUS";

void handleTwoHandEquip(object oPC = OBJECT_INVALID)
{
   //debugVarObject("handleTwoHandEquip()", OBJECT_SELF);

   if (oPC == OBJECT_INVALID) oPC = GetItemLastEquippedBy();
   //debugVarObject("oPC", oPC);

   object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   //debugVarObject("oRightHand", oRightHand);

   if (oRightHand == OBJECT_INVALID) return;

   object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
   //debugVarObject("oLeftHand", oLeftHand);

   // 3 = medium
   int nPCSize = GetCreatureSize(oPC);
   //debugVarInt("noPCSize", nPCSize);
   int nBaseItemType = GetBaseItemType(oRightHand);
   // 3 = medium
   int nWeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize",
      nBaseItemType));
   //debugVarInt("nWeaponSize", nWeaponSize);
   // 2DA values ("****" will resolve into zero):
   // **** melee weapon, one or two handed depending on size
   // 1    Non-weapon
   // 4    Two-handed items (e.g. halberd) (these already get the bonus)
   // 5    Bow
   // 6    Crossbow
   // 7    Shield
   // 8    Double-headed weapons (these should not get the bonus)
   // 9    Creature weapon
   // 10   Dart and sling
   // 11   Shuriken and throwing axe
   int nWeaponWield = StringToInt(Get2DAString("baseitems", "WeaponWield",
      nBaseItemType));
   //debugVarInt("nWeaponWield", nWeaponWield);

   // Melee weapons of the same size as the wielder, wielded alone, get the
   // two-handed strength damage bonus.
   if (IPGetIsMeleeWeapon(oRightHand) && nWeaponSize == nPCSize &&
       nWeaponWield == 0)
   {
      int nBonusDamageType = weaponBonusDamageType(oRightHand);
      //debugVarInt("nBonusDamageType", nBonusDamageType);
      if (!GetIsObjectValid(oLeftHand))
      {
         // Give 'em a break -- minimum +1 damage bonus no matter how weak.
         int nStrBonus = max(GetAbilityModifier(ABILITY_STRENGTH, oPC) / 2, 1);
         //debugVarInt("nStrBonus", nStrBonus);
         FloatingTextStringOnCreature("Wielding " + GetName(oRightHand) +
            " with two hands.", oPC, FALSE);
         //debugMsg(GetName(oPC) + " wielding " + GetName(oRightHand) + " with two hands.");
         addTwoHandDamageBonus(oRightHand, nStrBonus, nBonusDamageType);
      }
      else // There's an object in the left hand, so remove the bonus.
      {
         int nDamageBonus = getPersistentInt(oRightHand,
            VAR_TWO_HAND_DAMAGE_BONUS);
         if (nDamageBonus > 0)
         {
            FloatingTextStringOnCreature("Wielding " + GetName(oRightHand) +
               " with one hand.", oPC, FALSE);
            //debugMsg(GetName(oPC) + " no longer wielding a weapon with two hands.");
            removeTwoHandDamageBonus(oRightHand, nDamageBonus,
               weaponBonusDamageType(oRightHand));
         }
      }
   }
//   else if (nWeaponSize < nPCSize)
//   {
//      FloatingTextStringOnCreature(GetName(oRightHand) + " too small to wield two-handed.", oPC, FALSE);
//      //debugMsg(GetName(oPC) + " using " + GetName(oRightHand) + ", too small to wield two-handed.");
//   }
}

void handleTwoHandUnequip(object oPC = OBJECT_INVALID)
{
   //debugVarObject("handleTwoHandUnequip()", OBJECT_SELF);
   object oWeapon = GetItemLastUnequipped();
   //debugVarObject("oWeapon", oWeapon);
   if (IPGetIsMeleeWeapon(oWeapon))
   {
      int nPreviousBonus = getPersistentInt(oWeapon, VAR_TWO_HAND_DAMAGE_BONUS);
      if (nPreviousBonus)
      {
         //debugVarInt("nPreviousBonus", nPreviousBonus);
         int nDamageType = weaponBonusDamageType(oWeapon);
         //debugVarInt("nDamageType", nDamageType);
         removeTwoHandDamageBonus(oWeapon, nPreviousBonus, nDamageType);
      }
   }

   if (oPC == OBJECT_INVALID) oPC = GetItemLastUnequippedBy();
   //debugVarObject("oPC", oPC);

   // The unequip event is apparently not aware of current items in
   // the left and right hand, so reevaluating here is not useful.
   // What this means is, if you unequip the left hand weapon, the
   // right hand weapon is wielded one-handed until you unequip and
   // re-equip it.
   // I choose to think of this as a feature.
}

int bonusDamageType(int nDamageType)
{
   //debugVarObject("bonusDamageType()", OBJECT_SELF);
   //debugVarInt("nDamageType", nDamageType);

   int nBonusDamageType = IP_CONST_DAMAGETYPE_PHYSICAL; // failsafe value
   switch(nDamageType)
   {
      case 1: nBonusDamageType = IP_CONST_DAMAGETYPE_PIERCING; break;
      case 2: nBonusDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      case 3: nBonusDamageType = IP_CONST_DAMAGETYPE_SLASHING; break;
      case 4: nBonusDamageType = IP_CONST_DAMAGETYPE_SLASHING; break;
      case 5: nBonusDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      default:
         logError("Unrecognized damage type " + IntToString(nDamageType) +
            " in bonusDamageType()");
   }
   //debugVarInt("nBonusDamageType", nBonusDamageType);
   return nBonusDamageType;
}

int weaponBonusDamageType(object oWeapon)
{
   //debugVarObject("weaponBonusDamageType()", OBJECT_SELF);
   //debugVarObject("oWeapon", oWeapon);

   // 0   None
   // 1   Piercing
   // 2   Bludgeoning
   // 3   Slashing
   // 4   Slashing and Piercing
   // 5   Bludgeoning and Piercing
   int nDamageType = StringToInt(Get2DAString("baseitems", "WeaponType",
      GetBaseItemType(oWeapon)));
   //debugVarInt("nDamageType", nDamageType);
   return bonusDamageType(nDamageType);
}

int getIPConstDamageBonus(int nDamageBonus)
{
   //debugVarObject("getIPConstDamageBonus", OBJECT_SELF);
   //debugVarInt("nDamageBonus", nDamageBonus);

   int nIPDamageBonus = 0;
   switch(nDamageBonus)
   {
      case 1:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_1;  break;
      case 2:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_2;  break;
      case 3:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_3;  break;
      case 4:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_4;  break;
      case 5:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_5;  break;
      case 6:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_6;  break;
      case 7:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_7;  break;
      case 8:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_8;  break;
      case 9:  nIPDamageBonus = IP_CONST_DAMAGEBONUS_9;  break;
      case 10: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10; break;
      case 11: nIPDamageBonus = IP_CONST_DAMAGEBONUS_11; break;
      case 12: nIPDamageBonus = IP_CONST_DAMAGEBONUS_12; break;
      case 13: nIPDamageBonus = IP_CONST_DAMAGEBONUS_13; break;
      case 14: nIPDamageBonus = IP_CONST_DAMAGEBONUS_14; break;
      case 15: nIPDamageBonus = IP_CONST_DAMAGEBONUS_15; break;
      case 16: nIPDamageBonus = IP_CONST_DAMAGEBONUS_16; break;
      case 17: nIPDamageBonus = IP_CONST_DAMAGEBONUS_17; break;
      case 18: nIPDamageBonus = IP_CONST_DAMAGEBONUS_18; break;
      case 19: nIPDamageBonus = IP_CONST_DAMAGEBONUS_19; break;
      case 20: nIPDamageBonus = IP_CONST_DAMAGEBONUS_20; break;
      case 21: nIPDamageBonus = IP_CONST_DAMAGEBONUS_6d6; break; // 21
      case 22: nIPDamageBonus = IP_CONST_DAMAGEBONUS_4d10; break; // 22
      case 23: nIPDamageBonus = IP_CONST_DAMAGEBONUS_5d8; break; // 22.5
      case 24: nIPDamageBonus = IP_CONST_DAMAGEBONUS_9d4; break; // 22.5
      case 25: nIPDamageBonus = IP_CONST_DAMAGEBONUS_7d6; break; // 24.5
      case 26: nIPDamageBonus = IP_CONST_DAMAGEBONUS_4d12; break; // 26
      case 27: nIPDamageBonus = IP_CONST_DAMAGEBONUS_6d8; break; // 27
      case 28: nIPDamageBonus = IP_CONST_DAMAGEBONUS_8d6; break; // 28
      case 29: nIPDamageBonus = IP_CONST_DAMAGEBONUS_7d8; break; // 31.5
      case 30:
      case 31: nIPDamageBonus = IP_CONST_DAMAGEBONUS_9d6; break; // 31.5
      case 32: nIPDamageBonus = IP_CONST_DAMAGEBONUS_5d12; break; // 32.5
      case 33: nIPDamageBonus = IP_CONST_DAMAGEBONUS_6d10; break; // 33
      case 34:
      case 35: nIPDamageBonus = IP_CONST_DAMAGEBONUS_8d8; break; // 36
      case 36: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10d6; break; // 36
      case 37:
      case 38: nIPDamageBonus = IP_CONST_DAMAGEBONUS_7d10; break; // 38.5
      case 39: nIPDamageBonus = IP_CONST_DAMAGEBONUS_6d12; break; // 39
      case 40:
      case 41: nIPDamageBonus = IP_CONST_DAMAGEBONUS_9d8; break; // 40.5
      case 42:
      case 43:
      case 44: nIPDamageBonus = IP_CONST_DAMAGEBONUS_8d10; break; // 44
      case 45: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10d8; break; // 45
      case 46: nIPDamageBonus = IP_CONST_DAMAGEBONUS_7d12; break; // 45.5
      case 47:
      case 48:
      case 49:
      case 50: nIPDamageBonus = IP_CONST_DAMAGEBONUS_9d10; break; // 49.5
      case 51:
      case 52: nIPDamageBonus = IP_CONST_DAMAGEBONUS_8d12; break; // 52
      case 53:
      case 54:
      case 55: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10d10; break; // 55
      case 56:
      case 57:
      case 58:
      case 59: nIPDamageBonus = IP_CONST_DAMAGEBONUS_9d12; break; // 58.5
      case 60:
      case 61:
      case 62:
      case 63:
      case 64:
      case 65: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10d12; break; // 65
      default: nIPDamageBonus = IP_CONST_DAMAGEBONUS_10d12; break;
   }
   //debugVarInt("nIPDamageBonus", nIPDamageBonus);
   return nIPDamageBonus;
}

void addTwoHandDamageBonus(object oWeapon, int nDamageBonus, int nIPDamageType)
{
   //debugVarObject("addTwoHandDamageBonus()", OBJECT_SELF);
   //debugVarObject("oWeapon", oWeapon);
   //debugVarInt("nDamageBonus", nDamageBonus);
   //debugVarInt("nIPDamageType", nIPDamageType);

   SetCompositeBonusT(oWeapon, "TwoHandDam", nDamageBonus,
      ITEM_PROPERTY_DAMAGE_BONUS, nIPDamageType);

/*
   // No way to determine the value of any preexisting damage bonus, so if a
   // weapon was created with bonus damage it will not stack.  :-(
   int nPreviousBonus = getPersistentInt(oWeapon, VAR_TWO_HAND_DAMAGE_BONUS);
   if (nPreviousBonus)
   {
      //debugMsg("Removing previous bonus before adding new one");
      removeTwoHandDamageBonus(oWeapon, nPreviousBonus, nIPDamageType);
   }

   int nMaxExistingBonus = 0;
   itemproperty ip = GetFirstItemProperty(oWeapon);
   while (GetIsItemPropertyValid(ip))
   {
      //debugMsg("item property found");
      //debugVarInt("item property type", GetItemPropertyType(ip));
      if ((GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS))
      {
         //debugVarInt("item property duration type", GetItemPropertyDurationType(ip));
         if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
         {
            //debugVarInt("item property subtype", GetItemPropertySubType(ip));
            if (GetItemPropertySubType(ip) == nIPDamageType)
            {
               int nExistingBonus = GetItemPropertyCostTableValue(ip);
               //debugVarInt("+nExistingBonus", nExistingBonus);
               nMaxExistingBonus = max(nMaxExistingBonus,
                  getRawBonus(nExistingBonus));
               //debugVarInt("+nMaxExistingBonus", nMaxExistingBonus);
            }
         }
      }
      ip = GetNextItemProperty(oWeapon);
   }

   // Bonus damage stacks with existing bonuses.
   nDamageBonus += nMaxExistingBonus;
   //debugVarInt("total nDamageBonus", nDamageBonus);
   setPersistentInt(oWeapon, VAR_TWO_HAND_DAMAGE_BONUS, nDamageBonus);
   IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(
      nIPDamageType, getIPConstDamageBonus(nDamageBonus)), 0.0f, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
*/
   //debugMsg("exit addTwoHandDamageBonus()");
}

void removeTwoHandDamageBonus(object oWeapon, int nDamageBonus, int nIPDamageType)
{
   //debugVarObject("removeTwoHandDamageBonus()", OBJECT_SELF);
   //debugVarObject("oWeapon", oWeapon);
   //debugVarInt("nDamageBonus", nDamageBonus);
   //debugVarInt("nIPDamageType", nIPDamageType);

   SetCompositeBonusT(oWeapon, "TwoHandDam", 0, ITEM_PROPERTY_DAMAGE_BONUS,
      nIPDamageType);
/*
   if (!getPersistentInt(oWeapon, VAR_TWO_HAND_DAMAGE_BONUS)) return;

   deletePersistentInt(oWeapon, VAR_TWO_HAND_DAMAGE_BONUS);

   int bFoundIt = FALSE;
   itemproperty ip = GetFirstItemProperty(oWeapon);
   while (GetIsItemPropertyValid(ip) && !bFoundIt)
   {
      //debugMsg("item property found");
      //debugVarInt("item property type", GetItemPropertyType(ip));
      if ((GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS))
      {
         //debugVarInt("item property duration type", GetItemPropertyDurationType(ip));
         if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
         {
            //debugVarInt("item property subtype", GetItemPropertySubType(ip));
            if (GetItemPropertySubType(ip) == nIPDamageType)
            {
               int nExistingBonus = GetItemPropertyCostTableValue(ip);
               //debugVarInt("-nExistingBonus", nExistingBonus);
               if (nExistingBonus == getIPConstDamageBonus(nDamageBonus))
               {
                  //debugMsg("Deleting bonus damage item property");
                  bFoundIt = TRUE;
                  RemoveItemProperty(oWeapon, ip);
               }
            }
         }
      }
      ip = GetNextItemProperty(oWeapon);
   }

   if (!bFoundIt)
   {
      logError("Did not find matching item property on " +
         objectToString(oWeapon) + " to remove in removeTwoHandDamageBonus()");
   }
*/
   //debugMsg("exit removeTwoHandDamageBonus()");
}

int getRawBonus(int nIPDamageBonus)
{
   //debugVarObject("getRawBonus", OBJECT_SELF);
   //debugVarInt("nIPDamageBonus", nIPDamageBonus);

   int nDamageBonus = 0;
   switch(nIPDamageBonus)
   {
      case IP_CONST_DAMAGEBONUS_1: nDamageBonus = 1; break; // 1
      case IP_CONST_DAMAGEBONUS_2: nDamageBonus = 2; break; // 2
      case IP_CONST_DAMAGEBONUS_1d4: nDamageBonus = 3; break; // 2.5
      case IP_CONST_DAMAGEBONUS_3: nDamageBonus = 3; break; // 3
      case IP_CONST_DAMAGEBONUS_1d6: nDamageBonus = 4; break; // 3.5
      case IP_CONST_DAMAGEBONUS_4: nDamageBonus = 4; break; // 4
      case IP_CONST_DAMAGEBONUS_1d8: nDamageBonus = 5; break; // 4.5
      case IP_CONST_DAMAGEBONUS_5: nDamageBonus = 5; break; // 5
      case IP_CONST_DAMAGEBONUS_2d4: nDamageBonus = 5; break; // 5
      case IP_CONST_DAMAGEBONUS_1d10: nDamageBonus = 6; break; // 5.5
      case IP_CONST_DAMAGEBONUS_6: nDamageBonus = 6; break; // 6
      case IP_CONST_DAMAGEBONUS_1d12: nDamageBonus = 7; break; // 6.5
      case IP_CONST_DAMAGEBONUS_7: nDamageBonus = 7; break; // 7
      case IP_CONST_DAMAGEBONUS_2d6: nDamageBonus = 7; break; // 7
      case IP_CONST_DAMAGEBONUS_3d4: nDamageBonus = 8; break; // 7.5
      case IP_CONST_DAMAGEBONUS_8: nDamageBonus = 8; break; // 8
      case IP_CONST_DAMAGEBONUS_9: nDamageBonus = 9; break; // 9
      case IP_CONST_DAMAGEBONUS_2d8: nDamageBonus = 9; break; // 9
      case IP_CONST_DAMAGEBONUS_10: nDamageBonus = 10; break; // 10
      case IP_CONST_DAMAGEBONUS_4d4: nDamageBonus = 10; break; // 10
      case IP_CONST_DAMAGEBONUS_3d6: nDamageBonus = 11; break; // 10.5
      case IP_CONST_DAMAGEBONUS_11: nDamageBonus = 11; break; // 11
      case IP_CONST_DAMAGEBONUS_2d10: nDamageBonus = 11; break; // 11
      case IP_CONST_DAMAGEBONUS_12: nDamageBonus = 12; break; // 12
      case IP_CONST_DAMAGEBONUS_5d4: nDamageBonus = 13; break; // 12.5
      case IP_CONST_DAMAGEBONUS_3d8: nDamageBonus = 13; break; // 12.5
      case IP_CONST_DAMAGEBONUS_13: nDamageBonus = 13; break; // 13
      case IP_CONST_DAMAGEBONUS_2d12: nDamageBonus = 13; break; // 13
      case IP_CONST_DAMAGEBONUS_14: nDamageBonus = 14; break; // 14
      case IP_CONST_DAMAGEBONUS_4d6: nDamageBonus = 14; break; // 14
      case IP_CONST_DAMAGEBONUS_15: nDamageBonus = 15; break; // 15
      case IP_CONST_DAMAGEBONUS_6d4: nDamageBonus = 15; break; // 15
      case IP_CONST_DAMAGEBONUS_16: nDamageBonus = 16; break; // 16
      case IP_CONST_DAMAGEBONUS_3d10: nDamageBonus = 17; break; // 16.5
      case IP_CONST_DAMAGEBONUS_17: nDamageBonus = 17; break; // 17
      case IP_CONST_DAMAGEBONUS_5d6: nDamageBonus = 18; break; // 17.5
      case IP_CONST_DAMAGEBONUS_7d4: nDamageBonus = 18; break; // 17.5
      case IP_CONST_DAMAGEBONUS_18: nDamageBonus = 18; break; // 18
      case IP_CONST_DAMAGEBONUS_4d8: nDamageBonus = 18; break; // 18
      case IP_CONST_DAMAGEBONUS_19: nDamageBonus = 19; break; // 19
      case IP_CONST_DAMAGEBONUS_3d12: nDamageBonus = 20; break; // 19.5
      case IP_CONST_DAMAGEBONUS_20: nDamageBonus = 20; break; // 20
      case IP_CONST_DAMAGEBONUS_8d4: nDamageBonus = 20; break; // 20
      case IP_CONST_DAMAGEBONUS_6d6: nDamageBonus = 21; break; // 21
      case IP_CONST_DAMAGEBONUS_4d10: nDamageBonus = 22; break; // 22
      case IP_CONST_DAMAGEBONUS_5d8: nDamageBonus = 23; break; // 22.5
      case IP_CONST_DAMAGEBONUS_9d4: nDamageBonus = 23; break; // 22.5
      case IP_CONST_DAMAGEBONUS_7d6: nDamageBonus = 25; break; // 24.5
      case IP_CONST_DAMAGEBONUS_10d4: nDamageBonus = 25; break; // 25
      case IP_CONST_DAMAGEBONUS_4d12: nDamageBonus = 26; break; // 26
      case IP_CONST_DAMAGEBONUS_6d8: nDamageBonus = 27; break; // 27
      case IP_CONST_DAMAGEBONUS_5d10: nDamageBonus = 28; break; // 27.5
      case IP_CONST_DAMAGEBONUS_8d6: nDamageBonus = 28; break; // 28
      case IP_CONST_DAMAGEBONUS_7d8: nDamageBonus = 32; break; // 31.5
      case IP_CONST_DAMAGEBONUS_9d6: nDamageBonus = 32; break; // 31.5
      case IP_CONST_DAMAGEBONUS_5d12: nDamageBonus = 33; break; // 32.5
      case IP_CONST_DAMAGEBONUS_6d10: nDamageBonus = 33; break; // 33
      case IP_CONST_DAMAGEBONUS_8d8: nDamageBonus = 36; break; // 36
      case IP_CONST_DAMAGEBONUS_10d6: nDamageBonus = 36; break; // 36
      case IP_CONST_DAMAGEBONUS_7d10: nDamageBonus = 39; break; // 38.5
      case IP_CONST_DAMAGEBONUS_6d12: nDamageBonus = 39; break; // 39
      case IP_CONST_DAMAGEBONUS_9d8: nDamageBonus = 41; break; // 40.5
      case IP_CONST_DAMAGEBONUS_8d10: nDamageBonus = 44; break; // 44
      case IP_CONST_DAMAGEBONUS_10d8: nDamageBonus = 45; break; // 45
      case IP_CONST_DAMAGEBONUS_7d12: nDamageBonus = 46; break; // 45.5
      case IP_CONST_DAMAGEBONUS_9d10: nDamageBonus = 50; break; // 49.5
      case IP_CONST_DAMAGEBONUS_8d12: nDamageBonus = 52; break; // 52
      case IP_CONST_DAMAGEBONUS_10d10: nDamageBonus = 55; break; // 55
      case IP_CONST_DAMAGEBONUS_9d12: nDamageBonus = 59; break; // 58.5
      case IP_CONST_DAMAGEBONUS_10d12: nDamageBonus = 65; break; // 65
      default:
         logError("IP Constant " + IntToString(nIPDamageBonus) +
            " not found in getRawBonus()");
         nDamageBonus = 20;
         break;
   }
   //debugVarInt("nDamageBonus", nDamageBonus);
   return nDamageBonus;
}

//void main() {} // Testing/compiling purposes

/* raw values
IP_CONST_DAMAGEBONUS_1 = 1
IP_CONST_DAMAGEBONUS_2 = 2
IP_CONST_DAMAGEBONUS_1d4 = 6
IP_CONST_DAMAGEBONUS_3 = 3
IP_CONST_DAMAGEBONUS_1d6 = 7
IP_CONST_DAMAGEBONUS_4 = 4
IP_CONST_DAMAGEBONUS_1d8 = 8
IP_CONST_DAMAGEBONUS_5 = 5
IP_CONST_DAMAGEBONUS_2d4 = 12
IP_CONST_DAMAGEBONUS_1d10 = 9
IP_CONST_DAMAGEBONUS_6 = 16
IP_CONST_DAMAGEBONUS_1d12 = 14
IP_CONST_DAMAGEBONUS_7 = 17
IP_CONST_DAMAGEBONUS_2d6 = 10
IP_CONST_DAMAGEBONUS_3d4 = 37
IP_CONST_DAMAGEBONUS_8 = 18
IP_CONST_DAMAGEBONUS_9 = 19
IP_CONST_DAMAGEBONUS_2d8 = 11
IP_CONST_DAMAGEBONUS_10 = 20
IP_CONST_DAMAGEBONUS_4d4 = 38
IP_CONST_DAMAGEBONUS_3d6 = 31
IP_CONST_DAMAGEBONUS_11 = 21
IP_CONST_DAMAGEBONUS_2d10 = 13
IP_CONST_DAMAGEBONUS_12 = 22
IP_CONST_DAMAGEBONUS_5d4 = 39
IP_CONST_DAMAGEBONUS_3d8 = 41
IP_CONST_DAMAGEBONUS_13 = 23
IP_CONST_DAMAGEBONUS_2d12 = 15
IP_CONST_DAMAGEBONUS_14 = 24
IP_CONST_DAMAGEBONUS_4d6 = 32
IP_CONST_DAMAGEBONUS_15 = 25
IP_CONST_DAMAGEBONUS_6d4 = 40
IP_CONST_DAMAGEBONUS_16 = 26
IP_CONST_DAMAGEBONUS_3d10 = 55
IP_CONST_DAMAGEBONUS_17 = 27
IP_CONST_DAMAGEBONUS_5d6 = 33
IP_CONST_DAMAGEBONUS_7d4 = 49
IP_CONST_DAMAGEBONUS_18 = 28
IP_CONST_DAMAGEBONUS_4d8 = 42
IP_CONST_DAMAGEBONUS_19 = 29
IP_CONST_DAMAGEBONUS_3d12 = 63
IP_CONST_DAMAGEBONUS_20 = 30
IP_CONST_DAMAGEBONUS_8d4 = 50
IP_CONST_DAMAGEBONUS_6d6 = 34
IP_CONST_DAMAGEBONUS_4d10 = 56
IP_CONST_DAMAGEBONUS_5d8 = 43
IP_CONST_DAMAGEBONUS_9d4 = 51
IP_CONST_DAMAGEBONUS_7d6 = 35
IP_CONST_DAMAGEBONUS_10d4 = 52
IP_CONST_DAMAGEBONUS_4d12 = 64
IP_CONST_DAMAGEBONUS_6d8 = 44
IP_CONST_DAMAGEBONUS_5d10 = 57
IP_CONST_DAMAGEBONUS_8d6 = 36
IP_CONST_DAMAGEBONUS_7d8 = 45
IP_CONST_DAMAGEBONUS_9d6 = 53
IP_CONST_DAMAGEBONUS_5d12 = 65
IP_CONST_DAMAGEBONUS_6d10 = 58
IP_CONST_DAMAGEBONUS_8d8 = 46
IP_CONST_DAMAGEBONUS_10d6 = 54
IP_CONST_DAMAGEBONUS_7d10 = 59
IP_CONST_DAMAGEBONUS_6d12 = 66
IP_CONST_DAMAGEBONUS_9d8 = 47
IP_CONST_DAMAGEBONUS_8d10 = 60
IP_CONST_DAMAGEBONUS_10d8 = 48
IP_CONST_DAMAGEBONUS_7d12 = 67
IP_CONST_DAMAGEBONUS_9d10 = 61
IP_CONST_DAMAGEBONUS_8d12 = 68
IP_CONST_DAMAGEBONUS_10d10 = 62
IP_CONST_DAMAGEBONUS_9d12 = 69
IP_CONST_DAMAGEBONUS_10d12 = 70
*/