// On Used event for a (revealed) secret door.
// Based on zep_openclose
#include "zep_inc_scrptdlg"
void main()
{
   string sGateBlock = GetLocalString(OBJECT_SELF, "CEP_L_GATEBLOCK");
   location lSelfLoc = GetLocation(OBJECT_SELF);
   int bIsOpen = GetIsOpen(OBJECT_SELF);

   // If the object is locked, it cannot be opened or closed
   if (GetLocked(OBJECT_SELF))
   {
      //FloatingTextStringOnCreature("Locked", OBJECT_SELF);
      string sLockedMSG = GetStringByStrRef(nZEPDoorLocked, GENDER_MALE);
      SpeakString(sLockedMSG);
      return;
   }

   if (sGateBlock == "") // The item is not a door
   {
      if (bIsOpen)
      {
         PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
      }
      else
      {
         PlayAnimation(ANIMATION_PLACEABLE_OPEN);
      }
      return;
   }

   // The item is a door.
   if (bIsOpen)
   {
      // Find a waypoint with the tag "LOC_" + my tag, and transport to it.
      object oDest = GetWaypointByTag("LOC_" + GetTag(OBJECT_SELF));
      if (oDest != OBJECT_INVALID)
      {
         object oPC = GetLastUsedBy();
         AssignCommand(oPC, ActionJumpToLocation(GetLocation(oDest)));
         int nNth = 1;
         object oHench = GetHenchman(oPC, nNth);
         while (oHench != OBJECT_INVALID)
         {
            AssignCommand(oHench, ActionJumpToLocation(GetLocation(oDest)));
            nNth++;
            oHench = GetHenchman(oPC, nNth);
         }
      }
      else
      {
         SpeakString("The door appears to go nowhere.");
      }
      // Automatically close
      PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
      SetLocalObject(OBJECT_SELF, "GateBlock",
         CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock, lSelfLoc));
   }
   else
   {
      PlayAnimation(ANIMATION_PLACEABLE_OPEN);
      if (GetLocalObject(OBJECT_SELF, "GateBlock") != OBJECT_INVALID)
      {
         DestroyObject(GetLocalObject(OBJECT_SELF, "GateBlock"));
         SetLocalObject(OBJECT_SELF, "GateBlock", OBJECT_INVALID);
      }
      // Automatically close after a short delay.
      float fDelay = 2.0f;
      DelayCommand(fDelay, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      DelayCommand(fDelay + 0.1, SetLocalObject(OBJECT_SELF, "GateBlock",
         CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock, lSelfLoc)));
   }
}
