//::////////////////////////
// Dragon OnSpawn script.
//::////////////////////////

// Function to make the dragon sleep if in its lair.
void DragonSleep(object oDragon);

#include "inc_lair"
#include "inc_heartbeat"
#include "inc_debug_dac"

void main()
{
   ExecuteScript("x2_def_spawn", OBJECT_SELF);
   SetLocalInt(OBJECT_SELF, "IsAwake", TRUE);
   DragonSleep(OBJECT_SELF);
}

void DragonSleep(object oDragon)
{
   if (! GetIsObjectValid(oDragon)) return;
   if (GetIsDead(oDragon)) return;

   if (GetIsDMPossessed(oDragon))
   {
      AssignCommand(oDragon, DelayCommand(DURATION_1_ROUND, DragonSleep(oDragon)));
      return;
   }

   if (GetLocalInt(oDragon, "IsAwake"))
   {
      if (GetCurrentAction(oDragon) == ACTION_INVALID &&
          !GetIsInCombat(oDragon) &&
          !IsInConversation(oDragon)
         )
      {
         object oBed = getLair(OBJECT_SELF);
         if (GetIsObjectValid(oBed))
         {
            if (GetDistanceBetween(oDragon, oBed) <= 1.0f)
            {
               int bPlot = GetPlotFlag(oDragon);
               DeleteLocalInt(oDragon, "IsAwake");
               SetPlotFlag(oDragon, FALSE);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                  ExtraordinaryEffect(EffectSleep()), oDragon, DURATION_1_ROUND);
               SetPlotFlag(oDragon, bPlot);
               AssignCommand(oDragon, ActionPlayAnimation(
                  ANIMATION_LOOPING_DEAD_FRONT, 1.0f, DURATION_1_ROUND));
            }
            else
            {
               AssignCommand(oDragon, ActionMoveToObject(oBed, FALSE, 1.0f));
               AssignCommand(oDragon, ActionDoCommand(SetFacing(GetFacing(oBed))));
               AssignCommand(oDragon, ActionDoCommand(DragonSleep(oDragon)));
               return;
            }
         }
      }
   }
   else
   {
      if (d10() > 6)
      {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
            VFX_IMP_SLEEP), oDragon);
      }
      AssignCommand(oDragon, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
         1.0f, DURATION_1_ROUND));
   }

   AssignCommand(oDragon, DelayCommand(DURATION_1_ROUND, DragonSleep(oDragon)));
}

