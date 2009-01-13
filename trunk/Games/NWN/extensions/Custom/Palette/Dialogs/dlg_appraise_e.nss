// Attempt an easy difficulty Appraise
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_APPRAISE, skillDCEasy(GetPCSpeaker()));
}
