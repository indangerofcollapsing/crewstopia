// Attempt a normal difficulty Persuade at +10 at a cost of 1,000,000 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCNormal(GetPCSpeaker()), 10, 1000000);
}
