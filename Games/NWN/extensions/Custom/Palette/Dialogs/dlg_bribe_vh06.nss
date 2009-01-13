// Attempt a very hard difficulty Persuade at +6 at a cost of 100,000 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCVeryHard(GetPCSpeaker()), 6, 100000);
}
