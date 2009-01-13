/*
Checks a spawned creature to see whether setting a
FIGHT_OR_FLIGHT variable is warranted

010603 Testing shows this works quite well. Dominated
creatures will be tested for in the actual FIGHT_OR_FLIGHT
script.
012703 Had to change the check for undead/construct class to
a check for racial type--Curst have regular PC classes but are
considered undead by race.
*/

#include "inc_fof"

void main()
{
   // Basic restrictions: caller is not undead, construct, or HD > 20
   if (GetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD &&
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT &&
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_OOZE &&  // @DUG
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL &&  // @DUG
      (getCR(OBJECT_SELF) < 21.0)) //fairly arbitrary, but we can work with it
   {
      //Feat-based restrictions: caller has no special fear immunity
      if (!GetHasFeat(FEAT_AURA_OF_COURAGE, OBJECT_SELF) &&
          !GetHasFeat(FEAT_FEARLESS, OBJECT_SELF) &&
          !GetHasFeat(FEAT_RESIST_NATURES_LURE))
      {
         // @DUG: even unintelligent animals know when to run away
         //Is it too stupid to know better? Caller has basic intelligence.
         if (GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) > 2)
         {
            SetLocalInt(OBJECT_SELF, "FIGHT_OR_FLIGHT", 1);
            SetListening(OBJECT_SELF, TRUE);
            SetListenPattern(OBJECT_SELF, "RETREAT_CHECK", 5000);
            SetListenPattern(OBJECT_SELF, "GUARD_ME", 5001);

/* @DUG
            //FOF 011203: Set Green/Seasoned/Veteran by HD
            //Veterans = HD 5+
            if (GetHitDice(OBJECT_SELF) > 4)
            {
               SetLocalFloat(OBJECT_SELF, "fRaw", 5.0);
            }
            //Seasoned = HD 3-4
            if (GetHitDice(OBJECT_SELF) == 3 || GetHitDice(OBJECT_SELF) == 4)
            {
               SetLocalFloat(OBJECT_SELF, "fRaw", 4.0);
            }
            //Green = HD 1-2
            if (GetHitDice(OBJECT_SELF) == 1 || GetHitDice(OBJECT_SELF) == 2)
            {
               SetLocalFloat(OBJECT_SELF, "fRaw", 3.0);
            }
@DUG */
            // @DUG Use naming convention & wisdom instead of hit dice.
            //      This will allow much higher scaling of encounters.
            //      Slave indicates someone forced to fight, with no allegiance
            //            to their "allies" other than fear of punishment
            //      Conscript indicates someone who doesn't really want
            //                to fight, but has some allegiance
            //      Militia indicates a commoner, someone not battle trained
            //      Elite indicates battle hardened shock troops (usually
            //            prestige classes)
            float fRaw = 4.0 + GetLocalFloat(OBJECT_SELF, VAR_COURAGE_MODIFIER);
            string sName = GetName(OBJECT_SELF);
            if (FindSubString(sName, "Slave") != -1) fRaw -= 2.0;
            else if (FindSubString(sName, "Conscript") != -1) fRaw -= 1.5;
            else if (FindSubString(sName, "Militia") != -1) fRaw -= 1.0;
            else if (FindSubString(sName, "Elite") != -1) fRaw += 1.0;
            else
            {
               int nWS = GetAbilityScore(OBJECT_SELF, ABILITY_WISDOM);
               if (nWS < 8) fRaw += 1.0; // stay and fight to the death
               else if (nWS > 13) fRaw -= 1.0; // run away when appropriate
            }

            float fCourage = (fRaw < 0.001 ? 0.001 : fRaw);
            SetLocalFloat(OBJECT_SELF, VAR_COURAGE_MODIFIER, fRaw);
         }
      }
   }
}
