#include "lmpperfmisc"

void main()
{
    // Remove some gold from the player
    SetLocalInt(OBJECT_SELF, "lmpPerformTheft", FALSE);
    TakeGoldFromCreature(10, GetPCSpeaker(), TRUE);
    TerminatePerformBoth();
}
