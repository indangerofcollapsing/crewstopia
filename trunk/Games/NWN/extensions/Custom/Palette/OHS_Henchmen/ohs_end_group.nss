void main()
{
  int nNth;
  object oSpeaker;
  for (nNth=1;nNth<=6;nNth++)
  {
    oSpeaker= GetObjectByTag("OHS_SPEAKER_"+IntToString(nNth));
    if (GetIsObjectValid(oSpeaker))
    {
      AssignCommand(oSpeaker,SetIsDestroyable(TRUE,FALSE,FALSE));
      AssignCommand(oSpeaker,DestroyObject(oSpeaker));
    }
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