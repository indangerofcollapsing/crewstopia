// Does PC NOT have at least 10gp?
int StartingConditional()
{
   return (GetGold(GetPCSpeaker()) < 10);
}
