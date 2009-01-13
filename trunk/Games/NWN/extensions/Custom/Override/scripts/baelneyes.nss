#include "inc_debug_dac"
void main()
{
   string sError = "baelneyes.nss is broken!";
   SendMessageToAllDMs(sError);
   WriteTimestampedLogEntry(sError);
//effect eBaelnEyes = EffectVisualEffect(VFX_BAELN_EYES);

//if(GetLevelByClass(CLASS_TYPE_BAELNORN, oPC)> 0)
//   if("AddEyes")
//      if(!GetHasSpellEffect(SPELL_BAELNEYES, oPC))
//         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBaelnEyes, oPC);
//         DeleteLocalInt(oPC, "AddEyes");
//   else
//      RemoveSpellEffects(SPELL_BAELNEYES, oPC)
//else
//   RemoveSpellEffects(SPELL_BAELNEYES, oPC)
//   RemoveEventScript onequip
//   RemoveEventScript onunequip
}
