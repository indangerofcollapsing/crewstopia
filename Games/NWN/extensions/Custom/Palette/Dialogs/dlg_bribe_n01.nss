// Attempt a normal difficulty Persuade at +1 at a cost of 100 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCNormal(GetPCSpeaker()), 1, 100);
}
