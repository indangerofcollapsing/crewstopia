// Collection Purse: OnOpen
// Remembers who opened it, for use by the OnHeartbeat script.
#include "lmpperfmisc"

void main()
{
    SetLocalObject(OBJECT_SELF, "lmpPerfOpenedBy", GetLastOpenedBy());
}
