//::///////////////////////////////////////////////
//:: Soulknife: Manifest Mindblade
//:: psi_sk_manifmbld
//::///////////////////////////////////////////////
/** @file Soulknife: Manifest Mindblade
    Handles creation of mindblades.


    @author Ornedan
    @date   Created  - 07.04.2005
    @date   Modified - 01.09.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_soulkn"
#include "inc_debug_dac"

int LOCAL_DEBUG = DEBUG;

int nImprovedCriticalFeat; // @DUG
int nOverwhelmingCriticalFeat; // @DUG
int nDevastatingCriticalFeat; // @DUG
int nWeaponSpecializationFeat; // @DUG
int nEpicWeaponFocusFeat; // @DUG
int nEpicWeaponSpecializationFeat; // @DUG
int nWeaponOfChoiceFeat; // @DUG

const string VAR_USE_DUAL_MINDBLADES = "SOULKNIFE_DUAL_WIELD";

// @DUG This is duplicated in dac_inc_soulkn.nss, because including
// psi_inc_soulkn.nss there causes the StartingConditional scripts
// (dac_sc_sk_*.nss) to not work.
// Custom Mindblade Shape                          Granted on level  Feats
const int MBLADE_SHAPE_CLUB = 23; // prc_sk_mblade_cl             1  SDMoRW
const int MBLADE_SHAPE_LIGHTHAMMER = 29; // prc_sk_mblade_lh      1  M
const int MBLADE_SHAPE_DAGGER = 5; // prc_sk_mblade_dg            2  SDMoRW
const int MBLADE_SHAPE_DART = 32; // prc_sk_mblade_td             2  SDRW
const int MBLADE_SHAPE_SHURIKEN = 33; // prc_sk_mblade_sh         2  E
//const int MBLADE_SHAPE_SHORTSWORD       = 0; // prc_sk_mblade_ss  3  MR
const int MBLADE_SHAPE_QUARTERSTAFF = 31; // prc_sk_mblade_qs     4  SDMoRW
//const int MBLADE_SHAPE_RANGED           = 4; // prc_sk_mblade_th  4  M
//const int MBLADE_SHAPE_DUAL_SHORTSWORDS = 1; // prc_sk_mblade_ss  4  MR
const int MBLADE_SHAPE_HANDAXE = 27; // prc_sk_mblade_hx          5  MMo
const int MBLADE_SHAPE_KAMA = 28; // prc_sk_mblade_km             5  EMo
const int MBLADE_SHAPE_SICKLE = 30; // prc_sk_mblade_si           5  D
const int MBLADE_SHAPE_LIGHTMACE = 13; // prc_sk_mblade_lm        6  SR
//const int MBLADE_SHAPE_LONGSWORD        = 2; // prc_sk_mblade_ls  7  M
const int MBLADE_SHAPE_SPEAR = 12; // prc_sk_mblade_sp            7  SD
const int MBLADE_SHAPE_LIGHTFLAIL = 14; // prc_sk_mblade_lf       7  M
const int MBLADE_SHAPE_MORNINGSTAR = 21; // prc_sk_mblade_ms      8  SR
const int MBLADE_SHAPE_KUKRI = 20; // prc_sk_mblade_ku            8  E
const int MBLADE_SHAPE_SCIMITAR = 10; // prc_sk_mblade_sc         9  MD
const int MBLADE_SHAPE_BATTLEAXE = 8; // prc_sk_mblade_ba         10 M
const int MBLADE_SHAPE_RAPIER = 11; // prc_sk_mblade_ra           11 MR
const int MBLADE_SHAPE_WARHAMMER = 24; // prc_sk_mblade_wh        12 M
//const int MBLADE_SHAPE_BASTARDSWORD     = 3; // prc_sk_mblade_bs  13 M
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

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oMbld    mindblade item
void BuildMindblade(object oPC, object oMbld, int nMbldType);


void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting psi_sk_manifmbld");
    object oPC = OBJECT_SELF;
    object oMbld;
    int nMbldType = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    int nHand = GetPersistantLocalInt(oPC, MBLADE_HAND);

    // If this is the very first time a PC is manifesting a mindblade, initialise the hand to be main hand
    if(!nHand)
    {
        nHand = INVENTORY_SLOT_RIGHTHAND;
        SetPersistantLocalInt(oPC, MBLADE_HAND, INVENTORY_SLOT_RIGHTHAND);
        if (!nMbldType) // @DUG and make it a club
        {
           SetPersistantLocalInt(oPC, MBLADE_SHAPE, MBLADE_SHAPE_CLUB); // @DUG
           nMbldType = MBLADE_SHAPE_CLUB; // @DUG
        }
    }

    // Generate the item based on type selection
    switch(nMbldType)
    {
        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: First of dual shortswords - ");
            // The first of dual mindblades always goes to mainhand
            nHand = INVENTORY_SLOT_RIGHTHAND;
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORT_SWORD; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORT_SWORD; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD; // @DUG
        case MBLADE_SHAPE_SHORTSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created shortsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORT_SWORD; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORT_SWORD; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD; // @DUG
            break;
        case MBLADE_SHAPE_LONGSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created longsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_ls", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONG_SWORD; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONG_SWORD; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD; // @DUG
            break;
        case MBLADE_SHAPE_BASTARDSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created bastardsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_bs", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARD_SWORD; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARD_SWORD; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_BASTARDSWORD; // @DUG
            if (GetHasFeat(FEAT_EPIC_SOULKNIFE, oPC)) // @DUG
            {
               // Epic Soulknife gains exotic proficiency
               AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
                  IP_CONST_FEAT_WEAPON_PROF_EXOTIC), oMbld);
            }
            break;
        case MBLADE_SHAPE_RANGED:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created throwing mindblade");
            // Create one more mindblade than needed in order to bypass the BW bug of the last thrown weapon in a stack no longer being a valid object in the OnHitCast script
            oMbld = CreateItemOnObject("prc_sk_mblade_th", oPC, (GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1) + 1);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWING_AXE; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWING_AXE; // @DUG
            nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons) // @DUG
            break;

        case MBLADE_SHAPE_DAGGER: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created dagger");
            oMbld = CreateItemOnObject("prc_sk_mblade_dg", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER;
            break;
        case MBLADE_SHAPE_GREATSWORD: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created greatsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_gs", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREAT_SWORD;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREAT_SWORD;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATSWORD;
            break;
        case MBLADE_SHAPE_2BLADESWORD: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created 2-bladed sword");
            oMbld = CreateItemOnObject("prc_sk_mblade_2b", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_TWO_BLADED_SWORD;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;
            break;
        case MBLADE_SHAPE_BATTLEAXE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created battleaxe");
            oMbld = CreateItemOnObject("prc_sk_mblade_ba", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BATTLE_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLE_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_BATTLEAXE;
            break;
        case MBLADE_SHAPE_GREATAXE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created greataxe");
            oMbld = CreateItemOnObject("prc_sk_mblade_ga", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREAT_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREAT_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATAXE;
            break;
        case MBLADE_SHAPE_SCIMITAR: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created scimitar");
            oMbld = CreateItemOnObject("prc_sk_mblade_sc", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SCIMITAR;
            break;
        case MBLADE_SHAPE_RAPIER: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created rapier");
            oMbld = CreateItemOnObject("prc_sk_mblade_ra", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_RAPIER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_RAPIER;
            break;
        case MBLADE_SHAPE_SPEAR: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created spear");
            oMbld = CreateItemOnObject("prc_sk_mblade_sp", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SPEAR;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SPEAR;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
            break;
        case MBLADE_SHAPE_LIGHTMACE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created light mace");
            oMbld = CreateItemOnObject("prc_sk_mblade_lm", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHT_MACE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHT_MACE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
            break;
        case MBLADE_SHAPE_LIGHTFLAIL: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created light flail");
            oMbld = CreateItemOnObject("prc_sk_mblade_lf", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHT_FLAIL;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
            break;
        case MBLADE_SHAPE_HALBERD: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created halberd");
            oMbld = CreateItemOnObject("prc_sk_mblade_ha", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HALBERD;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_HALBERD;
            break;
        case MBLADE_SHAPE_DIREMACE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created dire mace");
            oMbld = CreateItemOnObject("prc_sk_mblade_dm", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DIRE_MACE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DIRE_MACE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DIREMACE;
            break;
        case MBLADE_SHAPE_DOUBLEAXE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created double axe");
            oMbld = CreateItemOnObject("prc_sk_mblade_da", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DOUBLE_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLE_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DOUBLEAXE;
            break;
        case MBLADE_SHAPE_HEAVYFLAIL: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created heavy flail");
            oMbld = CreateItemOnObject("prc_sk_mblade_hf", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HEAVY_FLAIL;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;
            break;
        case MBLADE_SHAPE_KATANA: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created katana");
            oMbld = CreateItemOnObject("prc_sk_mblade_ka", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KATANA;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KATANA;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_KATANA;
            break;
        case MBLADE_SHAPE_KUKRI: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created kukri");
            oMbld = CreateItemOnObject("prc_sk_mblade_ku", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KUKRI;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_KUKRI;
            break;
        case MBLADE_SHAPE_MORNINGSTAR: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created morning star");
            oMbld = CreateItemOnObject("prc_sk_mblade_ms", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_MORNING_STAR;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_MORNING_STAR;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_MORNINGSTAR;
            break;
        case MBLADE_SHAPE_SCYTHE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created scythe");
            oMbld = CreateItemOnObject("prc_sk_mblade_sy", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCYTHE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SCYTHE;
            break;
        case MBLADE_SHAPE_CLUB: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created club");
            oMbld = CreateItemOnObject("prc_sk_mblade_cl", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_CLUB;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_CLUB;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_CLUB;
            break;
        case MBLADE_SHAPE_WARHAMMER: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created warhammer");
            oMbld = CreateItemOnObject("prc_sk_mblade_wh", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WAR_HAMMER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WAR_HAMMER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_WARHAMMER;
            break;
        case MBLADE_SHAPE_WHIP: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created whip");
            oMbld = CreateItemOnObject("prc_sk_mblade_wp", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WHIP;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_WHIP;
            break;
        case MBLADE_SHAPE_DWAXE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created dwarven waraxe");
            oMbld = CreateItemOnObject("prc_sk_mblade_dw", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DWAXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DWAXE;
            break;
        case MBLADE_SHAPE_HANDAXE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created handaxe");
            oMbld = CreateItemOnObject("prc_sk_mblade_hx", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HAND_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HAND_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_HANDAXE;
            break;
        case MBLADE_SHAPE_KAMA: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created kama");
            oMbld = CreateItemOnObject("prc_sk_mblade_km", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KAMA;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_KAMA;
            break;
        case MBLADE_SHAPE_LIGHTHAMMER: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created light hammer");
            oMbld = CreateItemOnObject("prc_sk_mblade_lh", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHT_HAMMER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER;
            break;
        case MBLADE_SHAPE_SICKLE: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created sickle");
            oMbld = CreateItemOnObject("prc_sk_mblade_si", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SICKLE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SICKLE;
            break;
        case MBLADE_SHAPE_QUARTERSTAFF: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created quarterstaff");
            oMbld = CreateItemOnObject("prc_sk_mblade_qs", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_STAFF;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_STAFF;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;
            break;
        case MBLADE_SHAPE_DART: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created darts");
            // Create one more mindblade than needed in order to bypass the BW bug of the last thrown weapon in a stack no longer being a valid object in the OnHitCast script
            oMbld = CreateItemOnObject("prc_sk_mblade_td", oPC, (GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1) + 1);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DART;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DART;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DART;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DART;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DART;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DART;
            nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons) // @DUG
            break;
        case MBLADE_SHAPE_SHURIKEN: // @DUG
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created shuriken");
            // Create one more mindblade than needed in order to bypass the BW bug of the last thrown weapon in a stack no longer being a valid object in the OnHitCast script
            oMbld = CreateItemOnObject("prc_sk_mblade_sh", oPC, (GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1) + 1);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHURIKEN;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHURIKEN;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN;
            nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons) // @DUG
            break;
         case MBLADE_SHAPE_ASSASSINDAGGER:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created assassin dagger");
            oMbld = CreateItemOnObject("prc_sk_mblade_ad", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER;
            break;
         case MBLADE_SHAPE_CHAKRAM: // prc_sk_mblade_ck             5
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created chakram");
            // Create one more mindblade than needed in order to bypass the BW bug of the last thrown weapon in a stack no longer being a valid object in the OnHitCast script
            oMbld = CreateItemOnObject("prc_sk_mblade_ck", oPC, (GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1) + 1);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWING_AXE; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWING_AXE; // @DUG
            nWeaponOfChoiceFeat = -1; // (W-o-C not valid for non-melee weapons) // @DUG
            break;
         case MBLADE_SHAPE_SPIKEDCHAIN: // prc_sk_mblade_ch         22
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created spiked chain");
            oMbld = CreateItemOnObject("prc_sk_mblade_ch", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WHIP;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_WHIP;
            break;
         case MBLADE_SHAPE_DOUBLESCIMITAR: // prc_sk_mblade_ds      28
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created double scimitar");
            oMbld = CreateItemOnObject("prc_sk_mblade_ds", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_TWO_BLADED_SWORD;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;
            break;
         case MBLADE_SHAPE_FALCHION: // prc_sk_mblade_fa            8
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created falchion");
            oMbld = CreateItemOnObject("prc_sk_mblade_fa", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCIMITAR; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SCIMITAR; // @DUG
            break;
         case MBLADE_SHAPE_GOAD: // prc_sk_mblade_go                6
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created goad");
            oMbld = CreateItemOnObject("prc_sk_mblade_go", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_RAPIER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_RAPIER;
            break;
         case MBLADE_SHAPE_HEAVYMACE: // prc_sk_mblade_hm           11
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created heavy mace");
            oMbld = CreateItemOnObject("prc_sk_mblade_hm", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHT_MACE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHT_MACE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
            break;
         case MBLADE_SHAPE_HEAVYPICK: // prc_sk_mblade_hp           15
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created heavy pick");
            oMbld = CreateItemOnObject("prc_sk_mblade_hp", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREAT_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREAT_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATAXE;
            break;
         case MBLADE_SHAPE_KATAR: // prc_sk_mblade_kt               3
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created katar");
            oMbld = CreateItemOnObject("prc_sk_mblade_kt", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER;
            break;
         case MBLADE_SHAPE_LIGHTPICK: // prc_sk_mblade_lp           6
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created light pick");
            oMbld = CreateItemOnObject("prc_sk_mblade_lp", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HAND_AXE;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HAND_AXE;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_HANDAXE;
            break;
         case MBLADE_SHAPE_MAUL: // prc_sk_mblade_ma                19
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created maul");
            oMbld = CreateItemOnObject("prc_sk_mblade_ma", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WAR_HAMMER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WAR_HAMMER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_WARHAMMER;
            break;
         case MBLADE_SHAPE_MERCGREATSWORD: // prc_sk_mblade_mg      30
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created mercurial greatsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_mg", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREAT_SWORD;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREAT_SWORD;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATSWORD;
            break;
         case MBLADE_SHAPE_MERCLONGSWORD: // prc_sk_mblade_ml       29
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created mercurial longsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_ml", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD; // @DUG
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD; // @DUG
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD; // @DUG
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD; // @DUG
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONG_SWORD; // @DUG
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONG_SWORD; // @DUG
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD; // @DUG
            break;
         case MBLADE_SHAPE_NUNCHUKAU: // prc_sk_mblade_nu           6
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created nunchukau");
            oMbld = CreateItemOnObject("prc_sk_mblade_nu", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KAMA;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_KAMA;
            break;
         case MBLADE_SHAPE_SAI: // prc_sk_mblade_sa                 7
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created sai");
            oMbld = CreateItemOnObject("prc_sk_mblade_sa", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER;
            break;
         case MBLADE_SHAPE_SAP: // prc_sk_mblade_s                  7
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created sap");
            oMbld = CreateItemOnObject("prc_sk_mblade_s", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHT_FLAIL;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
            break;
         case MBLADE_SHAPE_TONFA: // prc_sk_mblade_to               2
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created tonfa");
            oMbld = CreateItemOnObject("prc_sk_mblade_to", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KAMA;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_KAMA;
            break;
         case MBLADE_SHAPE_TRIDENT: // prc_sk_mblade_tr             9
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created trident");
            oMbld = CreateItemOnObject("prc_sk_mblade_tr", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SPEAR;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SPEAR;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
            break;
         case MBLADE_SHAPE_WEIGHTEDCHAIN: // prc_sk_mblade_wc       22
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created weighted chain");
            oMbld = CreateItemOnObject("prc_sk_mblade_wc", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WHIP;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_WHIP;
            break;
         case MBLADE_SHAPE_WINDFIREWHEEL: // prc_sk_mblade_wf       3
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created wind fire wheel");
            oMbld = CreateItemOnObject("prc_sk_mblade_wf", oPC);
            nImprovedCriticalFeat = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER;
            nOverwhelmingCriticalFeat = IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
            nDevastatingCriticalFeat = IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
            nWeaponSpecializationFeat = IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER;
            nEpicWeaponFocusFeat = IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER;
            nEpicWeaponSpecializationFeat = IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
            nWeaponOfChoiceFeat = IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER;
            break;

        default:
            WriteTimestampedLogEntry("Invalid value in MBLADE_SHAPE for " + GetName(oPC) + ": " + IntToString(nMbldType));
            return;
    }

    // Construct the bonuses
    /*DelayCommand(0.25f, */BuildMindblade(oPC, oMbld, nMbldType)/*)*/;

    // check for existing one before equipping and destroy
    if(GetStringLeft(GetTag(GetItemInSlot(nHand, oPC)), 14) == "prc_sk_mblade_")
            MyDestroyObject(GetItemInSlot(nHand, oPC));
    // Force equip
    AssignCommand(oPC, ActionEquipItem(oMbld, nHand));

    // Hook the mindblade into OnHit event
    AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

    // Make even more sure the mindblade cannot be dropped
    SetDroppableFlag(oMbld, FALSE);
    SetItemCursedFlag(oMbld, TRUE);

    // Generate the second mindblade if set to dual shortswords
    if(nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS)
    {
        oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);

        //SendMessageToPC(oPC, "psi_sk_manifmbld: Created second mindblade - is valid: " + (GetIsObjectValid(oMbld) ? "TRUE":"FALSE"));

        DelayCommand(0.5f, BuildMindblade(oPC, oMbld, nMbldType)); // Delay a bit to prevent a lag spike
        //BuildMindblade(oPC, oMbld, nMbldType);
        AssignCommand(oPC, ActionDoCommand(ActionEquipItem(oMbld, INVENTORY_SLOT_LEFTHAND)));
        //AssignCommand(oPC, ActionEquipItem(oMbld, INVENTORY_SLOT_LEFTHAND));
        AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

        SetDroppableFlag(oMbld, FALSE);
        SetItemCursedFlag(oMbld, TRUE);
    }
    // Not dual-wielding, so delete the second mindblade if they have such
    else
    {
        // Get the other hand
        int nOtherHand;
        if(nHand == INVENTORY_SLOT_RIGHTHAND)
            nOtherHand = INVENTORY_SLOT_LEFTHAND;
        else
            nOtherHand = INVENTORY_SLOT_RIGHTHAND;
        // Check it's contents and take action if necessary
        if(GetStringLeft(GetTag(GetItemInSlot(nOtherHand, oPC)), 14) == "prc_sk_mblade_")
            MyDestroyObject(GetItemInSlot(nOtherHand, oPC));
    }

   // @DUG Soulknife Dual-Wield using the dialog
   if (GetPersistantLocalInt(oPC, VAR_USE_DUAL_MINDBLADES))
   {
      //debug("Using dual mindblades");
      object oLeft = CreateItemOnObject(GetResRef(oMbld), oPC);

      //SendMessageToPC(oPC, "psi_sk_manifmbld: Created second mindblade - is valid: " + (GetIsObjectValid(oLeft) ? "TRUE":"FALSE"));

      DelayCommand(0.5f, BuildMindblade(oPC, oLeft, nMbldType)); // Delay a bit to prevent a lag spike
      //BuildMindblade(oPC, oLeft, nMbldType);
      AssignCommand(oPC, ActionDoCommand(ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND)));
      //AssignCommand(oPC, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND));
      AddEventScript(oLeft, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

      SetDroppableFlag(oLeft, FALSE);
      SetItemCursedFlag(oLeft, TRUE);
   }
   else
   {
      // Get the other hand
      int nOtherHand = (nHand == INVENTORY_SLOT_RIGHTHAND ?
         INVENTORY_SLOT_LEFTHAND : INVENTORY_SLOT_RIGHTHAND);
      // Check its contents and take action if necessary
      if (GetStringLeft(GetTag(GetItemInSlot(nOtherHand, oPC)), 14) ==
         "prc_sk_mblade_")
      {
         MyDestroyObject(GetItemInSlot(nOtherHand, oPC));
      }
   }

/* Now in their own script - psi_sk_clseval
    // Hook psi_sk_event to the mindblade-related events it handles
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONUNAQUIREITEM,      "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERDEATH,       "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN,   "psi_sk_event", TRUE, FALSE);
*/
    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished psi_sk_manifmbld")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}


void BuildMindblade(object oPC, object oMbld, int nMbldType)
{
    /* Add normal stuff and VFX */
    /// Add enhancement bonus
    int nSKLevel = GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC);
    int nEnh;
    // The first actual enhancement bonus is gained at L4, but the mindblade needs to
    // have enhancement right from the beginning to pierce DR as per being magical
    if(nSKLevel < 4)
    {
        nEnh = 1;
        // The mindblade being magical should grant no benefits to attack or damage
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackPenalty(1), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamagePenalty(1), oMbld);
    }
    else
    {
        nEnh = nSKLevel <= 20 ?
                nSKLevel / 4:            // Boni are granget +1 / 4 levels pre-epic
                (nSKLevel - 20) / 5 + 5; // Boni are granted +1 / 5 levels epic

nEnh = nSKLevel / 4; // @DUG fuck that, I want my +10 mindblade!

        // Dual mindblades have one lower bonus
       if (GetPersistantLocalInt(oPC, VAR_USE_DUAL_MINDBLADES)) nEnh -= 1; else // @DUG
        nEnh -= nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS ? 1 : 0;

    }
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEnh), oMbld);
    // In case of bastard sword, store the enhancement bonus for later for use in the 2-h handling code
    if(nMbldType == MBLADE_SHAPE_BASTARDSWORD)
        SetLocalInt(oMbld, "PRC_SK_BSwd_EnhBonus", nEnh);

    // Handle Greater Weapon Focus (mindblade) here. It grants +1 to attack with any shape of mindblade.
    // Because of stacking issues, the actual value granted is enhancement bonus + 1.
    if(GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(nEnh + 1), oMbld);

    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
                                                                       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
                                                                        ITEM_VISUAL_SONIC
                                                                      ), oMbld);

    /* Add in common feats */
    //string sTag = GetTag(oMbld);
    // For the purposes of the rest of this function, dual shortswords is the same as single shortsword
    if(nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS) nMbldType = MBLADE_SHAPE_SHORTSWORD;

    // Weapon Focus
    /* Every soulknife has this, so it's automatically on the weapons now. Uncomment if for some reason another class with the mindblade class feature is added
    if(GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_FOCUS_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);*/
    // Improved Critical
    if (GetHasFeat(FEAT_IMPROVED_CRITICAL_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nImprovedCriticalFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE
                                                                      ), oMbld);
@DUG */
    // Overwhelming Critical
    if (GetHasFeat(FEAT_OVERWHELMING_CRITICAL_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nOverwhelmingCriticalFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD :
                                                                                                                IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
@DUG */
    // Devastating Critical
    if (GetHasFeat(FEAT_DEVASTATING_CRITICAL_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nDevastatingCriticalFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD :
                                                                                                                IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
@DUG */
    // Weapon Specialization
    if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nWeaponSpecializationFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
@DUG */
    // Epic Weapon Focus
    if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nEpicWeaponFocusFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);
@DUG */
    // Epic Weapon Specialization
    if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nEpicWeaponSpecializationFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
@DUG */
    // Weapon of Choice
    if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_MINDBLADE, oPC)) // @DUG
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(
           nWeaponOfChoiceFeat), oMbld);
    }
/* @DUG
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_OF_CHOICE_BASTARDSWORD :
                                                                                                                -1 // This shouldn't ever be reached
                                                                      ), oMbld);
@DUG */

    // Bladewind: Due to some moron @ BioWare, calls to DoWhirlwindAttack() do not do anything if one
    // does not have the feat. Therefore, we need to grant it as a bonus feat on the blade.
    if(GetHasFeat(FEAT_BLADEWIND, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND), oMbld);


    /* Apply the enhancements */
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

    if(nFlags & MBLADE_FLAG_LUCKY)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MINDBLADE_LUCKY, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oMbld);
    }
    if(nFlags & MBLADE_FLAG_DEFENDING)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oMbld);
    }
    if(nFlags & MBLADE_FLAG_KEEN)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_VICIOUS)
    { OnHit
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETIC && !(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST)) // Only Psychokinetic
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        bLight = TRUE;
    }
    if(nFlags & MBLADE_FLAG_MIGHTYCLEAVING)
    {
        if(GetHasFeat(FEAT_CLEAVE, oPC))
            AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_CLEAVE), oMbld);
        else
            AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE), oMbld);
    }
    if(nFlags & MBLADE_FLAG_COLLISION)
    {
        if(LOCAL_DEBUG) DoDebug("Added Collision damage", oPC);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_5), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_MINDCRUSHER )
    { OnHit
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST && !(nFlags & MBLADE_FLAG_PSYCHOKINETIC)) // Only Psychokinetic Burst
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6), oMbld);
        bLight = TRUE;
    }
    /*if(nFlags & MBLADE_FLAG_SUPPRESSION)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_WOUNDING)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_DISRUPTING)
    { OnHit
    }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)
    {
    }*/
    if((nFlags & MBLADE_FLAG_PSYCHOKINETICBURST) && (nFlags & MBLADE_FLAG_PSYCHOKINETIC)) // Both Psychokinetic and Psychokinetic Burst
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d4), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6), oMbld);
        bLight = TRUE;
    }

    if(bLight)
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE), oMbld);
}
