#include "inc_persistworld"
int StartingConditional()
{
   return (getNumberKilled(GetTag(OBJECT_SELF), GetPCSpeaker()) > 0);
}
