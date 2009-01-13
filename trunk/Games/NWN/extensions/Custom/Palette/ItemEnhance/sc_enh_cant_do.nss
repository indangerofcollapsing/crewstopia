#include "inc_enhanceitems"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetLocalObject(oPC, VAR_ENHANCE_ITEM);
   int nProperty = GetLocalInt(oPC, VAR_ENHANCE_PROPERTY);
   return (! canEnhanceItem(oItem, nProperty));
}
