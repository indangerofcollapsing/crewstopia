// Does PC have at least 100gp?
int StartingConditional()
{
   return (GetGold(GetPCSpeaker()) >= 100);
}
