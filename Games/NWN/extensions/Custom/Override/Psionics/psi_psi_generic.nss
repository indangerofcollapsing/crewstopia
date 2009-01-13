/*
    generic powercalling function
*/
#include "psi_inc_psifunc"

// @DUG @FIX Wilders use INT instead of CHA for charm/dominate due to how this is implemented by PrC
void main()
{
    int nClass = CLASS_TYPE_PSION;
    int nSpell = PRCGetSpellId();
//    object oPC = GetFirstPC();
//    SendMessageToPC(oPC, "spell is " + IntToString(nSpell));

    // @DUG: Thrallherd Charm and Dominate
    if ((nSpell == 14364) || (nSpell == 14524))
    {
//SendMessageToPC(oPC, "CH = " + IntToString(GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF)) + ", IN = " + IntToString(GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF)) + ", WS = " + IntToString(GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF)));

       if (GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF) >
           GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF))
       {
          nClass = CLASS_TYPE_WILDER;
       }
       if (GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF) >
           GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF))
       {
          nClass = CLASS_TYPE_PSYWAR;
       }
    }
//else
//{
//   SendMessageToPC(oPC, "Not charm or dominate");
//}

//    if (nClass == CLASS_TYPE_PSION) SendMessageToPC(oPC, "You are a Psion");
//    if (nClass == CLASS_TYPE_WILDER) SendMessageToPC(oPC, "You are a Wilder");
//    if (nClass == CLASS_TYPE_PSYWAR) SendMessageToPC(oPC, "You are a PsyWar");

    UsePower(GetPowerFromSpellID(PRCGetSpellId()), nClass);
}
