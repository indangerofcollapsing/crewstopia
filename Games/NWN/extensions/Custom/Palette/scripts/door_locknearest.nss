void main()
{
   object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
   DoDoorAction(oDoor, ACTION_CLOSEDOOR);
   SetLocked(oDoor, TRUE);
}
