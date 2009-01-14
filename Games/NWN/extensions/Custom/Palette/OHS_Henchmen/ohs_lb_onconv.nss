//::///////////////////////////////////////////////
//:: Name ohs_lb_onconv
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnConversation handler for a linkboy object in
   OldMansBeard's Henchman System.

   Responds to being spoken to in the normal way
   and also catches the party control OHS commands
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-10-17
//:: Last Modified: 2006-04-10
//:://////////////////////////////////////////////

#include "ohs_i0_commands"
// #include "ohs_i0_messages"  included in ohs_i0_commands
#include "inc_debug_dac"

void main()
{
  // V1.4.5 Added code copied from x0_ch_hen_conv relating to
  // X2 henchman interjection/banter scheme
  if (GetLocalInt(GetModule(), "X2_L_XP2") == TRUE)
  {
    SetLocalInt(OBJECT_SELF, "X2_BANTER_TRY", 0);
    SetHasInterjection(GetMaster(OBJECT_SELF), FALSE);
    SetLocalInt(OBJECT_SELF, "X0_L_BUSY_SPEAKING_ONE_LINER", 0);
    SetOneLiner(FALSE, 0);
  }

  int nMatch = GetListenPatternNumber();
  if (nMatch == -1)
  {
    // V1.5.1: Set AILevel appropriately
    int nAILast  = GetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_LAST");
    int nAIConvo = GetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_CONVO")-1;
    if (nAILast!=nAIConvo || (nAIConvo!=AI_LEVEL_DEFAULT && GetAILevel()!=nAIConvo))
    {
      SetAILevel(OBJECT_SELF,nAIConvo);
      SetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_LAST",nAIConvo);
    }
    BeginConversation();
  }
  else if (GetLastSpeaker()==GetMaster())
  {
    object oPC = GetLastSpeaker();
    string sError1 = OHS_GetStringByLanguage(7,oPC); // "The "
    sError1 += GetMatchedSubstring(0);               //
    sError1 += OHS_GetStringByLanguage(8,oPC);       // " command is disabled.";

    switch(nMatch)
    {
      case ASSOCIATE_COMMAND_FOLLOWMASTER:
      // Copied from x0_inc_henai::bkRespondToHenchmenShout()
      ResetHenchmenState();
      SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
      ActionForceFollowObject(GetMaster(), GetFollowDistance());
      SetAssociateState(NW_ASC_IS_BUSY);
      DelayCommand(5.0, SetAssociateState(NW_ASC_IS_BUSY, FALSE));
      break;

      case ASSOCIATE_COMMAND_STANDGROUND:
      // Copied from x0_inc_henai::bkRespondToHenchmenShout()
      SetAssociateState(NW_ASC_MODE_STAND_GROUND);
      SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
      ActionAttack(OBJECT_INVALID);
      ClearActions(CLEAR_X0_INC_HENAI_RespondToShout1);
      break;

      case 2000: // OHS KEEP
      case 2002: // OHK
      KeepHenchmen(oPC);
      break;

      case 2010: // OHS RECALL
      case 2012: // OHR
      RecallHenchmen(oPC);
      break;

      case 2014: // OHS RECALL UPDATE
      case 2016: // OHRU
      RecallHenchmen(oPC,FALSE,TRUE);
      break;

      case 2020: // OHS DROP ALL
      case 2022: // OHDA
      DropAllHenchmen(oPC);
      SetLocalInt(oPC,"OHS_ALL_DROPPED",TRUE);
      break;

      case 2030: // OHS FIX FACTIONS
      case 2032: // OHFF
      FixFactions(oPC);
      break;

      case 2040: // OHS PARTY SAVE
      case 2042: // OHPS
      case 2050: // OHS ABSENT FRIENDS
      case 2052: // OHAF
      case 2060: // OHS UPDATE ME
      case 2062: // OHUM
      InvokeOhum(oPC);
      break;

      case 2070: // OHS WEED VAULT
      case 2072: // OHWV
      SendMessageToPC(oPC,sError1);
      break;

      case 2080: // HEAR US GREAT OHUM
      case 2082: // HUGO
      InvokeOhum(oPC);
      break;

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


