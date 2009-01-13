// cs_oul_unlockxp
// This script rewards the PC for unlocking a door/placeable based on the difficulty of the lock - not to be used on doors with keys.
//Take 20 is taken into account thus any unlock DC equal to or below 20 is not given XP
// Modified by: 69MEH69
// Modified on: FEB2005

void main()
{
    object oUnlocker = GetLastUnlocked();
    if(oUnlocker == OBJECT_INVALID)
      oUnlocker = GetPCSpeaker();

    object oDoor = OBJECT_SELF;
    string sLockedTag = GetTag(oDoor);
    string sKey = GetLockKeyTag(oDoor);
    int nLocked = GetLocalInt(oUnlocker, sLockedTag);
    if(nLocked == 0 && sKey == "")  //Check to see if PC has unlocked this placeable before or uses a key
    {
     SetLocalInt(oUnlocker, sLockedTag, 1);
     int nLockXPGain = GetLockUnlockDC(oDoor);  //Give XP equal to unlock DC
     if(nLockXPGain > 20) //No XP below take 20
     {
      GiveXPToCreature(oUnlocker, nLockXPGain); // Give XP (nLockXPGain) to unlocking PC.
      FloatingTextStringOnCreature("XP Gained - use of open lock skill", oUnlocker, FALSE); //Inform PC of XP for use of skill
     }
    }
}
