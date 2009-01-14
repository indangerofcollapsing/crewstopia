void main()
{
if (GetLocalInt(OBJECT_SELF,"iLiOn") != 1)
    {
    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_RED_5);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF,"iLiOn",1);
    }
}
