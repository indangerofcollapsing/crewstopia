// Turns any creature into a doppelganger.  The on-spawn event will
// automagically pick a nearby creature to mimic.
#include "inc_doppelganger"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("convert_to_dopp", OBJECT_SELF);
   doppelgangerUncloak();
}


