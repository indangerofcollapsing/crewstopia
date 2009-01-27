#include "inc_debug_dac"
#include "prc_class_const"

int soulknifeCanWield(int nShapeId, object oPC = OBJECT_SELF);

// @DUG This is duplicated in psi_sk_manifmbld.nss, because including
// psi_inc_soulkn.nss here causes the StartingConditional scripts
// (dac_sc_sk_*.nss) to not work.
const string MBLADE_SHAPE         = "PRC_PSI_SK_MindbladeShape";

// @DUG This is duplicated in psi_sk_manifmbld.nss, because including
// psi_inc_soulkn.nss here causes the StartingConditional scripts
// (dac_sc_sk_*.nss) to not work.
// Custom Mindblade Shape                          Granted on level  Feats
const int MBLADE_SHAPE_CLUB = 23; // prc_sk_mblade_cl             1  SDMoRW
const int MBLADE_SHAPE_LIGHTHAMMER = 29; // prc_sk_mblade_lh      1  M
const int MBLADE_SHAPE_DAGGER = 5; // prc_sk_mblade_dg            2  SDMoRW
const int MBLADE_SHAPE_DART = 32; // prc_sk_mblade_td             2  SDRW
const int MBLADE_SHAPE_SHURIKEN = 33; // prc_sk_mblade_sh         2  E
const int MBLADE_SHAPE_SHORTSWORD       = 0; // prc_sk_mblade_ss  3  MR
const int MBLADE_SHAPE_QUARTERSTAFF = 31; // prc_sk_mblade_qs     4  SDMoRW
const int MBLADE_SHAPE_RANGED           = 4; // prc_sk_mblade_th  4  M
const int MBLADE_SHAPE_DUAL_SHORTSWORDS = 1; // prc_sk_mblade_ss  4  MR
const int MBLADE_SHAPE_HANDAXE = 27; // prc_sk_mblade_hx          5  MMo
const int MBLADE_SHAPE_KAMA = 28; // prc_sk_mblade_km             5  EMo
const int MBLADE_SHAPE_SICKLE = 30; // prc_sk_mblade_si           5  D
const int MBLADE_SHAPE_LIGHTMACE = 13; // prc_sk_mblade_lm        6  SR
const int MBLADE_SHAPE_LONGSWORD        = 2; // prc_sk_mblade_ls  7  M
const int MBLADE_SHAPE_SPEAR = 12; // prc_sk_mblade_sp            7  SD
const int MBLADE_SHAPE_LIGHTFLAIL = 14; // prc_sk_mblade_lf       7  M
const int MBLADE_SHAPE_MORNINGSTAR = 21; // prc_sk_mblade_ms      8  SR
const int MBLADE_SHAPE_KUKRI = 20; // prc_sk_mblade_ku            8  E
const int MBLADE_SHAPE_SCIMITAR = 10; // prc_sk_mblade_sc         9  MD
const int MBLADE_SHAPE_BATTLEAXE = 8; // prc_sk_mblade_ba         10 M
const int MBLADE_SHAPE_RAPIER = 11; // prc_sk_mblade_ra           11 MR
const int MBLADE_SHAPE_WARHAMMER = 24; // prc_sk_mblade_wh        12 M
const int MBLADE_SHAPE_BASTARDSWORD     = 3; // prc_sk_mblade_bs  13 M
const int MBLADE_SHAPE_HALBERD = 15; // prc_sk_mblade_ha          14 M
const int MBLADE_SHAPE_HEAVYFLAIL = 18; // prc_sk_mblade_hf       15 M
const int MBLADE_SHAPE_KATANA = 19; // prc_sk_mblade_ka           15 E
const int MBLADE_SHAPE_GREATAXE = 9; // prc_sk_mblade_ga          16 M
const int MBLADE_SHAPE_GREATSWORD = 6; // prc_sk_mblade_gs        17 M
const int MBLADE_SHAPE_DWAXE = 26; // prc_sk_mblade_dw            18 E
const int MBLADE_SHAPE_SCYTHE = 22; // prc_sk_mblade_sy           19 E
const int MBLADE_SHAPE_DIREMACE = 16; // prc_sk_mblade_dm         20 E
const int MBLADE_SHAPE_DOUBLEAXE = 17; // prc_sk_mblade_da        20 E
const int MBLADE_SHAPE_2BLADESWORD = 7; // prc_sk_mblade_2b       20 E
const int MBLADE_SHAPE_WHIP = 25; // prc_sk_mblade_wp             21 E
// CEP Weapons
const int MBLADE_SHAPE_LIGHTPICK = 43; // prc_sk_mblade_lp        2  M
const int MBLADE_SHAPE_TONFA = 50; // prc_sk_mblade_to            2  EMo
const int MBLADE_SHAPE_ASSASSINDAGGER = 34; // prc_sk_mblade_ad   2  SDMoRW
const int MBLADE_SHAPE_WINDFIREWHEEL = 53; // prc_sk_mblade_wf    3  EMo
const int MBLADE_SHAPE_KATAR = 42; // prc_sk_mblade_kt            3  SDMoRW
const int MBLADE_SHAPE_CHAKRAM = 35; // prc_sk_mblade_ck          5  M
const int MBLADE_SHAPE_GOAD = 39; // prc_sk_mblade_go             6  M
const int MBLADE_SHAPE_NUNCHUKAU = 47; // prc_sk_mblade_nu        6  EMo
const int MBLADE_SHAPE_SAI = 48; // prc_sk_mblade_sa              7  EMo
const int MBLADE_SHAPE_SAP = 49; // prc_sk_mblade_s               7  MR
const int MBLADE_SHAPE_FALCHION = 38; // prc_sk_mblade_fa         8  M
const int MBLADE_SHAPE_TRIDENT = 51; // prc_sk_mblade_tr          9  M
const int MBLADE_SHAPE_HEAVYMACE = 40; // prc_sk_mblade_hm        11 SR
const int MBLADE_SHAPE_HEAVYPICK = 41; // prc_sk_mblade_hp        12 M
const int MBLADE_SHAPE_MAUL = 44; // prc_sk_mblade_ma             15 M
const int MBLADE_SHAPE_DOUBLESCIMITAR = 37; // prc_sk_mblade_ds   20 E
const int MBLADE_SHAPE_MERCLONGSWORD = 46; // prc_sk_mblade_ml    21 E
const int MBLADE_SHAPE_MERCGREATSWORD = 45; // prc_sk_mblade_mg   21 E
const int MBLADE_SHAPE_WEIGHTEDCHAIN = 52; // prc_sk_mblade_wc    22 E
const int MBLADE_SHAPE_SPIKEDCHAIN = 36; // prc_sk_mblade_ch      22 E

int soulknifeCanWield(int nShapeId, object oPC = OBJECT_SELF)
{
   //debugVarObject("soulknifeCanWield()", OBJECT_SELF);
   //debugVarInt("nShapeId", nShapeId);
   //debugVarObject("oPC", oPC);

   int nSKLevel = GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC);
   //debugVarInt("nSKLevel", nSKLevel);

   int hasSimpleProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC);
   int hasMartialProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC);
   int hasExoticProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC);
   int hasDruidProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC);
   int hasMonkProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC);
   int hasRogueProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC);
   int hasWizardProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_WIZARD, oPC);
   int hasElfProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC);

   //debugVarBoolean("Simple Prof", hasSimpleProf);
   //debugVarBoolean("Martial Prof", hasMartialProf);
   //debugVarBoolean("Exotic Prof", hasExoticProf);
   //debugVarBoolean("Druid Prof", hasDruidProf);
   //debugVarBoolean("Monk Prof", hasMonkProf);
   //debugVarBoolean("Rogue Prof", hasRogueProf);
   //debugVarBoolean("Wizard Prof", hasWizardProf);
   //debugVarBoolean("Elf Prof", hasElfProf);

   switch(nShapeId)
   {
      case MBLADE_SHAPE_DAGGER:
         return (nSKLevel >= 2) && (hasSimpleProf || hasDruidProf || hasMonkProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_SHORTSWORD:
         return (nSKLevel >= 3) && (hasMartialProf || hasRogueProf);
      case MBLADE_SHAPE_RANGED:
         return (nSKLevel >= 4) && (hasMartialProf);
      case MBLADE_SHAPE_DUAL_SHORTSWORDS:
         return (nSKLevel >= 4) && (hasMartialProf || hasRogueProf);
      case MBLADE_SHAPE_CLUB:
         return (nSKLevel >= 1) && (hasSimpleProf || hasDruidProf || hasMonkProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_LONGSWORD:
         return (nSKLevel >= 7) && (hasMartialProf || hasElfProf);
      case MBLADE_SHAPE_BASTARDSWORD:
         return (nSKLevel >= 13) && (hasMartialProf);
      case MBLADE_SHAPE_HANDAXE:
         return (nSKLevel >= 5) && (hasMartialProf || hasMonkProf);
      case MBLADE_SHAPE_RAPIER:
         return (nSKLevel >= 11) && (hasMartialProf || hasRogueProf || hasElfProf);
      case MBLADE_SHAPE_LIGHTHAMMER:
         return (nSKLevel >= 1) && (hasMartialProf);
      case MBLADE_SHAPE_GREATSWORD:
         return (nSKLevel >= 17) && (hasMartialProf);
      case MBLADE_SHAPE_SPEAR:
         return (nSKLevel >= 7) && (hasSimpleProf || hasDruidProf);
      case MBLADE_SHAPE_BATTLEAXE:
         return (nSKLevel >= 10) && (hasMartialProf);
      case MBLADE_SHAPE_SCIMITAR:
         return (nSKLevel >= 9) && (hasMartialProf || hasDruidProf);
      case MBLADE_SHAPE_GREATAXE:
         return (nSKLevel >= 16) && (hasMartialProf);
      case MBLADE_SHAPE_KUKRI:
         return (nSKLevel >= 8) && (hasExoticProf);
      case MBLADE_SHAPE_KATANA:
         return (nSKLevel >= 15) && (hasExoticProf);
      case MBLADE_SHAPE_HALBERD:
         return (nSKLevel >= 14) && (hasMartialProf);
      case MBLADE_SHAPE_LIGHTMACE:
         return (nSKLevel >= 6) && (hasSimpleProf || hasRogueProf);
      case MBLADE_SHAPE_LIGHTFLAIL:
         return (nSKLevel >= 7) && (hasMartialProf);
      case MBLADE_SHAPE_WARHAMMER:
         return (nSKLevel >= 12) && (hasMartialProf);
      case MBLADE_SHAPE_MORNINGSTAR:
         return (nSKLevel >= 8) && (hasSimpleProf || hasRogueProf);
      case MBLADE_SHAPE_HEAVYFLAIL:
         return (nSKLevel >= 15) && (hasMartialProf);
      case MBLADE_SHAPE_WHIP:
         return (nSKLevel >= 21) && (hasExoticProf);
      case MBLADE_SHAPE_2BLADESWORD:
         return (nSKLevel >= 20) && (hasExoticProf);
      case MBLADE_SHAPE_DOUBLEAXE:
         return (nSKLevel >= 20) && (hasExoticProf);
      case MBLADE_SHAPE_DIREMACE:
         return (nSKLevel >= 20) && (hasExoticProf);
      case MBLADE_SHAPE_SCYTHE:
         return (nSKLevel >= 19) && (hasExoticProf);
      case MBLADE_SHAPE_DWAXE:
         return (nSKLevel >= 18) && (hasExoticProf);
      case MBLADE_SHAPE_KAMA:
         return (nSKLevel >= 5) && (hasExoticProf || hasMonkProf);
      case MBLADE_SHAPE_SICKLE:
         return (nSKLevel >= 5) && (hasDruidProf);
      case MBLADE_SHAPE_QUARTERSTAFF:
         return (nSKLevel >= 4) && (hasSimpleProf || hasDruidProf || hasMonkProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_DART:
         return (nSKLevel >= 2) && (hasSimpleProf || hasDruidProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_SHURIKEN:
         return (nSKLevel >= 2) && (hasExoticProf);
// CEP Weapons
      case MBLADE_SHAPE_ASSASSINDAGGER: // prc_sk_mblade_ad      3
         return (nSKLevel >= 3) && (hasSimpleProf || hasDruidProf || hasMonkProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_CHAKRAM: // prc_sk_mblade_ck             5
         return (nSKLevel >= 5) && (hasMartialProf);
      case MBLADE_SHAPE_SPIKEDCHAIN: // prc_sk_mblade_ch         22
         return (nSKLevel >= 22) && hasExoticProf;
      case MBLADE_SHAPE_DOUBLESCIMITAR: // prc_sk_mblade_ds      20
         return (nSKLevel >= 20) && hasExoticProf;
      case MBLADE_SHAPE_FALCHION: // prc_sk_mblade_fa            8
         return (nSKLevel >= 8) && hasMartialProf;
      case MBLADE_SHAPE_GOAD: // prc_sk_mblade_go                6
         return (nSKLevel >= 6) && hasMartialProf;
      case MBLADE_SHAPE_HEAVYMACE: // prc_sk_mblade_hm           11
         return (nSKLevel >= 7) && (hasSimpleProf || hasRogueProf);
      case MBLADE_SHAPE_HEAVYPICK: // prc_sk_mblade_hp           12
         return (nSKLevel >= 12) && hasMartialProf;
      case MBLADE_SHAPE_KATAR: // prc_sk_mblade_kt               3
         return (nSKLevel >= 3) && (hasSimpleProf || hasDruidProf || hasMonkProf || hasRogueProf || hasWizardProf);
      case MBLADE_SHAPE_LIGHTPICK: // prc_sk_mblade_lp           2
         return (nSKLevel >= 2) && hasMartialProf;
      case MBLADE_SHAPE_MAUL: // prc_sk_mblade_ma                15
         return (nSKLevel >= 15) && hasMartialProf;
      case MBLADE_SHAPE_MERCGREATSWORD: // prc_sk_mblade_mg      21
         return (nSKLevel >= 21) && hasExoticProf;
      case MBLADE_SHAPE_MERCLONGSWORD: // prc_sk_mblade_ml       21
         return (nSKLevel >= 21) && hasExoticProf;
      case MBLADE_SHAPE_NUNCHUKAU: // prc_sk_mblade_nu           6
         return (nSKLevel >= 6) && (hasExoticProf || hasMonkProf);
      case MBLADE_SHAPE_SAI: // prc_sk_mblade_sa                 7
         return (nSKLevel >= 7) && (hasExoticProf || hasMonkProf);
      case MBLADE_SHAPE_SAP: // prc_sk_mblade_sp                 7
         return (nSKLevel >= 7) && (hasMartialProf || hasRogueProf);
      case MBLADE_SHAPE_TONFA: // prc_sk_mblade_to               2
         return (nSKLevel >= 2) && (hasExoticProf || hasMonkProf);
      case MBLADE_SHAPE_TRIDENT: // prc_sk_mblade_tr             9
         return (nSKLevel >= 9) && hasMartialProf;
      case MBLADE_SHAPE_WEIGHTEDCHAIN: // prc_sk_mblade_wc       22
         return (nSKLevel >= 22) && hasExoticProf;
      case MBLADE_SHAPE_WINDFIREWHEEL: // prc_sk_mblade_wf       3
         return (nSKLevel >= 3) && (hasExoticProf || hasMonkProf);

      default:
         logError("Unknown nShapeId passed to SoulknifeCanWield: " +
            IntToString(nShapeId));
    }
    return FALSE;
}

//void main() {} // Testing/compiling purposes
