void main()
{
   object oPC = GetLastPerceived();
   ActionMoveToObject(oPC, TRUE);
   // If a door is in the way, stop trying to bash it down.
   DelayCommand(2.0f, ClearAllActions(TRUE));
}
