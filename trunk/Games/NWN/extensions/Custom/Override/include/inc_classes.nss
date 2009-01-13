int getLevel(object oPC);

int getLevel(object oPC)
{
   return GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
      GetLevelByPosition(3, oPC);
}

//void main() {} // testing/compiling purposes

