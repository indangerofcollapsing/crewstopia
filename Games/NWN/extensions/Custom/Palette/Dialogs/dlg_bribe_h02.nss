// Attempt a hard difficulty Persuade at +2 at a cost of 250 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCHard(GetPCSpeaker()), 2, 250);
}
