// Deprecated in favor of "on_death_XXX_rs" in the On Death event
#include "inc_debug_dac"
#include "inc_persistworld"
void main()
{
   logError("on_hb_respawner *** DEPRECATED ***, called by " + objectToString(OBJECT_SELF));
/* deprecated - the logError command is only left to flag instances where this
   has not been properly removed

   // This variable is set when the object is respawned via BESIE
   if (GetLocalInt(OBJECT_SELF, "re_bRespawned")) return;

   //debug("spawning a BESIE respawner for " + GetName(OBJECT_SELF));
   // Not respawned, so we are the original item.  Spawn a BESIE respawner.
   object oRespawner = CreateObject(OBJECT_TYPE_PLACEABLE, "besie_plcabl_000",
      GetLocation(OBJECT_SELF), FALSE, GetResRef(OBJECT_SELF));
   // Will saving throw is the average respawn delay in rounds
   // This is nonstandard for BESIE Placeable respawners
   SetWillSavingThrow(oRespawner, getRespawnDelay(OBJECT_SELF));

   // The respawner will now create a copy of me, so I am superfluous
   DestroyObject(OBJECT_SELF);
*/
}
