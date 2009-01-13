// Do I appear to NOT be the same race as the speaker?
#include "inc_appearance"
int StartingConditional()
{
   return (! amICousinTo(GetPCSpeaker()));
}
