//::///////////////////////////////////////////////
//:: Name ohs_lb_attack
//:: Copyright (c) 2006 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnAttacked handler for OHS linkboys
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2006-01-29
//:: Last Modified: 2006-02-15
//:://////////////////////////////////////////////

void main()
{
  // Try to stall attacks and befriend attackers
  object oEnemy = GetLastAttacker();
  AssignCommand(oEnemy,ClearAllActions());
  SetIsTemporaryFriend(OBJECT_SELF,oEnemy);
  SetIsTemporaryFriend(oEnemy,OBJECT_SELF);

  // Remove any existing sanctuary effects
  effect eEffect = GetFirstEffect(OBJECT_SELF);
  while (GetIsEffectValid(eEffect))
  {
    if (GetEffectType(eEffect)==EFFECT_TYPE_SANCTUARY)
    {
      DelayCommand(0.0,RemoveEffect(OBJECT_SELF,eEffect));
    }
    eEffect = GetNextEffect(OBJECT_SELF);
  }

  // Then apply a new one to affect everyone present
  effect eSanctuary = SupernaturalEffect(EffectSanctuary(127));
  SetPlotFlag(OBJECT_SELF,FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSanctuary,OBJECT_SELF);
  SetPlotFlag(OBJECT_SELF,TRUE);
}

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole modified    //
// or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

