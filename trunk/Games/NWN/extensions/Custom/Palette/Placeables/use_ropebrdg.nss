#include "inc_ropebridge"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("use_ropebrdg", OBJECT_SELF);
   object oUser = GetLastUsedBy();
   //debugVarObject("oUser", oUser);

   useRopeBridge(oUser, OBJECT_SELF);
}
