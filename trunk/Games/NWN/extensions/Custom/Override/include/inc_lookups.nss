/*

    This file is used for lookup functions for psionics and newspellbooks
    It is supposed to reduce the need for large loops that may result in
    TMI errors.
    It does this by creating arrays in advance and the using those as direct
    lookups.
*/

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

//nClass is the class to do this for
//nMin is the row to start at
//sSourceColumn is the column you want to lookup by
//sDestComumn is the column you want returned
//sVarNameBase is the root of the variables and tag of token
//nLoopSize is the number of rows per call
void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn,
    string sDestColumn, string sVarNameBase, int nLoopSize = 100, string sTag = "");

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase,
    string sColumnName, string sColumnValue, int nLoopSize = 100, string sTag = "");

void MakeSpellIDLoop(int nClass, int nMin, int nMax, string sRealColumn,
    string sVarNameBase, int nLoopSize = 100, string sTag = "", int nTemp = 0);

//this returns the real SpellID of "wrapper" spells cast by psionic or the new spellbooks
int GetPowerFromSpellID(int nSpellID);

/**
 * Maps spells.2da rows of the class-specific entries to corresponding cls_psipw_*.2da rows.
 *
 * @param nSpellID Spells.2da row to determine cls_psipw_*.2da row for
 * @return         The mapped value
 */
int GetPowerfileIndexFromSpellID(int nSpellID);

//this retuns the featID of the class-specific feat for a spellID
//useful for psionics GetHasPower function
int GetClassFeatFromPower(int nPowerID, int nClass);

/**
 * Determines cls_spell_*.2da index from a given new spellbook class-specific
 * spell spells.2da index.
 *
 * @param nSpell The class-specific spell to find cls_spell_*.2da index for
 * @return       The cls_spell_*.2da index in whichever class's file that the
 *               given spell belongs to.
 *               If the spell at nSpell isn't a newspellbook class-specific spell,
 *               returns -1 instead.
 */
int SpellToSpellbookID(int nSpell);

/**
 * Determines cls_spell_*.2da index from a given spells.2da index.
 *
 * @param nClass The class in whose spellbook to search in
 * @param nSpell The spell to search for
 * @return       The cls_spell_*.2da index in whichever class's file that the
 *               given spell belongs to.
 *               If nSpell does not exist within the spellbook,
 *               returns -1 instead.
 */
int RealSpellToSpellbookID(int nClass, int nSpell);

/**
 * Determines number of metamagics from a given spells.2da index.
 *
 * @param nClass The class in whose spellbook to search in
 * @param nSpell The spell to search for
 * @return       The number of metamagics in cls_spell_*.2da
 *               for a particular spell.
 */
int RealSpellToSpellbookIDCount(int nClass, int nSpell);

/**
 * Determines the name of the 2da file that defines the number of alternate magic
 * system powers/spells/whathaveyou known, maximum level of such known and
 * number of uses at each level of the given class. And possibly related things
 * that apply to that specific system.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the powers known 2da name of
 * @return       The name of the given class's powers known 2da
 */
string GetAMSKnownFileName(int nClass);

/**
 * Determines the name of the 2da file that lists the powers/spells/whathaveyou
 * on the given class's list of such.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the power list 2da name of
 * @return       The name of the given class's power list 2da
 */
string GetAMSDefinitionFileName(int nClass);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_utility"
#include "prc_class_const"


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

object _inc_lookups_GetCacheObject(string sTag)
{
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                                  GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                                  GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        // Some inventory shuffle, probably? - Ornedan
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);

        if(!GetIsObjectValid(oWP))
        {
            DoDebug("ERROR: Failed to create lookup storage token for " + sTag);
            return OBJECT_INVALID;
        }
    }

    return oWP;
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void MakeLookupLoopMaster()
{
    //now the loops
    DelayCommand(1.0, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.2, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSION)));
    DelayCommand(1.3, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(1.4, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.6, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSYWAR)));
    DelayCommand(1.7, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(1.8, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.0, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WILDER)));
    DelayCommand(2.1, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(2.2, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.4, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_FIST_OF_ZUOKEN)));
    DelayCommand(2.5, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WARMIND)));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    // The Truenamer uses the same lookup loop style as the psionic classes. Time adjusted to put it after the last of the caster lookup loops
    DelayCommand(7.3, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.5, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_TRUENAMER)));
    DelayCommand(7.6, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    // Tome of Battle uses the same lookup loop style as the psionic classes. Time adjusted to put it after the last of the caster lookup loops
    DelayCommand(11.3, MakeLookupLoop(CLASS_TYPE_CRUSADER,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(11.4, MakeLookupLoop(CLASS_TYPE_CRUSADER,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_CRUSADER)));
    DelayCommand(11.5, MakeLookupLoop(CLASS_TYPE_CRUSADER,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(11.6, MakeLookupLoop(CLASS_TYPE_SWORDSAGE,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(11.7, MakeLookupLoop(CLASS_TYPE_SWORDSAGE,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_SWORDSAGE)));
    DelayCommand(11.8, MakeLookupLoop(CLASS_TYPE_SWORDSAGE,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(11.9, MakeLookupLoop(CLASS_TYPE_WARBLADE,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(12.0, MakeLookupLoop(CLASS_TYPE_WARBLADE,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WARBLADE)));
    DelayCommand(12.1, MakeLookupLoop(CLASS_TYPE_WARBLADE,         0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    // Invokers use the same lookup loop style as the psionic classes. Time adjusted to put it after the last of the caster lookup loops
    DelayCommand(13.4, MakeLookupLoop(CLASS_TYPE_DRAGONFIRE_ADEPT, 0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(13.5, MakeLookupLoop(CLASS_TYPE_DRAGONFIRE_ADEPT, 0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_DRAGONFIRE_ADEPT)));
    DelayCommand(13.6, MakeLookupLoop(CLASS_TYPE_DRAGONFIRE_ADEPT, 0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(13.7, MakeLookupLoop(CLASS_TYPE_WARLOCK,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(13.8, MakeLookupLoop(CLASS_TYPE_WARLOCK,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WARLOCK)));
    DelayCommand(13.9, MakeLookupLoop(CLASS_TYPE_WARLOCK,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(14.1, MakeSpellbookLevelLoop(CLASS_TYPE_WARLOCK,  0, GetPRCSwitch(FILE_END_CLASS_POWER) , "SpellLvl", "Level", "1"));
    DelayCommand(14.1, MakeSpellbookLevelLoop(CLASS_TYPE_WARLOCK,  0, GetPRCSwitch(FILE_END_CLASS_POWER) , "SpellLvl", "Level", "2"));
    DelayCommand(14.1, MakeSpellbookLevelLoop(CLASS_TYPE_WARLOCK,  0, GetPRCSwitch(FILE_END_CLASS_POWER) , "SpellLvl", "Level", "3"));
    DelayCommand(14.1, MakeSpellbookLevelLoop(CLASS_TYPE_WARLOCK,  0, GetPRCSwitch(FILE_END_CLASS_POWER) , "SpellLvl", "Level", "4"));

    //add new psionic classes here
    //also add them later too

    //new spellbook lookups
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.4, MakeLookupLoop(CLASS_TYPE_ASSASSIN,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.5, MakeLookupLoop(CLASS_TYPE_SUEL_ARCHANAMACH,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SHADOWLORD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_BARD,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SORCERER,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.2, MakeLookupLoop(CLASS_TYPE_FAVOURED_SOUL,       0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.8, MakeLookupLoop(CLASS_TYPE_HEXBLADE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.8, MakeLookupLoop(CLASS_TYPE_SOHEI,               0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(8.8, MakeLookupLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(9.4, MakeLookupLoop(CLASS_TYPE_DUSKBLADE,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(10.1, MakeLookupLoop(CLASS_TYPE_HEALER,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(11.3, MakeLookupLoop(CLASS_TYPE_WARMAGE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(12.2, MakeLookupLoop(CLASS_TYPE_SHAMAN,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(13.5, MakeLookupLoop(CLASS_TYPE_JUSTICEWW,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));

    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.4, MakeLookupLoop(CLASS_TYPE_ASSASSIN,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.5, MakeLookupLoop(CLASS_TYPE_SUEL_ARCHANAMACH,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SHADOWLORD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_BARD,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SORCERER,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.2, MakeLookupLoop(CLASS_TYPE_FAVOURED_SOUL,       0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(7.9, MakeLookupLoop(CLASS_TYPE_HEXBLADE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(7.9, MakeLookupLoop(CLASS_TYPE_SOHEI,               0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(8.9, MakeLookupLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(9.5, MakeLookupLoop(CLASS_TYPE_DUSKBLADE,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(10.2, MakeLookupLoop(CLASS_TYPE_HEALER,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(11.4, MakeLookupLoop(CLASS_TYPE_WARMAGE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(12.3, MakeLookupLoop(CLASS_TYPE_SHAMAN,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(13.2, MakeLookupLoop(CLASS_TYPE_JUSTICEWW,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));

    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.2, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.3, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.4, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.5, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.6, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(4.7, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(4.8, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.9, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(5.0, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(5.1, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(5.2, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(5.3, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(5.4, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(5.5, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(5.6, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(5.7, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(5.8, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(5.9, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(6.0, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(6.1, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(6.2, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(6.3, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(6.4, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(6.5, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(6.6, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(6.7, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(6.8, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(6.9, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(7.0, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(7.1, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(7.2, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(8.0, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(8.1, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(8.2, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(8.3, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(8.4, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(8.5, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(8.6, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(8.7, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(9.0, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(9.1, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(9.2, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(9.3, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(9.6, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(9.7, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(9.8, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(9.9, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(10.0, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(11.3, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(10.3, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(10.4, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(10.5, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(10.6, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(10.7, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(10.8, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(10.9, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(11.0, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(11.1, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(11.2, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(10.3, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(10.4, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(10.5, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(10.6, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(10.7, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(10.8, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(10.9, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(11.0, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(11.1, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(11.2, MakeSpellbookLevelLoop(CLASS_TYPE_WARMAGE,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(12.4, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(12.5, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(12.6, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(12.7, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(12.8, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(12.9, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(13.0, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(13.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(13.2, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(13.3, MakeSpellbookLevelLoop(CLASS_TYPE_SHAMAN,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(13.4, MakeSpellbookLevelLoop(CLASS_TYPE_JUSTICEWW,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(13.5, MakeSpellbookLevelLoop(CLASS_TYPE_JUSTICEWW,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(13.6, MakeSpellbookLevelLoop(CLASS_TYPE_JUSTICEWW,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(13.7, MakeSpellbookLevelLoop(CLASS_TYPE_JUSTICEWW,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));

    DelayCommand(3.0, MakeSpellIDLoop(CLASS_TYPE_BLACKGUARD,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.1, MakeSpellIDLoop(CLASS_TYPE_ANTI_PALADIN,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.2, MakeSpellIDLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.3, MakeSpellIDLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.4, MakeSpellIDLoop(CLASS_TYPE_KNIGHT_CHALICE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.5, MakeSpellIDLoop(CLASS_TYPE_VIGILANT,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.6, MakeSpellIDLoop(CLASS_TYPE_VASSAL,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.7, MakeSpellIDLoop(CLASS_TYPE_OCULAR,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.8, MakeSpellIDLoop(CLASS_TYPE_ASSASSIN,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(3.9, MakeSpellIDLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.0, MakeSpellIDLoop(CLASS_TYPE_SHADOWLORD,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.1, MakeSpellIDLoop(CLASS_TYPE_BARD,                  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.2, MakeSpellIDLoop(CLASS_TYPE_SORCERER,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.3, MakeSpellIDLoop(CLASS_TYPE_FAVOURED_SOUL,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.4, MakeSpellIDLoop(CLASS_TYPE_HEXBLADE,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.5, MakeSpellIDLoop(CLASS_TYPE_SOHEI,                 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.6, MakeSpellIDLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.7, MakeSpellIDLoop(CLASS_TYPE_DUSKBLADE,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.8, MakeSpellIDLoop(CLASS_TYPE_HEALER,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(4.9, MakeSpellIDLoop(CLASS_TYPE_WARMAGE,               0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(5.0, MakeSpellIDLoop(CLASS_TYPE_SHAMAN,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    DelayCommand(5.1, MakeSpellIDLoop(CLASS_TYPE_JUSTICEWW,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "RealSpellID", "GetRowFromRealSpellID"));
    }

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase,
    string sColumnName, string sColumnValue, int nLoopSize = 100, string sTag = "")
{
/* @DUG
    if(DEBUG) DoDebug("MakeSpellbookLevelLoop("
                 +IntToString(nClass)+", "
                 +IntToString(nMin)+", "
                 +IntToString(nMax)+", "
                 +sVarNameBase+", "
                 +sColumnName+", "
                 +sColumnValue+", "
                 +IntToString(nLoopSize)+", "
                 +") : sTag = "+sTag);
@DUG */

    /// Determine the 2da to use
    int bNewSpellbook = FALSE;
    string sFile;
    // Stuff handled in GetAMSDefinitionFileName()
    if(nClass == CLASS_TYPE_PSION            ||
       nClass == CLASS_TYPE_PSYWAR           ||
       nClass == CLASS_TYPE_WILDER           ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN   ||
       nClass == CLASS_TYPE_WARMIND          ||
       // Add new psionic classes here

       // Tome of Battle
       nClass == CLASS_TYPE_CRUSADER         ||
       nClass == CLASS_TYPE_SWORDSAGE        ||
       nClass == CLASS_TYPE_WARBLADE         ||
       // Other new caster types
       nClass == CLASS_TYPE_TRUENAMER        ||
       //Invocation
       nClass == CLASS_TYPE_DRAGONFIRE_ADEPT ||
       nClass == CLASS_TYPE_WARLOCK
       )
        sFile = GetAMSDefinitionFileName(nClass);
    // New spellbook class
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        //sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
        sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
        bNewSpellbook = TRUE;
    }

    // If on the first iteration, generate the storage token tag
    if(sTag == "")
        sTag = sVarNameBase + "_" + IntToString(nClass) + "_" + sColumnName + "_" + sColumnValue;

    // Get the token to store the lookup table on. The token is piggybacked in the 2da cache creature's inventory
    object oToken = _inc_lookups_GetCacheObject(sTag);
    // Failed to obtain a valid token - nothing to store on
    if(!GetIsObjectValid(oToken))
        return;

    // Starting a new run and the array exists already. Assume the whole thing is present and abort
    if(nMin == 0 && array_exists(oToken, "Lkup"))
    {
        // @DUG DoDebug("MakeSpellbookLevelLoop("+sTag+") restored from database");
        return;
    }

    // New run, create the array
    if(nMin == 0)
        array_create(oToken, "Lkup");

    // Cache loopsize rows
    int i;
    for(i = nMin; i < nMin + nLoopSize; i++)
    {
        // None of the relevant 2da files have blank Label entries on rows other than 0. We can assume i is greater than 0 at this point
        if(i > 0 && Get2DAString(sFile, "Label", i) == "") // Using Get2DAString() instead of Get2DACache() to avoid caching useless data
            return;

        if(Get2DACache(sFile, sColumnName, i) == sColumnValue &&
           (!bNewSpellbook ||Get2DACache(sFile, "ReqFeat", i) == "") // Only new spellbooks have the ReqFeat column. No sense in caching it for other stuff
           )
        {
            array_set_int(oToken, "Lkup", array_get_size(oToken, "Lkup"), i);
        }
    }

    // And delay continuation to avoid TMI
    if(i < nMax)
        DelayCommand(0.0, MakeSpellbookLevelLoop(nClass, i, nMax, sVarNameBase, sColumnName, sColumnValue, nLoopSize, sTag));
}

void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn,
    string sDestColumn, string sVarNameBase, int nLoopSize = 100, string sTag = "")
{
/* @DUG
    if(DEBUG) DoDebug("MakeLookupLoop("
                 +IntToString(nClass)+", "
                 +IntToString(nMin)+", "
                 +IntToString(nMax)+", "
                 +sSourceColumn+", "
                 +sDestColumn+", "
                 +sVarNameBase+", "
                 +IntToString(nLoopSize)+", "
                 +") : sTag = "+sTag);
@DUG */

    string sFile;
    // Stuff handled in GetAMSDefinitionFileName()
    if(nClass == CLASS_TYPE_PSION            ||
       nClass == CLASS_TYPE_PSYWAR           ||
       nClass == CLASS_TYPE_WILDER           ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN   ||
       nClass == CLASS_TYPE_WARMIND          ||
       // Add new psionic classes here

       // Tome of Battle
       nClass == CLASS_TYPE_CRUSADER         ||
       nClass == CLASS_TYPE_SWORDSAGE        ||
       nClass == CLASS_TYPE_WARBLADE         ||
       // Other new caster types
       nClass == CLASS_TYPE_TRUENAMER        ||
       //Invocation
       nClass == CLASS_TYPE_DRAGONFIRE_ADEPT ||
       nClass == CLASS_TYPE_WARLOCK
       )
        sFile = GetAMSDefinitionFileName(nClass);
    // New spellbook class
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        //sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
        sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    }

    // If on the first iteration, generate the storage token tag
    if(sTag == "")
        sTag = "PRC_" + sVarNameBase;

    // Get the token to store the lookup table on. The token is piggybacked in the 2da cache creature's inventory
    object oToken = _inc_lookups_GetCacheObject(sTag);
    // Failed to obtain a valid token - nothing to store on
    if(!GetIsObjectValid(oToken))
        return;

    // Starting a new run and the data is present already. Assume the whole thing is present and abort
    if(nMin == 0
        && GetLocalInt(oToken, /*sTag + "_" + */IntToString(StringToInt(Get2DACache(sFile, sSourceColumn, nMin + 1)))))//+1 cos 0 is always null
    {
        // @DUG DoDebug("MakeLookupLoop("+sTag+") restored from database");
        return;
    }

    int i;
    int nSource, nDest;
    for(i = nMin; i < nMin + nLoopSize; i++)
    {
        // None of the relevant 2da files have blank Label entries on rows other than 0. We can assume i is greater than 0 at this point
        if(i > 0 && Get2DAString(sFile, "Label", i) == "") // Using Get2DAString() instead of Get2DACache() to avoid caching extra
            return;

        // In case of blank source or destination column, use current row index
        // Otherwise, read the relevant data from the 2da and convert it to an integer - we assume that the 2da data is numeral
        if(sSourceColumn == "") nSource = i;
        else                    nSource = StringToInt(Get2DACache(sFile, sSourceColumn, i));

        if(sDestColumn == "") nDest = i;
        else                  nDest = StringToInt(Get2DACache(sFile, sDestColumn, i));

        // Skip storing invalid values. The source column value should always be non-zero in valid cases.
        // The destination column value might be zero in some cases. However, due to non-presence = 0, it works out OK.
        if(nSource != 0 && nDest != 0)
        {
            if(DEBUG) Assert(!GetLocalInt(oToken, IntToString(nSource)) || (GetLocalInt(oToken, IntToString(nSource)) == nDest),
                             "!GetLocalInt(" + DebugObject2Str(oToken) + ", IntToString(" + IntToString(nSource) + ")) || GetLocalInt(" + DebugObject2Str(oToken) + ", IntToString(" + IntToString(nSource) + ")) == " + IntToString(nDest) + ")\n"
                           + " = !" + IntToString(GetLocalInt(oToken, IntToString(nSource))) + " || " + IntToString(GetLocalInt(oToken, IntToString(nSource))) + " == " + IntToString(nDest)
                             ,
                             "sFile = " + sFile + "\n"
                           + "i = " + IntToString(i)
                           + "sSourceColumn = " + sSourceColumn + "\n"
                           + "sDestColumn = " + sDestColumn
                             , "inc_lookups", "MakeLookupLoop");
            SetLocalInt(oToken, /*sTag + "_" + */IntToString(nSource), nDest);
        }
    }

    // And delay continuation to avoid TMI
    if(i < nMax)
        DelayCommand(0.0, MakeLookupLoop(nClass, i, nMax, sSourceColumn, sDestColumn, sVarNameBase, nLoopSize, sTag));
}

void MakeSpellIDLoop(int nClass, int nMin, int nMax, string sRealColumn,
    string sVarNameBase, int nLoopSize = 100, string sTag = "", int nTemp = 0)
{
/* @DUG
    if(DEBUG) DoDebug("MakeSpellIDLoop("
                 +IntToString(nClass)+", "
                 +IntToString(nMin)+", "
                 +IntToString(nMax)+", "
                 +sRealColumn+", "
                 +sVarNameBase+", "
                 +IntToString(nLoopSize)+", "
                 +") : sTag = "+sTag);
@DUG */

    string sFile;
    // Stuff handled in GetAMSDefinitionFileName()
    if(nClass == CLASS_TYPE_PSION            ||
       nClass == CLASS_TYPE_PSYWAR           ||
       nClass == CLASS_TYPE_WILDER           ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN   ||
       nClass == CLASS_TYPE_WARMIND          ||
       // Add new psionic classes here

       // Tome of Battle
       nClass == CLASS_TYPE_CRUSADER         ||
       nClass == CLASS_TYPE_SWORDSAGE        ||
       nClass == CLASS_TYPE_WARBLADE         ||
       // Other new caster types
       nClass == CLASS_TYPE_TRUENAMER        ||
       //Invocation
       nClass == CLASS_TYPE_DRAGONFIRE_ADEPT ||
       nClass == CLASS_TYPE_WARLOCK
       )
        sFile = GetAMSDefinitionFileName(nClass);
    // New spellbook class
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        //sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
        sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    }

    // If on the first iteration, generate the storage token tag
    if(sTag == "")
        sTag = "PRC_" + sVarNameBase;

    // Get the token to store the lookup table on. The token is piggybacked in the 2da cache creature's inventory
    object oToken = _inc_lookups_GetCacheObject(sTag);
    // Failed to obtain a valid token - nothing to store on
    if(!GetIsObjectValid(oToken))
        return;

    // Starting a new run and the data is present already. Assume the whole thing is present and abort
    if(nMin == 0
        && GetLocalInt(oToken, IntToString(StringToInt(Get2DACache(sFile, sRealColumn, nMin + 1)))))//+1 cos 0 is always null
    {
        // @DUG DoDebug("MakeSpellIDLevelLoop("+sTag+") restored from database");
        return;
    }

    int i;
    int nSource, nDest;
    int nCount = 0;
    for(i = nMin; i < nMin + nLoopSize; i++)
    {
        // None of the relevant 2da files have blank Label entries on rows other than 0. We can assume i is greater than 0 at this point
        if(i > 0 && Get2DAString(sFile, "Label", i) == "") // Using Get2DAString() instead of Get2DACache() to avoid caching extra
            return;

        nSource = StringToInt(Get2DACache(sFile, sRealColumn, i));
        if(i != 0)
        {
            if(nSource == nTemp)
            {
                nCount += 1;
                continue;
            }
            else
            {
                nDest = i;
                SetLocalInt(oToken, IntToString(nClass) + "_" + IntToString(nTemp) + "_Count", nCount);
                nCount = 0;
                nTemp = nSource;
                SetLocalInt(oToken, IntToString(nClass) + "_" + IntToString(nSource) + "_Start", i);
            }
        }
    }

    // And delay continuation to avoid TMI
    if(i < nMax)
        DelayCommand(0.0, MakeSpellIDLoop(nClass, i, nMax, sRealColumn, sVarNameBase, nLoopSize, sTag, nTemp));
}

int GetPowerFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    int nPower = GetLocalInt(oWP, /*"PRC_GetPowerFromSpellID_" + */IntToString(nSpellID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

int GetPowerfileIndexFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_SpellIDToClsPsipw");
    int nIndex = GetLocalInt(oWP, /*"PRC_SpellIDToClsPsipw_" + */IntToString(nSpellID));
    return nIndex;
}

int GetClassFeatFromPower(int nPowerID, int nClass)
{
    string sLabel = "PRC_GetClassFeatFromPower_" + IntToString(nClass);
    object oWP = GetObjectByTag(sLabel);
    int nPower = GetLocalInt(oWP, /*sLabel+"_" + */IntToString(nPowerID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

int SpellToSpellbookID(int nSpell)
{
    object oWP = GetObjectByTag("PRC_GetRowFromSpellID");
    int nOutSpellID = GetLocalInt(oWP, /*"PRC_GetRowFromSpellID_" + */IntToString(nSpell));
    if(nOutSpellID == 0)
        nOutSpellID = -1;
    //if(DEBUG) DoDebug("SpellToSpellbookID(" + IntToString(nSpell) + ", " + sFile + ") = " + IntToString(nOutSpellID));
    return nOutSpellID;
}

int RealSpellToSpellbookID(int nClass, int nSpell)
{
    object oWP = GetObjectByTag("PRC_GetRowFromRealSpellID");
    int nOutSpellID = GetLocalInt(oWP, IntToString(nClass) + "_" + IntToString(nSpell) + "_Start");
    if(nOutSpellID == 0)
        nOutSpellID = -1;
    return nOutSpellID;
}

int RealSpellToSpellbookIDCount(int nClass, int nSpell)
{
    return GetLocalInt(GetObjectByTag("PRC_GetRowFromRealSpellID"), IntToString(nClass) + "_" + IntToString(nSpell) + "_Count");
}

string GetAMSKnownFileName(int nClass)
{
    // Get the class-specific base
    string sFile = Get2DACache("classes", "FeatsTable", nClass);

    // Various naming schemes based on system
    if(nClass == CLASS_TYPE_TRUENAMER)
        sFile = "cls_true_known";
    // ToB
    else if(nClass == CLASS_TYPE_CRUSADER || nClass == CLASS_TYPE_SWORDSAGE || nClass == CLASS_TYPE_WARBLADE)
        sFile = "cls_mvkn" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    // Invocations
    else if(nClass == CLASS_TYPE_DRAGONFIRE_ADEPT || nClass == CLASS_TYPE_WARLOCK)
        sFile = "cls_invkn" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    // Assume psionics if no other match
    else
        sFile = "cls_psbk" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210

    return sFile;
}

string GetAMSDefinitionFileName(int nClass)
{
    // Get the class-specific base
    string sFile = Get2DACache("classes", "FeatsTable", nClass);

    // Various naming schemes based on system
    if(nClass == CLASS_TYPE_TRUENAMER)
        sFile = "cls_true_utter";
    // ToB
    else if(nClass == CLASS_TYPE_CRUSADER || nClass == CLASS_TYPE_SWORDSAGE || nClass == CLASS_TYPE_WARBLADE)
        sFile = "cls_move" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    // Invoc
    else if(nClass == CLASS_TYPE_DRAGONFIRE_ADEPT || nClass == CLASS_TYPE_WARLOCK)
        sFile = "cls_inv" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    // Assume psionics if no other match
    else
        sFile = "cls_psipw" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210

    return sFile;
}

// Test main
//void main(){}
