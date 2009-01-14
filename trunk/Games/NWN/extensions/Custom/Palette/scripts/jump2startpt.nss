#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("jump2startpt", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lStart = GetStartingLocation();
   AssignCommand(oPC, JumpToLocation(lStart));
}
