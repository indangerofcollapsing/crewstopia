#include "inc_debug_dac"
void main()
{
   object oDoor = GetObjectByTag("arena_door");
   if (oDoor != OBJECT_INVALID)
   {
      AssignCommand(oDoor, PlayAnimation(ANIMATION_DOOR_OPEN1));
   }
   else
   {
      logError("Unable to find arena door in arena_victory");
   }

}
