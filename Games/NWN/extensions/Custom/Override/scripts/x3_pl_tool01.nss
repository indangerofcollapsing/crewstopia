//::///////////////////////////////////////////////
//:: Player Tool 1 Instant Feat
//:: x3_pl_tool01
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a blank feat script for use with the
    10 Player instant feats provided in NWN v1.69.

    Look up feats.2da, spells.2da and iprp_feats.2da
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

#include "inc_debug_dac"

void main()
{
   debugVarObject("x3_pl_tool01", OBJECT_SELF);

   object oPC = OBJECT_SELF;
   SendMessageToPC(oPC, "Player Tool 01 activated.");
}