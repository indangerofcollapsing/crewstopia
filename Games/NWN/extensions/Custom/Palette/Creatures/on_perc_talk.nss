void main()
{
   object oPerc = GetLastPerceived();
   if (GetIsPC(oPerc) && !GetIsEnemy(oPerc) && !IsInConversation(OBJECT_SELF))
   {
      ActionStartConversation(oPerc);
   }

   ExecuteScript("x2_def_percept", OBJECT_SELF);
}
