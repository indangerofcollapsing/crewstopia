//::///////////////////////////////////////////////
//:: Name ohs_i0_anims
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
  Include functions for dual animations in close proximity
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-12-07
//:://////////////////////////////////////////////

// Close positioning. Caller goes to fDist from oTarget, disregarding personal spaces.
// fFacing* is an orientation relative to the line of centres, clockwise +ve.
// If bFreeze is set to TRUE, the caller will slide to the new position without foot movements.
void ActionMoveClose(float fDist, object oTarget, float fFacingCaller, float fFacingTarget, int bSlide=FALSE);

// Construct a pet name from a character's fullname
string MakePetName(string sFullname, int nGender);

// Animation for Female character kissing Male character
void ActionFemaleKissMale(object oKissee);

// Animation for Male character kissing Female character
void ActionMaleKissFemale(object oKissee);

/*******************/
/* Implementations */
/*******************/

// Close positioning. Caller goes to fDist from oTarget, disregarding personal spaces.
// fFacing* is an orientation relative to the line of centres, clockwise +ve.
// If bFreeze is set to TRUE, the caller will slide to the new position without foot movements.
void ActionMoveClose(float fDist, object oTarget, float fFacingCaller, float fFacingTarget, int bSlide=FALSE)
{
  vector vAxis = VectorNormalize(GetPosition(oTarget)-GetPosition(OBJECT_SELF));
  float fFacing = VectorToAngle(vAxis);
  vector vSpot = GetPosition(oTarget)-fDist*vAxis;
  location lSpot = Location(GetArea(oTarget),vSpot,fFacing+fFacingCaller);

  effect eGhost = EffectCutsceneGhost();
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,OBJECT_SELF);
  AssignCommand(oTarget,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,oTarget));
  AssignCommand(oTarget,SetFacing(fFacing+180.0f+fFacingTarget));

  effect eFreeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
  if (bSlide) ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT,eFreeze,OBJECT_SELF));

  ActionMoveToLocation(lSpot);
  ActionDoCommand(SetFacing(fFacing+fFacingCaller));
  if (!bSlide) ActionWait(0.75);

  ActionDoCommand(RemoveEffect(OBJECT_SELF,eGhost));
  if (bSlide) ActionDoCommand(RemoveEffect(OBJECT_SELF,eFreeze));
  ActionDoCommand(AssignCommand(oTarget,RemoveEffect(oTarget,eGhost)));
}

// Construct a pet name from a character's fullname
string MakePetName(string sFullname, int nGender)
{
  string char1 = GetStringUpperCase(GetSubString(sFullname,0,1));
  string char2 = GetStringLowerCase(GetSubString(sFullname,1,1));
  string char3 = GetStringLowerCase(GetSubString(sFullname,2,1));
  string char4 = GetStringLowerCase(GetSubString(sFullname,3,1));
  int bIsVowel1 = FindSubString("AEIOUY",char1)>-1;
  int bIsVowel2 = FindSubString("aeiouy",char2)>-1;
  int bIsVowel3 = FindSubString("aeiouy",char3)>-1;
  int bIsVowel4 = FindSubString("aeiouy",char4)>-1;
  int nFirstLength = FindSubString(sFullname," ");
  if (nFirstLength==-1) nFirstLength = GetStringLength(sFullname);
  string sFinal = (nGender==GENDER_FEMALE)?"i":"y";

  if (nFirstLength<3)
  {
    // I Claudius => I
    // Ug the Bold => Ug
    return GetStringLeft(sFullname,nFirstLength);
  }
  else if (bIsVowel2 && bIsVowel3)
  {
    // Maevir => Maes
    return char1+char2+char3+"s";
  }
  else if (bIsVowel2 && !bIsVowel3)
  {
    // Jacaran => Jaccy
    // Eamorel => Eammi
    return char1+char2+char3+char3+sFinal;
  }
  else if (bIsVowel1)
  {
    // Endomerilla => Enni
    // Anomen => Anny
    // Asgon => Azzy
    if (char2=="s") char2 = "z";
    return char1+char2+char2+sFinal;
  }
  else if (bIsVowel3 & !bIsVowel4)
  {
    // Frederick => Freddy
    // Thingora => Thinni
    return char1+char2+char3+char4+char4+sFinal;
  }
  else if (bIsVowel3)
  {
    // Trouble => Trozzy
    return char1+char2+char3+"zz"+sFinal;
  }
  else
  {
    // Sprat => Spry
    return char1+char2+char3+sFinal;
  }
}

// Animation for Female character kissing Male character
// They must be the same appearance type for it to look right
void ActionFemaleKissMale(object oMale)
{
  float fRadius;
  switch (GetAppearanceType(OBJECT_SELF))
  {
    case APPEARANCE_TYPE_DWARF:    fRadius = 0.50; break;
    case APPEARANCE_TYPE_ELF:      fRadius = 0.42; break;
    case APPEARANCE_TYPE_GNOME:    fRadius = 0.37; break;
    case APPEARANCE_TYPE_HALF_ELF: fRadius = 0.48; break;
    case APPEARANCE_TYPE_HALF_ORC: fRadius = 0.63; break;
    case APPEARANCE_TYPE_HALFLING: fRadius = 0.32; break;
    case APPEARANCE_TYPE_HUMAN:    fRadius = 0.48; break;
  }

  ActionMoveClose(fRadius,oMale,-2.0f,-2.0f);
  ActionDoCommand(AssignCommand(oMale,ActionWait(0.3)));
  ActionDoCommand(AssignCommand(oMale,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.6,1.8f)));
  ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,0.5,2.1f);
}

// Animation for Male character kissing Female character
// They must be the same appearance type for it to look right
void ActionMaleKissFemale(object oFemale)
{
  float fRadius;
  switch (GetAppearanceType(OBJECT_SELF))
  {
    case APPEARANCE_TYPE_DWARF:    fRadius = 0.50; break;
    case APPEARANCE_TYPE_ELF:      fRadius = 0.42; break;
    case APPEARANCE_TYPE_GNOME:    fRadius = 0.37; break;
    case APPEARANCE_TYPE_HALF_ELF: fRadius = 0.48; break;
    case APPEARANCE_TYPE_HALF_ORC: fRadius = 0.63; break;
    case APPEARANCE_TYPE_HALFLING: fRadius = 0.32; break;
    case APPEARANCE_TYPE_HUMAN:    fRadius = 0.48; break;
  }

  ActionMoveClose(fRadius,oFemale,-2.0f,-2.0f);
  ActionDoCommand(AssignCommand(oFemale,ActionWait(0.3)));
  ActionDoCommand(AssignCommand(oFemale,ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,0.6,1.8f)));
  ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.5,2.1f);
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