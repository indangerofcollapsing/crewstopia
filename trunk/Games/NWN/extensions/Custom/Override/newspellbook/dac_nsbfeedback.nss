// Feedback for New Spellbook spontaneous casters
#include "prc_inc_spells"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_nsbfeedback", OBJECT_SELF);
   object oPC = GetItemActivator();
   //debugVarObject("oPC", oPC);

   // Currently WarMage (237) is the only spontaneous caster.
   // See inc_newspellbook:GetSpellbookTypeForClass().
   string sFeedback = "WarMage: ";

   int nCount = 0;
   int nSpellLevel;
   for (nSpellLevel = 0; nSpellLevel < 10; nSpellLevel++)
   {
      nCount = persistant_array_get_int(oPC, "NewSpellbookMem_237",
         nSpellLevel);
      //debugVarInt("nCount", nCount);
      if (nSpellLevel > 0) sFeedback += "/";
      sFeedback += IntToString(nCount);
   }
   //debugVarString("nFeedback", sFeedback);
   FloatingTextStringOnCreature(sFeedback, oPC, FALSE);
}
