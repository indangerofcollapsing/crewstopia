// Attempt a very hard difficulty Persuade at +4 at a cost of 1000 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCVeryHard(GetPCSpeaker()), 4, 1000);
}