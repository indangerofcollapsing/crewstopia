// Does PC have at least 500gp?
int StartingConditional()
{
   return (GetGold(GetPCSpeaker()) >= 500);
}
