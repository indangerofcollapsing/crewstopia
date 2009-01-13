const string HIGHLIGHT_START = "<c´jŸ>";
const string HIGHLIGHT_END = "</c>";

const int DEBUG_ENABLED = TRUE;

void debugMsg(string sMsg);
void debugVarInt(string sVarName, int nVarValue);
void debugVarFloat(string sVarName, float fVarValue);
void debugVarString(string sVarName, string sVarValue);
void debugVarLoc(string sVarName, location lVarValue);
void debugVarVector(string sVarName, vector vVarValue);
void debugVarObject(string sVarName, object oVarValue);
void debugVarBoolean(string sVarName, int bVarValue);
void debugVarItemProperty(string sVarName, itemproperty ipVarValue);

void logError(string sError);

string objectToString(object oVarValue);
string booleanToString(int bVarValue);
string itempropertyToString(itemproperty ipVarValue);

#include "x0_i0_position"
#include "prc_x2_itemprop" //#include "x2_inc_itemprop"

void debugMsg(string sMsg)
{
   if (DEBUG_ENABLED)
   {
      SendMessageToPC(GetFirstPC(), HIGHLIGHT_START + sMsg + HIGHLIGHT_END);
      WriteTimestampedLogEntry(sMsg);
   }
}

void debugVarInt(string sVarName, int nVarValue)
{
   if (DEBUG_ENABLED) debugMsg(sVarName + "=>" + IntToString(nVarValue) + "<");
}

void debugVarFloat(string sVarName, float fVarValue)
{
   if (DEBUG_ENABLED) debugMsg(sVarName + "=>" + FloatToString(fVarValue) + "<");
}

void debugVarString(string sVarName, string sVarValue)
{
   if (DEBUG_ENABLED) debugMsg(sVarName + "=>" + sVarValue + "<");
}

void debugVarLoc(string sVarName, location lVarValue)
{
   if (DEBUG_ENABLED) debugMsg(sVarName + "=>" + LocationToString(lVarValue));
}

void debugVarVector(string sVarName, vector vVarValue)
{
   if (DEBUG_ENABLED) debugMsg(sVarName + "=>" + VectorToString(vVarValue));
}

void debugVarObject(string sVarName, object oVarValue)
{
   if (DEBUG_ENABLED)
   {
      debugMsg(sVarName + "=>" + objectToString(oVarValue) + "<");
   }
}

void debugVarBoolean(string sVarName, int bVarValue)
{
   debugVarString(sVarName, booleanToString(bVarValue));
}

void debugVarItemProperty(string sVarName, itemproperty ipVarValue)
{
   debugVarString(sVarName, itempropertyToString(ipVarValue));
}

void logError(string sError)
{
   SendMessageToAllDMs(sError);
   WriteTimestampedLogEntry(sError);
}

string objectToString(object oVarValue)
{
   return oVarValue == OBJECT_INVALID ? "OBJECT_INVALID" :
      GetName(oVarValue) + " [resref=" + GetResRef(oVarValue) + ";tag=" +
      GetTag(oVarValue) + "]";
}

string booleanToString(int bVarValue)
{
   return bVarValue ? "TRUE" : "FALSE";
}

string itempropertyToString(itemproperty ipVarValue)
{
   if (! GetIsItemPropertyValid(ipVarValue)) return "[ITEMPROPERTY_INVALID]";

   string sIpDesc = "[item property: ";
   switch (GetItemPropertyType(ipVarValue))
   {
      case ITEM_PROPERTY_ABILITY_BONUS:
         sIpDesc += "ITEM_PROPERTY_ABILITY_BONUS ";
         break;
      case ITEM_PROPERTY_AC_BONUS:
         sIpDesc += "ITEM_PROPERTY_AC_BONUS";
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
         sIpDesc += "ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP";
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
         sIpDesc += "ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE";
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
         sIpDesc += "ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP";
         break;
      case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
         sIpDesc += "ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT";
         break;
      case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
         sIpDesc += "ITEM_PROPERTY_ARCANE_SPELL_FAILURE";
         break;
      case ITEM_PROPERTY_ATTACK_BONUS:
         sIpDesc += "ITEM_PROPERTY_ATTACK_BONUS";
         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
         sIpDesc += "ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP";
         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
         sIpDesc += "ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP";
         break;
//      case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNEMENT:
//         sIpDesc += "ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNEMENT";
//         break;
      case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
         sIpDesc += "ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT";
         break;
      case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
         sIpDesc += "ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION";
         break;
      case ITEM_PROPERTY_BONUS_FEAT:
         sIpDesc += "ITEM_PROPERTY_BONUS_FEAT";
         break;
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
         sIpDesc += "ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N";
         break;
//      case ITEM_PROPERTY_BOOMERANG:
//         sIpDesc += "ITEM_PROPERTY_BOOMERANG";
//         break;
      case ITEM_PROPERTY_CAST_SPELL:
         sIpDesc += "ITEM_PROPERTY_CAST_SPELL";
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_BONUS";
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP";
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP";
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT";
         break;
      case ITEM_PROPERTY_DAMAGE_REDUCTION:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_REDUCTION";
         break;
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_RESISTANCE";
         break;
      case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
         sIpDesc += "ITEM_PROPERTY_DAMAGE_VULNERABILITY";
         break;
//      case ITEM_PROPERTY_DANCING:
//         sIpDesc += "ITEM_PROPERTY_DANCING";
//         break;
      case ITEM_PROPERTY_DARKVISION:
         sIpDesc += "ITEM_PROPERTY_DARKVISION";
         break;
      case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
         sIpDesc += "ITEM_PROPERTY_DECREASED_ABILITY_SCORE";
         break;
      case ITEM_PROPERTY_DECREASED_AC:
         sIpDesc += "ITEM_PROPERTY_DECREASED_AC";
         break;
      case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
         sIpDesc += "ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER";
         break;
      case ITEM_PROPERTY_DECREASED_DAMAGE:
         sIpDesc += "ITEM_PROPERTY_DECREASED_DAMAGE";
         break;
      case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
         sIpDesc += "ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER";
         break;
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
         sIpDesc += "ITEM_PROPERTY_DECREASED_SAVING_THROWS";
         break;
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
         sIpDesc += "ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC";
         break;
      case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
         sIpDesc += "ITEM_PROPERTY_DECREASED_SKILL_MODIFIER";
         break;
//      case ITEM_PROPERTY_DOUBLE_STACK:
//         sIpDesc += "ITEM_PROPERTY_DOUBLE_STACK";
//         break;
//      case ITEM_PROPERTY_ENHANCED_CONTAINER_BONUS_SLOTS:
//         sIpDesc += "ITEM_PROPERTY_ENHANCED_CONTAINER_BONUS_SLOTS";
//         break;
      case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
         sIpDesc += "ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT";
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS:
         sIpDesc += "ITEM_PROPERTY_ENHANCEMENT_BONUS";
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
         sIpDesc += "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP";
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
         sIpDesc += "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP";
         break;
      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
         sIpDesc += "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT";
         break;
//      case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNMENT:
//         sIpDesc += "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNMENT";
//         break;
      case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
         sIpDesc += "ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE";
         break;
      case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
         sIpDesc += "ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE";
         break;
      case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
         sIpDesc += "ITEM_PROPERTY_FREEDOM_OF_MOVEMENT";
         break;
      case ITEM_PROPERTY_HASTE:
         sIpDesc += "ITEM_PROPERTY_HASTE";
         break;
      case ITEM_PROPERTY_HEALERS_KIT:
         sIpDesc += "ITEM_PROPERTY_HEALERS_KIT";
         break;
      case ITEM_PROPERTY_HOLY_AVENGER:
         sIpDesc += "ITEM_PROPERTY_HOLY_AVENGER";
         break;
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
         sIpDesc += "ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE";
         break;
      case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
         sIpDesc += "ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS";
         break;
//      case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SCHOOL:
//         sIpDesc += "ITEM_PROPERTY_IMMUNITY_SPECIFIC_SCHOOL";
//         break;
      case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
         sIpDesc += "ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL";
         break;
      case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
         sIpDesc += "ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL";
         break;
      case ITEM_PROPERTY_IMPROVED_EVASION:
         sIpDesc += "ITEM_PROPERTY_IMPROVED_EVASION";
         break;
      case ITEM_PROPERTY_KEEN:
         sIpDesc += "ITEM_PROPERTY_KEEN";
         break;
      case ITEM_PROPERTY_LIGHT:
         sIpDesc += "ITEM_PROPERTY_LIGHT";
         break;
      case ITEM_PROPERTY_MASSIVE_CRITICALS:
         sIpDesc += "ITEM_PROPERTY_MASSIVE_CRITICALS";
         break;
      case ITEM_PROPERTY_MIGHTY:
         sIpDesc += "ITEM_PROPERTY_MIGHTY";
         break;
      case ITEM_PROPERTY_MIND_BLANK:
         sIpDesc += "ITEM_PROPERTY_MIND_BLANK";
         break;
      case ITEM_PROPERTY_MONSTER_DAMAGE:
         sIpDesc += "ITEM_PROPERTY_MONSTER_DAMAGE";
         break;
      case ITEM_PROPERTY_NO_DAMAGE:
         sIpDesc += "ITEM_PROPERTY_NO_DAMAGE";
         break;
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:
         sIpDesc += "ITEM_PROPERTY_ON_HIT_PROPERTIES";
         break;
      case ITEM_PROPERTY_ON_MONSTER_HIT:
         sIpDesc += "ITEM_PROPERTY_ON_MONSTER_HIT";
         break;
      case ITEM_PROPERTY_ONHITCASTSPELL:
         sIpDesc += "ITEM_PROPERTY_ONHITCASTSPELL";
         break;
      case ITEM_PROPERTY_POISON:
         sIpDesc += "ITEM_PROPERTY_POISON";
         break;
      case ITEM_PROPERTY_REGENERATION:
         sIpDesc += "ITEM_PROPERTY_REGENERATION";
         break;
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
         sIpDesc += "ITEM_PROPERTY_REGENERATION_VAMPIRIC";
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS:
         sIpDesc += "ITEM_PROPERTY_SAVING_THROW_BONUS";
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
         sIpDesc += "ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC";
         break;
      case ITEM_PROPERTY_SKILL_BONUS:
         sIpDesc += "ITEM_PROPERTY_SKILL_BONUS";
         break;
      case ITEM_PROPERTY_SPECIAL_WALK:
         sIpDesc += "ITEM_PROPERTY_SPECIAL_WALK";
         break;
      case ITEM_PROPERTY_SPELL_RESISTANCE:
         sIpDesc += "ITEM_PROPERTY_SPELL_RESISTANCE";
         break;
      case ITEM_PROPERTY_THIEVES_TOOLS:
         sIpDesc += "ITEM_PROPERTY_THIEVES_TOOLS";
         break;
      case ITEM_PROPERTY_TRAP:
         sIpDesc += "ITEM_PROPERTY_TRAP";
         break;
      case ITEM_PROPERTY_TRUE_SEEING:
         sIpDesc += "ITEM_PROPERTY_TRUE_SEEING";
         break;
      case ITEM_PROPERTY_TURN_RESISTANCE:
         sIpDesc += "ITEM_PROPERTY_TURN_RESISTANCE";
         break;
      case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
         sIpDesc += "ITEM_PROPERTY_UNLIMITED_AMMUNITION";
         break;
      case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
         sIpDesc += "ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP";
         break;
      case ITEM_PROPERTY_USE_LIMITATION_CLASS:
         sIpDesc += "ITEM_PROPERTY_USE_LIMITATION_CLASS";
         break;
      case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
         sIpDesc += "ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE";
         break;
      case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
         sIpDesc += "ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT";
         break;
      case ITEM_PROPERTY_USE_LIMITATION_TILESET:
         sIpDesc += "ITEM_PROPERTY_USE_LIMITATION_TILESET";
         break;
      case ITEM_PROPERTY_VISUALEFFECT:
         sIpDesc += "ITEM_PROPERTY_VISUALEFFECT";
         break;
//      case ITEM_PROPERTY_VORPAL:
//         sIpDesc += "ITEM_PROPERTY_VORPAL";
//         break;
      case ITEM_PROPERTY_WEIGHT_INCREASE:
         sIpDesc += "ITEM_PROPERTY_WEIGHT_INCREASE";
         break;
//      case ITEM_PROPERTY_WOUNDING:
//         sIpDesc += "ITEM_PROPERTY_WOUNDING";
//         break;
      default:
         sIpDesc += "(Unknown type: " + IntToString(GetItemPropertyType(
            ipVarValue)) + ")";
         break;
   }

   sIpDesc += ", subtype " + IntToString(GetItemPropertySubType(ipVarValue));
   sIpDesc += ", param1 " + IntToString(GetItemPropertyParam1(ipVarValue));
   sIpDesc += ", param1Value " + IntToString(GetItemPropertyParam1Value(
      ipVarValue));
   sIpDesc += ", costtable " + IntToString(GetItemPropertyCostTable(
      ipVarValue));
   sIpDesc += ", costtableValue " + IntToString(GetItemPropertyCostTableValue(
      ipVarValue));
   sIpDesc += ", durationtype " + (GetItemPropertyDurationType(ipVarValue) ==
      DURATION_TYPE_PERMANENT ? "PERMANENT" : "TEMPORARY");
   return sIpDesc;
}

//void main() {} // testing/compiling purposes
