#include "inc_debug_dac"
void main()
{
   //debug("open_door_nearby");
   object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
   //debugVarObject("oDoor", oDoor);
   AssignCommand(oDoor, ActionOpenDoor(oDoor));
}
