// On Unequip Item event
#include "inc_cep_weapfeat"
#include "inc_debug_dac"
void main()
{
   ExecuteScript("prc_unequip", OBJECT_SELF);

   // Handle CEP weapon feats
   onUnequipCEPWeapon();
}
