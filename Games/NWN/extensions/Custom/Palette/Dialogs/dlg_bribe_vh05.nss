// Attempt a very hard difficulty Persuade at +5 at a cost of 10000 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCVeryHard(GetPCSpeaker()), 5, 10000);
}
