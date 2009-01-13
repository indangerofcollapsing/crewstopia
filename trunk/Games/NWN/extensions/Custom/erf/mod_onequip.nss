// On Equip Item event
#include "inc_cep_weapfeat"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("_mod_onequip", OBJECT_SELF);

   ExecuteScript("x2_mod_def_equ", OBJECT_SELF);
   ExecuteScript("prc_equip", OBJECT_SELF);

   // Handle CEP weapon feats
   onEquipCEPWeapon();

/* Found a better way to do this, but keeping this just in case.
   object oPC = GetPCItemLastEquippedBy();
   //debugVarObject("oPC", oPC);
   if (! GetIsPC(oPC)) return;

   object oItem = GetPCItemLastEquipped();
   //debugVarObject("oItem", oItem);

   if (GetStringLeft(GetName(oItem), 15) == "Holy Symbol of ")
   {
      string sPCDeity = GetDeity(oPC);
      //debugVarString("sPCDeity", sPCDeity);
      string sSymbolDeity = GetSubString(GetName(oItem), 15, 100);
      //debugVarString("sSymbolDeity", sSymbolDeity);
      if (sPCDeity != "")
      {
         if (sPCDeity == sSymbolDeity)
         {
            int nPCLawChaos = GetAlignmentLawChaos(oPC);
            int nLawChaos = ALIGNMENT_ALL;
            if (nPCLawChaos == ALIGNMENT_CHAOTIC) nLawChaos = ALIGNMENT_LAWFUL;
            else if (nPCLawChaos == ALIGNMENT_LAWFUL) nLawChaos = ALIGNMENT_CHAOTIC;

            int nPCGoodEvil = GetAlignmentGoodEvil(oPC);
            int nGoodEvil = ALIGNMENT_ALL;
            if (nPCGoodEvil == ALIGNMENT_GOOD) nGoodEvil = ALIGNMENT_EVIL;
            else if (nPCGoodEvil == ALIGNMENT_EVIL) nGoodEvil = ALIGNMENT_GOOD;

            effect eHolySymbol = SupernaturalEffect(VersusAlignmentEffect(
               EffectAreaOfEffect(AOE_MOB_TIDE_OF_BATTLE, "holysymbol_enter",
               "holysymbol_hb", "holysymbol_exit"), nLawChaos, nGoodEvil));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHolySymbol, oPC,
               3600.0f); // After one hour, the effect dissipates.
            SendMessageToPC(oPC, "Holy Symbol aura activated.");
         }
         else
         {
            SendMessageToPC(oPC, sPCDeity +
               " may be angered if you use another deity's holy symbol.");
         }
      }
      else
      {
         SendMessageToPC(oPC, "Only worshippers of " + sSymbolDeity +
            " gain benefits from this holy symbol.");
      }
   }
*/
}
