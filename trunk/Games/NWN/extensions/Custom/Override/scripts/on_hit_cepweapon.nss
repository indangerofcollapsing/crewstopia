#include "inc_cep_weapfeat"
#include "inc_debug_dac"
void main()
{
   debugVarObject("on_hit_cepweapon", OBJECT_SELF);
   onHitCEPWeapon();
}
