#include "inc_faction"
#include "NW_I0_GENERIC"
#include "inc_equip"
#include "inc_debug_dac"

void main()
{
   //debugVarObject("dac_on_spawn", OBJECT_SELF);

   if (GetIsPC(OBJECT_SELF) || GetIsDM(OBJECT_SELF)) return;
   // Set factions and behavior
   string sFaction = getFaction(OBJECT_SELF);
/*
   if (sFaction == FACTION_COMMONER ||
       sFaction == FACTION_HOSTILE ||
       sFaction == FACTION_DEFENDER
      )
   {
      string sResRef = GetResRef(OBJECT_SELF);
      switch(GetRacialType(OBJECT_SELF))
      {
         case RACIAL_TYPE_ABERRATION:
            if (FindSubString(sResRef, "drider") != -1)
            {
               setFaction(OBJECT_SELF, FACTION_DROW);
            }
            if (FindSubString(sResRef, "illithid") != -1 ||
                FindSubString(sResRef, "flayer") != -1
               )
            {
               setFaction(OBJECT_SELF, FACTION_ILLITHID);
            }
            break;
         case RACIAL_TYPE_ANIMAL:
         case RACIAL_TYPE_BEAST:
         case RACIAL_TYPE_VERMIN:
            if (sFaction == FACTION_COMMONER)
            {
               setFaction(OBJECT_SELF, FACTION_PREY);
               SetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL);
               // Creature will flee those that close within 7m if they are not
               // friends, Rangers or Druids.
               SetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE);
               SetLocalInt(OBJECT_SELF, "X0_COMBAT_FLAG_COWARDLY", 1);
            }
            else if (sFaction == FACTION_HOSTILE)
            {
               setFaction(OBJECT_SELF, FACTION_PREDATOR);
               SetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL);
               // Creature will only attack those that close within 5m and are
               // not friends, Rangers or Druids.
               SetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE);
            }
            break;
         case RACIAL_TYPE_DRAGON:
            switch(GetAlignmentGoodEvil(OBJECT_SELF))
            {
               case ALIGNMENT_GOOD:
                  setFaction(OBJECT_SELF, FACTION_DRAGON_GOOD);
                  break;
               case ALIGNMENT_EVIL:
                  setFaction(OBJECT_SELF, FACTION_DRAGON_EVIL);
                  break;
               default:
                  break;
            }
            break;
         case RACIAL_TYPE_FEY:
            setFaction(OBJECT_SELF, FACTION_FEY);
            SetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL);
            // Creature will only attack those that close within 5m and are
            // not friends, Rangers or Druids.
            SetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE);
            break;
         case RACIAL_TYPE_DWARF:
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
               setFaction(OBJECT_SELF, FACTION_DWARVES);
            }
            break;
         case RACIAL_TYPE_ELF:
         case RACIAL_TYPE_HALFELF:
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
               setFaction(OBJECT_SELF, FACTION_ELVES);
            }
            break;
         case RACIAL_TYPE_GNOME:
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
               setFaction(OBJECT_SELF, FACTION_GNOMES);
            }
            break;
         case RACIAL_TYPE_HALFLING:
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
               setFaction(OBJECT_SELF, FACTION_HALFLINGS);
            }
            break;
         case RACIAL_TYPE_HALFORC:
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
               setFaction(OBJECT_SELF, FACTION_HUMANOIDS);
            }
            break;
         case RACIAL_TYPE_OUTSIDER:
            switch(GetAlignmentLawChaos(OBJECT_SELF))
            {
               case ALIGNMENT_CHAOTIC:
                  setFaction(OBJECT_SELF, FACTION_TANARRI);
                  break;
               case ALIGNMENT_LAWFUL:
                  setFaction(OBJECT_SELF, FACTION_BAATEZU);
                  break;
               default:
                  break;
            }
            break;
         default:
            break;
      }
   } // if standard faction
*/
   if (sFaction != FACTION_COMMONER) spawnItemsFor(OBJECT_SELF);
}
