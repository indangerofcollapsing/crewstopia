// Dismount from the Ballista or ballista is destroyed
#include "inc_ia_ballista"
void main()
{
   object oAimer = getAimer();
   SetPlotFlag(oAimer, FALSE);
   DestroyObject(oAimer, 0.0);
   DeleteLocalObject(OBJECT_SELF, VAR_AIMER);
   GestaltClearFX(OBJECT_SELF);
   GestaltStopCutscene(0.1, getUser(), "", TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 0);
   DeleteLocalObject(OBJECT_SELF, VAR_IA_BALLISTA_USER);
}
