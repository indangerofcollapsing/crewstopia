//::///////////////////////////////////////////////
//:: Tempest
//:://////////////////////////////////////////////
/*
    Script to modify skin of Tempest
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 5, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

void ApplyAbsAmbidex(object oPC)
{
     SetCompositeAttackBonus(oPC, "AbsoluteAmbidex", 2);
     SetLocalInt(oPC, "HasAbsAmbidex", 2);
}

void RemoveAbsAmbidex(object oPC)
{
     SetCompositeAttackBonus(oPC, "AbsoluteAmbidex", 0);
     SetLocalInt(oPC, "HasAbsAmbidex", 1);
}

void ApplyTwoWeaponDefense(object oPC, object oSkin)
{
     int ACBonus = 0;
     int tempestLevel = GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);

     if(tempestLevel < 4)
     {
          ACBonus = 1;
     }
     else if(tempestLevel >= 4 && tempestLevel < 7)
     {
          ACBonus = 2;
     }
     else if(tempestLevel >= 7)
     {
          ACBonus = 3;
     }

     itemproperty ipACBonus = ItemPropertyACBonus(ACBonus);

     SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", ACBonus, ITEM_PROPERTY_AC_BONUS);
}

void RemoveTwoWeaponDefense(object oPC, object oSkin)
{
     SetCompositeBonus(oSkin, "TwoWeaponDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
}

void ApplyExtraAttacks(object oPC)
{
     if(!GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
     {
          ActionCastSpellOnSelf(SPELL_T_TWO_WEAPON_FIGHTING);
     }
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    int armorType = GetArmorType(oArmor);
    if (oArmor == OBJECT_INVALID) armorType = ARMOR_TYPE_LIGHT;

    string nMes = "";

    // On Error Remove effects
    // This typically occurs On Load
    // Because the variables are not yet set.
    if(GetLocalInt(oPC, "HasAbsAmbidex") == 0 )
    {
         RemoveAbsAmbidex(oPC);
         RemoveTwoWeaponDefense(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              PRCRemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC);
         }
    }
    // Removes effects is armor is not light
    else if( armorType > ARMOR_TYPE_LIGHT )
    {
         RemoveAbsAmbidex(oPC);
         RemoveTwoWeaponDefense(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              PRCRemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC);
         }

         nMes = "*Two-Weapon Fighting Abilities Disabled Due To Equipped Armor*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }


    // Remove all effects if weapons are not correct
    else if(oWeapR == OBJECT_INVALID || oWeapL == OBJECT_INVALID ||
            GetBaseItemType(oWeapL) == BASE_ITEM_LARGESHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TOWERSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_SMALLSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TORCH)
    {
         RemoveAbsAmbidex(oPC);
         RemoveTwoWeaponDefense(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              PRCRemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC);
         }

         nMes = "*Two-Weapon Fighting Abilities Disabled Due To Invalid Weapon*"; // @DUG
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }
    // Apply effects if it passes all other checks
    else
    {
          // Is only called if Absolute Ambidex has been previously removed
          if(GetLocalInt(oPC, "HasAbsAmbidex") == 1 && GetHasFeat(FEAT_ABSOLUTE_AMBIDEX, oPC) )
          {
               ApplyAbsAmbidex(oPC);

               nMes = "*Absolute Ambidexterity Activated*";
               FloatingTextStringOnCreature(nMes, oPC, FALSE);
          }

          // Is called anytime TWD might have been upgraded
          // specifically set this way for level up
          if(GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC) )
          {
               //RemoveTwoWeaponDefense(oPC, oSkin);
               ApplyTwoWeaponDefense(oPC, oSkin);

               nMes = "*Two-Weapon Defense Activated*";
               FloatingTextStringOnCreature(nMes, oPC, FALSE);
          }

          // inserts a random delay before calling this function
          // this should prevent some errors caused by equipping
          // two weapons in rapid succession.
          float fDelay = IntToFloat(d6(1)) * 0.1;
          DelayCommand(fDelay, ApplyExtraAttacks(oPC) );
     }
}
