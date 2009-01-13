int StartingConditional()
{
   object oPC = GetPCSpeaker();
   int nWS = GetAbilityScore(oPC, ABILITY_WISDOM);
   return (nWS > 12);
}
