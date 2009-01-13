//::///////////////////////////////////////////////
//:: Name ohs_i0_messages
//:: Copyright (c) 2006 OldMansBeard
//:://////////////////////////////////////////////
/*
   Adds multi-language support (well, Polish and English anyway)
   for OHS V1.5.1 onwards. All of the strings previously embedded
   in scripts have been collected into ohs_messages.2da

   If you examine the 2da in an editor you will think
   that the accented characters are garbled. That is
   because the Polish column is written in the NWN Polish
   character set which is different from the character
   set that your editor uses. Trust me on this one.
   If your editor uses ISO-8859-2 (latin-2 or Baltic)
   they will look nearly right except for two characters:
   a-ogonek is represented by ALT-0185 (¹) and
   s-acute is represented by ALT-0156 (œ).
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2006-03-20
//:: Polish contributed by Aedrielle
//:://////////////////////////////////////////////

const int OHS_LANGUAGE_ENGLISH = 0;
const int OHS_LANGUAGE_POLISH  = 5;
const string OHS_LANGUAGE_VAR  = "TMP_langVar";

// nLanguage = OHS_LANGUAGE_*
void OHS_SetPlayerLanguage(object oPC, int nLanguage, int bStoreInDB=TRUE);

// returns OHS_LANGUAGE_*
int  OHS_GetPlayerLanguage(object oPC);

//Look up a string in ohs_messages.2da according to player's language
string OHS_GetStringByLanguage(int nStringID, object oPC);

// Look up the name of class nClass in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in classes.2da if it seems to be hak'ed in the current module
string OHS_GetClassNameString(int nClass, object oPC);

// Look up the name of Racial Type nType in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in racialtypes.2da if it seems to be hak'ed in the current module
string OHS_GetRacialTypeString(int nType, object oPC);

// Look up the name of a Base Item Type nType in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in baseitems.2da if it seems to be hak'ed in the current module
string OHS_GetBaseItemNameString(int nType, object oPC);

/*****************/
/* Implemetation */
/*****************/

// nLanguage = OHS_LANGUAGE_*
void OHS_SetPlayerLanguage(object oPC, int nLanguage, int bStoreInDB=TRUE)
{
  SetLocalInt(oPC,OHS_LANGUAGE_VAR,nLanguage);
  if (bStoreInDB)
  {
    string sDatabaseName = "OHS_PLAYER_"+GetPCPlayerName(oPC);
    SetCampaignInt(sDatabaseName,"ohs_language",nLanguage);
  }
}

// returns OHS_LANGUAGE_*
int  OHS_GetPlayerLanguage(object oPC)
{
  return GetLocalInt(oPC,OHS_LANGUAGE_VAR);
}

//Look up a string in ohs_messages.2da according to player's language
string OHS_GetStringByLanguage(int nStringID, object oPC)
{
  int nLanguage = OHS_GetPlayerLanguage(oPC);
  string sLang;
  switch (nLanguage)
  {
    case OHS_LANGUAGE_POLISH:
      sLang = "Polish";
      break;

    default:
      sLang = "English";
      break;
  }
  return Get2DAString("ohs_messages",sLang,nStringID);
}

// Look up the name of class nClass in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in classes.2da if it seems to be hak'ed in the current module
string OHS_GetClassNameString(int nClass, object oPC)
{
  int nStrRef1 = StringToInt(Get2DAString("classes","Name",nClass));
  if (nClass>38) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  int nStrRef2 = StringToInt(Get2DAString("ohs_messages","StrRef",nClass+10));
  if (nStrRef2!=nStrRef1) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  return OHS_GetStringByLanguage(nClass+10,oPC);
}

// Look up the name of Racial Type nType in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in racialtypes.2da if it seems to be hak'ed in the current module
string OHS_GetRacialTypeString(int nType, object oPC)
{
  int nStrRef1 = StringToInt(Get2DAString("racialtypes","Name",nType));
  if (nType>29) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  int nStrRef2 = StringToInt(Get2DAString("ohs_messages","StrRef",nType+50));
  if (nStrRef2!=nStrRef1) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  return OHS_GetStringByLanguage(nType+50,oPC);
}

// Look up the name of a Base Item Type nType in the player's language.
// Use the ohs_messages.2da if possible but fall back on the StrRef
// in baseitems.2da if it seems to be hak'ed in the current module
string OHS_GetBaseItemNameString(int nType, object oPC)
{
  int nStrRef1 = StringToInt(Get2DAString("baseitems","Name",nType));
  if (nType>112) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  int nStrRef2 = StringToInt(Get2DAString("ohs_messages","StrRef",nType+220));
  if (nStrRef2!=nStrRef1) return GetStringByStrRef(nStrRef1); // Must be a hak. Can't translate.
  return OHS_GetStringByLanguage(nType+220,oPC);
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

