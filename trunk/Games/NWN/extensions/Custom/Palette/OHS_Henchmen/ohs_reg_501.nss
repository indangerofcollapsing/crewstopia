int StartingConditional()
{
  int nAge = GetAge(GetPCSpeaker());
  SetCustomToken(501,IntToString(nAge));
  int nPhonyAge = nAge;
  while (nPhonyAge==nAge) nPhonyAge += Random(nPhonyAge)-Random(nPhonyAge-10);
  SetCustomToken(502,IntToString(nPhonyAge));
  return TRUE;
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