void horseMount(object oPC = OBJECT_SELF);
void horseDismount(object oPC = OBJECT_SELF);
object horseSummon(object oPC = OBJECT_SELF);
void horseUnsummon(object oPC = OBJECT_SELF);

const string HORSE_UTIL_RESREF = "dac_horsecontrol";
const string VAR_MY_HORSE = "MY_HORSE";

#include "zep_inc_phenos"
#include "inc_debug_dac"

void horseMount(object oPC = OBJECT_SELF)
{
   if (oPC == OBJECT_INVALID)
   {
      logError("ERROR: invalid rider in horseMount()");
      return;
   }
   object oHorse = GetLocalObject(oPC, VAR_MY_HORSE);
   if (oHorse == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "You must first summon your mount.");
      return;
   }
   if (GetDistanceBetween(oPC, oHorse) > 5.0)
   {
      SendMessageToPC(oPC, "You must be near your mount to ride it.");
      return;
   }
   zep_Mount(oPC, oHorse, 0, fDEFAULT_SPEED, HORSE_UTIL_RESREF);
}

void horseDismount(object oPC = OBJECT_SELF)
{
   zep_Dismount(oPC);
   object oHorse = horseSummon(oPC);
   AddHenchman(oPC, oHorse);
}

object horseSummon(object oPC = OBJECT_SELF)
{
   object oHorse = GetLocalObject(oPC, VAR_MY_HORSE);
   if (oHorse == OBJECT_INVALID)
   {
      object oHorseUtil = GetItemPossessedBy(oPC, HORSE_UTIL_RESREF);
      if (oHorseUtil != OBJECT_INVALID)
      {
         string sResRef = GetTag(oHorseUtil);
         if (sResRef == "")
         {
            SendMessageToPC(oPC, "Your mount seems to have run away.");
         }
         else
         {
            oHorse = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
               GetLocation(oPC));
            SetLocalObject(oPC, VAR_MY_HORSE, oHorse);
         }
      }
   }
   else
   {
      AssignCommand(oHorse, ActionMoveToObject(oPC, TRUE));
      SendMessageToPC(oPC, "Your mount is on its way.");
   }
   if (oHorse != OBJECT_INVALID) AddHenchman(oPC, oHorse);
   return oHorse;
}

void horseUnsummon(object oPC = OBJECT_SELF)
{
   object oHorse = GetLocalObject(oPC, VAR_MY_HORSE);
   DestroyObject(oHorse, 5.0f);
   DeleteLocalObject(oPC, VAR_MY_HORSE);
}

//void main() {} // Testing/compiling purposes
