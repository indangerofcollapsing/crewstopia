//::///////////////////////////////////////////////
//:: Soulknife: Shape Mindblade
//:: psi_sk_shmbld
//::///////////////////////////////////////////////
/*
    Changes the shape of mindblades that will be
    next manifested and calls the manifesting script.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "inc_debug_dac" // @DUG

//////////////////////////////////////////////////
/* Local constants                              */
//////////////////////////////////////////////////

const int SHORTSWORD        = 2405;
const int DUAL_SHORTSWORDS  = 2406;
const int LONGSWORD         = 2407;
const int BASTARDSWORD      = 2408;

// @DUG Override standard PrC Mindblade shaping?
const string VAR_USE_CUSTOM_MINDBLADES = "SOULKNIFE_CUSTOM_MINDBLADE_SHAPES";

void main()
{
   //debugVarObject("psi_sk_shmbld", OBJECT_SELF);

   object oPC = OBJECT_SELF;
   //debugVarObject("oPC", oPC);

   if (! GetIsPC(oPC))
   {
      logError("Invalid PC in psi_sk_shmbld: " + objectToString(oPC));
   }

   // @DUG Customized mindblade shapes depending on level
   //debugVarBoolean("use custom mindblades", GetLocalInt(GetModule(), VAR_USE_CUSTOM_MINDBLADES));
   if (GetLocalInt(GetModule(), VAR_USE_CUSTOM_MINDBLADES))
   {
      // SendMessageToPC(oPC, "Using custom Mindblade shapes");
      SetPersistantLocalInt(OBJECT_SELF, "SOULKNIFE_DUAL_WIELD",
         (GetSpellId() == DUAL_SHORTSWORDS));
      //debugVarBoolean("dual wield", GetPersistantLocalInt(OBJECT_SELF, "SOULKNIFE_DUAL_WIELD"));
// @DUG      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oPC, "dac_sk_focus_cry", TRUE,
         FALSE));
      //debugMsg("returning");
      return;
   }

   //debug("Using standard Mindblade shapes");

   int nShape;

   switch(GetSpellId())
   {
      case SHORTSWORD:
         nShape = MBLADE_SHAPE_SHORTSWORD;
         break;
      case DUAL_SHORTSWORDS:
         nShape = MBLADE_SHAPE_DUAL_SHORTSWORDS;
         break;
      case LONGSWORD:
         nShape = MBLADE_SHAPE_LONGSWORD;
         break;
      case BASTARDSWORD:
         nShape = MBLADE_SHAPE_BASTARDSWORD;
         break;

      default:
         WriteTimestampedLogEntry("Wrong SpellId in Shape Mindblade");
   }

   SetPersistantLocalInt(oPC, MBLADE_SHAPE, nShape);

   // Manifest the new blade
   ExecuteScript("psi_sk_manifmbld", oPC);
}
