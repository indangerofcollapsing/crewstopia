#include "inc_ropebridge"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_hb_ropebrdg", OBJECT_SELF);
   int nNPCRadius = getRopeBridgeNPCUseRadius(OBJECT_SELF);
   if (nNPCRadius <= 0) return;

   location lSelf = GetLocation(OBJECT_SELF);
   object oCreature = GetFirstObjectInShape(SHAPE_CUBE, 1.0f * nNPCRadius, lSelf);
   while (oCreature != OBJECT_INVALID)
   {
      //debugVarObject("near the rope bridge", oCreature);
      if (GetIsPC(oCreature) == FALSE &&
          GetIsDead(oCreature) == FALSE &&
          GetIsInCombat(oCreature) == FALSE &&
          GetLocalInt(oCreature, VAR_ROPE_BRIDGE_USED_RECENTLY) == FALSE &&
          ! GetIsPC(GetMaster(oCreature))
         )
      {
         //debugVarObject("using the rope bridge", oCreature);
         SetLocalInt(oCreature, VAR_ROPE_BRIDGE_USED_RECENTLY, TRUE);
         object oBridge = OBJECT_SELF;
         AssignCommand(oCreature, ActionMoveToObject(oBridge));
         AssignCommand(oCreature, ActionUseRopeBridge(oCreature, oBridge));
         DelayCommand(30.0f, ActionResetRopeBridgeUsed(oCreature));
      }
      oCreature = GetNextObjectInShape(SHAPE_CUBE, 1.0f * nNPCRadius, lSelf);
   }
}
