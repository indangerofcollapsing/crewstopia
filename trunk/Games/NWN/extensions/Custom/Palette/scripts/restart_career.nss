void main()
{
   object oPC = GetPCSpeaker();
   int nXP = GetXP(oPC);
   SetXP(oPC, 0);
   SetXP(oPC, nXP);
}
