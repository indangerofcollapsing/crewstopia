// On-Damaged event for an archery target
// Make sure Max HP is set very high, more than can be damaged in a single round.
void main()
{
   int nMaxHP = GetMaxHitPoints();
   int nCurrHP = GetCurrentHitPoints();
   effect eHeal = EffectHeal(nMaxHP - nCurrHP);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);

   object oUser = GetLastDamager();
   if (! GetIsPC(oUser)) return;

   // Only get XP for ranged attacks
   if (! GetWeaponRanged(GetLastWeaponUsed(oUser))) return;

   int nDistance = FloatToInt(GetDistanceBetween(OBJECT_SELF, oUser));
   int nXP = GetTotalDamageDealt() - GetHitDice(oUser) + (nDistance / 10) - 1;
   if (nXP < 0)
   {
      ActionSpeakString("You have learned all you can from practice.", TALKVOLUME_SHOUT);
   }
   else
   {
      GiveXPToCreature(oUser, nXP);
   }
}
