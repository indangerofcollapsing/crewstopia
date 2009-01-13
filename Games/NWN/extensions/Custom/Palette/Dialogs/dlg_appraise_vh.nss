// Attempt a very hard difficulty Appraise
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_APPRAISE, skillDCVeryHard(GetPCSpeaker()));
}
