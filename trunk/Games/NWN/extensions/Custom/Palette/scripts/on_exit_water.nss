#include "inc_pheno"
void main()
{
   object oCreature = GetExitingObject();
   if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
   {
      setPhenoFly(oCreature, PHENO_SWITCH_RESET);
   }
   ExecuteScript("on_exit_area", OBJECT_SELF);
}
