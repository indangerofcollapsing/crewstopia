// On Death event for a goblin worg rider
void main()
{
   ExecuteScript("nw_c2_default7", OBJECT_SELF);

   // Get position and facing of Worg and set spawn point for the Goblin
   vector vWorg = GetPosition(OBJECT_SELF);
   float fAngle = GetFacing(OBJECT_SELF);
   location lGoblin;
   vector vChange;
   object oArea = GetArea(OBJECT_SELF);
   vChange.x = cos(fAngle) * 1.0;
   lGoblin = Location(oArea, vWorg + vChange, fAngle);

   // Spawn the goblin because the worg has died
   effect eKnockdwn = ExtraordinaryEffect(EffectKnockdown());
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "dac_goblin", lGoblin,
      FALSE);
   // Level up the goblin to be a challenge to the PC
   int ii;
   int nMyHD = GetHitDice(OBJECT_SELF);
   int nKillerHD = GetHitDice(GetLastKiller());
   for (ii = nMyHD; ii < nKillerHD; ii++)
   {
      LevelUpHenchman(oSpawn, CLASS_TYPE_INVALID, TRUE);
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdwn, oSpawn, 2.0);
   AssignCommand(oSpawn, SpeakOneLinerConversation());
}
