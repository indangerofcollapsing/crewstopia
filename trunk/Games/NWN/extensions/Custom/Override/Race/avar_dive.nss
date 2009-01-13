//::///////////////////////////////////////////////
//:: [Dive Attack]
//:: [avar_dive.nss]
//:://////////////////////////////////////////////
/*
    -2 AC +2 attack, double damage with peircing weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Sept. 24, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"
//#include "prc_inc_util"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

    if(oTarget == OBJECT_INVALID)
    {
       FloatingTextStringOnCreature("Invalid Target for Dive Attack", oPC);
       return;
    }

    float fDistance = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget) );

    // PnP rules use feet, might as well convert it now.
    fDistance = MetersToFeet(fDistance);
    if(fDistance >= 7.0 )
    {
         // perform the jump
         int bPassedJump = PerformJump(oPC, GetLocation(oTarget), FALSE);
         if(bPassedJump)
         {
              effect eACpen = EffectACDecrease(2);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACpen, oPC, 6.0);


              // get weapon information
              int iWeaponType = GetBaseItemType(oWeap);
              int iNumSides = StringToInt(Get2DACache("baseitems", "DieToRoll", iWeaponType));
              int iNumDice = StringToInt(Get2DACache("baseitems", "NumDice", iWeaponType));
              int iCritMult = GetWeaponCritcalMultiplier(oPC, oWeap);
              int iDamType = GetWeaponDamageType(oWeap);

              struct BonusDamage sWeaponBonusDamage = GetWeaponBonusDamage(oWeap, oTarget);
              struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oPC);
              // deal double the damage
              if( iDamType == DAMAGE_TYPE_PIERCING )
              {
DelayCommand(3.3, FloatingTextStringOnCreature("Dive attack with piercing weapon", oPC)); // @DUG
                   iNumDice *= 2;
              }
else // @DUG
{
DelayCommand(3.3, FloatingTextStringOnCreature("Dive attack with non-piercing weapon", oPC));
iNumDice *= 2;
}

              // perform attack roll
              effect eDamage;
              string sMes = "";
              int bIsCritical = FALSE;
              int iAttackRoll = GetAttackRoll(oTarget, oPC, oWeap, 0, 0, 2, TRUE, 3.1);

              if(iAttackRoll == 2)  bIsCritical = TRUE;
              eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, 0, bIsCritical, iNumDice, iNumSides, iCritMult);

              if(iAttackRoll > 0)
              {
// @DUG                   sMes = "*Dive Attack Hit*";
                   sMes = "*Dive Attack Hit* (" + IntToString(iNumDice) + "d" + IntToString(iNumSides) + ")"; // @DUG
                   DelayCommand(3.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget) );
              }
              else
              {
                   sMes = "*Dive Attack Miss*";
              }
              DelayCommand(3.3, FloatingTextStringOnCreature(sMes, oPC) );
         }
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Dive Attack", oPC);
    }
}
