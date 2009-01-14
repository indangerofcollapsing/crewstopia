// On-Damaged event for a combat dummy.
// Set Max HP very high, more than can be damaged in a single round.
void main()
{
   int nMaxHP = GetMaxHitPoints();
   int nCurrHP = GetCurrentHitPoints();
   effect eHeal = EffectHeal(nMaxHP - nCurrHP);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);

   object oUser = GetLastDamager();
   if (! GetIsPC(oUser)) return;

   // Only get XP for melee attacks
   if (GetWeaponRanged(GetLastWeaponUsed(oUser))) return;

   int nXP = GetTotalDamageDealt() - GetHitDice(oUser);
   if (nXP < 0)
   {
      ActionSpeakString("You have learned all you can from practice.", TALKVOLUME_SHOUT);
   }
   else
   {
      GiveXPToCreature(oUser, nXP);
   }
}
