// Attempt a very hard-difficulty Persuade
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_PERSUADE, skillDCVeryHard(GetPCSpeaker()));
}
