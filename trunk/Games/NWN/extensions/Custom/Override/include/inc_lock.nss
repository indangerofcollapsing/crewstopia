void randomLock(object obj);
void randomLockArea();
void onUnlock();

// Variable which determines what percentage of doors/placeables are locked
const string VAR_LOCK_CHANCE = "LOCK_CHANCE";
// Only get XP for unlocking an object once
const string VAR_HAS_BEEN_UNLOCKED = "HAS_BEEN_UNLOCKED";

#include "inc_heartbeat"
#include "inc_persistworld"
#include "inc_variables"
#include "inc_debug_dac"

void randomLock(object obj)
{
   //debugVarObject("randomLock", obj);
   // If a specific key is required, the object is plot-driven so leave it alone
//   if (GetLockKeyRequired(obj)) return;
   // My personal opinion: if it's unlockable, it's relockable.
   SetLockLockable(obj, TRUE);
   // Set unlock difficulty
   int nDC = GetLockUnlockDC(obj);
   // This value is not set to zero by default, so it must have been on purpose
   if (nDC == 0) return;
   // Randomly adjust up or down by 0 to 3
   nDC += Random(7) - 3;
   // Sanity check: value must be between 1 and 250
   nDC = (nDC < 1 ? 1 : nDC);
   nDC = (nDC > 250 ? 250 : nDC);
   SetLockUnlockDC(obj, nDC);
   // It's more difficult to relock than to unlock
   SetLockLockDC(obj, (nDC > 245 ? 250: nDC + 5));
   // Finally, lock the beastie
   SetLocked(obj, TRUE);
}

void randomLockArea()
{
   int nLockChance = getVarInt(OBJECT_SELF, VAR_LOCK_CHANCE);
   //debugVarInt("nLockChance", nLockChance);
   if (nLockChance == NEVER) return;

   object obj = GetFirstObjectInArea();
   while (obj != OBJECT_INVALID)
   {
      nLockChance = getVarInt(obj, VAR_LOCK_CHANCE);
      switch(GetObjectType(obj))
      {
         case OBJECT_TYPE_DOOR:
            //debugVarObject("processing door", obj);
            if (Random(100) < nLockChance)
            {
               randomLock(obj);
            }
            break;
         case OBJECT_TYPE_PLACEABLE:
            //debugVarObject("processing placeable", obj);
            if (Random(100) < nLockChance)
            {
               randomLock(obj);
            }
            break;
      }
      obj = GetNextObjectInArea();
   }
}

void onUnlock()
{
   //debugVarObject("onUnlock()", OBJECT_SELF);
   object oCreature = GetLastUnlocked();
   if (! GetLocalInt(OBJECT_SELF, VAR_HAS_BEEN_UNLOCKED))
   {
      SetLocalInt(OBJECT_SELF, VAR_HAS_BEEN_UNLOCKED, TRUE);
      GiveXPToCreature(oCreature, GetLockUnlockDC(OBJECT_SELF));
   }

   // If it was locked, it will always be relocked.
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   if (fDelay > 0.0)
   {
      DelayCommand(fDelay, ExecuteScript("lock_reset_self", OBJECT_SELF));
   }
}

//void main() {} // testing/compiling purposes

