// When a PC enters the pentagram, a demon might be summoned.
//::///////////////////////////////////////////////
//:: Based on NW_O2_SKELETON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
#include "inc_debug_dac"
#include "inc_re_besie"
#include "inc_persistworld"
void main()
{
   //debugVarObject("on_hb_pentagram", OBJECT_SELF);
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oPC) == TRUE &&
       GetDistanceToObject(oPC) < 3.0 &&
       ! GetIsObjectValid(GetLocalObject(OBJECT_SELF, "spawned_guardian"))
      )
   {
      //debug("PC is near");
      ActionSpeakString("The air shimmers briefly.");
      object oCreature = spawnSinglePlanar(oPC);
      SetLocalObject(OBJECT_SELF, "spawned_guardian", oCreature);
   }
}

