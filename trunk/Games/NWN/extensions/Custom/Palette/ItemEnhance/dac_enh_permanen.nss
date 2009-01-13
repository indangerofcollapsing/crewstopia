#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   SetLocalInt(oPC, VAR_ENHANCE_DURATION, DURATION_TYPE_PERMANENT);
}
