#include "ohs_i0_messages"
int StartingConditional()
{
  string sDescr;
  object oPC = GetPCSpeaker();

  int iCloneGender = GetLocalInt(OBJECT_SELF,"OHS_CLONE_GENDER");
  int bDiffGender = iCloneGender != GetGender(oPC);
  int iCloneRace = GetLocalInt(OBJECT_SELF,"OHS_CLONE_RACE");
  int bDiffRace = iCloneRace != GetRacialType(oPC);
  int iClonePheno = GetLocalInt(OBJECT_SELF,"OHS_CLONE_PHENO");
  int bDiffPheno = iClonePheno != GetPhenoType(oPC);

  if (iCloneGender==GENDER_MALE)
    sDescr = OHS_GetStringByLanguage(160,oPC)+" ";  // "Male"
  else if (iCloneGender==GENDER_FEMALE)
    sDescr = OHS_GetStringByLanguage(161,oPC)+" ";  // "Female"
  else sDescr = "";
  sDescr += OHS_GetRacialTypeString(iCloneRace,oPC)+", ";
  int nPhenoMessage;
  if (iClonePheno==PHENOTYPE_NORMAL)
  {
    nPhenoMessage = (iCloneGender==GENDER_FEMALE)?170:169;
  }
  else if (iClonePheno==PHENOTYPE_BIG)
  {
    nPhenoMessage = (iCloneGender==GENDER_FEMALE)?171:172;
  }
  else
  {
    nPhenoMessage = 173;
  }
  sDescr += OHS_GetStringByLanguage(nPhenoMessage,oPC);
  SetCustomToken(504,sDescr);

  return bDiffGender || bDiffRace || bDiffPheno;
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
