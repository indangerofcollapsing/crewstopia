// Attempt a very easy difficulty Appraise
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_APPRAISE, skillDCVeryEasy(GetPCSpeaker()));
}
