// Doppelgangers pretend to be harmless until your guard is down.  Sneaky!
#include "inc_doppelganger"
#include "inc_variables"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dlg_undisguiseme", OBJECT_SELF);
   int nDoppChance = getVarInt(OBJECT_SELF, VAR_DOPPELGANGER_CHANCE);
   //debugVarInt("nDoppChance", nDoppChance);
   if (d100() <= nDoppChance)
   {
      //debugVarObject("doppelganger!", OBJECT_SELF);
      // I am a doppelganger.  Uncloak and attack.
      doppelgangerUncloak();
   }
}
