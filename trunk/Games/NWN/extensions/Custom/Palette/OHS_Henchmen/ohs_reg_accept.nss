//::///////////////////////////////////////////////
//:: Name ohs_reg_accept
//:: Copyright (c) 2004 OldMansBeard.
//:://////////////////////////////////////////////
/*
  The PC has signed and returned the warrant, so go ahead
  -- Countersign the warrant and give it back to the PC
  -- Create a clone with a unique tag
  -- Store the clone in the database
  -- Ensure it is indexed and has a short description
  -- Destroy the clone again
  -- Increment the player's personal tally if this is a new registration
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Last Modified: 2006-03-27
//:://////////////////////////////////////////////

#include "ohs_i0_tally"
#include "ohs_i0_messages"

void main()
{
  object oPC = GetPCSpeaker();
  string sM104 = OHS_GetStringByLanguage(104,oPC);   // "Henchman "
  string sM105 = OHS_GetStringByLanguage(105,oPC);   // " indexed."
  string sM106 = OHS_GetStringByLanguage(106,oPC);   // " stored."
  string sM108 = OHS_GetStringByLanguage(108,oPC);   // "Failed to store henchman "
  string sM109 = OHS_GetStringByLanguage(109,oPC);   // ", your personal tally is now "
  string sM110 = OHS_GetStringByLanguage(110,oPC);   // " registrations."

  ActionPauseConversation();
  ActionPlayAnimation(ANIMATION_FIREFORGET_READ);
  ActionDoCommand(AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0f,1.0f)));
  ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0f,1.0f);
  object oWarrant = CreateItemOnObject("ohs_warrant",oPC);
  SetPlotFlag(oWarrant,FALSE);
  SetItemCursedFlag(oWarrant,TRUE);

  // Create a clone with a unique tag
  location lClone = GetLocation(OBJECT_SELF);
  string sNameTag = "OHS_HEN_"+GetName(oPC);
  object oHenchman = CopyObject(oPC,lClone,OBJECT_INVALID,sNameTag);
  ExecuteScript("ohs_hen_spawn",oHenchman);

  // Store the clone in the database
  string sName = GetName(oHenchman);
  string sTag = GetTag(oHenchman);
  string sDatabaseName = "OHS_HENCHMAN_"+sName;
  string sVarName = "oHenchman";
  DestroyCampaignDatabase(sDatabaseName);
  int bOkay = StoreCampaignObject(sDatabaseName,sVarName,oHenchman);
  if (bOkay)
  {
    // Make sure the name is indexed
    string sRollCall = GetCampaignString("OHS_ROLL_CALL","sRollCall");
    string sTagList = GetCampaignString("OHS_ROLL_CALL","sTagList");
    if (GetStringLength(sRollCall)<2)
    {
      sRollCall = ",";
      sTagList = ",";
    }
    if (FindSubString(sRollCall,","+sName+",")==-1)
    {
      sRollCall = ","+sName+sRollCall;
      sTagList = ","+sTag+sTagList;
      DestroyCampaignDatabase("OHS_ROLL_CALL");
      SetCampaignString("OHS_ROLL_CALL","sRollCall",sRollCall);
      SetCampaignString("OHS_ROLL_CALL","sTagList",sTagList);
      SendMessageToPC(oPC,sM104+sName+sM105);
      int nTally = IncrementPersonalTally(oPC);
      if (nTally>1)
      {
        SendMessageToPC(oPC,GetPCPlayerName(oPC)+sM109+IntToString(nTally)+sM110);
      }
    }
    // Create a short description and store it with the object
    // V1.5.1: Using StrRefs rather than embedded strings
    string sDescription, sCoded;
    int bNeutral = FALSE;
    switch (GetAlignmentLawChaos(oHenchman))
    {
      case ALIGNMENT_LAWFUL:
        sDescription = GetStringLeft(OHS_GetStringByLanguage(166,oPC),1);
        sCoded ="[A166]";
        break;
      case ALIGNMENT_NEUTRAL:
        sDescription = GetStringLeft(OHS_GetStringByLanguage(162,oPC),1);
        sCoded = "[A162]"; // @DUG
        bNeutral = TRUE;
        break;
      case ALIGNMENT_CHAOTIC:
        sDescription = GetStringLeft(OHS_GetStringByLanguage(165,oPC),1);
        sCoded = "[A165]";
        break;
    }
    switch (GetAlignmentGoodEvil(oHenchman))
    {
      case ALIGNMENT_GOOD:
        sDescription += GetStringLeft(OHS_GetStringByLanguage(163,oPC),1);
        sCoded += "[A163]";
        break;
      case ALIGNMENT_NEUTRAL:
        if (bNeutral)
        {
          sDescription += " ";
          sCoded += " ";
        }
        else
        {
          sDescription += GetStringLeft(OHS_GetStringByLanguage(162,oPC),1);
          sCoded += "[A162]";
        }
        break;
      case ALIGNMENT_EVIL:
        sDescription += GetStringLeft(OHS_GetStringByLanguage(164,oPC),1);
        sCoded += "[A164]";
        break;
    }
    if (GetGender(oHenchman)==GENDER_MALE)
    {
      sDescription += " "+OHS_GetStringByLanguage(160,oPC)+" ";  // Male
      sCoded += " [160] ";
    }
    else if (GetGender(oHenchman)==GENDER_FEMALE)
    {
      sDescription += " "+OHS_GetStringByLanguage(161,oPC)+" ";  // Female
      sCoded += " [161] ";
    }
    else
    {
      sDescription += " ";
      sCoded += " ";
    }
    sDescription += OHS_GetRacialTypeString(GetRacialType(oHenchman),oPC)+" ";
    sCoded += "[R"+IntToString(GetRacialType(oHenchman))+"] ";
    int nClass1 = GetClassByPosition(1,oHenchman);
    int nClass2 = GetClassByPosition(2,oHenchman);
    int nClass3 = GetClassByPosition(3,oHenchman);
    sDescription += OHS_GetClassNameString(nClass1,oPC)+"-"+IntToString(GetLevelByPosition(1,oHenchman));
    sCoded += "[C"+IntToString(nClass1)+"]-"+IntToString(GetLevelByPosition(1,oHenchman));
    if (nClass2!=CLASS_TYPE_INVALID)
    {
      sDescription += "/"+OHS_GetClassNameString(nClass2,oPC)+"-"+IntToString(GetLevelByPosition(2,oHenchman));
      sCoded += "/[C"+IntToString(nClass2)+"]-"+IntToString(GetLevelByPosition(2,oHenchman));
    }
    if (nClass3!=CLASS_TYPE_INVALID)
    {
      sDescription += "/"+OHS_GetClassNameString(nClass3,oPC)+"-"+IntToString(GetLevelByPosition(3,oHenchman));
      sCoded += "/[C"+IntToString(nClass3)+"]-"+IntToString(GetLevelByPosition(3,oHenchman));
    }
    SetCampaignString(sDatabaseName,"sDescription",sDescription);
    SetCampaignString(sDatabaseName,"sCoded",sCoded);
    SetCustomToken(768,sDescription);
    SendMessageToPC(oPC,sM104+sName+sM106);
  }
  else
  {
    SendMessageToPC(oPC,sM108+sName+".");
  }

  // Destroy the clone again
  AssignCommand(oHenchman,SetIsDestroyable(TRUE,FALSE,FALSE));
  AssignCommand(oHenchman,ActionDoCommand(DestroyObject(OBJECT_SELF)));

  ActionResumeConversation();
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
