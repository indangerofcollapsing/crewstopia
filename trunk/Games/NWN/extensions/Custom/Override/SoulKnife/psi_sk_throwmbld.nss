//::///////////////////////////////////////////////
//:: Soulknife: Throw Mindblade
//:: psi_sk_throwmbld
//::///////////////////////////////////////////////
/** @file Soulknife: Throw Mindblade
    Sets Mindblade type to ranged, runs the blade
    creation script and starts attacking.

    Cannot be used if not already wielding a
    mindblade.


    @author Ornedan
    @date   Created  - 04.04.2005
    @date   Modified - 01.09.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_soulkn"

// @DUG This is duplicated in dac_inc_soulkn.nss, because including
// psi_inc_soulkn.nss there causes the StartingConditional scripts
// (dac_sc_sk_*.nss) to not work.
// Custom Mindblade Shape                                      Granted on level
const int MBLADE_SHAPE_DART = 32; // prc_sk_mblade_td                 2
const int MBLADE_SHAPE_SHURIKEN = 33; // prc_sk_mblade_sh             2

void Cleanup(object oPC)
{
    DeleteLocalInt(oPC, THROW_MBLD_USED);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    // If any thrown mindblades still remain, delete them
// @DAC    if(GetTag(oWeapon) == "prc_sk_mblade_th")
    if (GetStringLeft(GetTag(oWeapon), 14) == "prc_sk_mblade_") // @DAC
    {
       MyDestroyObject(oWeapon);
    }
    // @DAC automagically manifest a new mindblade if you can do it for free
    if (GetHasFeat(FEAT_FREE_DRAW, oPC))
    {
       ExecuteScript("psi_sk_manifmbld", oPC);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(GetLocalInt(oPC, THROW_MBLD_USED))
    {// "You cannot use this feat more than once per round."
        SendMessageToPCByStrRef(oPC, 16824496);
        return;
    }
/* @DAC
    if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) != "prc_sk_mblade_")
    {// "You must have a mindblade manifested to use this feat."
        SendMessageToPCByStrRef(oPC, 16824509);
        return;
    }
@DAC */
    if(!spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    {// "Due to PvP settings, you cannot attack this target."
        SendMessageToPCByStrRef(oPC, 16824410);
        return;
    }

    // Wipe previous actions
    AssignCommand(oPC, ClearAllActions());

    // Create and queue equipping of the throwable blades
    int nPrevShape = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    switch (GetPersistantLocalInt(oPC, MBLADE_SHAPE)) // @DAC
    {
       case MBLADE_SHAPE_DART:
       case MBLADE_SHAPE_SHURIKEN:
          // Keep existing
          break;
       default:
          SetPersistantLocalInt(oPC, MBLADE_SHAPE, MBLADE_SHAPE_RANGED);
    }
    ExecuteScript("psi_sk_manifmbld", oPC);

    // Queue attacking
    DelayCommand(0.2f, AssignCommand(oPC, ActionDoCommand(ActionAttack(oTarget))));
    // Rather buggy atm
    //DelayCommand(0.4f, AssignCommand(oPC, PerformAttackRound(oTarget, oPC, EffectVisualEffect(-1))));

    // Return the old blade setting
    if (! GetHasFeat(FEAT_FREE_DRAW, oPC)) // @DAC
    {
       AssignCommand(oPC, ClearAllActions());
       SetPersistantLocalInt(oPC, MBLADE_SHAPE, nPrevShape);
    }

    // Set the lock on this feat
    SetLocalInt(oPC, THROW_MBLD_USED, TRUE);
    // Schedule unlocking and deletion of remaining throwables
    DelayCommand(6.0f, Cleanup(oPC));
}
