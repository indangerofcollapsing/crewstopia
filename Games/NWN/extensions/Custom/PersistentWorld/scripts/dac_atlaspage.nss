// On Used event for a blank map page.
#include "inc_atlas"
#include "x2_inc_switches"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_atlaspage", OBJECT_SELF);

   // Only Cast Spell Unique Power Self Only should fire
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   //debugVarInt("user event", GetUserDefinedEventNumber());

   object oUser = GetItemActivator();
   object oPage = GetItemActivated();
   object oArea = GetArea(oUser);
   int nMapPointsRequired = GetLocalInt(oArea, VAR_AREA_MAP_POINTS);

   object oMap = CreateItemOnObject(RESREF_ATLAS_MAP, oUser, 10);
   //debugVarObject("oMap", oMap);
   SetLocalString(oMap, VAR_MAP_AREA_TAG, GetTag(oArea));
   //debugVarString("area tag", GetLocalString(oMap, VAR_MAP_AREA_TAG));
   SetName(oMap, "Map of " + GetName(oArea));
   DestroyObject(oPage, 0.1f);
   SendMessageToPC(oUser, "You have scribed a map of the current area.");
}
