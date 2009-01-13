// Does PC have enough gold to enhance their item?
#include "inc_enhanceitems"
int StartingConditional()
{
   int nGoldNeeded = GetLocalInt(GetPCSpeaker(), VAR_ENHANCE_COST);
   return (GetGold(GetPCSpeaker()) >= nGoldNeeded);
}
