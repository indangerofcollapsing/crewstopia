// Performer: Conversation OnAbort
// This ensures that if the "caught stealing" conversation is aborted the PC
// doesn't get away scot-free.
// It also terminates the current performance to put things back in a good
// state. (But it's not perfect - the performance sometimes continues after
// the performer sits down!)

#include "lmpperfmisc2"

void main()
{
    lmpDebugMsg("Conversation aborted");
    if (GetLocalInt(OBJECT_SELF, "lmpPerformTheft")) {
        SetLocalInt(OBJECT_SELF, "lmpPerformTheft", FALSE);
        BothAttackThief();
    } else {
        TerminatePerformBoth();
    }
}
