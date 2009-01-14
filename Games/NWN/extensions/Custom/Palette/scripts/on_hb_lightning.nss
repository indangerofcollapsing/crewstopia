/***********************************************
WRITTEN BY LILAC SOUL, AKA CARSTEN HJORTHOJ
FOUND ON LILAC SOUL'S WEBPAGE:

http://www.angelfire.com/space/lilacsoul

GOES ON HEARTBEAT OF AREAS THAT YOU WANT
RANDOM LIGHTNING IN
FOR CREDIBILITY, THOSE AREAS SHOULD PROBABLY BE RAINY

***********************************************/

// Percentage chance of a lightning strike on each heartbeat
int nPercent = 37;

void DoLightningDamage(object oTarget);
void HurtObject(object oTarget, location lTarget);

#include "inc_area"

void main()
{
   // There's nPercent chance of this happening
   if (d100() > nPercent) return;

   // Find a random location for the lightning bolt
   location lTarget = getRandomLocation(OBJECT_SELF);

   // Is there an object near that location?
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, lTarget, FALSE,
      OBJECT_TYPE_ALL);

   // If there was an object, there's 5% chance of hitting that instead
   if (GetIsObjectValid(oTarget) && d20() == 1)
   {
      HurtObject(oTarget, lTarget);
   }
   else
   {
      // Lightning strikes the location...
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
         VFX_IMP_LIGHTNING_M), lTarget);
   }
}

void DoLightningDamage(object oTarget)
{
   // Make a saving throw
   int nSave = ReflexSave(oTarget, d20(2), SAVING_THROW_TYPE_ELECTRICITY,
      OBJECT_SELF);

   // Only creatures can make saving throws - this might not be
   // necessary, but just in case. If the object type isn't a
   // creature, we'll set the 'saving throw' to failed.

   if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) nSave = 0;

   if (nSave == 0)
   {
      // Saving throw failed, damage oTarget
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(2),
         DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY), oTarget);
   }
   else if (GetIsPC(oTarget))
   {
      // Saving throw successful. If a PC was the target, let them know
      // how close they got.
      SendMessageToPC(oTarget, "You somehow managed to step aside from that lightning bolt.");
   }
}

void HurtObject(object oTarget, location lTarget)
{
   // What kind of object?
   int nType = GetObjectType(oTarget);

   // Only creatures, placeables and doors can be hurt
   switch(nType)
   {
      case OBJECT_TYPE_CREATURE:
      case OBJECT_TYPE_PLACEABLE:
      case OBJECT_TYPE_DOOR:
         // Lightning effect strikes the object
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
            VFX_IMP_LIGHTNING_M), oTarget);
         // Possibly, damage is dealt
         DoLightningDamage(oTarget);
         break;
      default:
         // For other kinds of objects, lightning just strikes at location
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
            VFX_IMP_LIGHTNING_M), lTarget);
         break;
   }
}

