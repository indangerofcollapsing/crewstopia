/** Set new Mindblade shape */
#include "dac_inc_soulkn"
#include "inc_persist_loca"
void main()
{
   // _ds used to stand for "dual shortswords", but that's obsolete now
   SetPersistantLocalInt(OBJECT_SELF, MBLADE_SHAPE, MBLADE_SHAPE_DOUBLESCIMITAR);
   ExecuteScript("psi_sk_manifmbld", OBJECT_SELF);
}

