// cs_ou_leverdoor
// TAG of Lever must be Lever_'Door TAG' where Door TAG is the TAG of the
//   Door to be opened and closed.
// Created By: 69MEH69  Mar2005

void main()
{
  string sTAG = GetTag(OBJECT_SELF);
  int nTAG = GetStringLength(sTAG) - 6;
  string sDoorTAG = GetStringRight(sTAG, nTAG);
  object oDoor = GetObjectByTag(sDoorTAG);
  int nOpen = GetLocalInt(OBJECT_SELF, "OPEN");

  if(nOpen == FALSE)
  {
   ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE, 1.0, 1.0);
   SetLocalInt(OBJECT_SELF, "OPEN", TRUE);
   SetLocked(oDoor, FALSE);
   DelayCommand(1.5, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
  }
  else
  {
   ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE, 1.0, 1.0);
   SetLocalInt(OBJECT_SELF, "OPEN", FALSE);
   DelayCommand(1.5, AssignCommand(oDoor, ActionCloseDoor(oDoor)));
   DelayCommand(1.5, SetLocked(oDoor, TRUE));
  }
}
