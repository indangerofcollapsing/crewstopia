#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_physattackweb", OBJECT_SELF);
   object oAttacker = GetLastAttacker();
   //debugVarObject("oAttacker", oAttacker);
   ActionCastSpellAtObject(SPELL_WEB, oAttacker, METAMAGIC_ANY, TRUE, 0,
      PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
}
