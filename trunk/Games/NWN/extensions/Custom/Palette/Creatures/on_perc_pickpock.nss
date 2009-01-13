// On Perception event for a pickpocket
void main()
{
   object oPC = GetLastPerceived();
   if (GetIsDM(oPC) || ! GetIsPC(oPC)) return;
//   string sKey = "thief";
//   SetLocalInt(oPC, sKey, 1);
   ActionUseSkill(SKILL_PICK_POCKET, oPC);
   ActionWait(1.0);
   ActionMoveAwayFromObject(oPC, TRUE, 4.0);
   ActionWait(2.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 3.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 3.0);
   ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0, 5.0);
   ActionUseSkill(SKILL_HIDE, oPC);
   ActionWait(3.0);
   ActionMoveAwayFromObject(oPC, TRUE, 10.0);
}

