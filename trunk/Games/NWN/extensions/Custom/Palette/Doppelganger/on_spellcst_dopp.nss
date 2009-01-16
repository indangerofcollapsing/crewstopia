#include "inc_doppelganger"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_spellcst_dopp", OBJECT_SELF);
   if (GetLastSpellHarmful()) doppelgangerUncloak();
   ExecuteScript("nw_c2_defaultb", OBJECT_SELF);
}
