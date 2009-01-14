// On Heartbeat for an auto-firing siege engine
#include "inc_ia_ballista"
void main()
{
   if (GetLocalInt(OBJECT_SELF, VAR_IS_RELOADING)) return;

   int nMinElev = getMinElev();
   int nMaxElev = getMaxElev();
   int nElev = nMinElev + (Random(nMaxElev - nMinElev));
   SetLocalInt(OBJECT_SELF, VAR_CURRENT_ELEVATION, nElev);
   int nMaxBearing = getMaxBearing();
   int nBearing = 0 - nMaxBearing + Random(2 * nMaxBearing);
   SetLocalInt(OBJECT_SELF, VAR_CURRENT_BEARING, nBearing);
   adjustAim(0, 0);
   //debug(GetName(OBJECT_SELF) + " firing at bearing " + IntToString(nBearing) +
//      ", elevation " + IntToString(nElev));
   launchMissile();
}
