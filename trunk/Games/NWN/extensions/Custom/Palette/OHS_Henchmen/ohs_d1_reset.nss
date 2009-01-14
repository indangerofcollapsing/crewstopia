void main()
{
  string sNameList = GetCampaignString("OHS_ROLL_CALL","sRollCall");
  sNameList = GetStringRight(sNameList,GetStringLength(sNameList)-1);
  string sTagList = GetCampaignString("OHS_ROLL_CALL","sTagList");
  sTagList = GetStringRight(sTagList,GetStringLength(sTagList)-1);
  string sFilteredNameList = ",";

  // Eliminate the names of any extant OHS_HEN* objects that match these tags
  string sName, sTag;
  int iBreak;
  int bFound;
  while (GetStringLength(sNameList)>2)
  {
    iBreak = FindSubString(sNameList,",");
    sName = GetStringLeft(sNameList,iBreak);
    sNameList = GetStringRight(sNameList,GetStringLength(sNameList)-iBreak-1);
    iBreak = FindSubString(sTagList,",");
    sTag = GetStringLeft(sTagList,iBreak);
    sTagList = GetStringRight(sTagList,GetStringLength(sTagList)-iBreak-1);
    bFound = GetIsObjectValid(GetObjectByTag(sTag));
    if (!bFound) sFilteredNameList += sName+",";
  }

  SetLocalString(OBJECT_SELF,"OHS_sRollCall",sFilteredNameList);
  SetLocalInt(OBJECT_SELF,"OHS_CONTINUATION_LIST",FALSE);
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