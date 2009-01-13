#include "inc_debug_dac"
#include "inc_pheno"
void main()
{
   debugVarObject("debug_item", OBJECT_SELF);
   object oPC = GetItemActivator();
   debugVarObject("oPC", oPC);
   deletePersistentInt(oPC, VAR_TRUE_PHENO);
   deletePersistentString(oPC, VAR_TRUE_PHENO);
   debugVarString("VAR_TRUE_PHENO", ">" + getPersistentString(oPC,
      VAR_TRUE_PHENO) + "<");
   int nPheno = GetPhenoType(oPC);
   debugVarInt("PC pheno before", nPheno);
   togglePhenoFly(oPC);
   int nNewPheno = GetPhenoType(oPC);
   debugVarInt("PC pheno after", nNewPheno);
   switch(nNewPheno)
   {
      case PHENO_NORMAL:
      case PHENO_LARGE:
      case PHENO_KENSAI:
      case PHENO_ASSASSIN:
      case PHENO_HEAVY:
      case PHENO_FENCING:
         debugVarObject("walking", oPC);
         break;
      case PHENO_FLYING:
      case PHENO_FLYING_LARGE:
         debugVarObject("flying", oPC);
         break;
      default:
         debugVarObject("Resetting pheno to normal", oPC);
         SetPhenoType(PHENO_NORMAL, oPC);
         break;
   }
}
