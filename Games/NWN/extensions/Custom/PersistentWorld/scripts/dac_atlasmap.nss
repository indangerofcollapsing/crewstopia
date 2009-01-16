// On Used event for a scribed map of a given area.
#include "inc_atlas"
#include "x2_inc_switches"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_atlasmap", OBJECT_SELF);

   // Only Cast Spell Unique Power Self Only should fire
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   //debugVarInt("user event", GetUserDefinedEventNumber());

   object oUser = GetItemActivator();
   object oMap = GetItemActivated();
   //debugVarObject("oMap", oMap);
   string sTag = GetLocalString(oMap, VAR_MAP_AREA_TAG);
   //debugVarString("sTag", sTag);
   if (sTag == "")
   {
      SendMessageToPC(oUser, "This map is damaged and unusable.");
      logError("No area tag set for item " + objectToString(oMap));
      return;
   }

   addMap(oUser, sTag);
   DestroyObject(oMap, 0.1f);
   SendMessageToPC(oUser, "You have added the map to your Atlas.");
}
