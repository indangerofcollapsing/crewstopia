// Attempt a very hard difficulty Persuade at +3 at a cost of 500 GP
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptBribe(SKILL_PERSUADE, skillDCVeryHard(GetPCSpeaker()), 3, 500);
}
