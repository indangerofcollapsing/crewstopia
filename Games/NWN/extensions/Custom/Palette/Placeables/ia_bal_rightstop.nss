//Checks that the ballista is able to pan right
#include "inc_ia_ballista"
int StartingConditional()
{
   return (GetLocalInt(OBJECT_SELF, VAR_CURRENT_BEARING) < getMaxBearing());
}
