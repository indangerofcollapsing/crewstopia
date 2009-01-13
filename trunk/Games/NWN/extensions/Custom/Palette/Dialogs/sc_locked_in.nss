// Am I behind an closed door nearby?
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_locked_in", OBJECT_SELF);
   ActionMoveToObject(GetPCSpeaker(), TRUE);
   DelayCommand(2.0f, ClearAllActions(TRUE));
   object oDoor = GetBlockingDoor(); // Returns either a door or a creature
   //debugVarObject("blocking door", oDoor);

   // A creature can move out of the way
   if (GetObjectType(oDoor) != OBJECT_TYPE_DOOR) return FALSE;

   // if there's a closed door nearby, return TRUE
   int bDoorIsOpen = GetIsOpen(oDoor);
   //debugVarBoolean("bDoorIsOpen", bDoorIsOpen);
   return (! bDoorIsOpen);
}
