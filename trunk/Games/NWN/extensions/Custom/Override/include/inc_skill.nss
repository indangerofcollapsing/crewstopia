///// Scalable skill difficulty checks
int skillDCVeryEasy(object oPC);
int skillDCEasy(object oPC);
int skillDCNormal(object oPC);
int skillDCHard(object oPC);
int skillDCVeryHard(object oPC);
int skillDCImpossible(object oPC);

int getLevel(object oPC);

#include "inc_debug_dac"
#include "inc_fof"

// A minimal investment of skill points will succeed most of the time
int skillDCVeryEasy(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) / 16 / 2 +  // relevant stat increased every 16th level
      getLevel(oPC) / 4; // 1 skill point invested per 4 levels
   //debugVarInt("very easy nDC", nDC);
   return nDC;
}

// A smattering of skill points invested will succeed most of the time
int skillDCEasy(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) / 8 / 2 +  // relevant stat increased every 8th level
      getLevel(oPC) / 3; // 1 skill point invested per 3 levels
   //debugVarInt("easy nDC", nDC);
   return nDC;
}

// A cross-class skill, maxxed out, will succeed most of the time
int skillDCNormal(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) / 4 / 2 +  // relevant stat increased every 4th level
      getLevel(oPC) / 2; // 1 skill point invested per 2 levels
   //debugVarInt("normal nDC", nDC);
   return nDC;
}

// A class skill with points invested most levelups will succeed generally
int skillDCHard(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) / 2 / 2 +  // relevant stat increased every 2nd level
      getLevel(oPC) * 2 / 3; // 2 skill points invested per 3 levels
   //debugVarInt("hard nDC", nDC);
   return nDC;
}

// A class skill, maxxed out, will succeed most of the time
int skillDCVeryHard(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) / 1 / 2 +  // relevant stat increased every level
      getLevel(oPC); // 1 skill point invested per level
   //debugVarInt("very hard nDC", nDC);
   return nDC;
}

// Class skill, maxxed out, plus chosen skill feats, needed to succeed
int skillDCImpossible(object oPC)
{
   int nDC = 10 + // average die roll
      getLevel(oPC) * 5 / 4 / 2 +  // relevant stat increased every level, plus GREAT_XXX feats chosen
      getLevel(oPC) * 5 / 4; // 1 skill point invested per level, plus Skill Focus XXX feats
   //debugVarInt("impossible nDC", nDC);
   return nDC;
}

int getLevel(object oPC)
{
   return FloatToInt(getCR(oPC));
}

//void main() {} // testing/compiling purposes
