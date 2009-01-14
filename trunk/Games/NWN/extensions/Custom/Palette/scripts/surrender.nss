void main()
{
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
      OBJECT_SELF, 1, CREATURE_TYPE_IS_ALIVE, TRUE, CREATURE_TYPE_REPUTATION,
      REPUTATION_TYPE_ENEMY);
   SurrenderToEnemies();
   ActionStartConversation(oPC, "surrender");
}
