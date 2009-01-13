// Sets custom token 2112 to the bridge max safe load, and 2113 to the fall
// distance in feet.
#include "inc_ropebridge"
void main()
{
   int nMaxLoad = getRopeBridgeMaxSafeLoad(OBJECT_SELF);
   SetCustomToken(2112, IntToString(nMaxLoad));
   int nDamageDice = getRopeBridgeFallDamageDice(OBJECT_SELF);
   SetCustomToken(2113, IntToString(nDamageDice * 10));
}
