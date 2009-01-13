// Attempt a normal difficulty Bluff
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_BLUFF, skillDCNormal(GetPCSpeaker()));
}
