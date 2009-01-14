// Template for On Module Load event
#include "inc_persistworld"
#include "inc_lock"
#include "inc_trap"
#include "inc_doppelganger"
#include "inc_debug_dac"
#include "x2_inc_switches"
void main()
{
   //debugVarObject("_mod_on_load", OBJECT_SELF);

   ExecuteScript("prc_onmodload", OBJECT_SELF);

   // Use custom Soulknife "Shape Mindblade" feat -- see psi_sk_shmbld.nss
   SetLocalInt(GetModule(), "SOULKNIFE_CUSTOM_MINDBLADE_SHAPES", 1);
   // Respawnable traps
   ExecuteScript("trap_on_load", OBJECT_SELF);
}
