//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
    - If target is valid attempt a hit
       - If miss then MISS
       - If hit then direct damage
    - If target is invalid or MISS
       - have area of effect near target
       - everyone in area takes splash damage
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////
//:: GZ: Can now be used to coat a weapon with fire.

#include "prc_inc_sp_tch" // @DUG

void PRCDoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL);

void AddFlamingEffectToWeapon(object oTarget, float fDuration);

void main()
{
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    object oMyWeapon;
    int nTarget = GetObjectType(oTarget);
    int nDuration = d6() + 1; // @DUG was previously hardcoded to 4
    int nCasterLvl = 1;

    if (nTarget == OBJECT_TYPE_ITEM)
    {
        oMyWeapon = oTarget;
        // @DUG Allow for projectiles; recompile to include CEP weapons
        if (IPGetIsMeleeWeapon(oMyWeapon) || IPGetIsProjectile(oMyWeapon))
        {
            if(GetIsObjectValid(oMyWeapon))
            {
                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                if (nDuration > 0)
                {
                    // haaaack: store caster level on item for the on hit spell to work properly
                    SetLocalInt(oMyWeapon,"X2_SPELL_CLEVEL_FLAMING_WEAPON",nCasterLvl);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
                    AddFlamingEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
                }
                    return;
            }
        }
        else
        {
            // "Must be a melee weapon..."
            FloatingTextStrRefOnCreature(100944,OBJECT_SELF);
        }
    }
    else if(nTarget == OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE)
    {
        PRCDoGrenade(d6(1),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE); // @DUG
    }
}

// @DUG Cribbed from x0_i0_spells, because including that gives
//      compile errors.
void PRCDoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL)
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eMissile;
    effect eVis = EffectVisualEffect(vSmallHit);
    location lTarget = GetSpellTargetLocation();


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    int nTouch;


    if (GetIsObjectValid(oTarget) == TRUE)
    {
/*        // * BK September 27 2002
        // * if the object is 'far' from the original impact it
        // * will be an automatic miss too
        location lObject = GetLocation(oTarget);
        float fDistance = GetDistanceBetweenLocations(lTarget, lObject);
//        SpawnScriptDebugger();
        if (fDistance > 1.0)
        {
            nTouch = -1;
        }
        else
        This did not work. The location and object location are the same.
        For now we'll have to live with the possiblity of the 'explosion'
        happening away from where the grenade hits.
        We could convert everything to splash...
        */
            nTouch = PRCDoRangedTouchAttack(oTarget);

    }
    else
    {
        nTouch = -1; // * this means that target was the ground, so the user
                    // * intended to splash
    }
    if (nTouch >= 1)
    {
        //Roll damage
        int nDam = nDirectDamage;

        if(nTouch == 2)
        {
            nDam *= 2;
        }

        //Set damage effect
        effect eDam = EffectDamage(nDam, nDamageType);
        //Apply the MIRV and damage effect

        // * only damage enemies
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
        // * must be the correct racial type (only used with Holy Water)
            if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == MyPRCGetRacialType(oTarget)))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }
            else
            if ((nRacialType == RACIAL_TYPE_ALL) )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }

        }

    //    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
    }

// *
// * Splash damage always happens as well now
// *
    {
        effect eExplode = EffectVisualEffect(vRingHit);
       //Apply the fireball explosion at the location captured above.

/*       float fFace = GetFacingFromLocation(lTarget);
       vector vPos = GetPositionFromLocation(lTarget);
       object oArea = GetAreaFromLocation(lTarget);
       vPos.x = vPos.x - 1.0;
       vPos.y = vPos.y - 1.0;
       lTarget = Location(oArea, vPos, fFace);
       missing code looks bad because it does not jive with visual
*/
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //Roll damage for each target
            nDamage = nSplashDamage;

            //Set the damage effect
            effect eDam = EffectDamage(nDamage, nDamageType);
            if(nDamage > 0)
            {
        // * must be the correct racial type (only used with Holy Water)
                if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == MyPRCGetRacialType(oTarget)))
                {
                    // Apply effects to the currently selected target.
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                if ((nRacialType == RACIAL_TYPE_ALL) )
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }

            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
       }
    }
}

void AddFlamingEffectToWeapon(object oTarget, float fDuration)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(124,1), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}
