// On Equip Item event
#include "inc_cep_weapfeat"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("_mod_onequip", OBJECT_SELF);

   ExecuteScript("prc_equip", OBJECT_SELF);

   // Handle CEP weapon feats
   onEquipCEPWeapon();
}
