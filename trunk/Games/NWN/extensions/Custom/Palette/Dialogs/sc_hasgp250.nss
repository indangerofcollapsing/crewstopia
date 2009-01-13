// Does PC have at least 250gp?
int StartingConditional()
{
   return (GetGold(GetPCSpeaker()) >= 250);
}
