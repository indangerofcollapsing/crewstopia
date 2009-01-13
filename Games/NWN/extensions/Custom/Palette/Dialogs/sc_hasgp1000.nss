// Does PC have at least 1000gp?
int StartingConditional()
{
   return (GetGold(GetPCSpeaker()) >= 1000);
}
