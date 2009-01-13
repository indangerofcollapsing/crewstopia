// Have I been commanded to "defend my master"?
// Not really designed for dialogs, but used by inc_ropebridge, it's here in
// case it's ever useful in a dialog.
#include "nw_i0_generic"
int StartingConditional()
{
   return GetAssociateState(NW_ASC_MODE_DEFEND_MASTER);
}