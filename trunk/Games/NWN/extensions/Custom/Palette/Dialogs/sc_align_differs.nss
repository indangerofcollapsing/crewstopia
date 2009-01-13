#include "inc_debug_dac"
int StartingConditional()
{
   object oPriest = OBJECT_SELF;
   object oPC = GetPCSpeaker();
   int nPriestGoodEvil = GetAlignmentGoodEvil(oPriest);
   int nPriestLawChaos = GetAlignmentLawChaos(oPriest);
   int nPCGoodEvil = GetAlignmentGoodEvil(oPC);
   int nPCLawChaos = GetAlignmentLawChaos(oPC);

   if (nPriestGoodEvil == -1 || nPriestLawChaos == -1 ||
       nPCGoodEvil == -1 || nPCLawChaos == -1)
   {
      logError("Invalid alignment response in sc_align_differs");
      logError("oPriest = " + objectToString(oPriest) + " law/chaos = " +
         IntToString(nPriestLawChaos) + ", good/evil = " +
         IntToString(nPriestGoodEvil));
      logError("oPC = " + objectToString(oPC) + " law/chaos = " +
         IntToString(nPCLawChaos) + ", good/evil = " +
         IntToString(nPCGoodEvil));
      return FALSE;
   }

   int bReturn = FALSE;
   string sNewAlignment;
   switch (nPriestLawChaos)
   {
      case ALIGNMENT_CHAOTIC:
         switch (nPCLawChaos)
         {
            case ALIGNMENT_LAWFUL:
               bReturn = TRUE;
               sNewAlignment = "Neutral";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = "Neutral";
               break;
            case ALIGNMENT_CHAOTIC:
               sNewAlignment = "Chaotic";
               break;
         }
         break;
      case ALIGNMENT_NEUTRAL:
         switch (nPCLawChaos)
         {
            case ALIGNMENT_LAWFUL:
               sNewAlignment = "Lawful";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = "Neutral";
               break;
            case ALIGNMENT_CHAOTIC:
               sNewAlignment = "Chaotic";
               break;
         }
         break;
      case ALIGNMENT_LAWFUL:
         switch (nPCLawChaos)
         {
            case ALIGNMENT_LAWFUL:
               sNewAlignment = "Lawful";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = "Neutral";
               break;
            case ALIGNMENT_CHAOTIC:
               bReturn = TRUE;
               sNewAlignment = "Neutral";
               break;
         }
         break;

   }

   switch (nPriestGoodEvil)
   {
      case ALIGNMENT_EVIL:
         switch (nPCGoodEvil)
         {
            case ALIGNMENT_EVIL:
               sNewAlignment = sNewAlignment + " Evil";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = sNewAlignment + " Neutral";
               break;
            case ALIGNMENT_GOOD:
               bReturn = TRUE;
               sNewAlignment = sNewAlignment + " Neutral";
               break;
         }
         break;
      case ALIGNMENT_NEUTRAL:
         switch (nPCGoodEvil)
         {
            case ALIGNMENT_EVIL:
               sNewAlignment = sNewAlignment + " Evil";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = sNewAlignment + " Neutral";
               break;
            case ALIGNMENT_GOOD:
               sNewAlignment = sNewAlignment + " Good";
               break;
         }
         break;
      case ALIGNMENT_GOOD:
         switch (nPCGoodEvil)
         {
            case ALIGNMENT_EVIL:
               bReturn = TRUE;
               sNewAlignment = sNewAlignment + " Neutral";
               break;
            case ALIGNMENT_NEUTRAL:
               sNewAlignment = sNewAlignment + " Neutral";
               break;
            case ALIGNMENT_GOOD:
               sNewAlignment = sNewAlignment + " Good";
               break;
         }
         break;
   }

   if (sNewAlignment == "Neutral Neutral") sNewAlignment = "True Neutral";

   if (bReturn) SetCustomToken(2113, sNewAlignment);
   return bReturn;
}
