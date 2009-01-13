//::///////////////////////////////////////////////
//:: Name ohs_i0_toolkit
//:: Copyright (c) 2005 OldMansBeard
//:://////////////////////////////////////////////
/*
   A Module Builders' Toolkit of functions to control
   various aspects of the Release-2 OHS system.
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2005-02-01
//:: Last Modified: 2006-03-01
//:://////////////////////////////////////////////

/*************/
/* Constants */
/*************/

// Use these constants as parameters of OHS_GetIsEnabled() and OHS_SetEnabled()
const int OHS_SYSTEM_LINKBOY_QUOTA = 0x1;
const int OHS_SYSTEM_HALF_XP_FOR_HENCHMEN = 0x2; // Obsolete in V1.4
const int OHS_SYSTEM_R2_COMMANDS = 0x4; // Obsolete in V1.3 - has no effect
const int OHS_SYSTEM_COMPANIONS_CHOOSY = 0x8;

/****************/
/* Declarations */
/****************/

// Gets the original name of oObject, disregarding any SetName() effects
string GetTrueName(object oObject);

// Test if oCreature is registered in Tobias' database
int OHS_GetIsRegistered(object oCreature);

// Returns TRUE if oCreature is flagged as a Hero/Companion, FALSE otherwise
int OHS_GetIsCompanion(object oCreature);

// Set or clear the Companion flag on oCreature and set or clear its player owner name.
// To set the flag on an NPC who is not currently an associate of a PC,
// a valid PC must be specified as the oOwner or nothing will happen.
// In all other cases the oOwner parameter is ignored.
void OHS_SetCompanion(object oCreature, int bFlag = TRUE, object oOwner = OBJECT_INVALID);

// Test if an OHS_SYSTEM_* option is currently enabled
int OHS_GetIsEnabled(int nOption);

// Enable or disable an OHS_SYSTEM_* option.
// N.B. this will instantaneously affect all players.
void OHS_SetEnabled(int nOption, int bEnable = TRUE);

// Get the current setting of the Companions XP Level-Lag(0..3)
int OHS_GetXPLag();

// Set the game to lag Companions's XP by the equivalent of 0..3 levels behind the Hero.
void OHS_LagXP(int nLevels=0);

// Get the current setting for Max Alignment Difference between
// henchman and master. This is not used for companions, only for
// normal henchmen. The value returned will be in the range 1..100,
// with 100 being the default "don't care" value.
int OHS_GetMaxAlignmentDifference();

// Set the Max Alignment Difference allowed between henchman and master.
// This is not used for companions, only for normal henchmen.
// The value of nDiff must be in the range 1..100, with 100 being
// the default "don't care" value.
void OHS_SetMaxAlignmentDifference(int nDiff=100);

// Return TRUE if oLinkboy is currently allowed to call a Registrar
int OHS_GetCanCallRegistrar(object oLinkboy);

// Allow oLinkboy to call a Registar or disallow it. Default is Allow.
void OHS_SetCanCallRegistrar(object oLinkboy, int bAllow=TRUE);

// Count how many Companions a Hero currently has.
int OHS_GetNumberOfCompanions(object oPC);

// Make an invisible ghost copy of oCreature inside it with tag sTag
// This is useful for multiway conversations where known tags have to be assigned.
object CreateDummySpeaker(object oCreature, string sTag);

// Test if two creatures are compatible for flirting.
int OHS_FlirtCompatible(object oCreature1, object oCreature2=OBJECT_SELF);

/******************/
/* Implementation */
/******************/

// Gets the original name of oObject, disregarding any SetName() effects
string GetTrueName(object oObject)
{
  // Much simplified in Patch 1.67 Beta 2
  return GetName(oObject);
}

// Test if oCreature is registered in Tobias' database
int OHS_GetIsRegistered(object oCreature)
{
  string sRollCall = GetCampaignString("OHS_ROLL_CALL","sRollCall");
  int iIndex = FindSubString(sRollCall,","+GetTrueName(oCreature)+",");
  return iIndex>=0;
}

// Returns TRUE if oCreature is flagged as a Hero/Companion, FALSE otherwise
int OHS_GetIsCompanion(object oCreature)
{
  int iFlags = GetLocalInt(oCreature,"OHS_L_R2_FLAGS");
  if (iFlags & 0x1) return TRUE; else return FALSE;
}

// Set or clear the Companion flag on oCreature and set or clear its player owner name.
// To set the flag on an NPC who is not currently an associate of a PC,
// a valid PC must be specified as the oOwner or nothing will happen.
// In all other cases the oOwner parameter is ignored.
void OHS_SetCompanion(object oCreature, int bFlag = TRUE, object oOwner = OBJECT_INVALID)
{
  if (bFlag) // Companion
  {
    int bOkay = FALSE;
    if (GetIsPC(oCreature))
    {
      oOwner = oCreature;
      bOkay = TRUE;
    }
    else
    {
      object oMaster = GetMaster(oCreature);
      if (GetIsObjectValid(oMaster) && GetIsPC(oMaster))
      {
        oOwner = oMaster;
        bOkay = TRUE;
      }
      else if (GetIsObjectValid(oOwner) && GetIsPC(oOwner))
      {
        bOkay = TRUE;
      }
      else
      {
        bOkay = FALSE;
      }
    }
    if (bOkay)
    {
      int iFlags = GetLocalInt(oCreature,"OHS_L_R2_FLAGS") | 0x1;
      SetLocalInt(oCreature,"OHS_L_R2_FLAGS",iFlags);
      SetLocalString(oCreature,"OHS_S_PLAYER_OWNER",GetPCPlayerName(oOwner));
    }
  }
  else // Henchman
  {
    int iFlags = GetLocalInt(oCreature,"OHS_L_R2_FLAGS") & -2;
    SetLocalInt(oCreature,"OHS_L_R2_FLAGS",iFlags);
    SetLocalString(oCreature,"OHS_S_PLAYER_OWNER","");
  }
}

// Test if an OHS_SYSTEM_* option is currently enabled
int OHS_GetIsEnabled(int nOption)
{
  int iFlags = GetLocalInt(GetModule(),"OHS_MODULE_FLAGS");
  if ((iFlags & nOption)==nOption) return TRUE; else return FALSE;
}

// Enable or disable an OHS_SYSTEM_* option.
// N.B. this will instantaneously affect all players.
void OHS_SetEnabled(int nOption, int bEnable = TRUE)
{
  int iFlags = GetLocalInt(GetModule(),"OHS_MODULE_FLAGS");
  if (bEnable)
  {
    iFlags = iFlags | nOption;
  }
  else
  {
    iFlags = iFlags & (-nOption-1);
  }
  SetLocalInt(GetModule(),"OHS_MODULE_FLAGS",iFlags);
}

// Get the current setting of the Companions XP Level-Lag(0..3)
int OHS_GetXPLag()
{
  int iFlags = GetLocalInt(GetModule(),"OHS_MODULE_FLAGS");
  return (iFlags >> 3) & 0x3;
}

// Set the game to lag Companions's XP by the equivalent of 0..3 levels behind the Hero.
void OHS_LagXP(int nLevels=0)
{
  int iFlags = GetLocalInt(GetModule(),"OHS_MODULE_FLAGS");
  int nMask = ((nLevels & 0x3 ) << 3) & 0x18;
  iFlags = (iFlags & -25) | nMask;
  SetLocalInt(GetModule(),"OHS_MODULE_FLAGS",iFlags);
}

// Get the current setting for Max Alignment Difference between
// henchman and master. This is not used for companions, only for
// normal henchmen. The value returned will be in the range 1..100,
// with 100 being the default "don't care" value.
int OHS_GetMaxAlignmentDifference()
{
  int nStored = GetLocalInt(GetModule(),"OHS_MAX_ALIGNMENT_DIFFERENCE");
  return 100-(nStored % 100);
}

// Set the Max Alignment Difference allowed between henchman and master.
// This is not used for companions, only for normal henchmen.
// The value of nDiff must be in the range 1..100, with 100 being
// the default "don't care" value.
void OHS_SetMaxAlignmentDifference(int nDiff=100)
{
  int nStored = (100-nDiff) % 100;
  SetLocalInt(GetModule(),"OHS_MAX_ALIGNMENT_DIFFERENCE",nStored);
}

// Return TRUE if oLinkboy is currently allowed to call a Registrar
int OHS_GetCanCallRegistrar(object oLinkboy)
{
  return !GetLocalInt(oLinkboy,"OHS_NO_CALL_REGISTRAR");
}

// Allow oLinkboy to call a Registar or disallow it. Default is Allow.
void OHS_SetCanCallRegistrar(object oLinkboy, int bAllow=TRUE)
{
  SetLocalInt(oLinkboy,"OHS_NO_CALL_REGISTRAR",!bAllow);
}

// Count how many Companions a Hero currently has.
int OHS_GetNumberOfCompanions(object oPC)
{
  int nCompanions = 0;
  int nNth = 1;
  object oHenchman = GetHenchman(oPC,nNth);
  while (GetIsObjectValid(oHenchman))
  {
    if (OHS_GetIsCompanion(oHenchman)) nCompanions++;
    nNth++;
    oHenchman = GetHenchman(oPC,nNth);
  }
  return nCompanions;
}

// Make an invisible ghost copy of oCreature inside it with tag sTag
// This is useful for multiway conversations where known tags have to be assigned.
object CreateDummySpeaker(object oCreature, string sTag)
{
  object oDummy = CopyObject(oCreature,GetLocation(oCreature),OBJECT_INVALID,sTag);
  ChangeToStandardFaction(oDummy,STANDARD_FACTION_MERCHANT);
  // V1.4.4: Exceptionally, if Defenders are hostile to Merchants
  // (e.g. in PotSC) join the Defenders instead
  if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER,oDummy)<=10)
  {
    ChangeToStandardFaction(oDummy,STANDARD_FACTION_DEFENDER);
  }
  effect eInvis = SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
  effect eGhost = SupernaturalEffect(EffectCutsceneGhost());
  AssignCommand(oDummy,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oDummy));
  AssignCommand(oDummy,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,oDummy));
  SetLocalObject(oDummy,"OHS_MY_PERSON",oCreature);
  return oDummy;
}

// Test if two creatures are compatible for flirting.
int OHS_FlirtCompatible(object oCreature1, object oCreature2=OBJECT_SELF)
{
   return TRUE; // @DUG
  int iApp1 = GetAppearanceType(oCreature1);
  if (iApp1==APPEARANCE_TYPE_HALF_ELF) iApp1 = APPEARANCE_TYPE_HUMAN;
  if (iApp1>=7) return FALSE;

  int iApp2 = GetAppearanceType(oCreature2);
  if (iApp2==APPEARANCE_TYPE_HALF_ELF) iApp2 = APPEARANCE_TYPE_HUMAN;
  if (iApp2>=7 || iApp2!=iApp1) return FALSE;

  int iGender1 = GetGender(oCreature1);
  int iGender2 = GetGender(oCreature2);
  if (iGender1==GENDER_MALE && iGender2==GENDER_FEMALE) return TRUE;
  else if (iGender1==GENDER_FEMALE && iGender2==GENDER_MALE) return TRUE;
  else return FALSE;
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

//void main() {} // Testing/compiling purposes @DUG
