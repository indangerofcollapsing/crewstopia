int amISiblingTo(object oCreature);
int amICousinTo(object oCreature);
int getPerceivedAppearance(int nAppearanceType);

//void main() {} // testing/compiling purposes

#include "zep_inc_monster"

int amISiblingTo(object oCreature)
{
   int nMyAppearance = GetAppearanceType(OBJECT_SELF);
   int nHisAppearance = GetAppearanceType(oCreature);
   return (nMyAppearance == nHisAppearance);
}

int amICousinTo(object oCreature)
{
   int nMyAppearance = GetAppearanceType(OBJECT_SELF);
   int nHisAppearance = GetAppearanceType(oCreature);
   return (getPerceivedAppearance(nMyAppearance) ==
      getPerceivedAppearance(nHisAppearance));
}

/**
 * Normalize the various appearances so that "cousins" can
 * recognise each other as such.
 */
int getPerceivedAppearance(int nAppearanceType)
{
   switch(nAppearanceType)
   {
      // human
      case APPEARANCE_TYPE_BARTENDER:
      case APPEARANCE_TYPE_BEGGER:
      case APPEARANCE_TYPE_BLOOD_SAILER:
      case APPEARANCE_TYPE_CONVICT:
      case APPEARANCE_TYPE_CULT_MEMBER:
      case APPEARANCE_TYPE_FEMALE_01:
      case APPEARANCE_TYPE_FEMALE_02:
      case APPEARANCE_TYPE_FEMALE_03:
      case APPEARANCE_TYPE_FEMALE_04:
      case APPEARANCE_TYPE_HOUSE_GUARD:
      case APPEARANCE_TYPE_HUMAN:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_04:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_05:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_06:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_07:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_08:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_09:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_10:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_11:
      case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_01:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_02:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_03:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_04:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_05:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_06:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_07:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_08:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_09:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_10:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_11:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_12:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_13:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_14:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_15:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_16:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_17:
      case APPEARANCE_TYPE_HUMAN_NPC_MALE_18:
      case APPEARANCE_TYPE_INN_KEEPER:
      case APPEARANCE_TYPE_KID_FEMALE:
      case APPEARANCE_TYPE_KID_MALE:
      case APPEARANCE_TYPE_LUSKAN_GUARD:
      case APPEARANCE_TYPE_MALE_01:
      case APPEARANCE_TYPE_MALE_02:
      case APPEARANCE_TYPE_MALE_03:
      case APPEARANCE_TYPE_MALE_04:
      case APPEARANCE_TYPE_MALE_05:
      case APPEARANCE_TYPE_NW_MILITIA_MEMBER:
      case APPEARANCE_TYPE_NWN_AARIN:
      case APPEARANCE_TYPE_NWN_NASHER:
      case APPEARANCE_TYPE_NWN_SEDOS:
      case APPEARANCE_TYPE_OLD_MAN:
      case APPEARANCE_TYPE_OLD_WOMAN:
      case APPEARANCE_TYPE_PLAGUE_VICTIM:
      case APPEARANCE_TYPE_PROSTITUTE_01:
      case APPEARANCE_TYPE_PROSTITUTE_02:
      case APPEARANCE_TYPE_SHOP_KEEPER:
      case APPEARANCE_TYPE_WAITRESS:
      case APPEARANCE_TYPE_ZEP_CHILD_FEMALE_1:
      case APPEARANCE_TYPE_ZEP_CHILD_FEMALE_2:
      case APPEARANCE_TYPE_ZEP_CHILD_FEMALE_3:
      case APPEARANCE_TYPE_ZEP_CHILD_FEMALE_4:
      case APPEARANCE_TYPE_ZEP_CHILD_FEMALE_5:
      case APPEARANCE_TYPE_ZEP_CHILD_MALE_1:
      case APPEARANCE_TYPE_ZEP_CHILD_MALE_2:
      case APPEARANCE_TYPE_ZEP_CHILD_MALE_3:
      case APPEARANCE_TYPE_ZEP_CHILD_MALE_4:
      case APPEARANCE_TYPE_ZEP_CHILD_MALE_5:
      case APPEARANCE_TYPE_ZEP_HUMAN_CLERIC_OF_TYR:
      case APPEARANCE_TYPE_ZEP_HUMAN_NPC_KING:
         return APPEARANCE_TYPE_HUMAN;
         break;
      // elf
      case APPEARANCE_TYPE_ARIBETH:
      case APPEARANCE_TYPE_ELF:
      case APPEARANCE_TYPE_ELF_NPC_FEMALE:
      case APPEARANCE_TYPE_ELF_NPC_MALE_01:
      case APPEARANCE_TYPE_ELF_NPC_MALE_02:
      case APPEARANCE_TYPE_NWN_ARIBETH_EVIL:
         return APPEARANCE_TYPE_ELF;
         break;
      // asabi
      case APPEARANCE_TYPE_ASABI_CHIEFTAIN:
      case APPEARANCE_TYPE_ASABI_SHAMAN:
      case APPEARANCE_TYPE_ASABI_WARRIOR:
         return APPEARANCE_TYPE_ASABI_WARRIOR;
         break;
      // beholder
      case APPEARANCE_TYPE_BEHOLDER:
      case APPEARANCE_TYPE_BEHOLDER_EYEBALL:
      case APPEARANCE_TYPE_BEHOLDER_MAGE:
      case APPEARANCE_TYPE_BEHOLDER_MOTHER:
      case APPEARANCE_TYPE_ZEP_BEHOLDER_B:
      case APPEARANCE_TYPE_ZEP_FLYING_EYE:
         return APPEARANCE_TYPE_BEHOLDER;
         break;
      // bugbears
      case APPEARANCE_TYPE_BUGBEAR_A:
      case APPEARANCE_TYPE_BUGBEAR_B:
      case APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_A:
      case APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_B:
      case APPEARANCE_TYPE_BUGBEAR_SHAMAN_A:
      case APPEARANCE_TYPE_BUGBEAR_SHAMAN_B:
      case APPEARANCE_TYPE_ZEP_BUGBEAR_ARCTIC:
      case APPEARANCE_TYPE_ZEP_BUGBEAR_ARCTIC_CHIEF:
      case APPEARANCE_TYPE_ZEP_BUGBEAR_ARCTIC_SHAMAN:
         return APPEARANCE_TYPE_BUGBEAR_A;
         break;
      // evil dragon
      case APPEARANCE_TYPE_DRAGON_BLACK:
      case APPEARANCE_TYPE_DRAGON_BLUE:
      case APPEARANCE_TYPE_DRAGON_GREEN:
      case APPEARANCE_TYPE_DRAGON_PRIS:
      case APPEARANCE_TYPE_DRAGON_RED:
      case APPEARANCE_TYPE_DRAGON_SHADOW:
      case APPEARANCE_TYPE_DRAGON_WHITE:
      case APPEARANCE_TYPE_WYRMLING_BLACK:
      case APPEARANCE_TYPE_WYRMLING_BLUE:
      case APPEARANCE_TYPE_WYRMLING_GREEN:
      case APPEARANCE_TYPE_WYRMLING_RED:
      case APPEARANCE_TYPE_WYRMLING_WHITE:
         return APPEARANCE_TYPE_DRAGON_BLACK;
         break;
      // good dragon
      case APPEARANCE_TYPE_DRAGON_BRASS:
      case APPEARANCE_TYPE_DRAGON_BRONZE:
      case APPEARANCE_TYPE_DRAGON_COPPER:
      case APPEARANCE_TYPE_DRAGON_GOLD:
      case APPEARANCE_TYPE_DRAGON_SILVER:
      case APPEARANCE_TYPE_WYRMLING_BRASS:
      case APPEARANCE_TYPE_WYRMLING_BRONZE:
      case APPEARANCE_TYPE_WYRMLING_COPPER:
      case APPEARANCE_TYPE_WYRMLING_GOLD:
      case APPEARANCE_TYPE_WYRMLING_SILVER:
         return APPEARANCE_TYPE_DRAGON_BRASS;
         break;
      // drow
      case APPEARANCE_TYPE_DRIDER:
      case APPEARANCE_TYPE_DRIDER_CHIEF:
      case APPEARANCE_TYPE_DRIDER_FEMALE:
      case APPEARANCE_TYPE_DROW_CLERIC:
      case APPEARANCE_TYPE_DROW_FEMALE_1:
      case APPEARANCE_TYPE_DROW_FEMALE_2:
      case APPEARANCE_TYPE_DROW_FIGHTER:
      case APPEARANCE_TYPE_DROW_MATRON:
      case APPEARANCE_TYPE_DROW_SLAVE:
      case APPEARANCE_TYPE_DROW_WARRIOR_1:
      case APPEARANCE_TYPE_DROW_WARRIOR_2:
      case APPEARANCE_TYPE_DROW_WARRIOR_3:
      case APPEARANCE_TYPE_DROW_WIZARD:
      case APPEARANCE_TYPE_ZEP_DRIDER_ARMOR_A:
      case APPEARANCE_TYPE_ZEP_DRIDER_ARMOR_B:
      case APPEARANCE_TYPE_ZEP_DRIDER_ARMOR_C:
      case APPEARANCE_TYPE_ZEP_DRIDER_FEMALE_A:
      case APPEARANCE_TYPE_ZEP_DRIDER_FEMALE_B:
      case APPEARANCE_TYPE_ZEP_DRIDER_FEMALE_C:
      case APPEARANCE_TYPE_ZEP_DRIDER_FEMALE_D:
      case APPEARANCE_TYPE_ZEP_DRIDER_MALE_A:
      case APPEARANCE_TYPE_ZEP_DRIDER_MALE_B:
      case APPEARANCE_TYPE_ZEP_DRIDER_MALE_C:
      case APPEARANCE_TYPE_ZEP_DRIDER_MALE_D:
      case APPEARANCE_TYPE_ZEP_DRIDER_MALE_E:
         return APPEARANCE_TYPE_DROW_FIGHTER;
         break;
      // duergar
      case APPEARANCE_TYPE_DRUEGAR_CLERIC:
      case APPEARANCE_TYPE_DRUEGAR_FIGHTER:
      case APPEARANCE_TYPE_DUERGAR_CHIEF:
      case APPEARANCE_TYPE_DUERGAR_SLAVE:
         return APPEARANCE_TYPE_DRUEGAR_FIGHTER;
         break;
      // dwarf
      case APPEARANCE_TYPE_DWARF:
      case APPEARANCE_TYPE_DWARF_NPC_FEMALE:
      case APPEARANCE_TYPE_DWARF_NPC_MALE:
         return APPEARANCE_TYPE_DWARF;
         break;
      // formian
      case APPEARANCE_TYPE_FORMIAN_MYRMARCH:
      case APPEARANCE_TYPE_FORMIAN_QUEEN:
      case APPEARANCE_TYPE_FORMIAN_WARRIOR:
      case APPEARANCE_TYPE_FORMIAN_WORKER:
         return APPEARANCE_TYPE_FORMIAN_WORKER;
         break;
      // ghoul/ghast
      case APPEARANCE_TYPE_GHAST:
      case APPEARANCE_TYPE_GHOUL:
      case APPEARANCE_TYPE_GHOUL_LORD:
      case APPEARANCE_TYPE_ZEP_GHOUL_ICE:
         return APPEARANCE_TYPE_GHOUL;
         break;
      // fire giant
      case APPEARANCE_TYPE_GIANT_FIRE:
      case APPEARANCE_TYPE_GIANT_FIRE_FEMALE:
         return APPEARANCE_TYPE_GIANT_FIRE;
         break;
      // frost giant
      case APPEARANCE_TYPE_GIANT_FROST:
      case APPEARANCE_TYPE_GIANT_FROST_FEMALE:
         return APPEARANCE_TYPE_GIANT_FROST;
         break;
      // I deem mountain and hill giants, and cyclops to be cousins
      case APPEARANCE_TYPE_GIANT_HILL:
      case APPEARANCE_TYPE_GIANT_MOUNTAIN:
      case APPEARANCE_TYPE_ZEP_CYCLOPS:
         return APPEARANCE_TYPE_GIANT_HILL;
         break;
      // gnoll
      case APPEARANCE_TYPE_GNOLL_WARRIOR:
      case APPEARANCE_TYPE_GNOLL_WIZ:
         return APPEARANCE_TYPE_GNOLL_WARRIOR;
         break;
      // gnome
      case APPEARANCE_TYPE_GNOME:
      case APPEARANCE_TYPE_GNOME_NPC_FEMALE:
      case APPEARANCE_TYPE_GNOME_NPC_MALE:
         return APPEARANCE_TYPE_GNOME;
         break;
      // goblin
      case APPEARANCE_TYPE_GOBLIN_A:
      case APPEARANCE_TYPE_GOBLIN_B:
      case APPEARANCE_TYPE_GOBLIN_CHIEF_A:
      case APPEARANCE_TYPE_GOBLIN_CHIEF_B:
      case APPEARANCE_TYPE_GOBLIN_SHAMAN_A:
      case APPEARANCE_TYPE_GOBLIN_SHAMAN_B:
      case APPEARANCE_TYPE_ZEP_GOBLIN_BONE_WIZARD:
      case APPEARANCE_TYPE_ZEP_GOBLIN_CAVE:
      case APPEARANCE_TYPE_ZEP_GOBLIN_CAVE_ARCHER:
      case APPEARANCE_TYPE_ZEP_GOBLIN_CAVE_BERKSERK:
      case APPEARANCE_TYPE_ZEP_GOBLIN_CAVE_SHAMAN:
      case APPEARANCE_TYPE_ZEP_GOBLIN_FROST:
      case APPEARANCE_TYPE_ZEP_GOBLIN_FROST_CHIEF:
      case APPEARANCE_TYPE_ZEP_GOBLIN_FROST_SHAMAN:
      case APPEARANCE_TYPE_ZEP_GOBLIN_SPIDER_RIDER:
      case APPEARANCE_TYPE_ZEP_GOBLIN_WORG_RIDER:
      case APPEARANCE_TYPE_ZEP_GOBLIN_WORG_RIDER_G:
      case APPEARANCE_TYPE_ZEP_GOBLIN_WORG_RIDER_W:
         return APPEARANCE_TYPE_GOBLIN_A;
         break;
      // half-elf
      case APPEARANCE_TYPE_HALF_ELF:
         return APPEARANCE_TYPE_HALF_ELF;
         break;
      // half-orc
      case APPEARANCE_TYPE_HALF_ORC:
      case APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE:
      case APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01:
      case APPEARANCE_TYPE_HALF_ORC_NPC_MALE_02:
      case APPEARANCE_TYPE_UTHGARD_ELK_TRIBE:
      case APPEARANCE_TYPE_UTHGARD_TIGER_TRIBE:
         return APPEARANCE_TYPE_HALF_ORC;
         break;
      // halfling
      case APPEARANCE_TYPE_HALFLING:
      case APPEARANCE_TYPE_HALFLING_NPC_FEMALE:
      case APPEARANCE_TYPE_HALFLING_NPC_MALE:
         return APPEARANCE_TYPE_HALFLING;
         break;
      // hobgoblin
      case APPEARANCE_TYPE_HOBGOBLIN_WARRIOR:
      case APPEARANCE_TYPE_HOBGOBLIN_WIZARD:
         return APPEARANCE_TYPE_HOBGOBLIN_WARRIOR;
          break;
      // kobold
      case APPEARANCE_TYPE_KOBOLD_A:
      case APPEARANCE_TYPE_KOBOLD_B:
      case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
      case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
      case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
      case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:
      case APPEARANCE_TYPE_ZEP_KOBOLD_ICE:
      case APPEARANCE_TYPE_ZEP_KOBOLD_ICE_NOBLE:
      case APPEARANCE_TYPE_ZEP_KOBOLD_ICE_WIZARD:
         return APPEARANCE_TYPE_KOBOLD_A;
         break;
      // lizardfolk
      case APPEARANCE_TYPE_LIZARDFOLK_A:
      case APPEARANCE_TYPE_LIZARDFOLK_B:
      case APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_A:
      case APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_B:
      case APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_A:
      case APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_B:
         return APPEARANCE_TYPE_LIZARDFOLK_A;
         break;
      // mephits
      case APPEARANCE_TYPE_MEPHIT_AIR:
      case APPEARANCE_TYPE_MEPHIT_DUST:
      case APPEARANCE_TYPE_MEPHIT_EARTH:
      case APPEARANCE_TYPE_MEPHIT_FIRE:
      case APPEARANCE_TYPE_MEPHIT_ICE:
      case APPEARANCE_TYPE_MEPHIT_MAGMA:
      case APPEARANCE_TYPE_MEPHIT_OOZE:
      case APPEARANCE_TYPE_MEPHIT_SALT:
      case APPEARANCE_TYPE_MEPHIT_STEAM:
      case APPEARANCE_TYPE_MEPHIT_WATER:
         return APPEARANCE_TYPE_MEPHIT_AIR;
         break;
      // illithids
      case APPEARANCE_TYPE_MINDFLAYER:
      case APPEARANCE_TYPE_MINDFLAYER_2:
      case APPEARANCE_TYPE_MINDFLAYER_ALHOON:
      case APPEARANCE_TYPE_ZEP_ILLITHID:
      case APPEARANCE_TYPE_ZEP_ILLITHID_3E:
      case APPEARANCE_TYPE_ZEP_ILLITHID_BIOLOGIST:
      case APPEARANCE_TYPE_ZEP_ILLITHID_BIOLOGIST_2:
      case APPEARANCE_TYPE_ZEP_ILLITHID_KID:
      case APPEARANCE_TYPE_ZEP_ILLITHID_MURRAY:
      case APPEARANCE_TYPE_ZEP_ILLITHID_SCIENTIST:
         return APPEARANCE_TYPE_MINDFLAYER;
         break;
      // minotaur
      case APPEARANCE_TYPE_MINOGON:
      case APPEARANCE_TYPE_MINOTAUR:
      case APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN:
      case APPEARANCE_TYPE_MINOTAUR_SHAMAN:
         return APPEARANCE_TYPE_MINOTAUR;
         break;
      // mummy
      case APPEARANCE_TYPE_MUMMY_COMMON:
      case APPEARANCE_TYPE_MUMMY_FIGHTER_2:
      case APPEARANCE_TYPE_MUMMY_GREATER:
      case APPEARANCE_TYPE_MUMMY_WARRIOR:
         return APPEARANCE_TYPE_MUMMY_COMMON;
         break;
      // ogre
      case APPEARANCE_TYPE_OGRE:
      case APPEARANCE_TYPE_OGRE_CHIEFTAIN:
      case APPEARANCE_TYPE_OGRE_CHIEFTAINB:
      case APPEARANCE_TYPE_OGRE_MAGE:
      case APPEARANCE_TYPE_OGRE_MAGEB:
      case APPEARANCE_TYPE_OGREB:
      case APPEARANCE_TYPE_ZEP_OGRILLION_DULL_1:
      case APPEARANCE_TYPE_ZEP_OGRILLION_DULL_2:
      case APPEARANCE_TYPE_ZEP_OGRILLION_TAN_1:
      case APPEARANCE_TYPE_ZEP_OGRILLION_TAN_2:
         return APPEARANCE_TYPE_OGRE;
         break;
      // orc
      case APPEARANCE_TYPE_ORC_A:
      case APPEARANCE_TYPE_ORC_B:
      case APPEARANCE_TYPE_ORC_CHIEFTAIN_A:
      case APPEARANCE_TYPE_ORC_CHIEFTAIN_B:
      case APPEARANCE_TYPE_ORC_SHAMAN_A:
      case APPEARANCE_TYPE_ORC_SHAMAN_B:
      case APPEARANCE_TYPE_ZEP_ORC_BLOODGUAR:
      case APPEARANCE_TYPE_ZEP_ORC_D:
      case APPEARANCE_TYPE_ZEP_ORC_E:
      case APPEARANCE_TYPE_ZEP_ORC_F:
      case APPEARANCE_TYPE_ZEP_ORC_FAERUN:
      case APPEARANCE_TYPE_ZEP_ORC_FAERUN_CHIEF:
      case APPEARANCE_TYPE_ZEP_ORC_MERCENARY:
      case APPEARANCE_TYPE_ZEP_ORC_SNOW:
      case APPEARANCE_TYPE_ZEP_ORC_SNOW_CHIEFTAN:
      case APPEARANCE_TYPE_ZEP_ORC_SNOW_SHAMAN:
      case APPEARANCE_TYPE_ZEP_ORC_URAK_CAPTAIN:
      case APPEARANCE_TYPE_ZEP_ORC_URAK_HAI_A:
      case APPEARANCE_TYPE_ZEP_ORC_URAK_HAI_B:
      case APPEARANCE_TYPE_ZEP_ORC_URAK_HAI_C:
      case APPEARANCE_TYPE_ZEP_ORC_URAK_WORG_TRAINER:
         return APPEARANCE_TYPE_ORC_A;
         break;
      // rakshasa
      case APPEARANCE_TYPE_RAKSHASA_BEAR_MALE:
      case APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE:
      case APPEARANCE_TYPE_RAKSHASA_TIGER_MALE:
      case APPEARANCE_TYPE_RAKSHASA_WOLF_MALE:
      case APPEARANCE_TYPE_ZEP_RAKSHASA_BEAR_FEMALE:
      case APPEARANCE_TYPE_ZEP_RAKSHASA_WOLF_FEMALE:
         return APPEARANCE_TYPE_RAKSHASA_TIGER_MALE;
         break;
      // slaadi
      case APPEARANCE_TYPE_SLAAD_BLACK:
      case APPEARANCE_TYPE_SLAAD_BLUE:
      case APPEARANCE_TYPE_SLAAD_DEATH:
      case APPEARANCE_TYPE_SLAAD_GRAY:
      case APPEARANCE_TYPE_SLAAD_GREEN:
      case APPEARANCE_TYPE_SLAAD_RED:
      case APPEARANCE_TYPE_SLAAD_WHITE:
      case APPEARANCE_TYPE_ZEP_SLAAD_GREEN_B:
         return APPEARANCE_TYPE_SLAAD_BLACK;
         break;
      // spider
      case APPEARANCE_TYPE_SPIDER_DIRE:
      case APPEARANCE_TYPE_SPIDER_GIANT:
      case APPEARANCE_TYPE_SPIDER_PHASE:
      case APPEARANCE_TYPE_SPIDER_SWORD:
      case APPEARANCE_TYPE_SPIDER_WRAITH:
      case APPEARANCE_TYPE_ZEP_SPIDER_BLOODBACK:
      case APPEARANCE_TYPE_ZEP_SPIDER_ICE:
      case APPEARANCE_TYPE_ZEP_SPIDER_REDBACK:
      case APPEARANCE_TYPE_ZEP_SPIDER_WRAITH_B:
      case APPEARANCE_TYPE_ZEP_SPIDERLING:
      case APPEARANCE_TYPE_ZEP_SPIDERLING_DIRE:
      case APPEARANCE_TYPE_ZEP_SPIDERLING_GIANT:
      case APPEARANCE_TYPE_ZEP_SPIDERLING_PHASE:
      case APPEARANCE_TYPE_ZEP_SPIDERLING_SWORD:
         return APPEARANCE_TYPE_SPIDER_GIANT;
         break;
      // stinger
      case APPEARANCE_TYPE_STINGER:
      case APPEARANCE_TYPE_STINGER_CHIEFTAIN:
      case APPEARANCE_TYPE_STINGER_MAGE:
      case APPEARANCE_TYPE_STINGER_WARRIOR:
         return APPEARANCE_TYPE_STINGER;
         break;
      // svirfneblin
      case APPEARANCE_TYPE_SVIRF_FEMALE:
      case APPEARANCE_TYPE_SVIRF_MALE:
         return APPEARANCE_TYPE_SVIRF_MALE;
         break;
      // trolls
      case APPEARANCE_TYPE_TROLL:
      case APPEARANCE_TYPE_TROLL_CHIEFTAIN:
      case APPEARANCE_TYPE_TROLL_SHAMAN:
      case APPEARANCE_TYPE_ZEP_TROLL_B:
         return APPEARANCE_TYPE_TROLL;
         break;
      // vampire
      case APPEARANCE_TYPE_VAMPIRE_FEMALE:
      case APPEARANCE_TYPE_VAMPIRE_MALE:
         return APPEARANCE_TYPE_VAMPIRE_MALE;
         break;
      // yuan-ti
      case APPEARANCE_TYPE_YUAN_TI:
      case APPEARANCE_TYPE_YUAN_TI_CHIEFTEN:
      case APPEARANCE_TYPE_YUAN_TI_WIZARD:
         return APPEARANCE_TYPE_YUAN_TI;
         break;
      // satyr
      case APPEARANCE_TYPE_ZEP_SATYR:
      case APPEARANCE_TYPE_ZEP_SATYR_LARGE:
         return APPEARANCE_TYPE_ZEP_SATYR;
         break;
      // undead, unintelligent
      case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
      case APPEARANCE_TYPE_SKELETON_COMMON:
      case APPEARANCE_TYPE_SKELETON_MAGE:
      case APPEARANCE_TYPE_SKELETON_PRIEST:
      case APPEARANCE_TYPE_SKELETON_WARRIOR:
      case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
      case APPEARANCE_TYPE_SKELETON_WARRIOR_2:
      case APPEARANCE_TYPE_ZEP_SKELETON_DWARF:
      case APPEARANCE_TYPE_ZEP_SKELETON_FLAMING:
      case APPEARANCE_TYPE_ZEP_SKELETON_GREEN:
      case APPEARANCE_TYPE_ZEP_SKELETON_OGRE:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_1:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_2:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_3:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_4:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_5:
      case APPEARANCE_TYPE_ZEP_SKELETON_PIRATE_6:
      case APPEARANCE_TYPE_ZEP_SKELETON_PURPLE:
      case APPEARANCE_TYPE_ZEP_SKELETON_RED_EYES:
      case APPEARANCE_TYPE_ZEP_SKELETON_SMALL:
      case APPEARANCE_TYPE_ZEP_SKELETON_YELLOW:
      case APPEARANCE_TYPE_ZOMBIE:
      case APPEARANCE_TYPE_ZOMBIE_ROTTING:
      case APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG:
      case APPEARANCE_TYPE_ZOMBIE_WARRIOR_1:
      case APPEARANCE_TYPE_ZOMBIE_WARRIOR_2:
      case APPEARANCE_TYPE_ZEP_ZOMBIE_PIRATE_1:
      case APPEARANCE_TYPE_ZEP_ZOMBIE_PIRATE_2:
      case APPEARANCE_TYPE_ZEP_ZOMBIE_PIRATE_3:
      case APPEARANCE_TYPE_ZEP_ZOMBIE_PIRATE_4:
      case APPEARANCE_TYPE_SHADOW:
      case APPEARANCE_TYPE_SHADOW_FIEND:
      case APPEARANCE_TYPE_ZEP_SHADE:
      case APPEARANCE_TYPE_ZEP_SHADE_HOODED:
      case APPEARANCE_TYPE_WRAITH:
      case APPEARANCE_TYPE_ZEP_WRAITH_HOODED_1:
      case APPEARANCE_TYPE_ZEP_WRAITH_HOODED_2:
      case APPEARANCE_TYPE_ZEP_BAT_BONE:
      case APPEARANCE_TYPE_ZEP_GHOST_PIRATE:
         return APPEARANCE_TYPE_SKELETON_COMMON;
         break;
      // myconids
      case APPEARANCE_TYPE_ZEP_MYCONID:
      case APPEARANCE_TYPE_ZEP_MYCONID_ELDER:
      case APPEARANCE_TYPE_ZEP_MYCONID_SPROUT:
         return APPEARANCE_TYPE_ZEP_MYCONID;
         break;
      // vegepygmies
      case APPEARANCE_TYPE_ZEP_VEGEPYGMY:
      case APPEARANCE_TYPE_ZEP_VEGEPYGMY_THORNY_RIDER:
      case APPEARANCE_TYPE_ZEP_VEGEPYGMY_THORNY_RIDER_T:
      case APPEARANCE_TYPE_ZEP_VEGEPYGMY_THORNY_RIDER_V:
         return APPEARANCE_TYPE_ZEP_VEGEPYGMY;
         break;
      // blackrose elves
      case APPEARANCE_TYPE_ZEP_ELF_BLACKROSE_MALE:
      case APPEARANCE_TYPE_ZEP_ELF_BLACKROSE_FEMALE:
         return APPEARANCE_TYPE_ZEP_ELF_BLACKROSE_MALE;
         break;
      // baatezu (devils)
      case APPEARANCE_TYPE_DEVIL:
      case APPEARANCE_TYPE_DOOM_KNIGHT:
      case APPEARANCE_TYPE_MEPHISTO_BIG:
      case APPEARANCE_TYPE_MEPHISTO_NORM:
      case APPEARANCE_TYPE_ZEP_DEVIL_B:
      case APPEARANCE_TYPE_ZEP_HAMATULA:
      case APPEARANCE_TYPE_ZEP_OSYLUTH_A:
      case APPEARANCE_TYPE_ZEP_OSYLUTH_B:
      case APPEARANCE_TYPE_ZEP_OSYLUTH_C:
      case APPEARANCE_TYPE_ZEP_ERINYES:
      case APPEARANCE_TYPE_ZEP_ERINYES_B:
      case APPEARANCE_TYPE_ZEP_ERINYES3:
      case APPEARANCE_TYPE_ZEP_CORNUGON_A:
      case APPEARANCE_TYPE_ZEP_CORNUGON_B:
      case APPEARANCE_TYPE_ZEP_GELUGON:
      case APPEARANCE_TYPE_ZEP_BALROG:
         return APPEARANCE_TYPE_DEVIL;
         break;
      // tanar'ri (demons), intelligent
      case APPEARANCE_TYPE_BALOR:
      case APPEARANCE_TYPE_ZEP_GLABREZU:
      case APPEARANCE_TYPE_ZEP_MARILITH_DEMONIC:
      case APPEARANCE_TYPE_ZEP_MARILITH_HUMANOID:
      case APPEARANCE_TYPE_ZEP_MARILITH_BLACKGUARD:
      case APPEARANCE_TYPE_SUCCUBUS:
      case APPEARANCE_TYPE_ZEP_SUCCUBUS__PG_RATED:
      case APPEARANCE_TYPE_ZEP_SUCCUBUS_2ND_ED:
      case APPEARANCE_TYPE_VROCK:
         return APPEARANCE_TYPE_BALOR;
         break;
      // salamanders
      case APPEARANCE_TYPE_ZEP_SALAMANDER_AVERAGE:
      case APPEARANCE_TYPE_ZEP_SALAMANDER_FLAME_BRO:
      case APPEARANCE_TYPE_ZEP_SALAMANDER_NOBLE:
         return APPEARANCE_TYPE_ZEP_SALAMANDER_AVERAGE;
         break;
      // azer
      case APPEARANCE_TYPE_AZER_FEMALE:
      case APPEARANCE_TYPE_AZER_MALE:
      case APPEARANCE_TYPE_ZEP_AZER_FEMALE_B:
      case APPEARANCE_TYPE_ZEP_AZER_MALE_B:
         return APPEARANCE_TYPE_AZER_MALE;
         break;
      // lupinals
      case APPEARANCE_TYPE_ZEP_LUPINAL_FEMALE_1:
      case APPEARANCE_TYPE_ZEP_LUPINAL_FEMALE_2:
      case APPEARANCE_TYPE_ZEP_LUPINAL_FEMALE_3:
      case APPEARANCE_TYPE_ZEP_LUPINAL_FEMALE_4:
      case APPEARANCE_TYPE_ZEP_LUPINAL_MALE_1:
      case APPEARANCE_TYPE_ZEP_LUPINAL_MALE_2:
      case APPEARANCE_TYPE_ZEP_LUPINAL_MALE_3:
      case APPEARANCE_TYPE_ZEP_LUPINAL_MALE_4:
         return APPEARANCE_TYPE_ZEP_LUPINAL_MALE_1;
         break;
      // ants
      case APPEARANCE_TYPE_ZEP_ANT_GIANT:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_FIRE:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_GUARD:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_HIVEQUEEN:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_LARVA:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_QUEEN:
      case APPEARANCE_TYPE_ZEP_ANT_GIANT_SOLDIER:
         return APPEARANCE_TYPE_ZEP_ANT_GIANT;
         break;
      // maug
      case APPEARANCE_TYPE_ZEP_MAUG:
      case APPEARANCE_TYPE_ZEP_MAUG_CAPTAIN:
      case APPEARANCE_TYPE_ZEP_MAUG_COMMANDER:
      case APPEARANCE_TYPE_ZEP_MAUG_LIEUTENANT:
         return APPEARANCE_TYPE_ZEP_MAUG;
         break;
      default:
         return nAppearanceType;
   }
   return nAppearanceType;
}
