// Called by "guard_*" dialogs when the PC convinces the guard to open the door
// Important:  The door tag must be the same as this script's filename.
#include "inc_debug_dac"
void main()
{
   //debugVarObject("guard_door", OBJECT_SELF);
   ExecuteScript("door_open", OBJECT_SELF);
}
