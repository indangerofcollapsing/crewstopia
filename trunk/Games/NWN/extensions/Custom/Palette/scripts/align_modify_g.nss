#include "inc_money"
void main()
{
   object oPC = GetPCSpeaker();
   TakeGoldFromCreature(50, oPC);
   AdjustAlignment(oPC, ALIGNMENT_GOOD, 1);
}