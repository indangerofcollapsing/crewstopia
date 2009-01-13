//::///////////////////////////////////////////////
//:: [Acrobatic Attack]
//:: [prc_s_acroatk.nss]
//:://////////////////////////////////////////////
//:: Leaps at a target and performs a full round of
//:: attacks at a bonus to damage and attack determined
//:: by feat level.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:: Rewritten By: Oni5115 -  to use new combat engine and jump skill
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_inc_util"
#include "prc_inc_skills" // @DUG recompile only

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

    if(oTarget == OBJECT_INVALID)
    {
       FloatingTextStringOnCreature("Invalid Target for Acrobatic Attack", oPC);
       return;
    }

    float fDistance = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget) );

    int iBonus = 0;
    int iDam = 0;
    int iDamType = 0;

    effect eVfx;

    //Check which level of acrobatic attack has been used
    if(GetHasFeat(FEAT_ACROBATIC_ATTACK_8))
    {
         iBonus = 8;
         iDam = DAMAGE_BONUS_8;
    }
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_6))
    {
         iBonus = 6;
         iDam = DAMAGE_BONUS_6;
    }
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_4))
    {
         iBonus = 4;
         iDam = DAMAGE_BONUS_4;
    }
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_2))
    {
         iBonus = 2;
         iDam = DAMAGE_BONUS_2;
    }

    iDamType = GetWeaponDamageType(oWeap);

    // PnP rules use feet, might as well convert it now.
    fDistance = MetersToFeet(fDistance);

    // Ability only works from 5 feet away
    // Since the horizontal game distance seems so far off
    // I adjusted the distance to fit better.
    if(fDistance >= 7.0 )
    {
         // perform the jump
         int bPassedJump = PerformJump(oPC, GetLocation(oTarget), FALSE);
         if(bPassedJump)
         {
              DelayCommand(3.1, PerformAttackRound(oTarget, oPC, eVfx, 0.0, iBonus, iDam, iDamType,  TRUE, "*Acrobatic Attack*", "*Acrobatic Attack Miss*"));
         }
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Acrobatic Attack", oPC);
    }
}
