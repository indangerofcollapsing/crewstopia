int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sName = GetLocalString(OBJECT_SELF,"OHS_CALL_NAME");
  vector vSelf = GetPosition(OBJECT_SELF);
  vector vPC = GetPosition(oPC);
  vector vAxis = VectorNormalize(vSelf-vPC);
  float fFacing = VectorToAngle(vPC-vSelf);
  location lSpot = Location(GetArea(oPC),vPC+1.8f*vAxis,fFacing);
  object oHenchman = RetrieveCampaignObject("OHS_HENCHMAN_"+sName,"oHenchman",lSpot);
  if (GetIsObjectValid(oHenchman))
  {
    ChangeToStandardFaction(oHenchman,STANDARD_FACTION_MERCHANT);
    // V1.4.5: Exceptionally, if Defenders are hostile to Merchants
    // (e.g. in PotSC) join the Defenders instead
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER)<=10)
    {
      ChangeToStandardFaction(oHenchman,STANDARD_FACTION_DEFENDER);
    }
    SetCustomToken(707,sName);
    string sTallyUsedVarName = "OHS_TALLY_USED_"+GetName(oPC);
    int nUsed = GetLocalInt(GetModule(),sTallyUsedVarName);
    nUsed++;
    SetLocalInt(GetModule(),sTallyUsedVarName,nUsed);
    return TRUE;
  }
  else
  {
    return FALSE;
  }
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