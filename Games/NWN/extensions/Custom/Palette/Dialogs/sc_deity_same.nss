int StartingConditional()
{
   string sMyDeity = GetDeity(OBJECT_SELF);
   string sPCDeity = GetDeity(GetPCSpeaker());

   if (sMyDeity == "") return FALSE;

   return (sMyDeity == sPCDeity);
}
