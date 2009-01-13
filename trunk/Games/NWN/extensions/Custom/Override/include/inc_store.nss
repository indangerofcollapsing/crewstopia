void openDefaultStore(int nStoreType, int bOpenExistingStore = TRUE);
void openStoreByResRef(string sResRef, int bOpenExistingStore = TRUE);
object findNearestStore();
void openMyStore(object oStore, object oProprietor, object oCustomer);

// If set, store will give a discount to customer of the same race as owner.
const string VAR_RACIAL_STORE = "STORE_RACIAL_DISCOUNT";

const int STORE_TYPE_DYE = 1;
const int STORE_TYPE_GENERAL = 2;
const int STORE_TYPE_GENIE = 3;
const int STORE_TYPE_LOST_ITEMS = 4;
const int STORE_TYPE_MAGIC = 5;
const int STORE_TYPE_NATURE = 6;
const int STORE_TYPE_ROGUE = 7;
const int STORE_TYPE_SPECIALTY = 8;
const int STORE_TYPE_TAVERN = 9;
const int STORE_TYPE_TEMPLE = 10;
const int STORE_TYPE_WEAPONS = 11;
// custom human/generic stores
const int STORE_TYPE_CLOTHIER = 101;
const int STORE_TYPE_LEATHER = 102;
const int STORE_TYPE_BLACKSMITH = 103;
const int STORE_TYPE_BARBARIAN = 104;
const int STORE_TYPE_JEWELLER = 105;
const int STORE_TYPE_ALCHEMIST = 106;
const int STORE_TYPE_CARPENTER = 107;
const int STORE_TYPE_BLACKMARKET = 108;
const int STORE_TYPE_DRUIDRANGER = 109;
const int STORE_TYPE_HOLY = 110;
const int STORE_TYPE_MONK = 111;
const int STORE_TYPE_BARD = 117;
const int STORE_TYPE_WIZARDSORC = 118;
const int STORE_TYPE_BLACKSMITH_SPECIAL = 119;
const int STORE_TYPE_CARPENTER_SPECIAL = 120;
const int STORE_TYPE_JEWELLER_SPECIAL = 121;
const int STORE_TYPE_LEATHERSMITH_SPECIAL = 122;
const int STORE_TYPE_CLOTHIER_SPECIAL = 123;
const int STORE_TYPE_WIZARDSORC_SPECIAL = 124;
// custom racial craftsmen
const int STORE_TYPE_ELF = 112;
const int STORE_TYPE_DWARF = 113;
const int STORE_TYPE_HALFLING = 114;
const int STORE_TYPE_GNOME = 115;
const int STORE_TYPE_ORC = 116;

const string STORE_DYE1 = "x2_merc_dye";
const string STORE_GENERAL1 = "nw_storgenral001";
const string STORE_GENERAL2 = "nw_storgenral002";
const string STORE_GENERAL3 = "nw_storgenral003";
const string STORE_GENERAL4 = "x2_storegenl001";
const string STORE_GENIE1 = "x2_genie";
const string STORE_LOST_ITEMS1 = "nw_lostitems";
const string STORE_MAGIC1 = "nw_storemagic001";
const string STORE_MAGIC2 = "nw_storemagic002";
const string STORE_MAGIC3 = "nw_storemagic003";
const string STORE_MAGIC4 = "nw_storemagic004";
const string STORE_MAGIC5 = "x2_storemage001";
const string STORE_MAGIC6 = "x2_storemage002";
const string STORE_MAGIC7 = "x2_storemage003";
const string STORE_NATURE1 = "nw_storenatu001";
const string STORE_NATURE2 = "nw_storenatu002";
const string STORE_NATURE3 = "nw_storenatu003";
const string STORE_NATURE4 = "nw_storenatu004";
const string STORE_NATURE5 = "x2_storenatr001";
const string STORE_ROGUE1 = "nw_storethief001";
const string STORE_ROGUE2 = "nw_storethief002";
const string STORE_ROGUE3 = "nw_storethief003";
const string STORE_ROGUE4 = "x2_storethief001";
const string STORE_ROGUE5 = "x2_storethief002";
const string STORE_ROGUE6 = "x2_storethief003";
const string STORE_SPECIAL1 = "nw_storespec001";
const string STORE_SPECIAL2 = "nw_storespec002";
const string STORE_SPECIAL3 = "nw_storespec003";
const string STORE_TAVERN1 = "nw_storebar01";
const string STORE_TEMPLE1 = "nw_storetmple001";
const string STORE_TEMPLE2 = "nw_storetmple002";
const string STORE_TEMPLE3 = "nw_storetmple003";
const string STORE_TEMPLE4 = "nw_storetmple004";
const string STORE_TEMPLE5 = "x2_storetempl001";
const string STORE_TEMPLE6 = "x2_storetempl002";
const string STORE_WEAPON1 = "nw_storeweap001";
const string STORE_WEAPON2 = "nw_storeweap002";
const string STORE_WEAPON3 = "nw_storeweap003";
const string STORE_WEAPON4 = "nw_storeweap004";
const string STORE_WEAPON5 = "x2_storeweap001";
const string STORE_WEAPON6 = "x2_storeweap002";
const string STORE_WEAPON7 = "x2_storeweap003";
const string STORE_ALCHEMIST0 = "alchemist_000";
const string STORE_ALCHEMIST1 = "alchemist_001";
const string STORE_ALCHEMIST2 = "alchemist_002";
const string STORE_ALCHEMIST3 = "alchemist_003";
const string STORE_ALCHEMIST4 = "alchemist_004";
const string STORE_ALCHEMIST5 = "alchemist_005";
const string STORE_BLACKMARKET0 = "blackmarket_000";
const string STORE_BLACKMARKET1 = "blackmarket_001";
const string STORE_BLACKMARKET2 = "blackmarket_002";
const string STORE_BLACKMARKET3 = "blackmarket_003";
const string STORE_BLACKMARKET4 = "blackmarket_004";
const string STORE_BLACKMARKET5 = "blackmarket_005";
const string STORE_CLOTHIER0 = "clothier_000";
const string STORE_CLOTHIER1 = "clothier_001";
const string STORE_CLOTHIER2 = "clothier_002";
const string STORE_CLOTHIER3 = "clothier_003";
const string STORE_CLOTHIER4 = "clothier_004";
const string STORE_CLOTHIER5 = "clothier_005";
const string STORE_LEATHER0 = "leathersmith_000";
const string STORE_LEATHER1 = "leathersmith_001";
const string STORE_LEATHER2 = "leathersmith_002";
const string STORE_LEATHER3 = "leathersmith_003";
const string STORE_LEATHER4 = "leathersmith_004";
const string STORE_LEATHER5 = "leathersmith_005";
const string STORE_BLACKSMITH0 = "blacksmith_000";
const string STORE_BLACKSMITH1 = "blacksmith_001";
const string STORE_BLACKSMITH2 = "blacksmith_002";
const string STORE_BLACKSMITH3 = "blacksmith_003";
const string STORE_BLACKSMITH4 = "blacksmith_004";
const string STORE_BLACKSMITH5 = "blacksmith_005";
const string STORE_BARBARIAN0 = "barbarian_000";
const string STORE_BARBARIAN1 = "barbarian_001";
const string STORE_BARBARIAN2 = "barbarian_002";
const string STORE_BARBARIAN3 = "barbarian_003";
const string STORE_BARBARIAN4 = "barbarian_004";
const string STORE_BARBARIAN5 = "barbarian_005";
const string STORE_JEWELLER0 = "jeweller_000";
const string STORE_JEWELLER1 = "jeweller_001";
const string STORE_JEWELLER2 = "jeweller_002";
const string STORE_JEWELLER3 = "jeweller_003";
const string STORE_JEWELLER4 = "jeweller_004";
const string STORE_JEWELLER5 = "jeweller_005";
const string STORE_CARPENTER0 = "carpenter_000";
const string STORE_CARPENTER1 = "carpenter_001";
const string STORE_CARPENTER2 = "carpenter_002";
const string STORE_CARPENTER3 = "carpenter_003";
const string STORE_CARPENTER4 = "carpenter_004";
const string STORE_CARPENTER5 = "carpenter_005";
const string STORE_DRUIDRANGER0 = "druidranger_000";
const string STORE_DRUIDRANGER1 = "druidranger_001";
const string STORE_DRUIDRANGER2 = "druidranger_002";
const string STORE_DRUIDRANGER3 = "druidranger_003";
const string STORE_DRUIDRANGER4 = "druidranger_004";
const string STORE_DRUIDRANGER5 = "druidranger_005";
const string STORE_HOLY0 = "holy_000";
const string STORE_HOLY1 = "holy_001";
const string STORE_HOLY2 = "holy_002";
const string STORE_HOLY3 = "holy_003";
const string STORE_HOLY4 = "holy_004";
const string STORE_HOLY5 = "holy_005";
const string STORE_MONK0 = "monk_000";
const string STORE_MONK1 = "monk_001";
const string STORE_MONK2 = "monk_002";
const string STORE_MONK3 = "monk_003";
const string STORE_MONK4 = "monk_004";
const string STORE_MONK5 = "monk_005";
const string STORE_BARD0 = "bard_000";
const string STORE_BARD1 = "bard_001";
const string STORE_BARD2 = "bard_002";
const string STORE_BARD3 = "bard_003";
const string STORE_BARD4 = "bard_004";
const string STORE_BARD5 = "bard_005";
const string STORE_WIZARDSORC0 = "wizardsorc_000";
const string STORE_WIZARDSORC1 = "wizardsorc_001";
const string STORE_WIZARDSORC2 = "wizardsorc_002";
const string STORE_WIZARDSORC3 = "wizardsorc_003";
const string STORE_WIZARDSORC4 = "wizardsorc_004";
const string STORE_WIZARDSORC5 = "wizardsorc_005";
const string STORE_ELF0 = "elf_000";
const string STORE_ELF1 = "elf_001";
const string STORE_ELF2 = "elf_002";
const string STORE_ELF3 = "elf_003";
const string STORE_ELF4 = "elf_004";
const string STORE_ELF5 = "elf_005";
const string STORE_DWARF0 = "dwarf_000";
const string STORE_DWARF1 = "dwarf_001";
const string STORE_DWARF2 = "dwarf_002";
const string STORE_DWARF3 = "dwarf_003";
const string STORE_DWARF4 = "dwarf_004";
const string STORE_DWARF5 = "dwarf_005";
const string STORE_HALFLING0 = "halfling_000";
const string STORE_HALFLING1 = "halfling_001";
const string STORE_HALFLING2 = "halfling_002";
const string STORE_HALFLING3 = "halfling_003";
const string STORE_HALFLING4 = "halfling_004";
const string STORE_HALFLING5 = "halfling_005";
const string STORE_GNOME0 = "gnome_000";
const string STORE_GNOME1 = "gnome_001";
const string STORE_GNOME2 = "gnome_002";
const string STORE_GNOME3 = "gnome_003";
const string STORE_GNOME4 = "gnome_004";
const string STORE_GNOME5 = "gnome_005";
const string STORE_ORC0 = "orc_000";
const string STORE_ORC1 = "orc_001";
const string STORE_ORC2 = "orc_002";
const string STORE_ORC3 = "orc_003";
const string STORE_ORC4 = "orc_004";
const string STORE_ORC5 = "orc_005";
const string STORE_BLACKSMITH_SPECIAL = "blacksmith_speci";
const string STORE_CARPENTER_SPECIAL = "carpenter_specia";
const string STORE_CLOTHIER_SPECIAL = "clothier_special";
const string STORE_LEATHERSMITH_SPECIAL = "leathersmith_spe";
const string STORE_JEWELLER_SPECIAL = "jeweller_special";
const string STORE_WIZARDSORC_SPECIAL = "wizardsorc_speci";
const string STORE_RECALLRUNE = "store_recallrune";

#include "inc_persistworld"
#include "inc_debug_dac"
#include "nw_i0_plot"
#include "inc_appearance"
#include "inc_dialog"

void openDefaultStore(int nStoreType, int bOpenExistingStore = TRUE)
{
   //debugVarObject("openDefaultStore()", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   object oStore = OBJECT_INVALID;

   int nHD = GetHitDice(oPC);
   string sStoreResRef = "";
   switch(nStoreType)
   {
      case STORE_TYPE_DYE:
         sStoreResRef = STORE_DYE1;
         break;
      case STORE_TYPE_GENERAL:
         if (nHD <= 4) sStoreResRef = STORE_GENERAL1;
         else if (nHD <= 8) sStoreResRef = STORE_GENERAL2;
         else if (nHD <= 12) sStoreResRef = STORE_GENERAL3;
         else sStoreResRef = STORE_GENERAL4;
         break;
      case STORE_TYPE_GENIE:
         sStoreResRef = STORE_GENIE1;
         break;
      case STORE_TYPE_LOST_ITEMS:
         sStoreResRef = STORE_LOST_ITEMS1;
         break;
      case STORE_TYPE_MAGIC:
         if (nHD <= 4) sStoreResRef = STORE_MAGIC1;
         else if (nHD <= 8) sStoreResRef = STORE_MAGIC2;
         else if (nHD <= 12) sStoreResRef = STORE_MAGIC3;
         else if (nHD <= 16) sStoreResRef = STORE_MAGIC4;
         else if (nHD <= 20) sStoreResRef = STORE_MAGIC5;
         else if (nHD <= 24) sStoreResRef = STORE_MAGIC6;
         else sStoreResRef = STORE_MAGIC7;
         break;
      case STORE_TYPE_NATURE:
         if (nHD <= 4) sStoreResRef = STORE_NATURE1;
         else if (nHD <= 8) sStoreResRef = STORE_NATURE2;
         else if (nHD <= 12) sStoreResRef = STORE_NATURE3;
         else if (nHD <= 16) sStoreResRef = STORE_NATURE4;
         else sStoreResRef = STORE_NATURE5;
         break;
      case STORE_TYPE_ROGUE:
         if (nHD <= 4) sStoreResRef = STORE_ROGUE1;
         else if (nHD <= 8) sStoreResRef = STORE_ROGUE2;
         else if (nHD <= 12) sStoreResRef = STORE_ROGUE3;
         else if (nHD <= 16) sStoreResRef = STORE_ROGUE4;
         else if (nHD <= 20) sStoreResRef = STORE_ROGUE5;
         else sStoreResRef = STORE_ROGUE6;
         break;
      case STORE_TYPE_SPECIALTY:
         if (nHD <= 4) sStoreResRef = STORE_SPECIAL1;
         else if (nHD <= 8) sStoreResRef = STORE_SPECIAL2;
         else sStoreResRef = STORE_SPECIAL3;
         break;
      case STORE_TYPE_TAVERN:
         sStoreResRef = STORE_TAVERN1;
         break;
      case STORE_TYPE_TEMPLE:
         if (nHD <= 4) sStoreResRef = STORE_TEMPLE1;
         else if (nHD <= 8) sStoreResRef = STORE_TEMPLE2;
         else if (nHD <= 12) sStoreResRef = STORE_TEMPLE3;
         else if (nHD <= 16) sStoreResRef = STORE_TEMPLE4;
         else if (nHD <= 20) sStoreResRef = STORE_TEMPLE5;
         else sStoreResRef = STORE_TEMPLE6;
         break;
      case STORE_TYPE_WEAPONS:
         if (nHD <= 4) sStoreResRef = STORE_WEAPON1;
         else if (nHD <= 8) sStoreResRef = STORE_WEAPON2;
         else if (nHD <= 12) sStoreResRef = STORE_WEAPON3;
         else if (nHD <= 16) sStoreResRef = STORE_WEAPON4;
         else if (nHD <= 20) sStoreResRef = STORE_WEAPON5;
         else if (nHD <= 24) sStoreResRef = STORE_WEAPON6;
         else sStoreResRef = STORE_WEAPON7;
         break;
      case STORE_TYPE_CLOTHIER:
         if (nHD <= 1) sStoreResRef = STORE_CLOTHIER0;
         else if (nHD <= 4) sStoreResRef = STORE_CLOTHIER1;
         else if (nHD <= 8) sStoreResRef = STORE_CLOTHIER2;
         else if (nHD <= 12) sStoreResRef = STORE_CLOTHIER3;
         else if (nHD <= 16) sStoreResRef = STORE_CLOTHIER4;
         else sStoreResRef = STORE_CLOTHIER5;
         break;
      case STORE_TYPE_LEATHER:
         if (nHD <= 1) sStoreResRef = STORE_LEATHER0;
         else if (nHD <= 4) sStoreResRef = STORE_LEATHER1;
         else if (nHD <= 8) sStoreResRef = STORE_LEATHER2;
         else if (nHD <= 12) sStoreResRef = STORE_LEATHER3;
         else if (nHD <= 16) sStoreResRef = STORE_LEATHER4;
         else sStoreResRef = STORE_LEATHER5;
         break;
      case STORE_TYPE_BLACKSMITH:
         if (nHD <= 1) sStoreResRef = STORE_BLACKSMITH0;
         else if (nHD <= 4) sStoreResRef = STORE_BLACKSMITH1;
         else if (nHD <= 8) sStoreResRef = STORE_BLACKSMITH2;
         else if (nHD <= 12) sStoreResRef = STORE_BLACKSMITH3;
         else if (nHD <= 16) sStoreResRef = STORE_BLACKSMITH4;
         else sStoreResRef = STORE_BLACKSMITH5;
         break;
      case STORE_TYPE_BARBARIAN:
         if (nHD <= 1) sStoreResRef = STORE_BARBARIAN0;
         else if (nHD <= 4) sStoreResRef = STORE_BARBARIAN1;
         else if (nHD <= 8) sStoreResRef = STORE_BARBARIAN2;
         else if (nHD <= 12) sStoreResRef = STORE_BARBARIAN3;
         else if (nHD <= 16) sStoreResRef = STORE_BARBARIAN4;
         else sStoreResRef = STORE_BARBARIAN5;
         break;
      case STORE_TYPE_JEWELLER:
         if (nHD <= 1) sStoreResRef = STORE_JEWELLER0;
         else if (nHD <= 4) sStoreResRef = STORE_JEWELLER1;
         else if (nHD <= 8) sStoreResRef = STORE_JEWELLER2;
         else if (nHD <= 12) sStoreResRef = STORE_JEWELLER3;
         else if (nHD <= 16) sStoreResRef = STORE_JEWELLER4;
         else sStoreResRef = STORE_JEWELLER5;
         break;
      case STORE_TYPE_ALCHEMIST:
         if (nHD <= 1) sStoreResRef = STORE_ALCHEMIST0;
         else if (nHD <= 4) sStoreResRef = STORE_ALCHEMIST1;
         else if (nHD <= 8) sStoreResRef = STORE_ALCHEMIST2;
         else if (nHD <= 12) sStoreResRef = STORE_ALCHEMIST3;
         else if (nHD <= 16) sStoreResRef = STORE_ALCHEMIST4;
         else sStoreResRef = STORE_ALCHEMIST5;
         break;
      case STORE_TYPE_CARPENTER:
         if (nHD <= 1) sStoreResRef = STORE_CARPENTER0;
         else if (nHD <= 4) sStoreResRef = STORE_CARPENTER1;
         else if (nHD <= 8) sStoreResRef = STORE_CARPENTER2;
         else if (nHD <= 12) sStoreResRef = STORE_CARPENTER3;
         else if (nHD <= 16) sStoreResRef = STORE_CARPENTER4;
         else sStoreResRef = STORE_CARPENTER5;
         break;
      case STORE_TYPE_BLACKMARKET:
         if (nHD <= 1) sStoreResRef = STORE_BLACKMARKET0;
         else if (nHD <= 4) sStoreResRef = STORE_BLACKMARKET1;
         else if (nHD <= 8) sStoreResRef = STORE_BLACKMARKET2;
         else if (nHD <= 12) sStoreResRef = STORE_BLACKMARKET3;
         else if (nHD <= 16) sStoreResRef = STORE_BLACKMARKET4;
         else sStoreResRef = STORE_BLACKMARKET5;
         break;
      case STORE_TYPE_DRUIDRANGER:
         if (nHD <= 1) sStoreResRef = STORE_DRUIDRANGER0;
         else if (nHD <= 4) sStoreResRef = STORE_DRUIDRANGER1;
         else if (nHD <= 8) sStoreResRef = STORE_DRUIDRANGER2;
         else if (nHD <= 12) sStoreResRef = STORE_DRUIDRANGER3;
         else if (nHD <= 16) sStoreResRef = STORE_DRUIDRANGER4;
         else sStoreResRef = STORE_DRUIDRANGER5;
         break;
      case STORE_TYPE_HOLY:
         if (nHD <= 1) sStoreResRef = STORE_HOLY0;
         else if (nHD <= 4) sStoreResRef = STORE_HOLY1;
         else if (nHD <= 8) sStoreResRef = STORE_HOLY2;
         else if (nHD <= 12) sStoreResRef = STORE_HOLY3;
         else if (nHD <= 16) sStoreResRef = STORE_HOLY4;
         else sStoreResRef = STORE_HOLY5;
         break;
      case STORE_TYPE_MONK:
         if (nHD <= 1) sStoreResRef = STORE_MONK0;
         else if (nHD <= 4) sStoreResRef = STORE_MONK1;
         else if (nHD <= 8) sStoreResRef = STORE_MONK2;
         else if (nHD <= 12) sStoreResRef = STORE_MONK3;
         else if (nHD <= 16) sStoreResRef = STORE_MONK4;
         else sStoreResRef = STORE_MONK5;
         break;
      case STORE_TYPE_BARD:
         if (nHD <= 1) sStoreResRef = STORE_BARD0;
         else if (nHD <= 4) sStoreResRef = STORE_BARD1;
         else if (nHD <= 8) sStoreResRef = STORE_BARD2;
         else if (nHD <= 12) sStoreResRef = STORE_BARD3;
         else if (nHD <= 16) sStoreResRef = STORE_BARD4;
         else sStoreResRef = STORE_BARD5;
         break;
      case STORE_TYPE_WIZARDSORC:
         if (nHD <= 1) sStoreResRef = STORE_WIZARDSORC0;
         else if (nHD <= 4) sStoreResRef = STORE_WIZARDSORC1;
         else if (nHD <= 8) sStoreResRef = STORE_WIZARDSORC2;
         else if (nHD <= 12) sStoreResRef = STORE_WIZARDSORC3;
         else if (nHD <= 16) sStoreResRef = STORE_WIZARDSORC4;
         else sStoreResRef = STORE_WIZARDSORC5;
         break;
      case STORE_TYPE_ELF:
         if (nHD <= 1) sStoreResRef = STORE_ELF0;
         else if (nHD <= 4) sStoreResRef = STORE_ELF1;
         else if (nHD <= 8) sStoreResRef = STORE_ELF2;
         else if (nHD <= 12) sStoreResRef = STORE_ELF3;
         else if (nHD <= 16) sStoreResRef = STORE_ELF4;
         else sStoreResRef = STORE_ELF5;
         break;
      case STORE_TYPE_DWARF:
         if (nHD <= 1) sStoreResRef = STORE_DWARF0;
         else if (nHD <= 4) sStoreResRef = STORE_DWARF1;
         else if (nHD <= 8) sStoreResRef = STORE_DWARF2;
         else if (nHD <= 12) sStoreResRef = STORE_DWARF3;
         else if (nHD <= 16) sStoreResRef = STORE_DWARF4;
         else sStoreResRef = STORE_DWARF5;
         break;
      case STORE_TYPE_HALFLING:
         if (nHD <= 1) sStoreResRef = STORE_HALFLING0;
         else if (nHD <= 4) sStoreResRef = STORE_HALFLING1;
         else if (nHD <= 8) sStoreResRef = STORE_HALFLING2;
         else if (nHD <= 12) sStoreResRef = STORE_HALFLING3;
         else if (nHD <= 16) sStoreResRef = STORE_HALFLING4;
         else sStoreResRef = STORE_HALFLING5;
         break;
      case STORE_TYPE_GNOME:
         if (nHD <= 1) sStoreResRef = STORE_GNOME0;
         else if (nHD <= 4) sStoreResRef = STORE_GNOME1;
         else if (nHD <= 8) sStoreResRef = STORE_GNOME2;
         else if (nHD <= 12) sStoreResRef = STORE_GNOME3;
         else if (nHD <= 16) sStoreResRef = STORE_GNOME4;
         else sStoreResRef = STORE_GNOME5;
         break;
      case STORE_TYPE_ORC:
         if (nHD <= 1) sStoreResRef = STORE_ORC0;
         else if (nHD <= 4) sStoreResRef = STORE_ORC1;
         else if (nHD <= 8) sStoreResRef = STORE_ORC2;
         else if (nHD <= 12) sStoreResRef = STORE_ORC3;
         else if (nHD <= 16) sStoreResRef = STORE_ORC4;
         else sStoreResRef = STORE_ORC5;
         break;
      case STORE_TYPE_BLACKSMITH_SPECIAL:
         sStoreResRef = STORE_BLACKSMITH_SPECIAL;
         break;
      case STORE_TYPE_CARPENTER_SPECIAL:
         sStoreResRef = STORE_CARPENTER_SPECIAL;
         break;
      case STORE_TYPE_CLOTHIER_SPECIAL:
         sStoreResRef = STORE_CLOTHIER_SPECIAL;
         break;
      case STORE_TYPE_LEATHERSMITH_SPECIAL:
         sStoreResRef = STORE_LEATHERSMITH_SPECIAL;
         break;
      case STORE_TYPE_JEWELLER_SPECIAL:
         sStoreResRef = STORE_JEWELLER_SPECIAL;
         break;
      case STORE_TYPE_WIZARDSORC_SPECIAL:
         sStoreResRef = STORE_WIZARDSORC_SPECIAL;
         break;
      default:
         logError("ERROR: Store type " + IntToString(nStoreType) +
            " not recognized in inc_store.");
         break;
   }

   //debugVarString("sStoreResRef", sStoreResRef);
   openStoreByResRef(sStoreResRef, bOpenExistingStore);
}

object findNearestStore()
{
   object oStore = OBJECT_INVALID;
   object oMyStore = GetNearestObject(OBJECT_TYPE_STORE);
   int iNth = 1;
   while (oMyStore != OBJECT_INVALID)
   {
      if (isTemporary(oMyStore))
      {
         oMyStore = GetNearestObject(OBJECT_TYPE_STORE, OBJECT_SELF, ++iNth);
      }
      else
      {
         oStore = oMyStore;
         oMyStore = OBJECT_INVALID;
      }
   }

   return oStore;
}

void openStoreByResRef(string sResRef, int bOpenExistingStore = TRUE)
{
   //debugVarObject("openStoreByResRef()", OBJECT_SELF);
   //debugVarString("sResRef", sResRef);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   object oStore = OBJECT_INVALID;

   // if an existing store is defined nearby, use that
   if (bOpenExistingStore)
   {
      //debug("trying to find existing store");
      oStore = findNearestStore();
//      if (oStore == OBJECT_INVALID) logError("no store found");
//      else //debugVarObject("found store", oStore);
   }

   if (oStore == OBJECT_INVALID || GetResRef(oStore) != sResRef)
   {
      //debug("creating new store of type: " + sResRef);
      oStore = CreateObject(OBJECT_TYPE_STORE, sResRef,
         GetLocation(OBJECT_SELF));
   }

   if (oStore == OBJECT_INVALID)
   {
      logError("ERROR: oStore is invalid");
      return;
   }

   //debug("opening store: " + GetName(oStore));
   openMyStore(oStore, OBJECT_SELF, oPC);
}

void openMyStore(object oStore, object oProprietor, object oCustomer)
{
   //debugVarObject("openMyStore()", OBJECT_SELF);
   //debugVarObject("oStore", oStore);
   //debugVarObject("oProprietor", oProprietor);
   //debugVarObject("oCustomer", oCustomer);

   if (oStore != OBJECT_INVALID)
   {
      int nBonusMarkup = 0; // on items sold
      int nBonusMarkdown = 0; // on items bought
      int nProprietorRace = GetRacialType(oProprietor);
      //debugVarInt("nProprietorRace", nProprietorRace);
      int nCustomerRace = GetRacialType(oCustomer);
      //debugVarInt("nCustomerRace", nCustomerRace);

      if (nProprietorRace == nCustomerRace)
      {
         WriteTimestampedLogEntry("Racial discount given to " +
            GetName(oCustomer) + " by " + GetName(oProprietor) + ", races = " +
            IntToString(nProprietorRace) + "/" + IntToString(nCustomerRace) + ".");
         // Gender both/none/other are referred to as "brother".  Deal with it.
//         string sMessage = "Welcome, " +
//            (GetGender(oCustomer) == GENDER_FEMALE ? "sister" : "brother") + ".";
//         FloatingTextStringOnCreature(sMessage, oProprietor, FALSE);
         nBonusMarkup -= 25;
         nBonusMarkdown -= 25;
      }

      if (amICousinTo(oCustomer))
      {
//         FloatingTextStringOnCreature("We are cousins, you and I.", oProprietor, FALSE);
         WriteTimestampedLogEntry("Cousin discount given to " +
            GetName(oCustomer) + " by " + GetName(oProprietor));
         nBonusMarkup -= 25;
         nBonusMarkdown -= 25;
         SetStoreIdentifyCost(oStore, GetStoreIdentifyCost(oStore) / 2);
      }
      if (nBonusMarkup != 0)
      {
         string sMessage = "Welcome, cousin.  I'm giving you a " +
            IntToString(-nBonusMarkup) + "% discount.";
         AssignCommand(oProprietor, ActionSpeakString(sMessage));
//         FloatingTextStringOnCreature(sMessage, oProprietor, FALSE);
      }
      gplotAppraiseFavOpenStore(oStore, oCustomer, nBonusMarkup, nBonusMarkdown);
   }
   else
   {
      SpeakString("Sorry, no store is available.");
   }
}

//void main() {} // testing/compiling purposes

