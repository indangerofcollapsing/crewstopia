//::///////////////////////////////////////////////
//:: Name ohs_lb_heart
//:: Copyright (c) 2004 OldMansBeard.
//:://////////////////////////////////////////////
/*
   Heartbeat script for a linkboy in the Multi-Character system.
   -- Ensure that you are HASTED
   -- Ensure that you are PLOT
   -- Restore AI level to USUAL if necessary (V1.5.1)
   -- Ensure that you are a henchman
   -- Befriend any extant enemies so they won't attack you
   -- Scan for "lost" henchmen
   -- Scan for extra henchmen you hadn't put in your list
   -- V1.4.1: Check that all henchmen are in the right faction
   -- V1.4.5: Move story henchmen to the top of the list
   -- If Master or you is in a cutscene, stop all OHS_* doing anything
      otherwise marshal henchmen (including self) into party formation
   -- Nudge master's heartbeat clock count
   -- Refresh yourself if stale
   -- V1.4.4: Fire your own UserDefined Heartbeat event if appropriate
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-10-17
//:: Last Modified: 2006-04-10
//:://////////////////////////////////////////////

#include "x0_inc_henai"
#include "ohs_i0_common"
#include "ohs_i0_linkboy"
//V1.5.1: "ohs_i0_messages" included in ohs_i0_linkboy
#include "inc_debug_dac"

// Jump to your position in nRank, nFile behind oMaster
void TakePosition(object oMaster, int nRank, int nFile);

void main()
{
  // Ensure that self is HASTED
  if (!GetHasEffect(EFFECT_TYPE_HASTE,OBJECT_SELF))
  {
    effect eHaste = SupernaturalEffect(EffectHaste());
    SetPlotFlag(OBJECT_SELF,FALSE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eHaste,OBJECT_SELF);
    SetPlotFlag(OBJECT_SELF,TRUE);
  }
  // Ensure that self is PLOT
  SetPlotFlag(OBJECT_SELF,TRUE);

  // Restore AI level to USUAL if necessary (V1.5.1)
  if (!IsInConversation(OBJECT_SELF) && !GetCutsceneMode())
  {
    int nAILast  = GetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_LAST");
    int nAIUsual = GetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_USUAL")-1;
    if (nAILast!=nAIUsual || (nAIUsual!=AI_LEVEL_DEFAULT && GetAILevel()!=nAIUsual))
    {
      SetAILevel(OBJECT_SELF,nAIUsual);
      SetLocalInt(OBJECT_SELF,"OHS_LB_AI_LEVEL_LAST",nAIUsual);
    }
  }

  // Ensure that you are your master's henchman
  object oMaster = GetMaster();
  if (!GetIsObjectValid(oMaster))
  {
    string sMasterName = GetLocalString(OBJECT_SELF,"OHS_S_MY_MASTER");
    object oPC = GetFirstPC();
    int bFound = FALSE;
    while (GetIsObjectValid(oPC) && !bFound)
    {
      object oPCLinkboy = GetLocalObject(oPC,"OHS_O_MY_LINKBOY");
      if (GetName(oPC)==sMasterName || oPCLinkboy==OBJECT_SELF)
      {
        oMaster = oPC;
        bFound = TRUE;
      }
      oPC = GetNextPC();
    }
    if (GetIsObjectValid(oMaster) && !GetLocalInt(oMaster,"OHS_ALL_DROPPED"))
    {
      ForceMaxHenchmen(oMaster);
      AddHenchman(oMaster,OBJECT_SELF);
      SetIsFollower(OBJECT_SELF,TRUE);
    }
  }

  // Befriend any extant enemies so they won't attack you
  int nNth = 1;
  object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,nNth);
  while (GetIsObjectValid(oEnemy))
  {
    DelayCommand(0.0,SetIsTemporaryFriend(OBJECT_SELF,oEnemy));
    DelayCommand(0.0,SetIsTemporaryFriend(oEnemy,OBJECT_SELF));
    nNth++;
    oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,nNth);
  }

  // Scan for "lost" henchmen
  oMaster = GetMaster();
  if (GetIsObjectValid(oMaster))
  {
    string sTagList = GetLocalString(OBJECT_SELF,"OHS_PARTY_TAGLIST");
    while (GetStringLength(sTagList)>0)
    {
      int iIndex = FindSubString(sTagList,",");
      string sTag = GetStringLeft(sTagList,iIndex);
      sTagList = GetStringRight(sTagList,GetStringLength(sTagList)-iIndex-1);
      if (GetStringLength(sTag)>0)
      {
        nNth = 0;
        object oHenchman = GetObjectByTag(sTag,nNth);
        int bLostFound = FALSE;
        while (GetIsObjectValid(oHenchman) && !bLostFound)
        {
          if (GetMaster(oHenchman)==oMaster)
          {
            bLostFound = TRUE;
          }
          else
          {
            nNth++;
            oHenchman = GetObjectByTag(sTag,nNth);
          }
        }
        nNth = 0;
        oHenchman = GetObjectByTag(sTag,nNth);
        while (GetIsObjectValid(oHenchman) && !bLostFound)
        {
          if (GetLocalString(oHenchman,"OHS_S_MY_MASTER")==GetName(oMaster) && GetMaster(oHenchman)!=oMaster)
          {
            bLostFound = TRUE;
            // V1.5: fix to retrieve henchmen of henchmen
            RemoveHenchman(GetMaster(oHenchman),oHenchman);
            HireHenchman(oMaster,oHenchman,FALSE);
            AddHenchman(oMaster,oHenchman);
          }
          else
          {
            nNth++;
            oHenchman = GetObjectByTag(sTag,nNth);
          }
        }
      }
    }
  }

  // Scan for extra henchmen you hadn't put in your list
  oMaster = GetMaster();
  if (GetIsObjectValid(oMaster))
  {
    string sTagList = GetLocalString(OBJECT_SELF,"OHS_PARTY_TAGLIST");
    string sTag;
    nNth = 1;
    object oHenchman = GetHenchman(oMaster,nNth);
    while (GetIsObjectValid(oHenchman))
    {
      sTag = GetTag(oHenchman);
      if (FindSubString(sTag,"OHS_HEN")==0)
      {
        sTag = ","+sTag+",";
        if (FindSubString(sTagList,sTag)==-1) sTagList += sTag;
      }
      nNth++;
      oHenchman = GetHenchman(oMaster,nNth);
    }
    SetLocalString(OBJECT_SELF,"OHS_PARTY_TAGLIST",sTagList);
  }

  // V1.4.1: Check that all henchmen are in the right faction
  oMaster = GetMaster();
  if (GetIsObjectValid(oMaster) && GetFactionEqual(oMaster))
  {
    nNth = 1;
    object oHenchman = GetHenchman(oMaster,nNth);
    while (GetIsObjectValid(oHenchman))
    {
      if (!GetFactionEqual(oHenchman))
      {
         ChangeFaction(oHenchman,OBJECT_SELF);
      }
      nNth++;
      oHenchman = GetHenchman(oMaster,nNth);
    }
  }

  // V1.4.5: Move story henchmen to the top of the list
  // V1.5.1: Patch 1.67 Beta 3 behaves differently
  oMaster = GetMaster();
  if (GetIsObjectValid(oMaster))
  {
    nNth = 1;
    object oHenchman = GetHenchman(oMaster,nNth);
    string sTag;
    int nFirstOHS = 0;
    int nLastOther = 0;
    while (GetIsObjectValid(oHenchman))
    {
      sTag = GetTag(oHenchman);
      if (FindSubString(sTag,"OHS_")!=0)
      {
        nLastOther = nNth;
      }
      else if (nFirstOHS==0)
      {
        nFirstOHS = nNth;
      }
      nNth++;
      oHenchman = GetHenchman(oMaster,nNth);
    }
    if (nFirstOHS>0 && nLastOther>nFirstOHS)
    {
      nNth = 1;
      oHenchman = GetHenchman(oMaster,nNth);
      object oBackMarker = GetHenchman(oMaster,nLastOther);
      while (GetIsObjectValid(oHenchman) && oHenchman!=oBackMarker)
      {
        sTag = GetTag(oHenchman);
        if (FindSubString(sTag,"OHS_")==0)
        {
          RemoveHenchman(oMaster,oHenchman);
          AddHenchman(oMaster,oHenchman);
        }
        else
        {
          nNth++;
        }
        oHenchman = GetHenchman(oMaster,nNth);
      }
    }
  }

  // If Master or Linkboy is in a cutscene, stop everything
  // otherwise marshal henchmen (including self) into party formation
  oMaster = GetMaster();
  if (GetIsObjectValid(oMaster))
  {
    int nInRank1, nInRank2, nInRank3 = 0;
    int nNth = 1;
    object oHenchman = GetHenchman(oMaster,nNth);
    while (GetIsObjectValid(oHenchman))
    {
      if (GetIsHenchmanDying(oHenchman))
      {
        // Dying. Leave him alone.
      }
      else if (GetCutsceneMode(oMaster) || GetCutsceneMode(OBJECT_SELF))
      {
        // Changed V1.1.3
        // Leave story henchmen alone. They may have special scripts.
        if (FindSubString(GetTag(oHenchman),"OHS_")==0)
        {
          AssignCommand(oHenchman,ClearAllActions());
        }
      }
      else if (!IsInConversation(oMaster) && (oHenchman==OBJECT_SELF || GetCurrentAction(oHenchman)==ACTION_FOLLOW || GetCurrentAction(oHenchman)==ACTION_WAIT || GetCurrentAction(oHenchman)==ACTION_INVALID))
      {
        if (GetAssociateState(NW_ASC_DISTANCE_2_METERS,oHenchman))
        {
          nInRank1++;
          AssignCommand(oHenchman,TakePosition(oMaster,1,nInRank1));
          AssignCommand(oHenchman,DelayCommand(3.0,TakePosition(oMaster,1,nInRank1)));
        }
        else if (GetAssociateState(NW_ASC_DISTANCE_4_METERS,oHenchman))
        {
          nInRank2++;
          AssignCommand(oHenchman,TakePosition(oMaster,2,nInRank2));
          AssignCommand(oHenchman,DelayCommand(3.0,TakePosition(oMaster,2,nInRank2)));
        }
        else // if (GetAssociateState(NW_ASC_DISTANCE_6_METERS,oHenchman))
        {
          nInRank3++;
          AssignCommand(oHenchman,TakePosition(oMaster,3,nInRank3));
          AssignCommand(oHenchman,DelayCommand(3.0,TakePosition(oMaster,3,nInRank3)));
        }
      }
      nNth++;
      oHenchman = GetHenchman(oMaster,nNth);
    }
  }

  // Nudge master's heartbeat clock count
  if (GetIsObjectValid(oMaster))
  {
    int iFlag = GetLocalInt(GetMaster(),"OHS_HEARTBEAT_COUNT");
    SetLocalInt(GetMaster(),"OHS_HEARTBEAT_COUNT",++iFlag);
  }

  // Refresh yourself if stale
  if (OHS_GetIsLinkboyStale())
  {
    OHS_SetLinkboyListeningPatterns();
    OHS_SetLinkboyVersion();
    if (GetIsPC(GetMaster()))
    {
      string sRefreshed = OHS_GetStringByLanguage(103,GetMaster());
      SendMessageToPC(GetMaster(),sRefreshed);
    }
  }

  // Fire your own UserDefined Heartbeat event if appropriate
  if (!GetCutsceneMode(OBJECT_SELF) && !GetCutsceneMode(GetMaster()))
  {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_HEARTBEAT));
  }
}

// Jump to your position in nRank, nFile behind oMaster
void TakePosition(object oMaster, int nRank, int nFile)
{
    // V1.5.1: Check if dismissed in the last 3 seconds
    if (GetMaster()!=oMaster) return;
    if (IsInConversation(oMaster) || IsInConversation(OBJECT_SELF)) return;
    if (GetCutsceneMode(oMaster) || GetCutsceneMode(OBJECT_SELF)) return;
    if (GetCurrentAction()!=ACTION_FOLLOW && GetCurrentAction()!=ACTION_WAIT &&
        GetCurrentAction()!=ACTION_MOVETOPOINT && GetCurrentAction()!=ACTION_INVALID) return;
    if (GetAssociateState(NW_ASC_MODE_STAND_GROUND)) return;

    vector vMaster = GetPosition(oMaster);
    float fFacing = GetFacing(oMaster);
    float fRank = IntToFloat(nRank);
    nFile++; // V1.4.5 - leave the line astern empty
    vector vHench = vMaster - 1.9f*fRank*AngleToVector(fFacing+22.5f*((nFile%2==0)?nFile:(1-nFile))/fRank);
    location lHench = Location(GetArea(oMaster),vHench,fFacing);
    if (GetArea(OBJECT_SELF)!=GetArea(oMaster))
    {
      ClearAllActions();
      JumpToObject(oMaster);
      ActionForceFollowObject(oMaster,1.9f*fRank+1.0);
    }
    else if (!LineOfSightObject(oMaster,OBJECT_SELF))
    {
      ClearAllActions();
      JumpToLocation(lHench);
      ActionForceFollowObject(oMaster,1.9f*fRank+1.0);
    }
    else if (GetDistanceToObject(oMaster)>2.1f*fRank)
    {
      ClearAllActions();
      ActionMoveToLocation(lHench,FALSE);
      ActionForceFollowObject(oMaster,1.9f*fRank+1.0);
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

