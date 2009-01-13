// cs_odt_trapxp
// This script rewards the PC for disarming a door/placeable based on the difficulty of the trap.
//   Take 20 is taken into account thus any trap disarm DC equal to or below 20 is not given XP
// Modified by: 69MEH69
// Modified on: FEB2005

void main()
{
    object oDisarmer = GetLastDisarmed();
    if(oDisarmer == OBJECT_INVALID)
      oDisarmer = GetPCSpeaker();

    object oDoor = OBJECT_SELF;
    string sTrappedTag = GetTag(oDoor);
    int nTrapped = GetLocalInt(oDisarmer, sTrappedTag);
    if(nTrapped == 0)  //Check to see if PC has unlocked this placeable before or uses a key
    {
     SetLocalInt(oDisarmer, sTrappedTag, 1);
     int nTrapXPGain = GetTrapDisarmDC(oDoor);  //Give XP equal to unlock DC
     if(nTrapXPGain > 20) //No XP below take 20
     {
      GiveXPToCreature(oDisarmer, nTrapXPGain); // Give XP (nLockXPGain) to unlocking PC.
      FloatingTextStringOnCreature("XP Gained - use of disable trap skill", oDisarmer, FALSE); //Inform PC of XP for use of skill
     }
    }
}
