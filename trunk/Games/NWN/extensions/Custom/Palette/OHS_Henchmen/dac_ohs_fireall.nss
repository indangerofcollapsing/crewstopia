// Cribbed and modified from ohs_d1_fire
// Hmmmm...see also ohs_i0_commands::DropAllHenchmen()
#include "x0_i0_henchman"
#include "inc_debug_dac"

void notifyLinkboy(object oMaster, object oHenchman);

void main()
{
   debugVarObject("dac_ohs_fireall", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   debugVarObject("oPC", oPC);
   object oLinkBoy = OBJECT_INVALID;
   int nNth = 1;
   object oHenchman = GetHenchman(oPC, nNth);
   while (GetIsObjectValid(oHenchman))
   {
      if (FindSubString(GetTag(oHenchman), "OHS_") == 0)
      {
         if (GetResRef(oHenchman) == "ohs_linkboy")
         {
            oLinkBoy = oHenchman;
         }
         else
         {
            debugVarObject("You're fired!", oHenchman);
            FireHenchman(oPC, oHenchman);
            ChangeToStandardFaction(oHenchman, STANDARD_FACTION_MERCHANT);
            // V1.4.4: Exceptionally, if Defenders are hostile to Merchants
            // (e.g. in PotSC) join the Defenders instead
            if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER) <= 10)
            {
               ChangeToStandardFaction(oHenchman, STANDARD_FACTION_DEFENDER);
            }
            notifyLinkboy(oPC, oHenchman);
            DeleteLocalString(oHenchman, "OHS_S_MY_MASTER");
         }
      }

      oHenchman = GetHenchman(oPC, ++nNth);
   }

   if (oLinkBoy != OBJECT_INVALID)
   {
      ExecuteScript("dac_ohs_lbunsumm", oLinkBoy);
   }
}

void notifyLinkboy(object oMaster, object oHenchman)
{
  object oLinkboy = GetLocalObject(oMaster, "OHS_O_MY_LINKBOY");
  if (GetIsObjectValid(oLinkboy))
  {
    string sTagList = GetLocalString(oLinkboy, "OHS_PARTY_TAGLIST");
    string sMyTag = "," + GetTag(oHenchman) + ",";
    int iIndex = FindSubString(sTagList, sMyTag);
    if (iIndex >= 0)
    {
      sTagList = GetStringLeft(sTagList, iIndex) + GetStringRight(sTagList,
         GetStringLength(sTagList) - iIndex - GetStringLength(sMyTag));
      SetLocalString(oLinkboy,"OHS_PARTY_TAGLIST", sTagList);
    }
  }
}
