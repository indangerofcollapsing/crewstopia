#include "ohs_i0_tally"
#include "ohs_i0_messages"

void main()
{
  object oPC = GetPCSpeaker();
  string sName = GetName(oPC);
  DestroyCampaignDatabase("OHS_HENCHMAN_"+sName);

  string sM104 = OHS_GetStringByLanguage(104,oPC); // "Henchman "
  string sM107 = OHS_GetStringByLanguage(107,oPC); // " deleted."
  string sM111 = OHS_GetStringByLanguage(111,oPC); // ", your personal tally now stands at "

  string sRollCall = GetCampaignString("OHS_ROLL_CALL","sRollCall");
  string sTagList = GetCampaignString("OHS_ROLL_CALL","sTagList");
  sRollCall = GetStringRight(sRollCall,GetStringLength(sRollCall)-1);
  sTagList = GetStringRight(sTagList,GetStringLength(sTagList)-1);
  string sRollCall2 = ",";
  string sTagList2 = ",";
  string sName1,sTag1;
  int nComma;
  while (GetStringLength(sRollCall)>0)
  {
    nComma = FindSubString(sRollCall,",");
    sName1 = GetSubString(sRollCall,0,nComma);
    sRollCall = GetStringRight(sRollCall,GetStringLength(sRollCall)-nComma-1);
    nComma = FindSubString(sTagList,",");
    sTag1 = GetSubString(sTagList,0,nComma);
    sTagList = GetStringRight(sTagList,GetStringLength(sTagList)-nComma-1);
    if (sName1!=sName)
    {
      sRollCall2 += sName1+",";
      sTagList2 += sTag1+",";
    }
    else
    {
      int nTally = DecrementPersonalTally(oPC);
      SendMessageToPC(oPC,GetPCPlayerName(oPC)+sM111+IntToString(nTally)+".");
    }
  }
  DestroyCampaignDatabase("OHS_ROLL_CALL");
  SetCampaignString("OHS_ROLL_CALL","sRollCall",sRollCall2);
  SetCampaignString("OHS_ROLL_CALL","sTagList",sTagList2);
  SendMessageToPC(oPC,sM104+sName+sM107);
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
