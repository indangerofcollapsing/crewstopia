void main()
{
   if (GetPlotFlag(OBJECT_SELF)) return;

   effect eDamage = EffectDamage(GetMaxHitPoints(OBJECT_SELF));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);

   // Just in case, destroy self as well
   DelayCommand(1.0f, DestroyObject(OBJECT_SELF));
}
