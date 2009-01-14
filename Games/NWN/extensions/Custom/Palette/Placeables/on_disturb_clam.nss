#include "inc_debug_dac"
#include "inc_heartbeat"
#include "inc_area"
void main()
{
   object oCreature = GetLastDisturbed();
   if (! GetIsPC(oCreature)) return;

   ActionCastFakeSpellAtObject(SPELL_HOLD_MONSTER, oCreature);
   switch(ReflexSave(oCreature, 20, SAVING_THROW_TYPE_TRAP))
   {
      case 0: // Failed
         SendMessageToPC(oCreature, "You are trapped!");
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(100),
            oCreature, Random(3) * DURATION_1_ROUND);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4(),
            DAMAGE_TYPE_BLUDGEONING), oCreature);

      case 1: // Succeeded
      case 2: // Immune
         SendMessageToPC(oCreature, "You escaped the clam's trap.");
         break;
   }

   // If the pearl is removed, destroy self and create a new clam elsewhere
   object oPearl = GetFirstItemInInventory();
   if (oPearl == OBJECT_INVALID)
   {
      string sResRef = GetResRef(OBJECT_SELF);
      location locNew = getRandomLocation(GetArea(OBJECT_SELF));
      CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, locNew);
      DestroyObject(OBJECT_SELF);
   }
}
