int IAmHenchman(object oMaster);
void AddMe();
void RemoveMe();
int GetHenchmenCount(object oPC);

int IAmHenchman(object oMaster)
{
   object oHench;
   int ii = 1;
   do
   {
      oHench = GetHenchman(oMaster, ii++);
      if (oHench == OBJECT_SELF) return TRUE;
   } while (oHench != OBJECT_INVALID);
   return FALSE;
}

void AddMe()
{
   AddHenchman(GetPCSpeaker(), OBJECT_SELF);
}

void RemoveMe()
{
   RemoveHenchman(GetPCSpeaker(), OBJECT_SELF);
}

int GetHenchmenCount(object oPC)
{
   int nHenchmen = 0;
   object oHenchman;
   do
   {
      oHenchman = GetHenchman(oPC, nHenchmen);
      if (oHenchman != OBJECT_INVALID) nHenchmen++;
   } while (oHenchman != OBJECT_INVALID);
   return nHenchmen;
}

