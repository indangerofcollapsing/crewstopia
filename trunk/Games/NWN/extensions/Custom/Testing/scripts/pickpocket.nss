void main()
{
   object oPC = GetLastPerceived();
   if (!GetIsPC(oPC)) return;
   if (!GetLastPerceptionSeen()) return;
   ActionUseSkill(SKILL_PICK_POCKET, oPC);
   ActionWait(3.0);
   ActionMoveAwayFromObject(oPC, TRUE, 80.0);
   ActionWait(5.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 3.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 3.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0, 5.0);
   ActionUseSkill(SKILL_HIDE, oPC);
   ActionWait(5.0);
   ActionMoveAwayFromObject(oPC, TRUE, 80.0);
}