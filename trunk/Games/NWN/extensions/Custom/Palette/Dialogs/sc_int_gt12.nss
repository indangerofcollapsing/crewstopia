int StartingConditional()
{
   object oPC = GetPCSpeaker();
   int nIN = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
   return (nIN > 12);
}
