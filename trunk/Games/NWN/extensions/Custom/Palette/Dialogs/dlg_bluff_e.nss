// Attempt an easy difficulty Bluff
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_BLUFF, skillDCEasy(GetPCSpeaker()));
}
