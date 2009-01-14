// Create the target location and fire the charge
#include "inc_ia_ballista"
void main()
{
   launchMissile();
/*
   object oSeat = getSeat();
   int nBrng = GetLocalInt(OBJECT_SELF, VAR_CURRENT_BEARING);
   int nElev = GetLocalInt(OBJECT_SELF, VAR_CURRENT_ELEVATION);
   float fFace = GetFacing(oSeat);
   float fFire = fFace - IntToFloat(nBrng);
   float fRange = IntToFloat((nElev / 2) + 15);
   float x = fRange * cos(fFire);
   float y = fRange * sin(fFire);
   vector vSelf = GetPosition(OBJECT_SELF);
   vSelf.x += x;
   vSelf.y += y;
   location lTarget = Location(GetArea(OBJECT_SELF), vSelf, fFire);
   location lTarget = GetLocation(getAimer());
   ActionCastSpellAtLocation(getSpellId(), lTarget, METAMAGIC_MAXIMIZE, TRUE,
      PROJECTILE_PATH_TYPE_BALLISTIC, TRUE);
   SetLocalInt(OBJECT_SELF, VAR_IS_RELOADING, TRUE);
   DelayCommand(getReloadDelay() * 1.0f,
      SetLocalInt(OBJECT_SELF, VAR_IS_RELOADING, FALSE));
*/
}
