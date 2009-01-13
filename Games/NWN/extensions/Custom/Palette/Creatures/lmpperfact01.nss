#include "lmpperfmisc"

void main()
{
    object oOtherGuy = GetOtherGuy();
    if (oOtherGuy != OBJECT_INVALID)
        AssignCommand(oOtherGuy, PerformRabbitTrick());
}
