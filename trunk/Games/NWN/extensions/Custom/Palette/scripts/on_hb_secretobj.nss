// This secret object will reveal itself to searchers automagically.
void main()
{
   int nDetectDC = GetWillSavingThrow(OBJECT_SELF) ?
      GetWillSavingThrow(OBJECT_SELF) : d20();
   object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 10.0f,
      GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oCreature) && ! GetIsDead(oCreature))
   {
      if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
      {
         if (GetDetectMode(oCreature) == DETECT_MODE_ACTIVE ||
             GetDistanceBetween(oCreature, OBJECT_SELF) <= 5.0f
            )
         {
            if (GetIsSkillSuccessful(oCreature, SKILL_SEARCH, nDetectDC))
            {
               ExecuteScript("dac_unsecret", OBJECT_SELF);
            }
         }
      }
      oCreature = GetNextObjectInShape(SHAPE_SPHERE, 10.0f,
         GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
   }
}
