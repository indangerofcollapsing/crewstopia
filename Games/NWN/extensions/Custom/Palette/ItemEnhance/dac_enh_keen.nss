#include "inc_enhanceitems"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_enh_keen", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   //debugVarInt("ITEM_PROPERTY_KEEN", ITEM_PROPERTY_KEEN);
   SetLocalInt(oPC, VAR_ENHANCE_PROPERTY, ITEM_PROPERTY_KEEN);
   //debugVarInt("property from variable", GetLocalInt(oPC, VAR_ENHANCE_PROPERTY));
}
