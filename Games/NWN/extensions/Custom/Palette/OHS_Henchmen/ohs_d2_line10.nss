// returns true if the player has a henchman in line 10 who is not the caller
int StartingConditional()
{
  object oMaster = GetMaster();
  int nOffset = GetLocalInt(OBJECT_SELF,"OHS_OFFSET");
  object oHenchman = GetHenchman(oMaster,nOffset+10);
  return oHenchman != OBJECT_INVALID && oHenchman != OBJECT_SELF;
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