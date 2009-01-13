#include "inc_heartbeat"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("door_open", OBJECT_SELF);
   int bIsLocked = GetLocked(OBJECT_SELF);
   SetLocked(OBJECT_SELF, FALSE);
   PlayAnimation(ANIMATION_PLACEABLE_OPEN);
   ActionOpenDoor(OBJECT_SELF);
   if (! bIsLocked) return;

   int nDelay = getRespawnDelay(OBJECT_SELF) / 10;
   if (nDelay == 0) nDelay = Random(10) + 10;
   float fDelay = nDelay * DURATION_1_ROUND;
   //debugVarFloat("fDelay", fDelay);
   if (fDelay > 0.0)
   {
      DelayCommand(fDelay, ActionLockObject(OBJECT_SELF));
   }
}
