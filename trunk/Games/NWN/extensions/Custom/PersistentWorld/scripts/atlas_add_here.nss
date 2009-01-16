#include "inc_money"
#include "inc_atlas"
void main()
{
   object oPC = GetPCSpeaker();
   object oGem = getMostExpensiveGem(oPC);

   if (oGem == OBJECT_INVALID)
   {
      FloatingTextStringOnCreature("Liar!", OBJECT_SELF);
      AdjustReputation(oPC, OBJECT_SELF, -100);
   }
   else
   {
      FloatingTextStringOnCreature("Oooh, pretty!", OBJECT_SELF);
      CopyObject(oGem, GetLocation(OBJECT_SELF), OBJECT_SELF);
      // @FIX: If the gem chosen is stacked with more than one gem, she will
      //       take all of them.  There does not seem to be a SetNumStackedItems()
      //       so at this point it seems the pixie is just greedy.  Deal with it.
      DestroyObject(oGem);
      string sArea = GetTag(GetArea(OBJECT_SELF));
      addMap(oPC, sArea);
//      ExploreAreaForPlayer(GetArea(OBJECT_SELF), oPC);
   }
}

