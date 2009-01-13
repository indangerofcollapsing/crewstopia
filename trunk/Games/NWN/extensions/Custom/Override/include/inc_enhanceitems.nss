#include "inc_debug_dac"
#include "prc_x2_itemprop" //#include "x2_inc_itemprop"

void enhanceItem(object oItem, itemproperty ip, int nDurationType);
itemproperty getEnhanceIP(object oPC);
int canEnhanceItem(object oItem, int nProperty);
void setEnhanceItem(object oPC, object oItem);

// Dialog custom tokens
// 2101 Name of item being upgraded
// 2102 Cost of upgrade
// 2103 Left hand
// 2104 Armor
// 2105 Helm
// 2106 Left Ring
// 2107 Right Ring
// 2108 Gloves
// 2109 Gauntlets
// 2110 Cloak
// 2111 Amulet

const string VAR_ENHANCE_ITEM = "CURRENT_ENHANCE_ITEM";
const string VAR_ENHANCE_PROPERTY = "CURRENT_ENHANCE_PROPERTY";
const string VAR_ENHANCE_DURATION = "CURRENT_ENHANCE_DURATION";
const string VAR_ENHANCE_PARAM1 = "CURRENT_ENHANCE_PARAM1";
const string VAR_ENHANCE_PARAM2 = "CURRENT_ENHANCE_PARAM2";
const string VAR_ENHANCE_PARAM3 = "CURRENT_ENHANCE_PARAM3";
const string VAR_ENHANCE_COST = "CURRENT_ENHANCE_COST";
const float ONE_DAY = 86400.0; // one day, in seconds
const int ENHANCE_COST_MODIFIER = 10;
// Agh!  The constant for ability bonus propertyitems is zero!
const int ENHANCE_PROPERTY_NONE = -1;

void enhanceItem(object oItem, itemproperty ip, int nDurationType)
{
   debugVarObject("enhanceItem()", OBJECT_SELF);
   debugVarItemProperty("ip", ip);
   debugVarObject("oItem", oItem);
   debugVarInt("nDurationType", nDurationType);

   float fDuration = (nDurationType == DURATION_TYPE_TEMPORARY ? ONE_DAY : 0.0f);
   IPSafeAddItemProperty(oItem, ip, fDuration);

   // Rename armor, shields, weapons, and ammo for basic enhancements.
   if (nDurationType == DURATION_TYPE_PERMANENT)
   {
      string sPlusValue = "";
      switch(GetItemPropertyType(ip))
      {
         case ITEM_PROPERTY_AC_BONUS:
            switch(GetBaseItemType(oItem))
            {
               case BASE_ITEM_ARMOR:
               case BASE_ITEM_LARGESHIELD:
               case BASE_ITEM_SMALLSHIELD:
               case BASE_ITEM_TOWERSHIELD:
                  sPlusValue = IntToString(GetLocalInt(GetPCSpeaker(),
                     VAR_ENHANCE_PARAM1));
                  break;
               default:
                  // nothing
                 break;
            }
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            if (IPGetIsMeleeWeapon(oItem) || IPGetIsRangedWeapon(oItem) ||
                IPGetIsProjectile(oItem))
            {
               //debugMsg("weapon or ammo");
               sPlusValue = IntToString(GetLocalInt(GetPCSpeaker(),
                  VAR_ENHANCE_PARAM1));
            }
            break;
         default:
            //debugMsg("not an item to change the name on");
            // nothing
            break;
      }
      //debugVarString("sPlusValue", sPlusValue);
      if (sPlusValue != "")
      {
         string sName = GetName(oItem);
         //debugVarString("sName", sName);
         int nPos = FindSubString(sName, "+");
         //debugVarInt("nPos", nPos);
         if (nPos == -1)
         {
            sName = sName + " +";
            //debugVarString("+ not found, sName", sName);
         }
         else
         {
            sName = GetStringLeft(sName, nPos + 1);
            //debugVarString("+ found, sName", sName);
         }
         sName = sName + sPlusValue;
         SetName(oItem, sName);
      }
   } // renaming
}

itemproperty getEnhanceIP(object oPC)
{
   //debugVarObject("getEnhanceIP()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   itemproperty ip;
   int nProperty = GetLocalInt(oPC, VAR_ENHANCE_PROPERTY);
   //debugVarInt("nProperty", nProperty);
   if (nProperty == ENHANCE_PROPERTY_NONE)
   {
      SendMessageToPC(oPC, "Error in script -- please notify a DM.");
      logError("ERROR: no current upgrade property for " + objectToString(oPC) +
         " in getEnhanceIP()");
      return ip;
   }

   int nParam1 = GetLocalInt(oPC, VAR_ENHANCE_PARAM1);
   //debugVarInt("nParam1", nParam1);
   int nParam2 = GetLocalInt(oPC, VAR_ENHANCE_PARAM2);
   //debugVarInt("nParam2", nParam2);
   int nParam3 = GetLocalInt(oPC, VAR_ENHANCE_PARAM3);
   //debugVarInt("nParam3", nParam3);

   switch (nProperty)
   {
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:
         ip = ItemPropertyOnHitProps(nParam1, nParam2, nParam3);
         break;
      case ITEM_PROPERTY_ABILITY_BONUS:
         ip = ItemPropertyAbilityBonus(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
         ip = ItemPropertyACBonusVsAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
         ip = ItemPropertyACBonusVsDmgType(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
         ip = ItemPropertyACBonusVsRace(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
         ip = ItemPropertyACBonusVsSAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_AC_BONUS:
         ip = ItemPropertyACBonus(nParam1);
         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
         ip = ItemPropertyAttackBonusVsAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
         ip = ItemPropertyAttackBonusVsRace(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
         ip = ItemPropertyAttackBonusVsSAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
         ip = ItemPropertyBonusLevelSpell(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_CAST_SPELL:
         ip = ItemPropertyCastSpell(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS:
         ip = ItemPropertyDamageBonus(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
         ip = ItemPropertyDamageBonusVsAlign(nParam1, nParam2, nParam3);
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
         ip = ItemPropertyDamageBonusVsRace(nParam1, nParam2, nParam3);
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
         ip = ItemPropertyDamageBonusVsSAlign(nParam1, nParam2, nParam3);
         break;
      case ITEM_PROPERTY_DAMAGE_REDUCTION:
         ip = ItemPropertyDamageReduction(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:
         ip = ItemPropertyDamageResistance(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
         ip = ItemPropertyDamageVulnerability(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
         ip = ItemPropertyDecreaseAbility(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DECREASED_AC:
         ip = ItemPropertyDecreaseAC(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
         ip = ItemPropertyReducedSavingThrow(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
         ip = ItemPropertyReducedSavingThrowVsX(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
         ip = ItemPropertyDecreaseSkill(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
         ip = ItemPropertyEnhancementBonusVsAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
         ip = ItemPropertyEnhancementBonusVsRace(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
         ip = ItemPropertyEnhancementBonusVsSAlign(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
         ip = ItemPropertyDamageImmunity(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_LIGHT:
         ip = ItemPropertyLight(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ONHITCASTSPELL:
         ip = ItemPropertyOnHitCastSpell(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS:
         ip = ItemPropertyBonusSavingThrow(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
         ip = ItemPropertyBonusSavingThrowVsX(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_SKILL_BONUS:
         ip = ItemPropertySkillBonus(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_TRAP:
         ip = ItemPropertyTrap(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
         ip = ItemPropertyArcaneSpellFailure(nParam1);
         break;
      case ITEM_PROPERTY_ATTACK_BONUS:
         ip = ItemPropertyAttackBonus(nParam1);
         break;
      case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
         ip = ItemPropertyWeightReduction(nParam1);
         break;
      case ITEM_PROPERTY_BONUS_FEAT:
         ip = ItemPropertyBonusFeat(nParam1);
         break;
      case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
         ip = ItemPropertyAttackPenalty(nParam1);
         break;
      case ITEM_PROPERTY_DECREASED_DAMAGE:
         ip = ItemPropertyDamagePenalty(nParam1);
         break;
      case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
         ip = ItemPropertyEnhancementPenalty(nParam1);
         break;
      case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
         ip = ItemPropertyContainerReducedWeight(nParam1);
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS:
         ip = ItemPropertyEnhancementBonus(nParam1);
         break;
      case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
         ip = ItemPropertyExtraMeleeDamageType(nParam1);
         break;
      case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
         ip = ItemPropertyExtraRangeDamageType(nParam1);
         break;
      case ITEM_PROPERTY_HEALERS_KIT:
         ip = ItemPropertyHealersKit(nParam1);
         break;
      case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
         ip = ItemPropertyImmunityMisc(nParam1);
         break;
      case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
         ip = ItemPropertySpellImmunitySpecific(nParam1);
         break;
      case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
         ip = ItemPropertySpellImmunitySchool(nParam1);
         break;
      case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
         ip = ItemPropertyImmunityToSpellLevel(nParam1);
         break;
      case ITEM_PROPERTY_MASSIVE_CRITICALS:
         ip = ItemPropertyMassiveCritical(nParam1);
         break;
      case ITEM_PROPERTY_MIGHTY:
         ip = ItemPropertyMaxRangeStrengthMod(nParam1);
         break;
      case ITEM_PROPERTY_MONSTER_DAMAGE:
         ip = ItemPropertyMonsterDamage(nParam1);
         break;
      case ITEM_PROPERTY_ON_MONSTER_HIT:
         ip = ItemPropertyOnMonsterHitProperties(nParam1, nParam2);
         break;
      case ITEM_PROPERTY_REGENERATION:
         ip = ItemPropertyRegeneration(nParam1);
         break;
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
         ip = ItemPropertyVampiricRegeneration(nParam1);
         break;
      case ITEM_PROPERTY_SPECIAL_WALK:
         ip = ItemPropertySpecialWalk(nParam1);
         break;
      case ITEM_PROPERTY_THIEVES_TOOLS:
         ip = ItemPropertyThievesTools(nParam1);
         break;
      case ITEM_PROPERTY_TURN_RESISTANCE:
         ip = ItemPropertyTurnResistance(nParam1);
         break;
      case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
         ip = ItemPropertyUnlimitedAmmo(nParam1);
         break;
      case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
         ip = ItemPropertyLimitUseByAlign(nParam1);
         break;
      case ITEM_PROPERTY_USE_LIMITATION_CLASS:
         ip = ItemPropertyLimitUseByClass(nParam1);
         break;
      case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
         ip = ItemPropertyLimitUseByRace(nParam1);
         break;
      case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
         ip = ItemPropertyLimitUseBySAlign(nParam1);
         break;
      case ITEM_PROPERTY_VISUALEFFECT:
         ip = ItemPropertyVisualEffect(nParam1);
         break;
      case ITEM_PROPERTY_WEIGHT_INCREASE:
         ip = ItemPropertyWeightIncrease(nParam1);
         break;
      case ITEM_PROPERTY_SPELL_RESISTANCE:
         ip = ItemPropertyBonusSpellResistance(nParam1);
         break;
      case ITEM_PROPERTY_DARKVISION:
         ip = ItemPropertyDarkvision();
         break;
      case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
         ip = ItemPropertyFreeAction();
         break;
      case ITEM_PROPERTY_HASTE:
         ip = ItemPropertyHaste();
         break;
      case ITEM_PROPERTY_HOLY_AVENGER:
         ip = ItemPropertyHolyAvenger();
         break;
      case ITEM_PROPERTY_IMPROVED_EVASION:
         ip = ItemPropertyImprovedEvasion();
         break;
      case ITEM_PROPERTY_KEEN:
         ip = ItemPropertyKeen();
         break;
      case ITEM_PROPERTY_NO_DAMAGE:
         ip = ItemPropertyNoDamage();
         break;
      case ITEM_PROPERTY_TRUE_SEEING:
         ip = ItemPropertyTrueSeeing();
         break;
      // Not sure what these are used for or how to create them
      case ITEM_PROPERTY_MIND_BLANK:
         logError("ITEM_PROPERTY_MIND_BLANK chosen in getEnhanceIP()");
         break;
      case ITEM_PROPERTY_POISON:
         logError("ITEM_PROPERTY_POISON chosen in getEnhanceIP()");
         break;
      default:
         SendMessageToPC(oPC, "Error in script -- please notify a DM.");
         logError("ERROR: upgrade property " + IntToString(nProperty) +
            " not found for " + objectToString(oPC) + " in getEnhanceIP()");
         break;
   }
   if (! GetIsItemPropertyValid(ip))
   {
      logError("ERROR: invalid itemproperty in getEnhanceIP()");
      logError("oPC=" + objectToString(oPC));
      logError("nProperty=" + IntToString(nProperty));
      logError("nParam1=" + IntToString(nParam1));
      logError("nParam2=" + IntToString(nParam2));
      logError("nParam3=" + IntToString(nParam3));
   }
   return ip;
}

int canEnhanceItem(object oItem, int nProperty)
{
   //debugVarObject("canEnhanceItem()", OBJECT_SELF);
   //debugVarObject("oItem", oItem);
   //debugVarInt("nProperty", nProperty);

   int nBaseItem = GetBaseItemType(oItem);
   //debugVarInt("nBaseItem", nBaseItem);
   int bIsMeleeWeapon = IPGetIsMeleeWeapon(oItem);
   //debugVarBoolean("bIsMeleeWeapon", bIsMeleeWeapon);
   int bIsRangedWeapon = IPGetIsRangedWeapon(oItem);
   //debugVarBoolean("bIsRangedWeapon", bIsRangedWeapon);
   int bIsProjectile = IPGetIsProjectile(oItem);
   //debugVarBoolean("bIsProjectile", bIsProjectile);
   switch(nProperty)
   {
      case ITEM_PROPERTY_ABILITY_BONUS:
      case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
      case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
      case ITEM_PROPERTY_HASTE:
      case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
      case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
      case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
      case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
      case ITEM_PROPERTY_IMPROVED_EVASION:
      case ITEM_PROPERTY_MIND_BLANK:
      case ITEM_PROPERTY_REGENERATION:
      case ITEM_PROPERTY_SAVING_THROW_BONUS:
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
      case ITEM_PROPERTY_SKILL_BONUS:
      case ITEM_PROPERTY_SPELL_RESISTANCE:
      case ITEM_PROPERTY_TRUE_SEEING:
      case ITEM_PROPERTY_TURN_RESISTANCE:
         return (nBaseItem == BASE_ITEM_AMULET ||
            nBaseItem == BASE_ITEM_BELT ||
            nBaseItem == BASE_ITEM_BOOTS ||
            nBaseItem == BASE_ITEM_CLOAK ||
            nBaseItem == BASE_ITEM_GLOVES ||
            nBaseItem == BASE_ITEM_HELMET ||
            nBaseItem == BASE_ITEM_RING);
         break;
      case ITEM_PROPERTY_AC_BONUS:
      case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
      case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
      case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
      case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
      case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
      case ITEM_PROPERTY_DAMAGE_REDUCTION:
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:
      case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
      case ITEM_PROPERTY_DECREASED_AC:
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
         return (nBaseItem == BASE_ITEM_ARMOR ||
            nBaseItem == BASE_ITEM_LARGESHIELD ||
            nBaseItem == BASE_ITEM_SMALLSHIELD ||
            nBaseItem == BASE_ITEM_TOWERSHIELD);
         break;
      case ITEM_PROPERTY_ATTACK_BONUS:
      case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
      case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
      case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
      case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
      case ITEM_PROPERTY_KEEN:
      case ITEM_PROPERTY_MIGHTY:
         return (bIsMeleeWeapon || bIsRangedWeapon);
         break;
      case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
      case ITEM_PROPERTY_BONUS_FEAT:
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
      case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
         return TRUE;
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
      case ITEM_PROPERTY_CAST_SPELL:
      case ITEM_PROPERTY_DARKVISION:
         return (nBaseItem == BASE_ITEM_AMULET ||
            nBaseItem == BASE_ITEM_BOOK ||
            nBaseItem == BASE_ITEM_ENCHANTED_SCROLL ||
            nBaseItem == BASE_ITEM_ENCHANTED_WAND ||
            nBaseItem == BASE_ITEM_GEM ||
            nBaseItem == BASE_ITEM_HELMET ||
            nBaseItem == BASE_ITEM_RING ||
            nBaseItem == BASE_ITEM_SCROLL);
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS:
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
      case ITEM_PROPERTY_DECREASED_DAMAGE:
      case ITEM_PROPERTY_MASSIVE_CRITICALS:
      case ITEM_PROPERTY_NO_DAMAGE:
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:
      case ITEM_PROPERTY_ONHITCASTSPELL:
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
         return (bIsMeleeWeapon || bIsProjectile ||
            nBaseItem == BASE_ITEM_GLOVES);
         break;
      case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
      case ITEM_PROPERTY_ENHANCEMENT_BONUS:
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
         return (bIsMeleeWeapon || bIsRangedWeapon);
         break;
      case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
         return (nBaseItem == BASE_ITEM_LARGEBOX ||
            nBaseItem == BASE_ITEM_MISCMEDIUM);
         break;
      case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
      case ITEM_PROPERTY_HOLY_AVENGER:
         return bIsMeleeWeapon;
         break;
      case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
         return bIsProjectile;
         break;
      case ITEM_PROPERTY_HEALERS_KIT:
      case ITEM_PROPERTY_POISON:
      case ITEM_PROPERTY_THIEVES_TOOLS:
      case ITEM_PROPERTY_TRAP:
      case ITEM_PROPERTY_USE_LIMITATION_TILESET:
         return FALSE;
         break;
      case ITEM_PROPERTY_LIGHT:
      case ITEM_PROPERTY_SPECIAL_WALK:
      case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
      case ITEM_PROPERTY_USE_LIMITATION_CLASS:
      case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
      case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
      case ITEM_PROPERTY_VISUALEFFECT:
      case ITEM_PROPERTY_WEIGHT_INCREASE:
         return TRUE;
         break;
      case ITEM_PROPERTY_MONSTER_DAMAGE:
      case ITEM_PROPERTY_ON_MONSTER_HIT:
         return (nBaseItem == BASE_ITEM_CPIERCWEAPON ||
            nBaseItem == BASE_ITEM_CSLASHWEAPON ||
            nBaseItem == BASE_ITEM_CSLSHPRCWEAP);
         break;
      case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
         return bIsRangedWeapon;
         break;
      default:
         logError("Invalid itemproperty type " + IntToString(nProperty) +
            " for " + objectToString(oItem) + " in canEnhanceItem()");
         return FALSE;
   }
   return FALSE;
}

void setEnhanceItem(object oPC, object oItem)
{
   SetLocalObject(oPC, VAR_ENHANCE_ITEM, oItem);
   SetCustomToken(2101, GetName(oItem));
   // Workaround for ITEM_PROPERTY_ABILITY_BONUS being zero
   SetLocalInt(oPC, VAR_ENHANCE_PROPERTY, ENHANCE_PROPERTY_NONE);
}

//void main() {} // Testing/compiling purposes
