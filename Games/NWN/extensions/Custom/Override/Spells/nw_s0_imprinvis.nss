/*
    nw_s0_imprinvis

    Target creature can attack and cast spells while
    invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006
*/

// Mod by ScrewTape - @DUG
/*
 Idea by Belial Prime. The PHB specifies Greater Invisibility as not being
 canceled by offensive actions, but Bioware wisely did not make Improved
 Invisibility behave this way as unlike in the PnP world, you cannot 'guess'
 and target an invisible character, so Bioware's compromise cancels
 invisibility, but keeps the concealment. This script achieves a closer
 compromise, where invisibility is still canceled by offensive actions, but it
 is re-instated for the remaining spell duration after combat. Big thanks to
 He Who Watches for helping me bulletproof it from reinstating it when it was
 canceled by dispel, rest, etc.
 */
// alter this to adjust the response time
// (this is how often the check will be made)
const float F_DELAY = 18.0f;
void ReapplyIfCanceled(object oTarget, float fDuration);

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int bBio = GetPRCSwitch(PRC_BIOWARE_INVISIBILITY);
    float fDur;
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(bBio ? INVISIBILITY_TYPE_NORMAL : INVISIBILITY_TYPE_IMPROVED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
    int CasterLvl = nCasterLevel;
    int nDuration = CasterLvl;
    if (GetHasFeat(FEAT_INSIDIOUSMAGIC,OBJECT_SELF) && GetHasFeat(FEAT_SHADOWWEAVE,oTarget))
       nDuration = nDuration*2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    fDur = bBio ? TurnsToSeconds(nDuration) : RoundsToSeconds(nDuration);
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,CasterLvl);

    float fDurationLeft = TurnsToSeconds(nDuration) - F_DELAY; // @DUG
    DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft)); // @DUG

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}

///////////////////////////////////////////////////////////////////////////////
// ReapplyIfCanceled
//  Delayed recursion (pseudo heartbeat function to check for canceled
//  invisibility during the duration of the spell).  Big thanks to
//  He Who Watches for thinking of checking to see if concealment still
//  applied to determine if it was canceled by rest or dispel.
void ReapplyIfCanceled(object oTarget, float fDuration) // @DUG
{
   // determine remaining duration
   float fDurationLeft = fDuration - F_DELAY;
   int bConcealed = FALSE;
   int bInvisible = FALSE;

   if (fDurationLeft < F_DELAY) return; // we be done - duration has expired

   if (GetIsInCombat(oTarget)) // check again later
   {
      DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
      return;
   }

   // Check for both concealment (which doesn't get canceled by anything but
   // resting or Dispel - if no concealment, we're also done) and for
   // invisibility effect.
   effect eEffectLoop = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffectLoop))
   {
      // If we find invisibility, we don't need to do anything yet.
      if (GetEffectType(eEffectLoop) == INVISIBILITY_TYPE_NORMAL ||
          GetEffectType(eEffectLoop) == INVISIBILITY_TYPE_IMPROVED)
      {
         bInvisible = TRUE;
         DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
         return;
      }

      // If we find concealment, and it was applied by the spell Improved
      // Invisibility, we know the effect has not been dispelled by rest
      // or Dispel Magic.
      if (GetEffectType(eEffectLoop) == EFFECT_TYPE_CONCEALMENT)
      {
         if (GetEffectSpellId(eEffectLoop) == SPELL_IMPROVED_INVISIBILITY)
         {
            bConcealed = TRUE;
         }
      }

      eEffectLoop = GetNextEffect(oTarget);
   }

   // If we didn't find invisibility, reapply if it was canceled by combat
   // (concealment still exists).
   if (bConcealed && !bInvisible)
   {
      effect eNewInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNewInvis, oTarget,
         fDurationLeft);
      FloatingTextStringOnCreature("Your invisibility returns.", oTarget,
         FALSE);

      // keep checking for later
      DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
   }
   // otherwise, do nothing - maybe rested, dispelled etc.
}
