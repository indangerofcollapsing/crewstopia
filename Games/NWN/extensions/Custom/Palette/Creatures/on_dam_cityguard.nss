// On Damaged script for City Guard
#include "inc_area"
void main()
{
   ExecuteScript("x2_def_ondamage", OBJECT_SELF); // Standard on-damaged script

   if (GetCurrentHitPoints() < (GetMaxHitPoints() / 2))
   {
      // Can the guard use his whistle to summon other guards?
      int bCanMove = TRUE;
      effect eHold = GetFirstEffect(OBJECT_SELF);
      while (GetIsEffectValid(eHold))
      {
         switch (GetEffectType(eHold))
         {
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POLYMORPH:
            case EFFECT_TYPE_SILENCE:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_STUNNED:
               bCanMove = FALSE;
               break;
            default:
               // Nothing
               break;
         }
         eHold = GetNextEffect(OBJECT_SELF);
      }

      if (! bCanMove) return;

      // There's an endless supply -- kill one and you call two more!
      SpeakString("Phweeeet!  Phweeeet!  Phweeeet!", TALKVOLUME_SHOUT);
      object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
      if (oDoor != OBJECT_INVALID && GetArea(oDoor) == GetArea(OBJECT_SELF))
      {
         CreateObject(OBJECT_TYPE_CREATURE, GetResRef(OBJECT_SELF),
            GetLocation(oDoor), FALSE);
         CreateObject(OBJECT_TYPE_CREATURE, GetResRef(OBJECT_SELF),
            GetLocation(oDoor), FALSE);
      }
      else
      {
         CreateObject(OBJECT_TYPE_CREATURE, GetResRef(OBJECT_SELF),
            getRandomLocation(GetArea(OBJECT_SELF)), FALSE);
         CreateObject(OBJECT_TYPE_CREATURE, GetResRef(OBJECT_SELF),
            getRandomLocation(GetArea(OBJECT_SELF)), FALSE);
      }
   }
}
