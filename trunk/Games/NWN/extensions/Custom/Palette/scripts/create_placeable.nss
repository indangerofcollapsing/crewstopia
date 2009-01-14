// Unique Spell for an item that can be turned into a placeable.
#include "inc_debug_dac"
#include "x2_inc_switches"
#include "x0_i0_position"
#include "inc_persistworld"
void main()
{
   //debugVarObject("create_placeable", OBJECT_SELF);

   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   object oItem = GetItemActivated();
   //debugVarObject("oItem", oItem);

   string sResRef = GetLocalString(oItem, "CREATE_PLACEABLE");
   //debugVarString("sResRef", sResRef);

   if (sResRef == "")
   {
      logError("Placeable resref invalid in create_placeable: " +
         objectToString(oItem));
      return;
   }

   object oUser = GetItemActivator();
   if (oUser == OBJECT_INVALID)
   {
      logError("Object user invalid in create_placeable: " +
         objectToString(oItem));
      return;
   }

   // Make the new placeable face the user at arm's length
   location lLoc = GenerateNewLocation(oUser, DISTANCE_TINY, GetFacing(oUser),
      GetFacing(oUser));
   //debugVarLoc("lLoc", lLoc);
   //debugVarLoc("user loc", GetLocation(oUser));
   object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc);
   //debugVarObject("oPlaceable", oPlaceable);
   if (GetIsObjectValid(oPlaceable))
   {
      SetLocalString(oPlaceable, "CREATE_ITEM", GetResRef(oItem));
      // Since we're dealing with a specific item, do not allow respawning.
      SetLocalInt(oPlaceable, VAR_RESPAWN_TIME, -1);
      DestroyObject(oItem, 0.1f);
   }
}
