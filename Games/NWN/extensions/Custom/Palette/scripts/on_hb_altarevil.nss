// Coming near an evil shrine, you might awaken something you won't like.
//::///////////////////////////////////////////////
//:: Based on NW_O2_SKELETON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
#include "inc_debug_dac"
#include "inc_re_besie"
#include "inc_persistworld"
void main()
{
   //debugVarObject("on_hb_altarevil", OBJECT_SELF);
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oPC) == TRUE &&
       GetDistanceToObject(oPC) < 5.0 &&
       ! GetIsObjectValid(GetLocalObject(OBJECT_SELF, "spawned_guardian")) &&
       GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
      )
   {
      //debug("PC is near");
      if (onDisturbedGuardMe())
      {
         ActionSpeakString("The altar shivers visibly.");
         object oCreature = spawnSinglePlanar(oPC);
         SetLocalObject(OBJECT_SELF, "spawned_guardian", oCreature);
      }
   }
}

