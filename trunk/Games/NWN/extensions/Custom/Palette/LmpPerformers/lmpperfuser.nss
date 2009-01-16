// Performer: OnUserDefined
#include "lmpperfmisc"

void main()
{
    int nEvent = GetUserDefinedEventNumber();

    // OnHeartbeat 1001
    if (nEvent == 1001) {
        OnHeartbeatUpdatePerformerState();
    }

    // State transitions
    else if (nEvent == stPerformerDoneMoveToPerform) {
        PerformerDoneMoveToPerform();
    } else if (nEvent == stPerformerDoneMoveHome) {
        PerformerDoneMoveHome();
    }
}

