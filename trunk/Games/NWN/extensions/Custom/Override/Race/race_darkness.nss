/*
    Racepack Darkness
*/
#include "prc_alterations"

#include "prc_racial_const"
void main()
{
   int nCasterLevel = 0;
   switch (GetRacialType(OBJECT_SELF))
   {
      case RACIAL_TYPE_TIEFLING:
      case RACIAL_TYPE_FEYRI:
         nCasterLevel = GetHitDice(OBJECT_SELF);
         break;
      case RACIAL_TYPE_PURE_YUAN:
      case RACIAL_TYPE_ABOM_YUAN:
      case RACIAL_TYPE_DROW_MALE:
      case RACIAL_TYPE_DROW_FEMALE:
         nCasterLevel = 3;
         break;
      case RACIAL_TYPE_OMAGE:
         nCasterLevel = 9;
         break;
      default:
         nCasterLevel = GetHitDice(OBJECT_SELF);
         break;
   }

   if (nCasterLevel < 1) nCasterLevel = 1;

   DoRacialSLA(SPELL_DARKNESS, nCasterLevel);
}
