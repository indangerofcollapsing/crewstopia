// Sets custom token 2112 to the speaker's deity
int StartingConditional()
{
   SetCustomToken(2112, GetDeity(OBJECT_SELF));
   return TRUE;
}

