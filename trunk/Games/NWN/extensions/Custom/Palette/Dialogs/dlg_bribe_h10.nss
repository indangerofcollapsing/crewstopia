// Attempt a hard difficulty Persuade at +10 at a cost of 1,000,000 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCHard(GetPCSpeaker()), 10, 1000000);
}
