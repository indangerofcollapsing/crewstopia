/**
 * Are you sure you really want to speak the true name of a demon?
 */
void main()
{
   object oPC = GetItemActivator();
//   SendMessageToPC(oPC, "Starting dac_book_fwords");
   AssignCommand(oPC, ClearAllActions(TRUE));
   AssignCommand(oPC, ActionStartConversation(OBJECT_SELF,
      "dac_book_fwords", TRUE, FALSE));
}
