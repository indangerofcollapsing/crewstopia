// Trap Tool On-Used event
#include "inc_debug_dac"
#include "x2_inc_switches"
#include "inc_trap"
void main()
{
   //debugVarObject("dac_thieftool", OBJECT_SELF);

   // Only Cast Spell Unique Power Self Only should fire
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   object oTarget = GetItemActivatedTarget();
   //debugVarObject("oTarget", oTarget);
   object oUser = GetItemActivator();
   //debugVarObject("oUser", oUser);
   object oItem = GetItemActivated();
   //debugVarObject("oItem", oItem);

   if (oTarget == OBJECT_INVALID)
   {
      SendMessageToPC(oUser, "You must use this on an object.");
      return;
   }

   if (!GetTrapDetectable(oTarget) || !GetIsTrapped(oTarget))
   {
      SendMessageToPC(oUser, "The " + GetName(oTarget) +
         " appears not to be trapped.");
      return;
   }

   int nDisarmBonus = GetLocalInt(oItem, "DISARM_TRAP_BONUS");
   //debugVarInt("nDisarmBonus", nDisarmBonus);

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
      EffectSkillIncrease(SKILL_DISABLE_TRAP, nDisarmBonus), oUser, 7.0f);
   AssignCommand(oUser, ActionUseSkill(SKILL_DISABLE_TRAP, oTarget, 0, oItem));

   DestroyObject(oItem);
}
