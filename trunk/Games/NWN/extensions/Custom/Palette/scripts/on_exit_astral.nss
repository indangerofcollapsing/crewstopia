#include "zep_inc_phenos"
void main()
{
   object oCreature = GetExitingObject();
   if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
   {
      zep_Fly_Land(oCreature, TRUE);
   }
   ExecuteScript("on_exit_area", OBJECT_SELF);
}
