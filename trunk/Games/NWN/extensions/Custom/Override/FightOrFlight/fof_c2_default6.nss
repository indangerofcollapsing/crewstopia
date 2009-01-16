// Call from NW_C2_DEFAULT6 (at the end)
// ExecuteScript("fof_c2_default6", OBJECT_SELF);

//#include "nw_i0_generic"
void main()
{
   // FIGHT_OR_FLIGHT
   if (GetLocalInt(OBJECT_SELF, "FIGHT_OR_FLIGHT") == 1 &&
       GetLocalInt(OBJECT_SELF, "RETREATED") == 0)
   {
      ExecuteScript("fight_or_flight", OBJECT_SELF);
   }
}
