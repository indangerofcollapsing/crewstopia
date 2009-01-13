//cs_oo_closedoor
//Delay based on Will save on door
//Will automatically close the door and relock it if the door is set to Relockable
//Created: 69MEH69  Oct2004
void main()
{
 int nDelay = GetWillSavingThrow(OBJECT_SELF);
 float fDelay = IntToFloat(nDelay);
 if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_DOOR)
 {
   DelayCommand(fDelay, ActionCloseDoor(OBJECT_SELF));
   if(GetLockLockable(OBJECT_SELF))
   {
     DelayCommand(fDelay + 3.0, SetLocked(OBJECT_SELF, TRUE));
   }
 }
}
