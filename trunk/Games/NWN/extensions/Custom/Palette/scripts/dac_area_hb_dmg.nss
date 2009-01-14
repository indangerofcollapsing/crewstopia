// On Heartbeat for Area Heartbeat Environmental Damage invisible object
// (Placeables/Special/Custom 2/Area Heartbeat Environmental Damage)
#include "inc_debug_dac"
#include "nw_i0_plot"
void main()
{
   //debugVarObject("dac_area_hb_dmg", OBJECT_SELF);

   // If no PC's in area, do nothing
   //debugVarObject("GetNearestPC()", GetNearestPC());
   if (GetNearestPC() == OBJECT_INVALID) return;
   //debugVarObject("PC is in da house", GetNearestPC());

   int nMaxDamage = GetLocalInt(OBJECT_SELF, "MAX_SCALED_DAMAGE");
   int nMinDamage = GetFortitudeSavingThrow(OBJECT_SELF);
   if (nMaxDamage < nMinDamage) nMaxDamage = nMinDamage;
   if (nMinDamage == 0)
   {
      logError("Damage = 0 in area for " + GetName(OBJECT_SELF) + " in area " +
         GetName(GetArea(OBJECT_SELF)) +
         ".  Deleting object to stop wasting CPU cycles");
      SetPlotFlag(OBJECT_SELF, FALSE);
      SetIsDestroyable(TRUE);
      DestroyObject(OBJECT_SELF);
      return;
   }
   int nDamageType;
   switch (GetReflexSavingThrow(OBJECT_SELF))
   {
      case 0: nDamageType = DAMAGE_TYPE_MAGICAL; break;
      case 1: nDamageType = DAMAGE_TYPE_ACID; break;
      case 2: nDamageType = DAMAGE_TYPE_COLD; break;
      case 3: nDamageType = DAMAGE_TYPE_DIVINE; break;
      case 4: nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
      case 5: nDamageType = DAMAGE_TYPE_FIRE; break;
      case 6: nDamageType = DAMAGE_TYPE_NEGATIVE; break;
      case 7: nDamageType = DAMAGE_TYPE_POSITIVE; break;
      case 8: nDamageType = DAMAGE_TYPE_SONIC; break;
      case 9: nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 10: nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 11: nDamageType = DAMAGE_TYPE_SLASHING; break;
      default: nDamageType = DAMAGE_TYPE_MAGICAL; break;
   }
   int nDamagePower = GetWillSavingThrow(OBJECT_SELF);
   if (nDamagePower > DAMAGE_POWER_PLUS_TWENTY)
   {
      // Invalid value; reset back to default
      nDamagePower = 0;
      SetWillSavingThrow(OBJECT_SELF, nDamagePower);
   }
   effect eDamage;
   int nRadius = GetHardness(OBJECT_SELF) * 5;
   int nNth = 1;
   object oCreature;
   if (nRadius)
   {
      // Nonzero radius specified, use shape rather than entire area
      oCreature = GetFirstObjectInShape(SHAPE_SPHERE, nRadius * 1.0,
         GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
   }
   else
   {
      // Zero radius specified, use entire area
      oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
   }
   while (oCreature != OBJECT_INVALID)
   {
      //debugVarObject("oCreature", oCreature);
      int nHD = GetHitDice(oCreature);
      // Scale damage between min and max, based on character level.
      int nDamage = nMinDamage + ((nMaxDamage - nMinDamage) * nHD / 40);
      eDamage = EffectDamage(nDamage, nDamageType, nDamagePower);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreature);
      if (nRadius)
      {
         oCreature = GetNextObjectInShape(SHAPE_SPHERE, nRadius * 1.0,
            GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
      }
      else
      {
         nNth++;
         oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,
            OBJECT_SELF, nNth);
      }
   }
}
