/** Set new Mindblade shape */
#include "dac_inc_soulkn"
#include "inc_persist_loca"
void main()
{
   SetPersistantLocalInt(OBJECT_SELF, MBLADE_SHAPE, MBLADE_SHAPE_CHAKRAM);
   ExecuteScript("psi_sk_manifmbld", OBJECT_SELF);
}

