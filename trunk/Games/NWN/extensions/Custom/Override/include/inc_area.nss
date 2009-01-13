#include "x0_i0_position"
#include "inc_debug_dac"

location getRandomLocation(object oArea);
void areaDamage(int nDamageAmount, int nDamageType, int nDamagePower = DAMAGE_POWER_NORMAL);
location getSurroundLocation(object oPC, int nRadius = 10);


location getRandomLocation(object oArea)
{
   int nMaxX = 10 * GetAreaSize(AREA_HEIGHT); // Maximum vector X value
   int nMaxY = 10 * GetAreaSize(AREA_WIDTH); // Maximum vector Y value
   int nX = Random(nMaxX) + 1;
   int nY = Random(nMaxY) + 1;

   vector vPos = Vector(IntToFloat(nX), IntToFloat(nY), 0.0f);

   location lRandom = Location(oArea, vPos, 90.0f);

   return lRandom;
}

// Applies damage to every creature in the area
void areaDamage(int nDamageAmount, int nDamageType, int nDamagePower = DAMAGE_POWER_NORMAL)
{
   effect eDamage = EffectDamage(nDamageAmount, nDamageType, nDamagePower);
   int nNth = 1;
   object oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nNth);
   while (oCreature != OBJECT_INVALID)
   {
      if (! GetIsDead(oCreature))
      {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreature);
      }
      nNth++;
      oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nNth);
   }
}

// Returns a location in a circle around the PC
location getSurroundLocation(object oPC, int nRadius = 10)
{
   //debugVarObject("getSurroundLocation()", OBJECT_SELF);
   vector vPC = GetPosition(oPC);
   float fAngle = Random(360) * 1.0;
   float fDist = Random(nRadius) * 1.0;
   vector vNew = GetChangedPosition(vPC, fDist, fAngle);
   location lReturn = Location(GetArea(oPC), vNew, 360 - fAngle);
   return lReturn;
}

//void main() {} // testing/compiling purposes
