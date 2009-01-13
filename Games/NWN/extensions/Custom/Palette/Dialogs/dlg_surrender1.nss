// The PC does not accept surrender.  Prisoners are killed.
// No XP awarded since combat resumes.
#include "nw_i0_generic"
#include "inc_dialog"
void main()
{
   object oPC = GetPCSpeaker();
   setPCSpeaker(oPC);
   AdjustReputation(oPC, OBJECT_SELF, -100);
   AdjustAlignment(oPC, ALIGNMENT_EVIL, 1);
   DetermineCombatRound();
}
