void main()
{
if (GetLocalInt(OBJECT_SELF,"iLiOn") != 1)
    {
    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_5);
    effect eLight2 = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_5);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight2, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF,"iLiOn",1);
    }

}
