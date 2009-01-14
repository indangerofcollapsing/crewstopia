// This script is called by the guard_* dialogs when the PC convinces the guard
// to do something.  The script name (modify this and save it with a new name)
// must match the guard's tag.
void main()
{
   SendMessageToPC(GetFirstPC(), "It works.");
}
