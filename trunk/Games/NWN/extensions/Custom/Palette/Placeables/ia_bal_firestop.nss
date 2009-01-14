//Checks that the ballista is ready to fire
#include "inc_ia_ballista"
int StartingConditional()
{
   return GetLocalInt(OBJECT_SELF, VAR_IS_RELOADING);
}
