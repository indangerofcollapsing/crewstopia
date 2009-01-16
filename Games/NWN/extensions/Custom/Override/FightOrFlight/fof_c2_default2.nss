// Add to NW_C2_DEFAULT2 as follows:
// After this line,
//            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
// Remove or comment this line,
//            DetermineCombatRound();
// And replace it with this line,
//            ExecuteScript("fof_c2_default2", OBJECT_SELF);

/*
This code has been modified so as to make morale checks
on perception.

This modification was made by Ray Miller on 4/21/2003.
All changes are clearly marked.

Under this modified OnPerception script, creatures whose challenge
ratings are less than half the level of the perceived PC have only
a 5 percent chance of attacking the PC divided by the number of
party members with him.

If the CR of the creature is half or more then the creature has a
base chance of approximately 30 percent of attacking the PC which
increases factorialy (at a factor of 2) as the CR approaches the
PC's level and decreases proportionately for each party member he
has with him.

This script works very well in conjunction with Jeff Peterson's
"Fight or Flight" morale checking system.  It's available here:
(at the time of this writing)

http://nwvault.ign.com/Files/scripts/data/1042055589265.shtml

Email any questions or comments to:
kaynekayne@bigfoot.com

//////////////////////////////////////////////////////////////
A more in depth (and boring) explaination of the math
follows.  Read on at your own risk:

When an NPC perceives an enemy the chance of the NPC
attacking that enemy is figured by the following equation
            (     -----------------------------------------  )
Chance = int(    /(CR + 1) - PCLevel * .5) / (PCLevel * .5)  )
            (  \/                                            )

Where CR = the Challenge Rating of the perceiving creature.

In case my attempt at witty character art isn't clear.  The square
root of the entire equation is to be taken then truncated to the
integer.

The same equation is then applied to each member of the PC's party
in a 15 meter radius of the PC.  The results are cumulative.

If the result of all this is zero then this equation is applied:

Chance = int( 5 / PartyMembers )

Where PartyMembers is the number of the PCs party members within
a 15 meter radius of the PC.
/////////////////////////////////////////////////////////////////
*/

#include "nw_i0_generic"

// Code added by Ray Miller 4/21/2003
int DetermineChanceOfAttack();

void main()
{
   int nChance = DetermineChanceOfAttack();// Code added by Ray Miller 4/21/2003
   if (d100() <= nChance) // Code added by Ray Miller 4/21/2003
   {
      DetermineCombatRound();
   }
}

// Function added by Ray Miller 4/21/2003
int DetermineChanceOfAttack()
{
   object oEnemy = GetLastPerceived();
   float fCR = GetChallengeRating(OBJECT_SELF);
   int iPartyMembers = 1;
   if (fCR < 1.0) fCR = 1.0;
   fCR = fCR + 1.0;
   float fPartyModFactor;
   float fModFactor = sqrt((fCR - (GetHitDice(oEnemy) * 0.5)) /
      (GetHitDice(oEnemy) * 0.5));
   if (fModFactor > 1.0) fModFactor = 1.0;
   if (fModFactor < 0.0) fModFactor = 0.0;
   object oPartyMember = GetFirstFactionMember(oEnemy, TRUE);
   while(GetIsObjectValid(oPartyMember))
   {
      if (oPartyMember != oEnemy &&
          GetDistanceBetween(oEnemy, oPartyMember) < 15.0)
      {
         fPartyModFactor = sqrt((fCR - (GetHitDice(oPartyMember) * 0.5)) /
            (GetHitDice(oPartyMember) * 0.5));
         if(fPartyModFactor > 1.0) fPartyModFactor = 1.0;
         if(fPartyModFactor < 0.0) fPartyModFactor = 0.0;
         fModFactor = fModFactor * fPartyModFactor;
         iPartyMembers++;
      }
      oPartyMember = GetNextFactionMember(oEnemy);
   }
   float fChance = 100.0 * fModFactor;
   if (fChance == 0.0) fChance = 5.0 / IntToFloat(iPartyMembers);
   int iChance = FloatToInt(fChance);
   if (iChance == 0) iChance = 1;
   return iChance;
}

