// On Death event for respawnable placeable door, no treasure
// Placeables/Civilization Exterior/Buildings/Doors
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_door_rs", OBJECT_SELF);
   respawnPlaceable();

   // Stolen from zep_doorkill
   string sGateBlock = GetLocalString(OBJECT_SELF, "CEP_L_GATEBLOCK");
   location lSelfLoc = GetLocation(OBJECT_SELF);

   if (! GetIsOpen(OBJECT_SELF)) // If the door is closed
   {
      object oSelf = OBJECT_SELF;
      if (GetLocalObject(oSelf, "GateBlock")!= OBJECT_INVALID)
      {
         DestroyObject(GetLocalObject(oSelf, "GateBlock"));
      }
   }

   // Create new placeable if specified by variable
   string sDieReplace = GetLocalString(OBJECT_SELF, "CEP_L_DIEREPLACE");
   if (sDieReplace != "")
   {
      CreateObject(OBJECT_TYPE_PLACEABLE, sDieReplace, lSelfLoc);
   }
}

