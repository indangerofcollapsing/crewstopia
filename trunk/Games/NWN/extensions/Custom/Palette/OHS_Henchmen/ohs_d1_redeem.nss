void main()
{
  object oPC = GetPCSpeaker();
  object oSelf = OBJECT_SELF;
  object oSurety = GetLocalObject(OBJECT_SELF,"OHS_SURETY");
  int nFee = GetLocalInt(oSurety,"OHS_REDEMPTION_FEE");

  TakeGoldFromCreature(nFee,oPC);
  DeleteLocalInt(oSurety,"OHS_REDEMPTION_FEE");
  SetItemCursedFlag(oSurety,FALSE);
  AssignCommand(oPC,ActionTakeItem(oSurety,oSelf));
  DeleteLocalObject(OBJECT_SELF,"OHS_SURETY");
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