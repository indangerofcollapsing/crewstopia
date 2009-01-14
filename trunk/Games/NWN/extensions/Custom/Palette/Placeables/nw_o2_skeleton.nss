//::///////////////////////////////////////////////
//:: NW_O2_SKELETON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Turns the placeable into a skeleton
   if a player comes near enough.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   January 17, 2002
//:://////////////////////////////////////////////
#include "inc_debug_dac"
#include "inc_re_besie"
#include "inc_persistworld"
void main()
{
   //debugVarObject("nw_o2_skeleton", OBJECT_SELF);
   // This variable is set when the object is respawned via BESIE
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oCreature) == TRUE &&
       GetDistanceToObject(oCreature) < 10.0
      )
   {
      //debugMsg("PC is near");
      if (onDisturbedGuardMe())
      {
         ActionSpeakString("Brainsssss!");
         spawnSingleUndead(oCreature);
         // Allow to respawn (must also use on_death_XXX_rs)
         ApplyEffectToObject(DURATION_TYPE_INSTANT,
            EffectDamage(GetMaxHitPoints()),  OBJECT_SELF);
      }
   }
}

/* original code
void ActionCreate(string sCreature, location lLoc)
{
   CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
}
void main()
{
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oCreature) == TRUE && GetDistanceToObject(oCreature) < 10.0)
   {
    effect eMind = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    string sCreature = "NW_SKELWARR01";
    // * 10% chance of a skeleton chief instead
    if (Random(100) > 90)
    {
        sCreature = "NW_SKELCHIEF";
    }
    location lLoc = GetLocation(OBJECT_SELF);
    DelayCommand(0.3, ActionCreate(sCreature, lLoc));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMind, GetLocation(OBJECT_SELF));
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF, 0.5);
   }
}
*/

