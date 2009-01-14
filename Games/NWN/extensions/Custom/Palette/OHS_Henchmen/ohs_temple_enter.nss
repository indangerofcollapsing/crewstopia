#include "ohs_i0_toolkit"

int IsRemembered(object oPC)
{
  string sDatabaseName = "OHS_PLAYER_"+GetPCPlayerName(oPC);
  string sNameList = GetCampaignString(sDatabaseName,"sNameList");
  string sToLookFor = ","+GetName(oPC)+",";
  return FindSubString(sNameList,sToLookFor)>=0;
}

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;

  int iStatus = GetLocalInt(oPC,"OHS_TEMPLE_STATUS");
  if (IsRemembered(oPC))
  {
    // Can skip intro and allow Ritual if already known to Ohum
    if (iStatus==0) iStatus =3;
  }
  SetLocalInt(oPC,"OHS_TEMPLE_STATUS",iStatus);

  AssignCommand(oPC,ClearAllActions());
  AssignCommand(oPC,SetCameraFacing(225.0f,6.0f,45.0f));
  object oVera = GetObjectByTag("OHS_PRIESTESS");
  SetCreatureAppearanceType(oVera,GetAppearanceType(oPC));
  AssignCommand(oPC,ActionStartConversation(oVera));
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