// Unsummon the OHS linkboy.  Be careful you don't have any henchmen still
// hired before doing this.
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_ohs_lbunsummon", OBJECT_SELF);
   SetIsDestroyable(TRUE, FALSE, FALSE);
   SetPlotFlag(OBJECT_SELF, FALSE);
   DestroyObject(OBJECT_SELF);
}
