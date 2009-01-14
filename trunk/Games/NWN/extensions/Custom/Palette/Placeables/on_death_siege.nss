// On Death event for a Siege Engine
// The wrecked version must have a ResRef defined as the unwrecked ResRef + "w".
#include "inc_ia_ballista"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_siege", OBJECT_SELF);
   string sResRef = GetResRef(OBJECT_SELF) + "w";

   // If a PC was manning the object, kick them off
   object oAimer = getAimer();
   SetPlotFlag(oAimer, FALSE);
   DestroyObject(oAimer, 0.0);
   DeleteLocalObject(OBJECT_SELF, VAR_AIMER);
   GestaltClearFX(OBJECT_SELF);
   GestaltStopCutscene(0.1, GetPCSpeaker(), "", TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 0);

   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, GetLocation(OBJECT_SELF));
}

