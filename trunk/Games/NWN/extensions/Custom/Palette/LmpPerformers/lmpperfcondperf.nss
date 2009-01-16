#include "lmpperfmisc"

int StartingConditional()
{
    return GetCurrentState() == 0
        && GetIsPC(GetPCSpeaker());
}
