// Attempt a hard difficulty Bluff
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_BLUFF, skillDCHard(GetPCSpeaker()));
}
