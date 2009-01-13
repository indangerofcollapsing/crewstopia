#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   SetLocalInt(oPC, VAR_ENHANCE_PROPERTY, ITEM_PROPERTY_DARKVISION);
}
