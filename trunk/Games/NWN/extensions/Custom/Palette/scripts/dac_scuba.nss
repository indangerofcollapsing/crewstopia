#include "inc_underwater"
#include "inc_debug_dac"
void main()
{
   //debug("dac_scuba");
   object oUser = GetItemActivator();
   //debugVarObject("oUser", oUser);
   FloatingTextStringOnCreature("  o", oUser);
   FloatingTextStringOnCreature("o  ", oUser);
   FloatingTextStringOnCreature(" o ", oUser);
   FloatingTextStringOnCreature("o  ", oUser);
   FloatingTextStringOnCreature(" o ", oUser);
   takeDeepBreath(oUser);
}
