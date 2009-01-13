//::////////////////////////
// Dragon OnPerception script.
//::////////////////////////
#include "nw_i0_plot"

void main()
{
   if (GetIsDead(OBJECT_SELF)) return;

   if (GetLocalInt(OBJECT_SELF, "IsAwake"))
   {
      if (GetLastPerceptionSeen() &&
          GetCurrentAction() == ACTION_INVALID &&
          !IsInConversation(OBJECT_SELF) &&
          !GetIsInCombat()
         )
      {
         object oPerceived = GetLastPerceived();
         if (GetIsDM(oPerceived)) return;
         if (GetIsPC(oPerceived))
         {
            ClearAllActions(TRUE);
            ActionStartConversation(oPerceived);
         }
      }
      else
      {
         // Default On Perception handling
         ExecuteScript("x2_def_percept", OBJECT_SELF);
      }
   }
   else if(GetLastPerceptionHeard())
   {
      object oPerceived = GetLastPerceived();
      int nDC = DC_SUPERIOR; // default value
      int nHD = GetHitDice(OBJECT_SELF);
      if (nHD > 35) nDC = DC_EPIC;
      else if (nHD > 30) nDC = DC_LEGENDARY;
      else if (nHD > 25) nDC = DC_MASTER;
      else if (nHD > 20) nDC = DC_SUPERIOR;
      else if (nHD > 15) nDC = DC_HARD;
      else if (nHD > 10) nDC = DC_MEDIUM;
      else nDC = DC_EASY;

      if (GetIsPC(oPerceived) &&
          ((GetStealthMode(oPerceived) == STEALTH_MODE_DISABLED) ||
          ! AutoDC(nDC, SKILL_MOVE_SILENTLY, oPerceived))
         )
      {
         // Dragon wakes up.
         SetLocalInt(OBJECT_SELF, "IsAwake", TRUE);
         ClearAllActions(TRUE);
         effect eSleep = GetFirstEffect(OBJECT_SELF);
         while (GetIsEffectValid(eSleep))
         {
            if (GetEffectType(eSleep) == EFFECT_TYPE_SLEEP)
            {
               RemoveEffect( OBJECT_SELF, eSleep);
            }
            eSleep = GetNextEffect(OBJECT_SELF);
         }
      }
   }
}

