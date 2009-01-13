#include "inc_enhanceitems"
//#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_enh_ability", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   //debugVarInt("ITEM_PROPERTY_ABILITY_BONUS", ITEM_PROPERTY_ABILITY_BONUS);
   SetLocalInt(oPC, VAR_ENHANCE_PROPERTY, ITEM_PROPERTY_ABILITY_BONUS);
   //debugVarInt("property from variable", GetLocalInt(oPC, VAR_ENHANCE_PROPERTY));
}
