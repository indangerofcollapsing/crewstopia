// Does PC have at least 50 gp per level?
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
      GetLevelByPosition(3, oPC);
   int nGold = GetGold(oPC);
   return (nGold > (nLevel * 50));
}
