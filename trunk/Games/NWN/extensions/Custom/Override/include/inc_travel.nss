#include "inc_debug_dac"

void onHeartbeatTravel();
void startTravel();
void endTravel();
int getTravelStatus();
void exitShip();
void speakRandomNauticalPhrase();
string getTravelDestination();
int isLocationValid(location lLoc);
void jumpTo(location lLoc, object oPC = OBJECT_SELF);

// Variable which holds the tag of the destination
const string VAR_TRAVEL_DESTINATION = "Travel_Destination";
// Variable which holds the time remaining (rounds) until the trip ends
const string VAR_TRAVEL_TIME = "Travel_Time";
// Variable which holds the status of the travel coordinator
const string VAR_TRAVEL_STATUS = "Travel_Status";

// Statuses for the travel coordinator
const int STATUS_IDLE = 0;
const int STATUS_TRAVELLING = 1;
const int STATUS_ARRIVED = 2;

void onHeartbeatTravel()
{
   string sDest = GetLocalString(OBJECT_SELF, VAR_TRAVEL_DESTINATION);
   if (sDest == "") return;

   if (getTravelStatus() != STATUS_TRAVELLING) return;

   int nRoundsRemaining = GetLocalInt(OBJECT_SELF, VAR_TRAVEL_TIME);
   //debugVarInt("waiting", nRoundsRemaining);
   if (nRoundsRemaining > 0)
   {
      // We are travelling
      nRoundsRemaining--;
      SetLocalInt(OBJECT_SELF, VAR_TRAVEL_TIME, nRoundsRemaining);
      switch(nRoundsRemaining)
      {
         case 10:
            ActionSpeakString("There it is, on the horizon.", TALKVOLUME_SHOUT);
            break;
         case 3:
            ActionSpeakString("Almost there.", TALKVOLUME_SHOUT);
            break;
         case 1:
            ActionSpeakString("Weigh anchor!  Prepare for docking!", TALKVOLUME_SHOUT);
            break;
         default:
            speakRandomNauticalPhrase();
            break;
      }
   }
   else
   {
      endTravel();
   }
}

void startTravel()
{
   //debugVarObject("startTravel()", OBJECT_SELF);
   string sDestTag = GetLocalString(OBJECT_SELF, VAR_TRAVEL_DESTINATION);
   //debugVarString("sDestTag", sDestTag);
   if (sDestTag == "")
   {
      logError("Invalid destination in startTravel()");
      return;
   }

   object wpDest = GetWaypointByTag(sDestTag);
   if (wpDest == OBJECT_INVALID)
   {
      logError("Invalid waypoint in startTravel()");
      return;
   }

   location locDest = GetLocation(wpDest);
   if (GetAreaFromLocation(locDest) == OBJECT_INVALID)
   {
      logError("Invalid waypoint location in startTravel()");
      return;
   }

   int nTravelRounds = Random(10) + 3;
   SetLocalInt(OBJECT_SELF, VAR_TRAVEL_TIME, nTravelRounds);
   SetLocalInt(OBJECT_SELF, VAR_TRAVEL_STATUS, STATUS_TRAVELLING);
   ActionSpeakString("Estimated travel time is " + IntToString(nTravelRounds) +
      " rounds, if these winds hold.");
}

void endTravel()
{
   SetLocalInt(OBJECT_SELF, VAR_TRAVEL_STATUS, STATUS_ARRIVED);
   ActionSpeakString("We've arrived at " + getTravelDestination() + ".",
      TALKVOLUME_TALK);
}

int getTravelStatus()
{
   return GetLocalInt(OBJECT_SELF, VAR_TRAVEL_STATUS);
}

void exitShip()
{
   string sDestTag = GetLocalString(OBJECT_SELF, VAR_TRAVEL_DESTINATION);
   //debugVarString("sDestTag", sDestTag);
   if (sDestTag == "")
   {
      logError("Invalid destination in startTravel()");
      return;
   }

   object wpDest = GetWaypointByTag(sDestTag);
   if (wpDest == OBJECT_INVALID)
   {
      logError("Invalid waypoint in startTravel() for tag " + sDestTag);
      return;
   }

   location locDest = GetLocation(wpDest);
   if (GetAreaFromLocation(locDest) == OBJECT_INVALID)
   {
      logError("Invalid waypoint location in startTravel() for tag " + sDestTag);
      return;
   }

   SetLocalInt(OBJECT_SELF, VAR_TRAVEL_STATUS, STATUS_IDLE);
   SetLocalString(OBJECT_SELF, VAR_TRAVEL_DESTINATION, "");
   AssignCommand(GetPCSpeaker(), ActionJumpToLocation(locDest));
}

void speakRandomNauticalPhrase()
{
   switch(Random(20))
   {
      case 0:
         ActionSpeakString("Prepare to come about.", TALKVOLUME_SHOUT);
         break;
      case 1:
         ActionSpeakString("Hold fast there.", TALKVOLUME_SHOUT);
         break;
      case 2:
         ActionSpeakString("Steady as she goes.", TALKVOLUME_SHOUT);
         break;
      case 3:
         ActionSpeakString("You there!  Look lively!", TALKVOLUME_SHOUT);
         break;
      default:
         break;
   }
}

string getTravelDestination()
{
   string sDest = GetLocalString(OBJECT_SELF, VAR_TRAVEL_DESTINATION);
   object oWaypoint = GetWaypointByTag(sDest);
   if (oWaypoint != OBJECT_INVALID) sDest = GetName(oWaypoint);
   if (sDest == "") sDest = "an unknown location";
   return sDest;
}

int isLocationValid(location lLoc)
{
   return (GetAreaFromLocation(lLoc) != OBJECT_INVALID);
}

void jumpTo(location lLoc, object oPC = OBJECT_SELF)
{
   if (isLocationValid(lLoc))
   {
      AssignCommand(oPC, ActionJumpToLocation(lLoc));
      int nNth = 1;
      object oHench = GetHenchman(oPC, nNth);
      while (oHench != OBJECT_INVALID)
      {
         AssignCommand(oHench, ActionJumpToLocation(lLoc));
         nNth++;
         oHench = GetHenchman(oPC, nNth);
      }
   }
   else
   {
      logError("Invalid location in jumpTo(): " + LocationToString(lLoc));
   }
}

//void main() {} // testing/compiling purposes

