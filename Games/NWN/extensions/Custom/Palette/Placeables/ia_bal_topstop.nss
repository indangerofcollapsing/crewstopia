// Checks that the ballista is able to elevate
#include "inc_ia_ballista"
int StartingConditional()
{
   return (GetLocalInt(OBJECT_SELF, VAR_CURRENT_ELEVATION) < getMaxElev());
}
