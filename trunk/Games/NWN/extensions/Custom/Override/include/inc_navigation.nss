#include "inc_debug_dac"

int countWaypoints(string sTag);
void jumpToRandomWaypoint(string sTag);

int countWaypoints(string sTag)
{
   if (GetLocalInt(GetModule(), sTag) == 0)
   {
      int nWaypoints = 0;
      while (GetObjectByTag(sTag, nWaypoints++) != OBJECT_INVALID) {}
//      SendMessageToPC(GetFirstPC(), "found " + IntToString(nWaypoints - 1) + " waypoints with tag " + sTag);
      SetLocalInt(GetModule(), sTag, nWaypoints - 1);
   }
   return GetLocalInt(GetModule(), sTag);
}

// jump to random waypoint, but not the one you're at now
void jumpToRandomWaypoint(string sTag)
{
   object oPC = GetFirstPC();
//   SendMessageToPC(oPC, "jumping to random waypoint matching " + sTag);
   int nWaypoints = countWaypoints(sTag);
   object oNearestWaypoint = GetNearestObjectByTag(sTag);
   object oWaypoint;
   int nWaypoint = Random(nWaypoints);
   oWaypoint = GetObjectByTag(sTag, nWaypoint);
   if (oNearestWaypoint != OBJECT_INVALID && nWaypoints > 1)
   {
      if (oWaypoint == oNearestWaypoint)
      {
//         SendMessageToPC(oPC, "chosen is this one, choosing another");
         do
         {
            nWaypoint = Random(nWaypoints);
            oWaypoint = GetObjectByTag(sTag, nWaypoint);
         } while (oWaypoint == oNearestWaypoint);
//         SendMessageToPC(oPC, "new waypoint = " + IntToString(nWaypoint));
      }
   }
   if (oWaypoint == OBJECT_INVALID)
   {
      // this should not happen
      SendMessageToPC(oPC, "*** invalid waypoint " + IntToString(nWaypoint) + "***");
   }
   else
   {
//      SendMessageToPC(oPC, "Jumping to waypoint " + sTag + ":" + IntToString(nWaypoint));
      AssignCommand(oPC, ActionJumpToObject(oWaypoint));
      if (GetLocalInt(oPC, GetTag(GetArea(oWaypoint))) == 0)
      {
         // Haven't been here before
//         SendMessageToPC(oPC, "haven't been here before");
         SetLocalInt(oPC, GetTag(GetArea(oWaypoint)), 1);
      }
      else
      {
//         SendMessageToPC(oPC, "have been here before");
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0f, 0.5f));
         AssignCommand(oPC, ActionSpeakString("Funny.  I could swear I've been here before.", TALKVOLUME_TALK));
      }
   }
}

