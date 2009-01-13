//#include "nw_i0_generic"
#include "nw_i0_plot"
#include "inc_dialog"
#include "inc_persistworld"
void main()
{
   object oNPC = getNPCSpeaker();
   object oPC = GetPCSpeaker();
   location locEscape = GetRandomLocation(GetArea(oNPC));
   object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint", locEscape, FALSE, "NW_EXIT");
   markTemporary(oWaypoint);
   AssignCommand(oNPC, EscapeArea(FALSE, "NW_EXIT"));
   AssignCommand(oNPC, DestroyObject(OBJECT_SELF, 5.0f));
}
