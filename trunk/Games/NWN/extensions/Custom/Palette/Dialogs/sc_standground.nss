// Have I been commanded to "stand my ground"?
// Not really designed for dialogs, but used by inc_ropebridge, it's here in
// case it's ever useful in a dialog.
#include "nw_i0_generic"
#include "inc_debug_dac"
int StartingConditional()
{
   debugVarObject("sc_standground", OBJECT_SELF);
   int nState = GetAssociateState(NW_ASC_MODE_STAND_GROUND);
   debugVarInt("nState", nState);
   return nState;
}