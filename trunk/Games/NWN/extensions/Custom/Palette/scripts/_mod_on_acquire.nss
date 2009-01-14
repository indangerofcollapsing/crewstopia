#include "inc_debug_dac"
void main()
{
   //debugVarObject("_mod_on_acquire", OBJECT_SELF);

   ExecuteScript("x2_mod_def_aqu", OBJECT_SELF);
   ExecuteScript("prc_onaquire", OBJECT_SELF);

   object oOwner = GetModuleItemAcquiredBy();
   //debugVarObject("oOwner", oOwner);
   if (! GetIsPC(oOwner)) return;

   object oItem = GetModuleItemAcquired();
   //debugVarObject("oItem", oItem);
   if (oItem == OBJECT_INVALID) return;

   // Attempt to identify the object
   if (! GetIdentified(oItem) && GetResRef(oItem) != "nw_it_gold001")
   {
      int nLore = GetSkillRank(SKILL_LORE, oOwner);
      string sMaxValue = Get2DAString("SkillVsItemCost", "DeviceCostMax", nLore);
      int nMaxValue = StringToInt(sMaxValue);
      // * Handle overflow (November 2003 - BK)
      if (sMaxValue == "") nMaxValue = 120000000;

      SetIdentified(oItem, TRUE); // setting TRUE to get the true value of the item
      int nItemValue = GetGoldPieceValue(oItem);
      SetIdentified(oItem, FALSE); // back to FALSE
      if (nMaxValue >= nItemValue)
      {
         SetIdentified(oItem, TRUE);
         SendMessageToPC(oOwner, "You have identified this " + GetName(oItem));
      }
   }
}
