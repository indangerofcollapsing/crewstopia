#include "inc_debug_dac"
#include "inc_variables"
void main()
{
   //debugVarObject("inc_debug_dac", OBJECT_SELF);
   object oUser = GetLastUsedBy();
   //debugVarObject("oUser", oUser);

   location lMe = GetLocation(OBJECT_SELF);
   //debugVarLoc("lMe", lMe);
   location lUser = GetLocation(oUser);
   //debugVarLoc("lUser", lUser);

   float fStrMod = GetAbilityModifier(ABILITY_STRENGTH, oUser) * 1.0f;
   //debugVarFloat("fStrMod", fStrMod);

   // GetAngleBetweenLocations() is buggy.
//   float fAngle = GetAngleBetweenLocations(lUser, lMe);
   vector vPos1 = GetPositionFromLocation(lUser);
   vector vPos2 = GetPositionFromLocation(lMe);
   float fDist = GetDistanceBetweenLocations(lUser, lMe);
   //debugVarFloat("fDist", fDist);
   float fChangeX = vPos1.x - vPos2.x;
   float fAngle = acos(fChangeX / fDist);
   //debugVarFloat("fAngle", fAngle);

   int nWeight = getVarInt(OBJECT_SELF, "WEIGHT");
   if (nWeight == 0)
   {
      nWeight = 100;
      SetLocalInt(OBJECT_SELF, "WEIGHT", nWeight);
   }
   //debugVarInt("nWeight", nWeight);

   // Distance modifier, based on strength and weight of the object
   float fDistMod = pow(1.5, fStrMod) * (100 / nWeight) * 0.1;

   float fDx = cos(fAngle) * fDistMod;
   //debugVarFloat("fDx", fDx);
   float fDy = sin(fAngle) * fDistMod;
   //debugVarFloat("fDy", fDy);

   vector vMe = GetPositionFromLocation(lMe);
   vMe.x = vMe.x + fDx;
   vMe.y = vMe.y + fDy;
   location lNew = Location(GetAreaFromLocation(lMe), vMe, GetFacingFromLocation(lMe));
   //debugVarLoc("lNew", lNew);
   object oNew = CreateObject(OBJECT_TYPE_PLACEABLE, GetResRef(OBJECT_SELF),
      lNew, FALSE, GetTag(OBJECT_SELF));
   SetLocalInt(oNew, "WEIGHT", nWeight);
   DestroyObject(OBJECT_SELF);
}
