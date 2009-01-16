location getRopeBridgeDest(object oBridge = OBJECT_SELF);
location getRopeBridgeFallDest(object oBridge = OBJECT_SELF);
int getRopeBridgeMaxSafeLoad(object oBridge = OBJECT_SELF);
int getRopeBridgeFallDamageDice(object oBridge = OBJECT_SELF);
int getRopeBridgeNPCUseRadius(object oBridge = OBJECT_SELF);
void useRopeBridge(object oUser, object oBridge = OBJECT_SELF);
void flyOverRopeBridge(object oUser, object oBridge = OBJECT_SELF);
void ActionResetRopeBridgeUsed(object oCreature);
void ActionUseRopeBridge(object oUser, object oBridge = OBJECT_SELF);

// Tag of the waypoint that the bridge leads to.
const string VAR_ROPE_BRIDGE_DEST = "ROPE_BRIDGE_DEST";
// Tag of the waypoint where the user will fall if the bridge breaks.
const string VAR_ROPE_BRIDGE_FALL_DEST = "ROPE_BRIDGE_FALL_DEST";
// Maximum safe load (in pounds) before the bridge begins to fail.
const string VAR_ROPE_BRIDGE_MAX_SAFE_LOAD = "ROPE_BRIDGE_MAX_SAFE_LOAD";
// Number of damage dice (d6) to apply if the PC falls off the bridge
const string VAR_ROPE_BRIDGE_FALL_DAMAGE_DICE = "ROPE_BRIDGE_FALL_DAMAGE_DICE";
// Distance (in meters) at which NPC's and monsters should use the bridge.
// Set to -1 if they should never use it.
const string VAR_ROPE_BRIDGE_NPC_USE_RADIUS = "ROPE_BRIDGE_NPC_RADIUS";
// Flag on an NPC that they have used the bridge, so they don't just recross
// immediately, and so on, and so on, and so on, ...
const string VAR_ROPE_BRIDGE_USED_RECENTLY = "ROPE_BRIDGE_USED_RECENTLY";

#include "inc_travel"
#include "inc_flying"
#include "x2_inc_switches"
#include "inc_debug_dac"

location getRopeBridgeDest(object oBridge = OBJECT_SELF)
{
   //debugVarObject("getRopeBridgeDest()", OBJECT_SELF);
   //debugVarObject("oBridge", oBridge);
   location lDest;
   string sWaypointTag = GetLocalString(oBridge, VAR_ROPE_BRIDGE_DEST);
   //debugVarString("sWaypointTag", sWaypointTag);
   if (sWaypointTag != "")
   {
      // Destination specified by variable on bridge pointing to waypoint
      object oWaypoint = GetWaypointByTag(sWaypointTag);
      //debugVarObject("oWaypoint", oWaypoint);
      lDest = GetLocation(oWaypoint);
   }
   else
   {
      // Destination is the matching bridge on the other side
      object oOtherBridge = GetNearestObjectByTag(GetTag(oBridge), oBridge);
      //debugVarObject("oOtherBridge", oOtherBridge);
      if (oOtherBridge == OBJECT_INVALID)
      {
         FloatingTextStringOnCreature("The bridge appears to be broken!", oBridge);
         return lDest;
      }
      lDest = GetLocation(oOtherBridge);
   }

   //debugVarLoc("lDest", lDest);
   if (! isLocationValid(lDest))
   {
      logError("Invalid bridge destination for " + objectToString(oBridge));
      logError("sWaypointTag=" + sWaypointTag);
      logError("lDest=" + LocationToString(lDest));
      FloatingTextStringOnCreature("The bridge leads nowhere.", oBridge, TRUE);
      return GetLocation(oBridge);
   }

   //debugVarLoc("rope bridge dest", lDest);
   return lDest;
}

location getRopeBridgeFallDest(object oBridge = OBJECT_SELF)
{
   string sWaypointTag = GetLocalString(oBridge, VAR_ROPE_BRIDGE_FALL_DEST);
   object oWaypoint = GetWaypointByTag(sWaypointTag);
   location lDest = GetLocation(oWaypoint);
   if (! isLocationValid(lDest))
   {
      logError("Invalid bridge fall destination for " + objectToString(oBridge));
      logError("sWaypointTag=" + sWaypointTag);
      logError("oWaypoint=" + objectToString(oWaypoint));
      logError("lDest=" + LocationToString(lDest));
      FloatingTextStringOnCreature("You manage somehow to scramble back to the ledge.",
         oBridge, TRUE);
      return GetLocation(oBridge);
   }

   //debugVarLoc("rope bridge FALL dest", lDest);
   return lDest;
}

int getRopeBridgeMaxSafeLoad(object oBridge = OBJECT_SELF)
{
   return GetLocalInt(oBridge, VAR_ROPE_BRIDGE_MAX_SAFE_LOAD);
}

int getRopeBridgeFallDamageDice(object oBridge = OBJECT_SELF)
{
   return GetLocalInt(oBridge, VAR_ROPE_BRIDGE_FALL_DAMAGE_DICE);
}

int getRopeBridgeNPCUseRadius(object oBridge = OBJECT_SELF)
{
   return GetLocalInt(oBridge, VAR_ROPE_BRIDGE_NPC_USE_RADIUS);
}

void useRopeBridge(object oUser, object oBridge = OBJECT_SELF)
{
   debugVarObject("*** useRopeBridge()", OBJECT_SELF);
   debugVarObject("oUser", oUser);
   debugVarObject("oBridge", oBridge);

   if (oBridge == OBJECT_INVALID)
   {
      FloatingTextStringOnCreature("The bridge is out!", oUser);
      return;
   }

   object oPC = GetMaster(oUser);
   if (oPC == OBJECT_INVALID || GetIsPC(oUser)) oPC = oUser;

   int nChanceOfFailure = ((GetWeight(oUser) / 10) - getRopeBridgeMaxSafeLoad(oBridge));
   int nCanFly = canFly(oUser);
   //debugVarInt("nCanFly", nCanFly);
   switch (nCanFly)
   {
      // The PC chose to *use* the bridge rather than fly or jump.  NPCs are not so stupid.
      case TRUE:
         if (! GetIsPC(oUser))
         {
            SendMessageToPC(oPC, GetName(oUser) + " flies to the other side.");
            nChanceOfFailure = -1; // automatic success
         }
         break;
      case JUMP_ANYWHERE:
         if (! GetIsPC(oUser))
         {
            SendMessageToPC(oPC, GetName(oUser) + " jumps to the other side.");
            nChanceOfFailure = -1; // automatic success
         }
         break;
   }

   //debugVarInt("nChanceOfFailure", nChanceOfFailure);
   location lDest = getRopeBridgeDest(oBridge);
   int bSuccess = TRUE;
   int bBridgeDestroyed = FALSE;
   int nRoll = d100();
   debugVarInt("nRoll", nRoll);
   if (nRoll < nChanceOfFailure)
   {
      bSuccess = FALSE;
      // The bridge is destroyed.
      ApplyEffectToObject(DURATION_TYPE_INSTANT,
         EffectDamage(GetMaxHitPoints(oBridge)), oBridge);
      bBridgeDestroyed = TRUE;
      SendMessageToPC(oPC, "The " + GetName(oBridge) + " breaks!");
      // Destroy the other side of the bridge.
      int nNth = 1;
      object oOtherBridge = GetNearestObjectByTag(GetTag(oBridge), oBridge);
      //debugVarObject("oOtherBridge", oOtherBridge);
      if (oOtherBridge != OBJECT_INVALID)
      {
         // Found a matching placeable near the destination, destroy it.
         ApplyEffectToObject(DURATION_TYPE_INSTANT,
            EffectDamage(GetMaxHitPoints(oOtherBridge)), oOtherBridge);
      }

      if (GetIsPC(oUser))
      {
         if (nCanFly == TRUE)
         {
            SendMessageToPC(oUser, "But you are able to fly to the other side.");
            bSuccess = TRUE;
         }
      }
      else
      {
         SendMessageToPC(oPC, GetName(oUser) + " plummets to the ground!");
         FloatingTextStringOnCreature("Aaaaaauuuuuuuuuuuuuggggggggggggghhhhhhh!", oUser, TRUE);
      }

      if (! bSuccess)
      {
         int nDamageDice = getRopeBridgeFallDamageDice(oBridge);
         effect eDamage = EffectDamage(d6(nDamageDice), DAMAGE_TYPE_BLUDGEONING);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oUser);
         location lFallDest = getRopeBridgeFallDest(oBridge);
         AssignCommand(oUser, ActionJumpToLocation(lFallDest));
      }
   }

   debugVarBoolean("bSuccess", bSuccess);
   if (bSuccess)
   {
      AssignCommand(oUser, ActionJumpToLocation(lDest));
      //jumpTo(lDest, oUser);
      if ((nRoll * 0.9) < (nChanceOfFailure * 1.0))
      {
         FloatingTextStringOnCreature("Whew!  That was close!", oUser);
      }
      if (GetIsPC(oUser))
      {
         SendMessageToPC(oUser, "You make it safely to the other side.");
         debugVarBoolean("bBridgeDestroyed", bBridgeDestroyed);
         if (! bBridgeDestroyed)
         {
            int nNth = 1;
            object oHench = GetHenchman(oPC, nNth);
            while (oHench != OBJECT_INVALID)
            {
               debugVarObject("oHench", oHench);
               // This is set in ohs_hen_heart
               int bWaiting = GetLocalInt(oHench, "MODE_STAND_GROUND");
               debugVarBoolean("bWaiting", bWaiting);
               // This is set in ohs_hen_heart
               int bDefendMaster = GetLocalInt(oHench, "MODE_DEFEND_MASTER");
               debugVarBoolean("bDefendMaster", bDefendMaster);
               if (bWaiting)
               {
                  // Assigned to stay put, do so.
                  FloatingTextStringOnCreature("I'll just wait here then.", oHench);
               }
               else if (! bDefendMaster && GetIsInCombat(oUser))
               {
                  // In combat and not assigned to defend master, stay in combat
                  FloatingTextStringOnCreature("I'm a little busy here.  I'll follow when I can.", oHench);
               }
               else
               {
                  // Follow master (if you can!)
                  FloatingTextStringOnCreature("I'm coming with you.", oHench);
                  AssignCommand(oHench, ActionMoveToObject(oBridge));
                  AssignCommand(oHench, ActionUseRopeBridge(oHench, oBridge));
               }
               oHench = GetHenchman(oPC, ++nNth);
            }
         }
      }
   }
}

// This should only be used for PCs.  Henchmen will fly automatically if
// useRopeBridge() is called and they are able.
void flyOverRopeBridge(object oUser, object oBridge = OBJECT_SELF)
{
   //debugVarObject("flyOverRopeBridge()", OBJECT_SELF);
   //debugVarObject("oUser", oUser);
   //debugVarObject("oBridge", oBridge);

   if (!GetIsPC(oUser))
   {
      logError("ERROR: non-PC " + objectToString(oUser) + " calling flyOverRopeBridge()");
      return;
   }

   int nCanFly = canFly(oUser);
   //debugVarInt("nCanFly", nCanFly);
   if (nCanFly != TRUE)
   {
      logError("ERROR: " + objectToString(oUser) + " cannot fly in flyOverRopeBridge()");
      return;
   }

   location lDest = getRopeBridgeDest(oBridge);
   AssignCommand(oUser, ActionJumpToLocation(lDest));
   //jumpTo(lDest, oUser);
   SendMessageToPC(oUser, "You fly safely to the other side.");
   int nNth = 1;
   object oHench = GetHenchman(oUser, nNth);
   while (oHench != OBJECT_INVALID)
   {
      useRopeBridge(oHench, oBridge);
      oHench = GetHenchman(oUser, ++nNth);
   }
}

void ActionResetRopeBridgeUsed(object oCreature)
{
   //debugVarObject("ActionResetRopeBridgeUsed()", OBJECT_SELF);
   //debugVarObject("oCreature", oCreature);
   SetLocalInt(oCreature, VAR_ROPE_BRIDGE_USED_RECENTLY, FALSE);
}

void ActionUseRopeBridge(object oCreature, object oBridge)
{
   //debugVarObject("ActionUseRopeBridge()", OBJECT_SELF);
   //debugVarObject("oCreature", oCreature);
   //debugVarObject("oBridge", oBridge);

   if (oBridge == OBJECT_INVALID)
   {
      FloatingTextStringOnCreature("The bridge is out!", oCreature);
      return;
   }

   useRopeBridge(oCreature, oBridge);
}

//void main() {} // testing/compiling purposes
