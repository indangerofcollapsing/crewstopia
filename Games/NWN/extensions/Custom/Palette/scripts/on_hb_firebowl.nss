// Coming near an fire bowl, you might awaken something you won't like.
//::///////////////////////////////////////////////
//:: Based on NW_O2_SKELETON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
#include "inc_debug_dac"
#include "inc_re_besie"
#include "inc_nbde"
#include "inc_persistworld"
#include "inc_party"
void main()
{
   //debugVarObject("on_hb_firebowl", OBJECT_SELF);
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oPC) == TRUE &&
       GetDistanceToObject(oPC) < 10.0 &&
       ! GetIsObjectValid(GetLocalObject(OBJECT_SELF, "spawned_guardian"))
      )
   {
      //debug("PC is near");
      if (onDisturbedGuardMe())
      {
         string sResRef = "nw_elemfire"; // failsafe value
         int nTotalPartyLevels = getPartyTotalLevel(oPC, FALSE);
         switch(GetGameDifficulty())
         {
            case GAME_DIFFICULTY_VERY_EASY:
               nTotalPartyLevels = FloatToInt(nTotalPartyLevels * 0.5);
               break;
            case GAME_DIFFICULTY_EASY:
               nTotalPartyLevels = FloatToInt(nTotalPartyLevels * 0.75);
               break;
            case GAME_DIFFICULTY_NORMAL:
               break;
            case GAME_DIFFICULTY_DIFFICULT:
               nTotalPartyLevels = FloatToInt(nTotalPartyLevels * 1.25);
               break;
            case GAME_DIFFICULTY_EASY:
               nTotalPartyLevels = FloatToInt(nTotalPartyLevels * 1.5);
               break;
            default:
               break;
         }
         if (testODBC())
         {
            string sSQL =
               "SELECT resref " +
                 "FROM nwn_creatures " +
                "WHERE resref LIKE '%fire%' " +
                  "AND race_id = 16 " +
                  "AND cr <= " + IntToString(nTotalPartyLevels);
            SQLExecDirect(sSQL);
            if (SQLFetch() == SQL_SUCCESS) sResRef = SQLGetData(1);
            if (sResRef == "")
            {
               logError("Unable to find elemental in on_hb_firebowl; SQL = " +
                  sSQL);
               return;
            }
         }
         ActionSpeakString("The fire bowl erupts!");
         object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
            GetLocation(OBJECT_SELF));
         SetLocalObject(OBJECT_SELF, "spawned_guardian", oCreature);
      }
   }
}

