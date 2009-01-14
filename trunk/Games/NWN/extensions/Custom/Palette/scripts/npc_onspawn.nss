#include "NW_I0_GENERIC"
// Refer to x2_inc_switches for variables you can set for custom AI.
void main()
{
   // Default PrC script.
   ExecuteScript("prc_npc_spawn", OBJECT_SELF);

   // Speak one-liner, then attack.  Requires a conversation line with
   // nw_d2_gen_combat as the starting conditional script.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_SPECIAL_COMBAT_CONVERSATION"))
   {
      SetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION);
   }

   // Speak one-liner upon perceiving a PC.  Requires a conversation line with
   // nw_d2_gen_check as the starting conditional script.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_SPECIAL_CONVERSATION"))
   {
      SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);
   }

   // Go stealthy.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_STEALTH"))
   {
      SetSpawnInCondition(NW_FLAG_STEALTH);
   }

   // Search.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_SEARCH"))
   {
      SetSpawnInCondition(NW_FLAG_SEARCH);
   }

   // This means that the creature will cast all the buff spells (summons,
   // stat and armor improvements etc) instantaneously in preperation for
   // combat. Note: If TalentAdvancedBuff(40.0) returns TRUE, this flag is
   // automatically disabled.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_FAST_BUFF_ENEMY"))
   {
      SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY);
   }

   // This will cause the NPC to play immobile ambient animations until the NPC
   // sees an enemy or is cleared. These animations will play automatically for
   // encounter creatures.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS"))
   {
      SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
   }

   // This will cause the NPC to play ambient animations until the NPC sees an
   // enemy or is cleared. These animations will play automatically for
   // encounter creatures.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_AMBIENT_ANIMATIONS"))
   {
      SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
   }

   // Causes the NPC to play avian ambient animations.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_AMBIENT_ANIMATIONS_AVIAN"))
   {
      SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN);
   }

   // Causes a spawn in animation to occur when the NPC spawns in.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_APPEAR_SPAWN_IN_ANIMATION"))
   {
      SetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION);
   }

   // Causes the NPC to act appropriately for the time of the day.
   // SetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT) to cause the NPC to sleep
   // at night (40% chance) and walk a set of waypoints during the day.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_DAY_NIGHT_POSTING"))
   {
      SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING);
   }

   // Determines if the NPC sleeps at night. Use in conjuction with
   // SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING) to cause the NPC to sleep
   // at night (40% chance) or walk a set of waypoints during the day.
   if (GetLocalInt(OBJECT_SELF, "NW_FLAG_SLEEPING_AT_NIGHT"))
   {
      SetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT);
   }

   // Custom AI script: X2_SPECIAL_COMBAT_AI_SCRIPT
   // Randomize name: X2_NAME_RANDOM
   // Randomize spell use: X2_SPELL_RANDOM
   // Immune to dispel magic (used for statues): X1_L_IMMUNE_TO_DISPEL
   // Is incorporeal: X2_L_IS_INCORPOREAL
   // Override number of attacks (1-6): X2_L_NUMBER_OF_ATTACKS
   // Magic use in combat (0-100): X2_L_BEH_MAGIC
   // Offensive abilities used (0-100, 0 to flee): X2_L_BEH_OFFENSE
   // Healing others in combat (0-100): X2_L_BEH_COMPASSION

   // Default NWN script
   ExecuteScript("x2_def_spawn", OBJECT_SELF);
}
