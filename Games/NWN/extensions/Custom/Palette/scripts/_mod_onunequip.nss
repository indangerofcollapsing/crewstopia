// On Unequip Item event
#include "inc_cep_weapfeat"
#include "inc_debug_dac"
void main()
{
   ExecuteScript("x2_mod_def_unequ", OBJECT_SELF);
   ExecuteScript("prc_unequip", OBJECT_SELF);

   // Handle CEP weapon feats
   onUnequipCEPWeapon();

/* Found a better way to do this, but keeping this just in case.
   object oPC = GetPCItemLastEquippedBy();
   //debugVarObject("oPC", oPC);
   if (! GetIsPC(oPC)) return;

   object oItem = GetPCItemLastUnequipped();
   //debugVarObject("oItem", oItem);

   if (GetStringLeft(GetName(oItem), 15) == "Holy Symbol of ")
   {
      effect eEffect = GetFirstEffect(oPC);
      while (GetIsEffectValid(eEffect))
      {
         if (GetEffectType(eEffect) == EFFECT_TYPE_AREA_OF_EFFECT &&
            GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL &&
            GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY)
         {
            // Hopefully we've only got the Holy Symbol aura, but can't be sure.
            RemoveEffect(oPC, eEffect);
            SendMessageToPC(oPC, "Holy Symbol aura inactivated.");
         }
         eEffect = GetNextEffect(oPC);
      }
   }
*/
}
