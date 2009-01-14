#include "inc_debug_dac"
void main()
{
   object oPC = GetClickingObject();
   if (oPC == OBJECT_INVALID) oPC = GetLastUsedBy();
   if (oPC == OBJECT_INVALID) oPC = GetItemActivator();
   if (! GetIsPC(oPC)) return;

   ActionStartConversation(oPC);
}

