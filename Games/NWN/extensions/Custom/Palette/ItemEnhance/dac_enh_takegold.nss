#include "inc_enhanceitems"
void main()
{
   int nGoldNeeded = GetLocalInt(GetPCSpeaker(), VAR_ENHANCE_COST);
   TakeGoldFromCreature(nGoldNeeded, GetPCSpeaker(), TRUE);
}
