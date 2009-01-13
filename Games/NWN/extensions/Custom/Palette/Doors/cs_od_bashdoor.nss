//cs_od_bashdoor
//Forces door open during bash based on Fortitude save of door
//If d20 + damage dealt is greater than Fortitude save of door then door
//   will open.
//If door is trapped attacking it with a ranged weapon will disable the trap
//   based on the DC of trap
//Created by: 69MEH69 FEB2005

void main()
{
  object oPC = GetLastDamager();
  object oWeapon = GetLastWeaponUsed(oPC);
  int nFort = GetFortitudeSavingThrow(OBJECT_SELF);
  int nDamage = GetTotalDamageDealt();
  int nRoll = d20(1) + nDamage;
  int nTrapDC;
  string sRoll = IntToString(nRoll);
  string sName = GetStringLowerCase(GetName(OBJECT_SELF));
  //Do check for ranged weapon and if door is trapped
  if(GetWeaponRanged(oWeapon))
  {
   if(GetIsTrapped(OBJECT_SELF) && GetTrapDetectedBy(OBJECT_SELF, oPC))
   {
    nTrapDC = GetTrapDisarmDC(OBJECT_SELF)/2;
    if(nRoll >= nTrapDC) //Disable trap
    {
      SetTrapDisabled(OBJECT_SELF);
      FloatingTextStringOnCreature("The trap has been disabled", oPC);
    }
   }
   else  //Cannot bash door with ranged weapon
   {
    FloatingTextStringOnCreature("Ranged weapons are not effective in forcing open this " +sName, oPC);
   }
  }
  else  //Melee weapon bash to open door
  {
   if(nRoll > nFort)  //Bash Door
   {
    DoDoorAction(OBJECT_SELF, DOOR_ACTION_UNLOCK);
    ActionOpenDoor(OBJECT_SELF);
    FloatingTextStringOnCreature("You successfully forced this " +sName+ " open", oPC);
   }
  }
  //TEST - Check for d20 roll + damage
  //SendMessageToPC(oPC, "Roll = " + sRoll);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), OBJECT_SELF);
  //TEST - Check for door healing
  //int nHP = GetCurrentHitPoints();
  //string sHP = IntToString(nHP);
  //SendMessageToPC(oPC, "Door has " +sHP+ " HP");
}
