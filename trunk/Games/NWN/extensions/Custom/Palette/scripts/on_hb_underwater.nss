#include "inc_heartbeat"
#include "inc_underwater"
#include "inc_debug_dac"
void main()
{
   //debug("on_hb_underwater");
   object oArea = GetArea(OBJECT_SELF);
   int nFog = GetFogAmount(FOG_TYPE_SUN, oArea);
   nFog += (Random(3) - 1) * 5;
   if (nFog < 0) nFog = 0;
   if (nFog > 100) nFog = 100;
   SetFogAmount(FOG_TYPE_SUN, nFog, oArea);
   object obj = GetFirstObjectInArea();
   while (obj != OBJECT_INVALID)
   {
      if (GetObjectType(obj) == OBJECT_TYPE_CREATURE)
      {
         doUnderwaterEffects(obj, nFog);
      }
      obj = GetNextObjectInArea();
   }
}
