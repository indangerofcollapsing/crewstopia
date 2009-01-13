// set custom token 2112 to 50 GP per level
void main()
{
   object oPC = GetPCSpeaker();
   int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
      GetLevelByPosition(3, oPC);
    SetCustomToken(2112, IntToString(nLevel * 50));
}
