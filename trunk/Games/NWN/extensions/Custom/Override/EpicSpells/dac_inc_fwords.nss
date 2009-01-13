#include "x0_i0_position"
#include "prc_alterations"
#include "inc_dispel"
#include "inc_epicspells"

void FiendishWordsSummon(string fiendResRef, object oPC);
location GetOppositeLoc(object oTarget);

void FiendishWordsSummon(string fiendResRef, object oPC)
{
   // 20 minutes max, or NPC destroys self at end of conversation
   float fDur = 1200.0f;
   // Create the NPC fiend in front of oPC.
   location lNPC = GetOppositeLoc(oPC);
   object oNPC = CreateObject(OBJECT_TYPE_CREATURE, fiendResRef, lNPC);
   effect eGhost = EffectCutsceneGhost();
   effect eEther = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
   effect eHold = EffectCutsceneImmobilize();
   effect eLink = EffectLinkEffects(eGhost, eEther);
   eLink = EffectLinkEffects(eLink, eHold);
   SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oNPC, fDur, TRUE, -1,
      GetTotalCastingLevel(OBJECT_SELF));
   SetPlotFlag(oNPC, TRUE);
   // Initiate a conversation with the PC.
   AssignCommand(oNPC, ActionStartConversation(oPC, "", TRUE, FALSE));
   // After the maximum duration, destroy the NPC (sever the connection).
   DelayCommand(fDur, SetPlotFlag(oNPC, FALSE));
   DelayCommand(fDur, DestroyObject(oNPC));
}

location GetOppositeLoc(object oTarget)
{
   float fDir = GetFacing(oTarget);
   float fAngleOpposite = GetOppositeDirection(fDir);
   return GenerateNewLocation(oTarget, 1.5f, fDir, fAngleOpposite);
}

