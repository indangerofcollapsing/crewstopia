void takeGoldPerLevel(int nGPPerLevel);
object getMostExpensiveGem(object oPC);

void takeGoldPerLevel(int nGPPerLevel)
{
   object oPC = GetPCSpeaker();
   int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
      GetLevelByPosition(3, oPC);
   TakeGoldFromCreature(nLevel * nGPPerLevel, oPC, TRUE);
}

object getMostExpensiveGem(object oPC)
{
   object oGem = OBJECT_INVALID;
   int nValue = 0;
   object obj = GetFirstItemInInventory(oPC);
   while (obj != OBJECT_INVALID)
   {
      if (GetBaseItemType(obj) == BASE_ITEM_GEM)
      {
         if (GetGoldPieceValue(obj) > nValue)
         {
            nValue = GetGoldPieceValue(obj);
            oGem = obj;
         }
      }
      obj = GetNextItemInInventory(oPC);
   }

   return oGem;
}

//void main() {} // testing/compiling purposes

