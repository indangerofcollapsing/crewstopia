// Event processing for an item
#include "x2_inc_switches"
#include "inc_recallrune"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_recallrune", OBJECT_SELF);

   // Acquire, Unacquire, etc., should not do anything -- only Activate
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   object oPC = GetItemActivator();
   //debugVarObject("oPC", oPC);
   AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "recall_rune", TRUE));
}

