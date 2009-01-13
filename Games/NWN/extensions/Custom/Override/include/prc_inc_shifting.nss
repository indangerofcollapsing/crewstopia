//::///////////////////////////////////////////////
//:: Shifting include
//:: prc_inc_shifting
//::///////////////////////////////////////////////
/** @file
    Defines constants, functions and structs
    related to shifting.


    Creature data is stored as two persistant
    arrays, with synchronised indexes.
    - Resref
    - Creature name, as given by GetName() on the
      original creature from which the resref was
      gotten


    @author Ornedan
    @date   Created - 2006.03.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int SHIFTER_TYPE_NONE          = 0;
const int SHIFTER_TYPE_SHIFTER       = 1;
const int SHIFTER_TYPE_SOULEATER     = 2;
const int SHIFTER_TYPE_POLYMORPH     = 3;
const int SHIFTER_TYPE_CHANGESHAPE   = 4;
const int SHIFTER_TYPE_HUMANOIDSHAPE = 5;
const int SHIFTER_TYPE_ALTER_SELF    = 6;
const int SHIFTER_TYPE_DISGUISE_SELF = 7;

const int SHIFTER_ABILITIESITEM_MAXPROPS = 8;

const int UNSHIFT_FAIL            = 0;
const int UNSHIFT_SUCCESS         = 1;
const int UNSHIFT_SUCCESS_DELAYED = 2;

const float SHIFTER_MUTEX_UNSET_DELAY = 3.0f;

const string SHIFTER_RESREFS_ARRAY    = "PRC_ShiftingResRefs_";
const string SHIFTER_NAMES_ARRAY      = "PRC_ShiftingNames_";
const string SHIFTER_TRUEAPPEARANCE   = "PRC_ShiftingTrueAppearance";
const string SHIFTER_ISSHIFTED_MARKER = "nPCShifted"; //"PRC_IsShifted"; // @todo Refactor across all scripts
const string SHIFTER_SHIFT_MUTEX      = "PRC_Shifting_InProcess";
const string SHIFTER_RESTRICT_SPELLS  = "PRC_Shifting_RestrictSpells";
const string SHIFTER_OVERRIDE_RACE    = "PRC_ShiftingOverride_Race";

const string SHIFTING_TEMPLATE_WP_TAG = "PRC_SHIFTING_TEMPLATE_SPAWN";
const string SHIFTING_SLAITEM_RESREF  = "epicshifterpower";
const string SHIFTING_SLAITEM_TAG     = "EpicShifterPowers";

const int STRREF_YOUNEED             = 16828326; // "You need"
const int STRREF_MORECHARLVL         = 16828327; // "more character levels before you can take on that form."
const int STRREF_NOPOLYTOPC          = 16828328; // "You cannot polymorph into a PC."
const int STRREF_FORBIDPOLY          = 16828329; // "Target cannot be polymorphed into."
const int STRREF_SETTINGFORBID       = 16828330; // "The module settings prevent this creature from being polymorphed into."
const int STRREF_PNPSFHT_FEYORSSHIFT = 16828331; // "You cannot use PnP Shifter abilities to polymorph into this creature."
const int STRREF_PNPSHFT_MORELEVEL   = 16828332; // "more PnP Shifter levels before you can take on that form."
const int STRREF_NEED_SPACE          = 16828333; // "Your inventory is too full for the PRC Polymorphing system to work. Please make space for three (3) helmet-size items (4x4) in your inventory before trying again."
const int STRREF_POLYMORPH_MUTEX     = 16828334; // "The PRC Polymorphing system will not work while you are affected by a polymorph effect. Please remove it before trying again."
const int STRREF_SHIFTING_MUTEX      = 16828335; // "Another PRC Polymorph transformation is underway at this moment. Please wait until it completes before trying again."
const int STRREF_TEMPLATE_FAILURE    = 16828336; // "Polymorph failed: Failed to create a template of the creature to polymorph into."


//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////

/**
 * A struct for data about appearance.
 */
struct appearancevalues{
   /* Fields for the actual appearance */

    /// The appearance type aka appearance.2da row
    int nAppearanceType;

    /// Body part - Right foot
    int nBodyPart_RightFoot;
    /// Body part - Left Foot
    int nBodyPart_LeftFoot;
    /// Body part - Right Shin
    int nBodyPart_RightShin;
    /// Body part - Left Shin
    int nBodyPart_LeftShin;
    /// Body part - Right Thigh
    int nBodyPart_RightThigh;
    /// Body part - Left Thigh
    int nBodyPart_LeftThight;
    /// Body part - Pelvis
    int nBodyPart_Pelvis;
    /// Body part - Torso
    int nBodyPart_Torso;
    /// Body part - Belt
    int nBodyPart_Belt;
    /// Body part - Neck
    int nBodyPart_Neck;
    /// Body part - Right Forearm
    int nBodyPart_RightForearm;
    /// Body part - Left Forearm
    int nBodyPart_LeftForearm;
    /// Body part - Right Bicep
    int nBodyPart_RightBicep;
    /// Body part - Left Bicep
    int nBodyPart_LeftBicep;
    /// Body part - Right Shoulder
    int nBodyPart_RightShoulder;
    /// Body part - Left Shoulder
    int nBodyPart_LeftShoulder;
    /// Body part - Right Hand
    int nBodyPart_RightHand;
    /// Body part - Left Hand
    int nBodyPart_LeftHand;
    /// Body part - Head
    int nBodyPart_Head;

    /// The wing type
    int nWingType;
    /// The tail type
    int nTailType;

   /* Other stuff */

    /// Portrait ID
    int nPortraitID;
    /// Portrait resref
    string sPortraitResRef;
    /// The footstep type
    int nFootStepType;
    ///The gender
    int nGender;

    ///Colors
    // Skin color
    int nSkinColor;
    // Hair color
    int nHairColor;
    // Tattoo 1 color
    int nTat1Color;
    // Tattoo 2 color
    int nTat2Color;
};

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

// @DUG
void pnpsMsg(string msg, object oPC = OBJECT_SELF, int bFloating = TRUE);
// @DUG
void scrubSkillBonuses(object oShifter = OBJECT_SELF);

// True appearance stuff //

/**
 * Stores the given creature's current appearance as it's true appearance.
 *
 * @param oShifter  The creature whose true appearance to store
 * @param bCarefull If this is TRUE, will only store the appearance if the creature
 *                  is not shifted or polymorphed
 * @return          TRUE if the appearance was stored, FALSE if not
 */
int StoreCurrentAppearanceAsTrueAppearance(object oShifter, int bCarefull = TRUE);

/**
 * Restores the given creature to it's stored true appearance.
 *
 * NOTE: This will function will fail if any polymorph effect is present on the creature.
 *
 *
 * @param oShifter The creature whose appearance to set into an appearance
 *                 previously stored as it's true appearance.
 *
 * @return         TRUE if appearance was restored, FALSE if not. Causes for failure
 *                 are being polymorphed and not having a true appearance stored.
 */
int RestoreTrueAppearance(object oShifter);

// Storage functions  //

/**
 * Stores the target's resref in the 'shifting template's list of the given creature.
 * Will silently fail if either the shifter or the target are not valid objects
 * or if the target is a PC.
 *
 * @param oShifter     The creature to whose list to store oTarget's resref in
 * @param nShifterType SHIFTER_TYPE_* of the list to store in
 * @param oTarget      The creature whose resref to store for later use in shifting
 */
void StoreShiftingTemplate(object oShifter, int nShifterType, object oTarget);

/**
 * Gets the number of 'template's stored in the given creature's list.
 *
 * @param oShifter     The creature whose list to examine
 * @param nShifterType SHIFTER_TYPE_* of the list to store examine
 * @return             The number of entries in the arrays making up the list
 */
int GetNumberOfStoredTemplates(object oShifter, int nShifterType);

/**
 * Reads the resref stored at the given index at a creature's 'template's
 * list.
 *
 * @param oShifter     The creature from whose list to read
 * @param nShifterType SHIFTER_TYPE_* of the list to read from
 * @param nIndex       The index of the entry to get in the list. Standard
 *                     base-0 indexing.
 * @return             The resref stored at the given index. "" on failure (ex.
 *                     reading from an index outside the list.
 */
string GetStoredTemplate(object oShifter, int nShifterType, int nIndex);

/**
 * Reads the name stored at the given index at a creature's 'templates's
 * list.
 *
 * @param oShifter     The creature from whose list to read
 * @param nShifterType SHIFTER_TYPE_* of the list to read from
 * @param nIndex       The index of the entry to get in the list. Standard
 *                     base-0 indexing.
 * @return             The name stored at the given index. "" on failure (ex.
 *                     reading from an index outside the list.
 */
string GetStoredTemplateName(object oShifter, int nShifterType, int nIndex);

/**
 * Deletes the 'shifting template's entry in a creature's list at a given
 * index.
 *
 * @param oShifter     The creature from whose list to delete
 * @param nShifterType SHIFTER_TYPE_* of the list to delete from
 * @param nIndex       The index of the entry to delete in the list. Standard
 *                     base-0 indexing.
 */
void DeleteStoredTemplate(object oShifter, int nShifterType, int nIndex);


// Shifting-related functions

/**
 * Determines whether the given creature can shift into the given target.
 *
 * @param oShifter     The creature attempting to shift into oTemplate
 * @param nShifterType SHIFTER_TYPE_*
 * @param oTemplate    The target of the shift
 *
 * @return             TRUE if oShifter can shift into oTemplate, FALSE otherwise
 */
int GetCanShiftIntoCreature(object oShifter, int nShifterType, object oTemplate);

/**
 * Attempts to shift into the given template creature. This functions as a wrapper
 * for ShiftIntoResRef(), which is supplied with oTemplate's resref.
 *
 * @param oShifter                The creature doing the shifting
 * @param nShifterType            SHIFTER_TYPE_*
 * @param oTemplate               The creature to shift into
 * @param bGainSpellLikeAbilities Whether to give the shifter access the template's SLAs
 *
 * @return                        TRUE if the shifting started successfully,
 *                                FALSE if it failed outright
 */
int ShiftIntoCreature(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities = FALSE);

/**
 * Attempts to shift into the given template creature. If the shifter is already
 * shifted, this will unshift them first. Any errors will result in a message
 * being sent to the shifter.
 *
 * @param oShifter                The creature doing the shifting
 * @param nShifterType            SHIFTER_TYPE_*
 * @param sResRef                 Resref of the creature to shift into
 * @param bGainSpellLikeAbilities Whether to give the shifter access the template's SLAs
 *
 * @return                        TRUE if the shifting started successfully,
 *                                FALSE if it failed outright
 */
int ShiftIntoResRef(object oShifter, int nShifterType, string sResRef, int bGainSpellLikeAbilities = FALSE);

/**
 * Undoes any currently active shifting, restoring original appearance &
 * creature items.
 * NOTE: Will fail if any of the following conditions are true
 * - oShifter is polymorphed and bRemovePoly is false
 * - SHIFTER_SHIFT_MUTEX flag is true on oShifter and bIgnoreShiftingMutex is false
 * - There is no true form stored for oShifter
 *
 * @param oShifter             The creature to unshift
 * @param bRemovePoly          Whether to also remove polymorph effects
 * @param bIgnoreShiftingMutex Whether to ignore the value of SHIFTER_SHIFT_MUTEX
 *
 * @return                     One of following:
 *                             - UNSHIFT_FAIL if one of the abovementioned failure conditions occurs.
 *                               If this is returned, nothing is done to oShifter.
 *                             - UNSHIFT_SUCCESS if the unshifting was completed immediately
 *                             - UNSHIFT_SUCCESS_DELAYED if the unshifting is doable, but delayed to
 *                               wait while a polymorph effect is being removed.
 */
int UnShift(object oShifter, int bRemovePoly = TRUE, int bIgnoreShiftingMutex = FALSE);

// Appearance data functions

/**
 * Reads in all the data about the target creature's appearance and stores it in
 * a structure that is then returned.
 *
 * @param oTemplate Creature whose appearance data to read
 * @return          An appearancevalues structure containing the data
 */
struct appearancevalues GetAppearanceData(object oTemplate);

/**
 * Sets the given creature's appearance data to values in the given appearancevalues
 * structure.
 *
 * @param oTarget The creauture whose appearance to modify
 * @param appval  The appearance data to apply to oTarget
 */
void SetAppearanceData(object oTarget, struct appearancevalues appval);

/**
 * Retrieves an appearancevalues structure that has been placed in local variable
 * storage.
 *
 * @param oStore The object on which the data has been stored
 * @param sName  The name of the local variable
 * @return       An appearancevalues structure containing the retrieved data
 */
struct appearancevalues GetLocalAppearancevalues(object oStore, string sName);

/**
 * Stores an appearancevalues structure on the given object as local variables.
 *
 * @param oStore The object onto which to store the data
 * @param sName  The name of the local variable
 * @param appval The data to store
 */
void SetLocalAppearancevalues(object oStore, string sName, struct appearancevalues appval);

/**
 * Deletes an appearancevalues structure that has been stored on the given object
 * as local variable.
 *
 * @param oStore The object from which to delete data
 * @param sName  The name of the local variable
 */
void DeleteLocalAppearancevalues(object oStore, string sName);

/**
 * Persistant storage version of GetLocalAppearancevalues(). As normal for
 * persistant storage, behaviour is not guaranteed in case the storage object is
 * not a creature.
 *
 * @param oStore The object on which the data has been stored
 * @param sName  The name of the local variable
 * @return       An appearancevalues structure containing the retrieved data
 */
struct appearancevalues GetPersistantLocalAppearancevalues(object oStore, string sName);

/**
 * Persistant storage version of GetLocalAppearancevalues(). As normal for
 * persistant storage, behaviour is not guaranteed in case the storage object is
 * not a creature.
 *
 * @param oStore The object onto which to store the data
 * @param sName  The name of the local variable
 * @param appval The data to store
 */
void SetPersistantLocalAppearancevalues(object oStore, string sName, struct appearancevalues appval);

/**
 * Persistant storage version of GetLocalAppearancevalues(). As normal for
 * persistant storage, behaviour is not guaranteed in case the storage object is
 * not a creature.
 *
 * @param oStore The object from which to delete data
 * @param sName  The name of the local variable
 */
void DeletePersistantLocalAppearancevalues(object oStore, string sName);

/**
 * Forces an unshift if spell duration ends, for Alter Self, etc.  If player
 * unshifts before then, fuction will recognize it's a new shift and do nothing.
 *
 * @param oShifter       The object to force an unshift if needed
 * @param nShifterNumber a number to check against to make sure DelayCommand
 *                       doesn't end the wrong shift
 */
void ForceUnshift(object oShifter, int nShiftedNumber);

/**
 * Creates a string containing the values of the fields of the given appearancevalues
 * structure.
 *
 * @param appval The appearancevalues structure to convert into a string
 * @return       A string that describes the contents of appval
 */
string DebugAppearancevalues2Str(struct appearancevalues appval);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

//#include "inc_utility"
//#include "prc_inc_switch"
#include "inv_invoc_const"
#include "prc_inc_racial"
#include "prc_inc_function"
#include "inc_debug_dac" // @DUG

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * Looks through the given creature's inventory and deletes all
 * creature items not in the creature item slots.
 *
 * @param oShifter The creature through whose inventory to look
 */
void _prc_inc_shifting_RemoveExtraCreatureItems(object oShifter)
{
    int nItemType;
    object oItem  = GetFirstItemInInventory(oShifter);
    object oCWPB  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShifter);
    object oCWPL  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShifter);
    object oCWPR  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShifter);
    object oCSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR,   oShifter);

    while(GetIsObjectValid(oItem))
    {
        nItemType = GetBaseItemType(oItem);

        if(nItemType == BASE_ITEM_CBLUDGWEAPON ||
           nItemType == BASE_ITEM_CPIERCWEAPON ||
           nItemType == BASE_ITEM_CREATUREITEM ||
           nItemType == BASE_ITEM_CSLASHWEAPON ||
           nItemType == BASE_ITEM_CSLSHPRCWEAP
           )
        {
            if(oItem != oCWPB &&
               oItem != oCWPL &&
               oItem != oCWPR &&
               oItem != oCSkin
               )
                MyDestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oShifter);
    }
}

/** Internal function.
 * Determines if beings of the given creature's racial type
 * could usually cast spells.
 */
int _prc_inc_shifting_GetCanFormCast(object oTemplate)
{
    int nRacialType = MyPRCGetRacialType(oTemplate);

    // Need to have hands, and the ability to speak

    switch (nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:
        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_MAGICAL_BEAST:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_OOZE:
//        case RACIAL_TYPE_PLANT:
            // These forms can't cast spells
            return FALSE;
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_FEY:
        case RACIAL_TYPE_GIANT:
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_SHAPECHANGER:
        case RACIAL_TYPE_UNDEAD:
            // Break and go return TRUE at the end of the function
            break;

        default:{
            if(DEBUG) DoDebug("prc_inc_shifting: _GetCanFormCast(): Unknown racial type: " + IntToString(nRacialType));
        }
    }

    return TRUE;
}

/** Internal function.
 * Checks a creature's challenge rating to determine if it could be
 * considered harmless.
 */
int _prc_inc_shifting_GetIsCreatureHarmless(object oTemplate)
{
    /* This is likely to cause problems - Ornedan
    string sCreatureName = GetName(oTemplate);

    // looking for small < 1 CR creatures that nobody looks at twice

    if ((sCreatureName == "Chicken") ||
        (sCreatureName == "Falcon") ||
        (sCreatureName == "Hawk") ||
        (sCreatureName == "Raven") ||
        (sCreatureName == "Bat") ||
        (sCreatureName == "Dire Rat") ||
        (sCreatureName == "Will-O'-Wisp") ||
        (sCreatureName == "Rat") ||
        (GetChallengeRating(oCreature) < 1.0 ))
        return TRUE;
    else
        return FALSE;
    */

    return (GetChallengeRating(oTemplate) < 1.0 // @DUG );
       && PRCGetCreatureSize(oTemplate) <= CREATURE_SIZE_SMALL); // @DUG
}

/** Internal function.
 * @todo Finish function & comments
 */
void _prc_inc_shifting_CopyAllItemProperties(object oFrom, object oTo)
{
    itemproperty iProp = GetFirstItemProperty(oFrom);

    while(GetIsItemPropertyValid(iProp))
    {
        if(GetItemPropertyDurationType(iProp) == DURATION_TYPE_PERMANENT)
        AddItemProperty(GetItemPropertyDurationType(iProp), iProp, oTo);
        iProp = GetNextItemProperty(oFrom);
    }
}

/** Internal function.
 * Builds the shifter spell-like and activatable supernatural abilities item.
 *
 * @param oTemplate The target creature of an ongoing shift
 * @param oItem     The item to create the activatable itemproperties on.
 */
void _prc_inc_shifting_CreateShifterActiveAbilitiesItem(object oTemplate, object oItem)
{
    string sNumUses;
    int nSpell, nNumUses, nProps;
    int i = 0;

    // Loop over shifter_abilitie.2da
    while((nProps < SHIFTER_ABILITIESITEM_MAXPROPS) && (nSpell = StringToInt(Get2DACache("shifter_abilitie", "Spell", i))))
    {
        // See if the template has this spell
        if(GetHasSpell(nSpell, oTemplate))
        {
            // Determine the number of uses from the 2da
            sNumUses = Get2DACache("shifter_abilitie", "IPCSpellNumUses", i);
            if(sNumUses == "1_USE_PER_DAY")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            else if(sNumUses == "2_USES_PER_DAY")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            else if(sNumUses == "3_USES_PER_DAY")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            else if(sNumUses == "4_USES_PER_DAY")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
            else if(sNumUses == "5_USES_PER_DAY")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;
            else if(sNumUses == "UNLIMITED_USE")
                nNumUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
            else{
                if(DEBUG) DoDebug("prc_inc_shifting: _CreateShifterActiveAbilitiesItem(): Unknown IPCSpellNumUses in shifter_abilitie.2da line " + IntToString(i) + ": " + sNumUses);
                nNumUses = -1;
            }

            // Create the itemproperty and add it to the item
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(StringToInt(Get2DACache("shifter_abilitie", "IPSpell", i)), nNumUses), oItem);

            // @DUG Feedback on powers gained
            pnpsMsg(Get2DACache("shifter_abilitie", "Label", i) + " (" +
               Get2DACache("shifter_abilitie", "IPCSpellNumUses", i) + ")");

            // Increment property counter
            nProps += 1;
        }

        // Increment loop counter
        i += 1;
    }
}

/** Internal function.
 * Adds bonus feats granting feats defined in shifter_feats.2da to the shifter's hide if
 * the template has the given feat.
 *
 * @param oTemplate    The target creature of an ongoing shift
 * @param oShifterHide The shifter's hide object
 */
void _prc_inc_shifting_CopyFeats(object oTemplate, object oShifterHide)
{
    string sFeat;
    int i = 0;

    // Loop over shifter_feats.2da. Assume there are no more entries when
    while((sFeat = Get2DACache("shifter_feats", "Feat", i)) != "")
    {
       { // @DUG
          // See if the template creature has the given feat
          if (GetHasFeat(StringToInt(sFeat), oTemplate))
          {
             // Add an itemproperty granting that feat to the shifter's hide
             AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(StringToInt(Get2DACache("shifter_feats", "IPFeat", i))),
                            oShifterHide
                            );
             pnpsMsg(Get2DACache("shifter_feats", "Label", i)); // @DUG
          }
       } // @DUG
       // Increment loop counter
       i += 1;
    }
}

/** Internal function.
 * Determines if the given resref has already been stored in the
 * templates array of the given creature's shifting list for
 * a particular shifting type.
 *
 * @param oShifter     The creature
 * @param nShifterType The shifting list to look in
 * @param sResRef      The resref to look for
 * @return             TRUE if the resref is present in the array
 */
int _prc_inc_shifting_GetIsTemplateStored(object oShifter, int nShifterType, string sResRef)
{
    string sResRefsArray = SHIFTER_RESREFS_ARRAY + IntToString(nShifterType);
    int i, nArraySize    = persistant_array_get_size(oShifter, sResRefsArray);

    // Lowercase the searched for string
    sResRef = GetStringLowerCase(sResRef);

    for(i = 0; i < nArraySize; i++)
    {
        if(sResRef == persistant_array_get_string(oShifter, sResRefsArray, i))
            return TRUE;
    }

    return FALSE;
}

/** Internal function.
 * Performs some checks to see if the given creature can shift without
 * the system falling apart.
 *
 * @param oShifter The creature that would be shifted
 * @return         TRUE if all is OK, FALSE otherwise
 */
int _prc_inc_shifting_GetCanShift(object oShifter)
{
    // Mutex - If another shifting process is active, fail immediately without disturbing it
    if(GetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX))
    {
        SendMessageToPCByStrRef(oShifter, STRREF_SHIFTING_MUTEX); // "Another PRC Polymorph transformation is underway at this moment. Please wait until it completes before trying again."
        return FALSE;
    }

    // Test space in inventory for creating the creature items
    int bReturn = TRUE;
    object o1 = CreateItemOnObject("pnp_shft_tstpkup", oShifter),
           o2 = CreateItemOnObject("pnp_shft_tstpkup", oShifter),
           o3 = CreateItemOnObject("pnp_shft_tstpkup", oShifter);

    if(!(GetItemPossessor(o1) == oShifter &&
         GetItemPossessor(o2) == oShifter &&
         GetItemPossessor(o3) == oShifter
       ))
    {
        bReturn = FALSE;
        SendMessageToPCByStrRef(oShifter, STRREF_NEED_SPACE); // "Your inventory is too full for the PRC Shifting system to work. Please make space for three (3) helmet-size items (4x4) in your inventory before trying again."
    }

    DestroyObject(o1);
    DestroyObject(o2);
    DestroyObject(o3);

    // Polymorph effect and shifting are mutually exclusive. Letting them stack
    // is inviting massive fuckups.
    effect eTest = GetFirstEffect(oShifter);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_POLYMORPH_MUTEX); // "The PRC Shifting system will not work while you are affected by a polymorph effect. Please remove it before trying again."
        }

        eTest = GetNextEffect(oShifter);
    }

    // True form must be stored in order to be allowed to shift
    if(!GetPersistantLocalInt(oShifter, SHIFTER_TRUEAPPEARANCE))
        bReturn = FALSE;

    return bReturn;
}

/** Internal function.
 * Implements the actual shifting bit. Copies creature items, changes appearance, etc
 *
 * @param oShifter                The creature shifting
 * @param nShifterType            SHIFTER_TYPE_*
 * @param oTemplate               The template creature
 * @param bGainSpellLikeAbilities Whether to create the SLA item
 */
void _prc_inc_shifting_ShiftIntoTemplateAux(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities)
{
    if(DEBUG) DoDebug("prc_inc_shifting: _ShiftIntoResRefAux():\n"
                    + "oShifter = " + DebugObject2Str(oShifter) + "\n"
                    + "nShifterType = " + IntToString(nShifterType) + "\n"
                    + "oTemplate = " + DebugObject2Str(oTemplate) + "\n"
                    + "bGainSpellLikeAbilities = " + DebugBool2String(bGainSpellLikeAbilities) + "\n"
                      );

    // Make sure the template creature is still valid
    if(!GetIsObjectValid(oTemplate) || GetObjectType(oTemplate) != OBJECT_TYPE_CREATURE)
    {
        if(DEBUG) DoDebug("prc_inc_shifting: _ShiftIntoTemplateAux(): ERROR: oTemplate is not a valid object or not a creature: " + DebugObject2Str(oTemplate));
        /// @todo Write a better error message
        SendMessageToPCByStrRef(oShifter, STRREF_TEMPLATE_FAILURE); // "Polymorph failed: Failed to create a template of the creature to polymorph into."

        // On failure, unset the mutex right away
        SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, FALSE);
    }
    else
    {
        // Queue unsetting the mutex. Done here so that even if something breaks along the way, this has a good chance of getting executed
        DelayCommand(SHIFTER_MUTEX_UNSET_DELAY, SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, FALSE));

        // @DUG Racial Shifting stacks with Class Shifting
        if (GetHasFeat(FEAT_SHIFTER_SHIFTING, oShifter))
        {
           ExecuteScript("race_shifter", oShifter);
        }

        /* Start the actual shifting */
        int bNeedSpellCast = FALSE;
        int i;

        // First, clear the shifter's action queue. We'll be assigning a bunch of commands that should get executed ASAP
        AssignCommand(oShifter, ClearAllActions(TRUE));

        // Get the shifter's creature items
        object oShifterHide = GetPCSkin(oShifter); // Use the PRC wrapper for this to make sure we get the right object
        object oShifterCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShifter);
        object oShifterCWpL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShifter);
        object oShifterCWpB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShifter);

        // Get the template's creature items
        object oTemplateHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,   oTemplate);
        object oTemplateCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTemplate);
        object oTemplateCWpL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTemplate);
        object oTemplateCWpB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTemplate);

        //Hide isn't modified for Change Shape - Special Qualities don't transfer
        if(nShifterType != SHIFTER_TYPE_CHANGESHAPE &&
           nShifterType != SHIFTER_TYPE_HUMANOIDSHAPE)
        {
            // Handle hide
            // Nuke old props and composite bonus tracking - they will be re-evaluated later
            scrubSkillBonuses(oShifter); // @DUG
            ScrubPCSkin(oShifter, oShifterHide);
            DeletePRCLocalInts(oShifterHide);
            // Copy all itemproperties from the source's hide. No need to check for validity of oTemplateHide - it not
            // existing works the same as it existing, but having no iprops.
            _prc_inc_shifting_CopyAllItemProperties(oTemplateHide, oShifterHide);

            // This may be necessary. Unknown if relevant BioBugs are still present - 20060630, Ornedan
            /*DelayCommand(0.05, */AssignCommand(oShifter, ActionEquipItem(oShifterHide, INVENTORY_SLOT_CARMOUR))/*)*/;
        }
        //Changlings don't get the natural attacks
        if(nShifterType != SHIFTER_TYPE_DISGUISE_SELF)
        {
            //debugMsg("Shifter: not Disguise Self");
            // Handle creature weapons - replace any old weapons with new
            // Delete old natural weapons
            if(GetIsObjectValid(oShifterCWpR)) MyDestroyObject(oShifterCWpR);
            if(GetIsObjectValid(oShifterCWpL)) MyDestroyObject(oShifterCWpL);
            if(GetIsObjectValid(oShifterCWpB)) MyDestroyObject(oShifterCWpB);

            // Copy the template's weapons and assign equipping
            if(GetIsObjectValid(oTemplateCWpR))
            {
                oShifterCWpR = CopyItem(oTemplateCWpR, oShifter, TRUE);
                SetIdentified(oShifterCWpR, TRUE);
                AssignCommand(oShifter, ActionEquipItem(oShifterCWpR, INVENTORY_SLOT_CWEAPON_R));
            }
            if(GetIsObjectValid(oTemplateCWpL))
            {
                oShifterCWpL = CopyItem(oTemplateCWpL, oShifter, TRUE);
                SetIdentified(oShifterCWpL, TRUE);
                AssignCommand(oShifter, ActionEquipItem(oShifterCWpL, INVENTORY_SLOT_CWEAPON_L));
            }
            if(GetIsObjectValid(oTemplateCWpB))
            {
                oShifterCWpB = CopyItem(oTemplateCWpB, oShifter, TRUE);
                SetIdentified(oShifterCWpB, TRUE);
                AssignCommand(oShifter, ActionEquipItem(oShifterCWpB, INVENTORY_SLOT_CWEAPON_B));
            }
        }

        // Ability score adjustments - doesn't apply to Change Shape
        if(nShifterType != SHIFTER_TYPE_CHANGESHAPE &&
           nShifterType != SHIFTER_TYPE_HUMANOIDSHAPE &&
           nShifterType != SHIFTER_TYPE_ALTER_SELF &&
           nShifterType != SHIFTER_TYPE_DISGUISE_SELF)
        {
            //debugMsg("Shifter type not changeshape,humanoid,alterself,disguise");
            // Get the base delta
            int nDeltaSTR = GetAbilityScore(oTemplate, ABILITY_STRENGTH,     TRUE) - GetAbilityScore(oShifter, ABILITY_STRENGTH,     TRUE);
            int nDeltaDEX = GetAbilityScore(oTemplate, ABILITY_DEXTERITY,    TRUE) - GetAbilityScore(oShifter, ABILITY_DEXTERITY,    TRUE);
            int nDeltaCON = GetAbilityScore(oTemplate, ABILITY_CONSTITUTION, TRUE) - GetAbilityScore(oShifter, ABILITY_CONSTITUTION, TRUE);
            int nNewDEX   = GetAbilityScore(oShifter, ABILITY_DEXTERITY, TRUE) + nDeltaDEX; // For calculating AC bonuses in case of dex bonus overflow
            pnpsMsg("ST/DX/CN = " + (nDeltaSTR >= 0 ? "+" : "") +
               IntToString(nDeltaSTR) + "/" + (nDeltaDEX >= 0 ? "+" : "") +
               IntToString(nDeltaDEX) + "/" + (nDeltaCON >= 0 ? "+" : "") +
               IntToString(nDeltaCON)); // @DUG
            int nExtraSTR = 0, nExtraDEX = 0, nExtraCON = 0;

            // Adjust for caps
            /// @todo Think of a more accurate calculation method
            if     (nDeltaSTR >  12) { nExtraSTR = nDeltaSTR - 12; nDeltaSTR =  12; }
            else if(nDeltaSTR < -10) { nExtraSTR = nDeltaSTR + 10; nDeltaSTR = -10; }
            if     (nDeltaDEX > 12)  { nExtraDEX = nDeltaDEX - 12; nDeltaDEX =  12; }
            else if(nDeltaDEX < -10) { nExtraDEX = nDeltaDEX + 10; nDeltaDEX = -10; }
            if     (nDeltaCON > 12)  { nExtraCON = nDeltaCON - 12; nDeltaCON =  12; }
            else if(nDeltaCON < -10) { nExtraCON = nDeltaCON + 10; nDeltaCON = -10; }

            //debugVarInt("Template STR", GetAbilityScore(oTemplate, ABILITY_STRENGTH, TRUE));
            //debugVarInt("Shifter STR", GetAbilityScore(oShifter, ABILITY_STRENGTH, TRUE));
            //debugVarInt("nDeltaSTR", nDeltaSTR);
            //debugVarInt("nDeltaDEX", nDeltaDEX);
            //debugVarInt("nDeltaCON", nDeltaCON);
            //debugVarInt("nExtraSTR", nExtraSTR);
            //debugVarInt("nExtraDEX", nExtraDEX);
            //debugVarInt("nExtraCON", nExtraCON);

            // Set the ability score adjustments as composite bonuses
            if(nDeltaSTR > 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentSTRBonus", nDeltaSTR, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
            else if(nDeltaSTR < 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentSTRPenalty", -nDeltaSTR, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_STR);
            if(nDeltaDEX > 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentDEXBonus", nDeltaDEX, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
            else if(nDeltaDEX < 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentDEXPenalty", -nDeltaDEX, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
            if(nDeltaCON > 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentCONBonus", nDeltaCON, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
            else if(nDeltaCON < 0)
                SetCompositeBonus(oShifterHide, "Shifting_AbilityAdjustmentCONPenalty", -nDeltaCON, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);

            // Extra Strength - Attack and damage bonus / penalty
            // Convert to stat bonus and see if it's non-zero
            if((nExtraSTR /= 2) != 0)
            {
                // Determine damage type. Default to bludgeoning
                int nDamageType = DAMAGE_TYPE_BLUDGEONING;
                int nCWpItemType;

                // Check the creature weapons. The first valid weapon encountered takes precedence
                if(GetIsObjectValid(oShifterCWpR))
                {
                    nCWpItemType = GetBaseItemType(oShifterCWpR);
                    if(nCWpItemType == BASE_ITEM_CSLASHWEAPON ||
                       nCWpItemType == BASE_ITEM_CSLSHPRCWEAP   // Slashing takes precedence over piercing in case of slashing & piercing
                       )
                        nDamageType = DAMAGE_TYPE_SLASHING;
                    else if(nCWpItemType == BASE_ITEM_CPIERCWEAPON)
                        nDamageType = DAMAGE_TYPE_PIERCING;
                }
                else if(GetIsObjectValid(oShifterCWpL))
                {
                    nCWpItemType = GetBaseItemType(oShifterCWpL);
                    if(nCWpItemType == BASE_ITEM_CSLASHWEAPON ||
                       nCWpItemType == BASE_ITEM_CSLSHPRCWEAP   // Slashing takes precedence over piercing in case of slashing & piercing
                       )
                        nDamageType = DAMAGE_TYPE_SLASHING;
                    else if(nCWpItemType == BASE_ITEM_CPIERCWEAPON)
                        nDamageType = DAMAGE_TYPE_PIERCING;
                }
                else if(GetIsObjectValid(oShifterCWpB))
                {
                    nCWpItemType = GetBaseItemType(oShifterCWpB);
                    if(nCWpItemType == BASE_ITEM_CSLASHWEAPON ||
                       nCWpItemType == BASE_ITEM_CSLSHPRCWEAP   // Slashing takes precedence over piercing in case of slashing & piercing
                       )
                        nDamageType = DAMAGE_TYPE_SLASHING;
                    else if(nCWpItemType == BASE_ITEM_CPIERCWEAPON)
                        nDamageType = DAMAGE_TYPE_PIERCING;
                }

                bNeedSpellCast = TRUE;
                SetLocalInt(oShifter, "PRC_Shifter_ExtraSTR", nExtraSTR);
                SetLocalInt(oShifter, "PRC_Shifter_DamageType", nDamageType);
            }

            // Extra Dex - AC penalty or dodge bonus
            if((nExtraDEX /= 2) != 0)
            {
                // For bonuses, limit to max allowed by worn armour
                if(nExtraDEX > 0)
                {
                    object oShifterArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oShifter);
                    if(GetIsObjectValid(oShifterArmour))
                    {
                        int nCurrentDexBon = GetAbilityModifier(ABILITY_DEXTERITY, oShifter);
                        int nMaxDexBon;

                        switch(GetItemACValue(oShifterArmour))
                        {
                            case 8: case 7: case 6:
                                nMaxDexBon = 1; break;
                            case 5:
                                nMaxDexBon = 2; break;
                            case 4: case 3:
                                nMaxDexBon = 4; break;
                            case 2:
                                nMaxDexBon = 6; break;
                            case 1:
                                nMaxDexBon = 8; break;

                            default:
                                nMaxDexBon = 100;
                        }

                        if(nCurrentDexBon > nMaxDexBon)
                            nExtraDEX = 0;
                        else if((nExtraDEX + nCurrentDexBon) > nMaxDexBon)
                            nExtraDEX = nMaxDexBon - nCurrentDexBon;
                    }
                }

                // Make sure there's still something left to apply
                if(nExtraDEX != 0)
                {
                    bNeedSpellCast = TRUE;
                    SetLocalInt(oShifter, "PRC_Shifter_ExtraDEX", nExtraDEX);
                }
            }

            // Extra Con bonus gets applied as temporary HP
            if((nExtraCON /= 2) > 0)
            {
                bNeedSpellCast = TRUE;
                SetLocalInt(oShifter, "PRC_Shifter_ExtraCON", nExtraCON);
            }
        }
        else
        {
           //debugMsg("Shifter type doesn't get ability bonuses");
        }

        // Approximately figure out the template's natural AC bonus
        int nNaturalAC = GetAC(oTemplate)
                       - 10                                                // Adjust for base AC
                       - GetAbilityModifier(ABILITY_DEXTERITY, oTemplate); // And Dex bonus
        // Decrement by AC from armor
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
            nNaturalAC -= GetItemACValue(GetItemInSlot(i, oTemplate));

        // If there is any AC bonus to apply - Change Shape doesn't get it, Alter Self does
        if(nNaturalAC > 0 && (nShifterType != SHIFTER_TYPE_CHANGESHAPE &&
                              nShifterType != SHIFTER_TYPE_HUMANOIDSHAPE &&
                              nShifterType != SHIFTER_TYPE_DISGUISE_SELF ))
        {
            bNeedSpellCast = TRUE;
            SetLocalInt(oShifter, "PRC_Shifter_NaturalAC", nNaturalAC);
        }


        // Feats - read from shifter_feats.2da, check if template has it and copy over if it does
        // Delayed, since this takes way too long
        //DelayCommand(0.0f, _prc_inc_shifting_CopyFeats(oTemplate, oShifterHide)); @todo Re-enable once it is known whether this is the cause of the lag.

        // Casting restrictions if our - inaccurate - check indicates the template can't cast spells
        if(!_prc_inc_shifting_GetCanFormCast(oTemplate))
        {
            // Check for the Natural Spell feat which prevents this restriction
            if(!GetHasFeat(FEAT_PRESTIGE_SHIFTER_NATURALSPELL, oShifter))
            {
                SetLocalInt(oShifter, SHIFTER_RESTRICT_SPELLS, TRUE);
            }
        }

        // Harmless stuff gets invisibility
        if(_prc_inc_shifting_GetIsCreatureHarmless(oTemplate))
        {
            bNeedSpellCast = TRUE;
            SetLocalInt(oShifter, "PRC_Shifter_HarmlessInvisible", TRUE);
        }

        // @DUG Adjust Skills if the target has any
        int nSkillId;
        for (nSkillId = 0; nSkillId < 29; nSkillId++)
        {
           int nTargetSkill = GetSkillRank(nSkillId, oTemplate);
           int nPCSkill = GetSkillRank(nSkillId, oShifter);
           int nSkillBonus = nTargetSkill - nPCSkill;
           if (nSkillBonus > 0)
           {
              effect eSkillBonus = EffectSkillIncrease(nSkillId, nSkillBonus);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(
                 eSkillBonus), oShifter);
              pnpsMsg("Skill Bonus: " + Get2DAString("skills", "Label",
                 nSkillId) + " +" + IntToString(nSkillBonus), oShifter);
              nPCSkill = GetSkillRank(nSkillId, oShifter);
           }
        }

        // If requested, generate an item for using SLAs
        if(bGainSpellLikeAbilities)
        {
            object oSLAItem = CreateItemOnObject(SHIFTING_SLAITEM_RESREF, oShifter);
            // Delayed to prevent potential TMI
            DelayCommand(0.0f, _prc_inc_shifting_CreateShifterActiveAbilitiesItem(oTemplate, oSLAItem));
        }

        // Change the appearance to that of the template
        if(GetAppearanceType(oTemplate) > 5)
             SetAppearanceData(oShifter, GetAppearanceData(oTemplate));
        else
        {
             SetAppearanceData(oShifter, GetAppearanceData(oTemplate));
             SetLocalInt(oShifter, "DynamicAppearance", TRUE);
             SetCreatureAppearanceType(oShifter, GetAppearanceType(oTemplate));
        }

        // Set a local variable to override racial type. Offset by +1 to differentiate value 0 from non-existence
        //Change shape doesn't include this, but there is a feat that gives it to Changelings
        if((nShifterType != SHIFTER_TYPE_CHANGESHAPE
            && nShifterType != SHIFTER_TYPE_HUMANOIDSHAPE
            && nShifterType != SHIFTER_TYPE_ALTER_SELF
            && nShifterType != SHIFTER_TYPE_DISGUISE_SELF)
           || GetHasFeat(FEAT_RACIAL_EMULATION))
            SetLocalInt(oShifter, SHIFTER_OVERRIDE_RACE, MyPRCGetRacialType(oTemplate) + 1);

        // Heal as if rested - this is a side-effect of polymorphing - doesn't apply to Change Shape
        if(nShifterType != SHIFTER_TYPE_CHANGESHAPE
           && nShifterType != SHIFTER_TYPE_HUMANOIDSHAPE
           && nShifterType != SHIFTER_TYPE_ALTER_SELF
           && nShifterType != SHIFTER_TYPE_DISGUISE_SELF)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetHitDice(oShifter) * d4()), oShifter);

        // Some VFX
// @DUG        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oShifter);

        // If something needs permanent effects applied, create a placeable to do the casting in order to bind the effects to a spellID
        if(bNeedSpellCast)
        {
            object oCastingObject = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_rodwonder", GetLocation(oShifter));
            if(!GetIsObjectValid(oCastingObject)) {
                string sErr = "prc_inc_shifting: _ShiftIntoTemplateAux(): ERROR: Unable to create x0_rodwonder object for casting effect application spell";
                if(DEBUG) DoDebug(sErr);
                else WriteTimestampedLogEntry(sErr);
            }
            else
            {
               //debugVarObject("oCastingObject", oCastingObject);
               //debugVarInt("SPELL_SHIFTING_EFFECTS", SPELL_SHIFTING_EFFECTS);
               AssignCommand(oCastingObject, ActionCastSpellAtObject(SPELL_SHIFTING_EFFECTS, oShifter, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            }
        }

        // Set the shiftedness marker
        SetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER, TRUE);

        if(nShifterType == SHIFTER_TYPE_ALTER_SELF ||
          (nShifterType == SHIFTER_TYPE_DISGUISE_SELF
           && GetRacialType(oShifter) != RACIAL_TYPE_CHANGELING
           && !GetLocalInt(oShifter, "MaskOfFleshInvocation")))
        {
            int nShiftedNumber = GetPersistantLocalInt(oShifter, "nTimesShifted");
            if(nShiftedNumber > 9) nShiftedNumber = 0;
            nShiftedNumber++;
            SetPersistantLocalInt(oShifter, "nTimesShifted", nShiftedNumber);
            int nMetaMagic = PRCGetMetaMagicFeat();
            int nDuration = PRCGetCasterLevel(oShifter) * 10;
            if ((nMetaMagic & METAMAGIC_EXTEND))
            {
                nDuration *= 2;
            }
            DelayCommand(TurnsToSeconds(nDuration), ForceUnshift(oShifter, nShiftedNumber));
        }

        else if(GetLocalInt(oShifter, "HumanoidShapeInvocation"))
        {
            int nShiftedNumber = GetPersistantLocalInt(oShifter, "nTimesShifted");
            if(nShiftedNumber > 9) nShiftedNumber = 0;
            nShiftedNumber++;
            SetPersistantLocalInt(oShifter, "nTimesShifted", nShiftedNumber);
            DelayCommand(HoursToSeconds(24), ForceUnshift(oShifter, nShiftedNumber));
        }

        else if(GetLocalInt(oShifter, "MaskOfFleshInvocation"))
        {
            int nShiftedNumber = GetPersistantLocalInt(oShifter, "nTimesShifted");
            if(nShiftedNumber > 9) nShiftedNumber = 0;
            nShiftedNumber++;
            SetPersistantLocalInt(oShifter, "nTimesShifted", nShiftedNumber);
            int nDuration = GetLocalInt(oShifter, "MaskOfFleshInvocation");
            DelayCommand(HoursToSeconds(nDuration), ForceUnshift(oShifter, nShiftedNumber));
        }

        // Run the class & feat evaluation code
        // In case of TMIs, add two domino blocks
        //*
        //debugMsg("calling EvalPRCFeats");
        DelayCommand(0.1f,
        // */
                     EvalPRCFeats(oShifter)
        //*
                     )
        // */
                      ;
    }

    // Destroy the template creature
    MyDestroyObject(oTemplate);
}

/** Internal function.
 * Implements the actual shifting bit. Only changes appearance for this version
 *
 * @param oShifter                The creature shifting
 * @param nShifterType            SHIFTER_TYPE_*    20060702, Ornedan: Currently unused
 * @param oTemplate               The template creature
 */
void _prc_inc_shifting_ShiftIntoChangeShapeAux(object oShifter, int nShifterType, object oTemplate)
{
    if(DEBUG) DoDebug("prc_inc_shifting: _ShiftIntoDisguiseAux():\n"
                    + "oShifter = " + DebugObject2Str(oShifter) + "\n"
                    + "nShifterType = " + IntToString(nShifterType) + "\n"
                    + "oTemplate = " + DebugObject2Str(oTemplate) + "\n"
                      );

    // Make sure the template creature is still valid
    if(!GetIsObjectValid(oTemplate) || GetObjectType(oTemplate) != OBJECT_TYPE_CREATURE)
    {
        if(DEBUG) DoDebug("prc_inc_shifting: _ShiftIntoTemplateAux(): ERROR: oTemplate is not a valid object or not a creature: " + DebugObject2Str(oTemplate));
        /// @todo Write a better error message
        SendMessageToPCByStrRef(oShifter, STRREF_TEMPLATE_FAILURE); // "Polymorph failed: Failed to create a template of the creature to polymorph into."

        // On failure, unset the mutex right away
        SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, FALSE);
    }
    else
    {
        // Queue unsetting the mutex. Done here so that even if something breaks along the way, this has a good chance of getting executed
        DelayCommand(SHIFTER_MUTEX_UNSET_DELAY, SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, FALSE));

        /* Start the actual shifting */

        // First, clear the shifter's action queue. We'll be assigning a bunch of commands that should get executed ASAP
        AssignCommand(oShifter, ClearAllActions(TRUE));

        // Change the appearance to that of the template
        SetAppearanceData(oShifter, GetAppearanceData(oTemplate));

        // Set a local variable to override racial type if appropriate feat is there. Offset by +1 to differentiate value 0 from non-existence
        if(GetHasFeat(FEAT_RACIAL_EMULATION, oShifter))
            SetLocalInt(oShifter, SHIFTER_OVERRIDE_RACE, MyPRCGetRacialType(oTemplate) + 1);

        // Some VFX
//@DUG        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oShifter);

        // Set the shiftedness marker
        SetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER, TRUE);
    }

    // Destroy the template creature
    MyDestroyObject(oTemplate);
}

/** Internal function.
 * Does the actual work in unshifting. Restores creature items and
 * appearance. If oTemplate is valid, _prc_inc_shifting_ShiftIntoTemplateAux()
 * will be called once unshifting is finished.
 *
 * NOTE: This assumes that all polymorph effects have already been removed.
 *
 * @param oShifter Creature to unshift
 *
 *  Reshift parameters:
 * @param nShifterType            Passed to _prc_inc_shifting_ShiftIntoTemplateAux() when reshifting.
 * @param oTemplate               Passed to _prc_inc_shifting_ShiftIntoTemplateAux() when reshifting.
 * @param bGainSpellLikeAbilities Passed to _prc_inc_shifting_ShiftIntoTemplateAux() when reshifting.
 */
void _prc_inc_shifting_UnShiftAux(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities)
{
    // Get the shifter's creature items
    object oShifterHide = GetPCSkin(oShifter); // Use the PRC wrapper for this to make sure we get the right object
    object oShifterCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShifter);
    object oShifterCWpL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShifter);
    object oShifterCWpB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShifter);

    // Clear the hide. We'll have to run EvalPRCFeats() later on
    scrubSkillBonuses(oShifter); // @DUG
    ScrubPCSkin(oShifter, oShifterHide);
    DeletePRCLocalInts(oShifterHide);

    // This may be necessary. Unknown if relevant BioBugs are still present - 20060630, Ornedan
    /*DelayCommand(0.05, */AssignCommand(oShifter, ActionEquipItem(oShifterHide, INVENTORY_SLOT_CARMOUR))/*)*/;

    // Nuke the creature weapons. If the normal form is supposed to have natural weapons, they'll get re-constructed
    if(GetIsObjectValid(oShifterCWpR)) MyDestroyObject(oShifterCWpR);
    if(GetIsObjectValid(oShifterCWpL)) MyDestroyObject(oShifterCWpL);
    if(GetIsObjectValid(oShifterCWpB)) MyDestroyObject(oShifterCWpB);

    object oSLAItem = GetItemPossessedBy(oShifter, SHIFTING_SLAITEM_TAG);
    int bCheckForAuraEffects = FALSE;
    if(GetIsObjectValid(oSLAItem))
    {
        MyDestroyObject(oSLAItem);
        bCheckForAuraEffects = TRUE;
    }

    // Remove effects
    effect eTest = GetFirstEffect(oShifter);
    int nEffectSpellID;
    while(GetIsEffectValid(eTest))
    {
        // Remove if the effect came from the shifter effects application spell or one of the auras usable via SLA item
        nEffectSpellID = GetEffectSpellId(eTest);
        if(nEffectSpellID == SPELL_SHIFTING_EFFECTS ||
           (bCheckForAuraEffects                     &&
            (nEffectSpellID == SPELLABILITY_AURA_BLINDING         ||
             nEffectSpellID == SPELLABILITY_AURA_COLD             ||
             nEffectSpellID == SPELLABILITY_AURA_ELECTRICITY      ||
             nEffectSpellID == SPELLABILITY_AURA_FEAR             ||
             nEffectSpellID == SPELLABILITY_AURA_FIRE             ||
             nEffectSpellID == SPELLABILITY_AURA_MENACE           ||
             nEffectSpellID == SPELLABILITY_AURA_PROTECTION       ||
             nEffectSpellID == SPELLABILITY_AURA_STUN             ||
             nEffectSpellID == SPELLABILITY_AURA_UNEARTHLY_VISAGE ||
             nEffectSpellID == SPELLABILITY_AURA_UNNATURAL        ||
             nEffectSpellID == SPELLABILITY_DRAGON_FEAR
             )
            )
           )
        {
            RemoveEffect(oShifter, eTest);
        }

        eTest = GetNextEffect(oShifter);
    }

    // Restore appearance
    if(!RestoreTrueAppearance(oShifter))
    {
        string sError = "prc_inc_shifting: _UnShiftAux(): ERROR: Unable to restore true form for " + DebugObject2Str(oShifter);
        if(DEBUG) DoDebug(sError);
        else      WriteTimestampedLogEntry(sError);
    }

    // Unset the racial override
    DeleteLocalInt(oShifter, SHIFTER_OVERRIDE_RACE);

    // Unset the spellcasting restriction marker
    DeleteLocalInt(oShifter, SHIFTER_RESTRICT_SPELLS);

    // Unset the shiftedness marker
    SetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER, FALSE);

    // Run the class & feat evaluation code
    // In case of TMIs, add two domino blocks
    /*
    DelayCommand(0.0f,
    // */
                 EvalPRCFeats(oShifter)
    /*
                 )
    // */
                  ;

    // Queue reshifting to happen if needed. Let a short while pass so any fallout from the unshift gets handled
    if(GetIsObjectValid(oTemplate))
        DelayCommand(1.0f, _prc_inc_shifting_ShiftIntoTemplateAux(oShifter, nShifterType, oTemplate, bGainSpellLikeAbilities));
    // Since there is no reshifting, we can unset the mutex now
    else
        SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, FALSE);
}

/** Internal function.
 * A polymorph effect was encountered during unshifting and removed. We need to
 * wait until it's actually removed (instead of merely gone from the active effects
 * list on oShifter) before calling _prc_inc_shifting_UnShiftAux().
 * This is done by tracking the contents of the creature armour slot. The object in
 * it will change when the polymorph is really removed.
 *
 * @param oShifter The creature whose creature armour slot to monitor.
 * @param oSkin    The skin object that was in the slot when the UnShift() call that triggered
 *                 this was run.
 * @param nRepeats Number of times this function has repeated the delay. Used to track timeout
 */
void _prc_inc_shifting_UnShiftAux_SeekPolyEnd(object oShifter, object oSkin, int nRepeats = 0)
{
    // Over 15 seconds passed, something is wrong
    if(nRepeats++ > 100)
    {
        if(DEBUG) DoDebug("prc_inc_shifting: _UnShiftAux_SeekPolyEnd(): ERROR: Repeated over 100 times, skin object remains the same.");
        return;
    }

    // See if the skin object has changed. When it does, the polymorph is genuinely gone instead of just being removed from the effects list
    if(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oShifter) == oSkin)
        DelayCommand(0.15f, _prc_inc_shifting_UnShiftAux_SeekPolyEnd(oShifter, oSkin, nRepeats));
    // It's gone, finish unshifting
    else
        _prc_inc_shifting_UnShiftAux(oShifter, SHIFTER_TYPE_NONE, OBJECT_INVALID, FALSE);
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int StoreCurrentAppearanceAsTrueAppearance(object oShifter, int bCarefull = TRUE)
{
    // If requested, check that the creature isn't shifted or polymorphed
    if(bCarefull)
    {
        if(GetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER))
            return FALSE;

        effect eTest = GetFirstEffect(oShifter);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
                return FALSE;

            eTest = GetNextEffect(oShifter);
        }
    }

    // Get the appearance data
    struct appearancevalues appval = GetAppearanceData(oShifter);

    // Store it
    SetPersistantLocalAppearancevalues(oShifter, SHIFTER_TRUEAPPEARANCE, appval);
    SetPersistantLocalInt(oShifter, "TrueFormAppearanceType", GetAppearanceType(oShifter));

    // Set a marker that tells that the true appearance is stored
    SetPersistantLocalInt(oShifter, SHIFTER_TRUEAPPEARANCE, TRUE);

    return TRUE;
}

int RestoreTrueAppearance(object oShifter)
{
    // Check fo the the "true appearance stored" marker. Abort if it's not present
    if(!GetPersistantLocalInt(oShifter, SHIFTER_TRUEAPPEARANCE))
        return FALSE;

    // See if the character is polymorphed. Won't restore the appearance if it is
    effect eTest = GetFirstEffect(oShifter);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return FALSE;

        eTest = GetNextEffect(oShifter);
    }

    // We got this far, everything should be OK
    // Retrieve the appearance data
    struct appearancevalues appval = GetPersistantLocalAppearancevalues(oShifter, SHIFTER_TRUEAPPEARANCE);

    // Apply it to the creature
    SetAppearanceData(oShifter, appval);

    if(GetLocalInt(oShifter, "DynamicAppearance"))
    {
        SetCreatureAppearanceType(oShifter, GetPersistantLocalInt(oShifter, "TrueFormAppearanceType"));
        DeleteLocalInt(oShifter, "DynamicAppearance");
    }

    // Inform caller of success
    return TRUE;
}


// Storage functions  //

void StoreShiftingTemplate(object oShifter, int nShifterType, object oTarget)
{
    // Some paranoia - both the target and the object to store on must be valid. And PCs are never legal for storage - PC resref should be always empty
    if(!(GetIsObjectValid(oShifter) && GetIsObjectValid(oTarget) && GetResRef(oTarget) != ""))
        return;

    string sResRefsArray = SHIFTER_RESREFS_ARRAY + IntToString(nShifterType);
    string sNamesArray   = SHIFTER_NAMES_ARRAY   + IntToString(nShifterType);

    // Determine array existence
    if(!persistant_array_exists(oShifter, sResRefsArray))
        persistant_array_create(oShifter, sResRefsArray);
    if(!persistant_array_exists(oShifter, sNamesArray))
        persistant_array_create(oShifter, sNamesArray);

    // Get the storeable data
    string sResRef = GetResRef(oTarget);
    string sName   = GetName(oTarget);
    int nArraySize = persistant_array_get_size(oShifter, sResRefsArray);

    // Check for the template already being present
    if(_prc_inc_shifting_GetIsTemplateStored(oShifter, nShifterType, sResRef))
        return;

    persistant_array_set_string(oShifter, sResRefsArray, nArraySize, sResRef);
    persistant_array_set_string(oShifter, sNamesArray, nArraySize, sName);
}

int GetNumberOfStoredTemplates(object oShifter, int nShifterType)
{
    if(!persistant_array_exists(oShifter, SHIFTER_RESREFS_ARRAY + IntToString(nShifterType)))
        return 0;

    return persistant_array_get_size(oShifter, SHIFTER_RESREFS_ARRAY + IntToString(nShifterType));
}

string GetStoredTemplate(object oShifter, int nShifterType, int nIndex)
{
    return persistant_array_get_string(oShifter, SHIFTER_RESREFS_ARRAY + IntToString(nShifterType), nIndex);
}

string GetStoredTemplateName(object oShifter, int nShifterType, int nIndex)
{
    return persistant_array_get_string(oShifter, SHIFTER_NAMES_ARRAY + IntToString(nShifterType), nIndex);
}

void DeleteStoredTemplate(object oShifter, int nShifterType, int nIndex)
{
    string sResRefsArray = SHIFTER_RESREFS_ARRAY + IntToString(nShifterType);
    string sNamesArray   = SHIFTER_NAMES_ARRAY   + IntToString(nShifterType);

    // Determine array existence
    if(!persistant_array_exists(oShifter, sResRefsArray))
        return;
    if(!persistant_array_exists(oShifter, sNamesArray))
        return;

    // Move array entries
    int i, nArraySize = persistant_array_get_size(oShifter, sResRefsArray);
    for(i = nIndex; i < nArraySize - 1; i++)
    {
        persistant_array_set_string(oShifter, sResRefsArray, i,
                                    persistant_array_get_string(oShifter, sResRefsArray, i + 1)
                                    );
        persistant_array_set_string(oShifter, sNamesArray, i,
                                    persistant_array_get_string(oShifter, sNamesArray, i + 1)
                                    );
    }

    // Shrink the arrays
    persistant_array_shrink(oShifter, sResRefsArray, nArraySize - 1);
    persistant_array_shrink(oShifter, sNamesArray,   nArraySize - 1);
}


// Shifting-related functions

int GetCanShiftIntoCreature(object oShifter, int nShifterType, object oTemplate)
{
    // Base assumption: Can shift into the target
    int bReturn = TRUE;

    // Some basic checks
    if(GetIsObjectValid(oShifter) && GetIsObjectValid(oTemplate))
    {
        // PC check
        if(GetIsPC(oTemplate))
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_NOPOLYTOPC); // "You cannot polymorph into a PC."
        }
        // Shifting prevention feat
        else if(GetHasFeat(SHIFTER_BLACK_LIST, oTemplate))
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_FORBIDPOLY); // "Target cannot be polymorphed into."
        }

        // Test switch-based limitations
        if(bReturn)
        {
            int nSize       = PRCGetCreatureSize(oTemplate);
            int nRacialType = MyPRCGetRacialType(oTemplate);

            // Size switches
            if(nSize >= CREATURE_SIZE_HUGE   && GetPRCSwitch(PNP_SHFT_S_HUGE))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_LARGE  && GetPRCSwitch(PNP_SHFT_S_LARGE))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_MEDIUM && GetPRCSwitch(PNP_SHFT_S_MEDIUM))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_SMALL  && GetPRCSwitch(PNP_SHFT_S_SMALL))
                bReturn = FALSE;
            if(nSize <= CREATURE_SIZE_TINY   && GetPRCSwitch(PNP_SHFT_S_TINY))
                bReturn = FALSE;

            // Type switches
            if(nRacialType == RACIAL_TYPE_OUTSIDER           && GetPRCSwitch(PNP_SHFT_F_OUTSIDER))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ELEMENTAL          && GetPRCSwitch(PNP_SHFT_F_ELEMENTAL))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_CONSTRUCT          && GetPRCSwitch(PNP_SHFT_F_CONSTRUCT))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_UNDEAD             && GetPRCSwitch(PNP_SHFT_F_UNDEAD))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_DRAGON             && GetPRCSwitch(PNP_SHFT_F_DRAGON))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ABERRATION         && GetPRCSwitch(PNP_SHFT_F_ABERRATION))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_OOZE               && GetPRCSwitch(PNP_SHFT_F_OOZE))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_MAGICAL_BEAST      && GetPRCSwitch(PNP_SHFT_F_MAGICALBEAST))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_GIANT              && GetPRCSwitch(PNP_SHFT_F_GIANT))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_VERMIN             && GetPRCSwitch(PNP_SHFT_F_VERMIN))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_BEAST              && GetPRCSwitch(PNP_SHFT_F_BEAST))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ANIMAL             && GetPRCSwitch(PNP_SHFT_F_ANIMAL))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS && GetPRCSwitch(PNP_SHFT_F_MONSTROUSHUMANOID))
                bReturn = FALSE;
            if(GetPRCSwitch(PNP_SHFT_F_HUMANOID)            &&
               (nRacialType == RACIAL_TYPE_DWARF              ||
                nRacialType == RACIAL_TYPE_ELF                ||
                nRacialType == RACIAL_TYPE_GNOME              ||
                nRacialType == RACIAL_TYPE_HUMAN              ||
                nRacialType == RACIAL_TYPE_HALFORC            ||
                nRacialType == RACIAL_TYPE_HALFELF            ||
                nRacialType == RACIAL_TYPE_HALFLING           ||
                nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
               ))
                bReturn = FALSE;

            if(!bReturn)
                SendMessageToPCByStrRef(oShifter, STRREF_SETTINGFORBID); // "The module settings prevent this creature from being polymorphed into."
        }

        // Still OK, test HD or CR
        if(bReturn)
        {
            // Check target's HD or CR
            int nShifterHD  = GetHitDice(oShifter);

            // @DUG Epic Shifter with 35+ total levels can take *any* form.
            if (nShifterHD >= 35 && GetHasFeat(FEAT_EPIC_SHIFTER, oShifter))
            {
               pnpsMsg("Your mastery of Shifting is unparalleled.", oShifter);
               return TRUE;
            }

            // @DUG Practised Shifter Feat (new)
            // @DUG Minimum of 5 non-Shifter levels are required to take PNP
            //      Shifter, so no need to check for them.
            if (GetHasFeat(FEAT_PRACTISED_SHIFTER, oShifter))
            {
//               pnpsMsg("Practised Shifter", oShifter);
               nShifterHD += 4;
            }

            // @DUG Practised Spellcaster Druid as Practised Shifter Feat
            //      (deprecated)
            // @DUG Minimum of 5 non-Shifter levels are required to take PNP
            //      Shifter, so no need to check for them.
            if (GetHasFeat(FEAT_PRACTISED_SPELLCASTER_DRUID, oShifter))
            {
//               pnpsMsg("Practised Shifter (Druid)", oShifter);
               nShifterHD += 4;
            }

            int nTemplateHD = GetPRCSwitch(PNP_SHFT_USECR) ?
                               FloatToInt(GetChallengeRating(oTemplate)) :
                               GetHitDice(oTemplate);
            if(nTemplateHD > nShifterHD)
            {
                bReturn = FALSE;
                // "You need X more character levels before you can take on that form."
                SendMessageToPC(oShifter, GetStringByStrRef(STRREF_YOUNEED) + " " + IntToString(nTemplateHD - nShifterHD) + " " + GetStringByStrRef(STRREF_MORECHARLVL));
            }

            if(nShifterType == SHIFTER_TYPE_ALTER_SELF && nTemplateHD > 5)
            {
                bReturn = FALSE;
                SendMessageToPC(oShifter, "This creature is too high a level to copy with this spell.");
            }
        }// end if - Checking HD or CR

        // Move onto shifting type-specific checks if there haven't been any problems yet
        if(bReturn)
        {
            if(nShifterType == SHIFTER_TYPE_SHIFTER)
            {
                int nShifterLevel  = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oShifter);
                int nLevelRequired = 0;

/* @DUG deprecated
                // @DUG Doppelganger
                int nMyRacialType = MyPRCGetRacialType(oShifter);
                if (nMyRacialType ==  RACIAL_TYPE_DOPPELGANGER ||
// @DUG                    nMyRacialType ==  RACIAL_TYPE_HALF_DOPPELGANGER ||
                    nMyRacialType == RACIAL_TYPE_SHAPECHANGER)
                {
                   nShifterLevel = max(nShifterLevel, 1);
                }
@DUG deprecated */
                int nSize       = PRCGetCreatureSize(oTemplate);
                int nRacialType = MyPRCGetRacialType(oTemplate);

/* @DUG
                // Fey and shapechangers are forbidden targets for PnP Shifter
                if(nRacialType == RACIAL_TYPE_FEY || nRacialType == RACIAL_TYPE_SHAPECHANGER)
                {
                    bReturn = FALSE;
                    SendMessageToPCByStrRef(oShifter, STRREF_PNPSFHT_FEYORSSHIFT); // "You cannot use PnP Shifter abilities to polymorph into this creature."
                }
                else
@DUG */
                {
                    // Size tests
                    if(nSize >= CREATURE_SIZE_HUGE)
                        nLevelRequired = max(nLevelRequired, 7);
                    if(nSize == CREATURE_SIZE_LARGE)
                        nLevelRequired = max(nLevelRequired, 3);
                    if(nSize == CREATURE_SIZE_MEDIUM)
                        nLevelRequired = max(nLevelRequired, 1);
                    if(nSize == CREATURE_SIZE_SMALL)
                        nLevelRequired = max(nLevelRequired, 1);
                    if(nSize <= CREATURE_SIZE_TINY)
                        nLevelRequired = max(nLevelRequired, 3);

                    // Type tests
                    if (nRacialType == RACIAL_TYPE_FEY) nLevelRequired = max(nLevelRequired, 6); // @DUG
                    if (nRacialType == RACIAL_TYPE_SHAPECHANGER) nLevelRequired = max(nLevelRequired, 9); // @DUG

                    if(nRacialType == RACIAL_TYPE_OUTSIDER)
                        nLevelRequired = max(nLevelRequired, 9);
                    if(nRacialType == RACIAL_TYPE_ELEMENTAL)
                        nLevelRequired = max(nLevelRequired, 9);
                    if(nRacialType == RACIAL_TYPE_CONSTRUCT)
                        nLevelRequired = max(nLevelRequired, 8);
                    if(nRacialType == RACIAL_TYPE_UNDEAD)
                        nLevelRequired = max(nLevelRequired, 8);
                    if(nRacialType == RACIAL_TYPE_DRAGON)
                        nLevelRequired = max(nLevelRequired, 7);
                    if(nRacialType == RACIAL_TYPE_ABERRATION)
                        nLevelRequired = max(nLevelRequired, 6);
                    if(nRacialType == RACIAL_TYPE_OOZE)
                        nLevelRequired = max(nLevelRequired, 6);
                    if(nRacialType == RACIAL_TYPE_MAGICAL_BEAST)
                        nLevelRequired = max(nLevelRequired, 5);
                    if(nRacialType == RACIAL_TYPE_GIANT)
                        nLevelRequired = max(nLevelRequired, 4);
                    if(nRacialType == RACIAL_TYPE_VERMIN)
                        nLevelRequired = max(nLevelRequired, 4);
                    if(nRacialType == RACIAL_TYPE_BEAST)
                        nLevelRequired = max(nLevelRequired, 3);
                    if(nRacialType == RACIAL_TYPE_ANIMAL)
                        nLevelRequired = max(nLevelRequired, 2);
                    if(nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS)
                        nLevelRequired = max(nLevelRequired, 2);
                    if(nRacialType == RACIAL_TYPE_DWARF              ||
                       nRacialType == RACIAL_TYPE_ELF                ||
                       nRacialType == RACIAL_TYPE_GNOME              ||
                       nRacialType == RACIAL_TYPE_HUMAN              ||
                       nRacialType == RACIAL_TYPE_HALFORC            ||
                       nRacialType == RACIAL_TYPE_HALFELF            ||
                       nRacialType == RACIAL_TYPE_HALFLING           ||
                       nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                       nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                       )
                        nLevelRequired = max(nLevelRequired, 1);

                    // Test level required
                    if(nLevelRequired > nShifterLevel)
                    {
                        bReturn = FALSE;
                        // "You need X more PnP Shifter levels before you can take on that form."
                        SendMessageToPC(oShifter, GetStringByStrRef(STRREF_YOUNEED) + " " + IntToString(nLevelRequired - nShifterLevel) + " " + GetStringByStrRef(STRREF_PNPSHFT_MORELEVEL));
                    }
                }// end else - Not outright forbidden due to target being Fey or Shapeshifter
            }// end if - PnP Shifter checks

            //Change Shape checks
            else if(nShifterType == SHIFTER_TYPE_HUMANOIDSHAPE)
            {
                int nTargetSize        = PRCGetCreatureSize(oTemplate);
                int nRacialType        = MyPRCGetRacialType(oTemplate);
                int nShifterSize       = PRCGetCreatureSize(oShifter);

                int nSizeDiff = nTargetSize - nShifterSize;

                if(nSizeDiff > 1 || nSizeDiff < -1)
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is too large or too small.");
                }

                if(!(nRacialType == RACIAL_TYPE_DWARF            ||
                   nRacialType == RACIAL_TYPE_ELF                ||
                   nRacialType == RACIAL_TYPE_GNOME              ||
                   nRacialType == RACIAL_TYPE_HUMAN              ||
                   nRacialType == RACIAL_TYPE_HALFORC            ||
                   nRacialType == RACIAL_TYPE_HALFELF            ||
                   nRacialType == RACIAL_TYPE_HALFLING           ||
                   nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                   nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                   ))
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is not a humanoid racial type.");
                }
            }

            //Changeling check
            else if(nShifterType == SHIFTER_TYPE_DISGUISE_SELF && GetRacialType(oShifter) == RACIAL_TYPE_CHANGELING)
            {
                int nSize        = PRCGetCreatureSize(oTemplate);
                int nRacialType  = MyPRCGetRacialType(oTemplate);
                int nShifterSize = PRCGetCreatureSize(oShifter);

                if(nSize != nShifterSize)
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is too large or too small.");
                }

                if(!(nRacialType == RACIAL_TYPE_DWARF            ||
                   nRacialType == RACIAL_TYPE_ELF                ||
                   nRacialType == RACIAL_TYPE_GNOME              ||
                   nRacialType == RACIAL_TYPE_HUMAN              ||
                   nRacialType == RACIAL_TYPE_HALFORC            ||
                   nRacialType == RACIAL_TYPE_HALFELF            ||
                   nRacialType == RACIAL_TYPE_HALFLING           ||
                   nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                   nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                   ))
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is not a humanoid racial type.");
                }
            }

            //Generic check
            else if(nShifterType == SHIFTER_TYPE_CHANGESHAPE
                    || nShifterType == SHIFTER_TYPE_ALTER_SELF
                    || (nShifterType == SHIFTER_TYPE_DISGUISE_SELF && GetRacialType(oShifter) != RACIAL_TYPE_CHANGELING))
            {
                int nTargetSize        = PRCGetCreatureSize(oTemplate);
                int nTargetRacialType  = MyPRCGetRacialType(oTemplate);
                int nShifterSize       = PRCGetCreatureSize(oShifter);
                int nShifterRacialType = MyPRCGetRacialType(oShifter);

                int nSizeDiff = nTargetSize - nShifterSize;

                if(nSizeDiff > 1 || nSizeDiff < -1)
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is too large or too small.");
                }

                if(!(nTargetRacialType == nShifterRacialType ||
                   //check for humanoid type
                   ((nTargetRacialType == RACIAL_TYPE_DWARF            ||
                   nTargetRacialType == RACIAL_TYPE_ELF                ||
                   nTargetRacialType == RACIAL_TYPE_GNOME              ||
                   nTargetRacialType == RACIAL_TYPE_HUMAN              ||
                   nTargetRacialType == RACIAL_TYPE_HALFORC            ||
                   nTargetRacialType == RACIAL_TYPE_HALFELF            ||
                   nTargetRacialType == RACIAL_TYPE_HALFLING           ||
                   nTargetRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                   nTargetRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                   ) &&
                   (nShifterRacialType == RACIAL_TYPE_DWARF            ||
                   nShifterRacialType == RACIAL_TYPE_ELF                ||
                   nShifterRacialType == RACIAL_TYPE_GNOME              ||
                   nShifterRacialType == RACIAL_TYPE_HUMAN              ||
                   nShifterRacialType == RACIAL_TYPE_HALFORC            ||
                   nShifterRacialType == RACIAL_TYPE_HALFELF            ||
                   nShifterRacialType == RACIAL_TYPE_HALFLING           ||
                   nShifterRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                   nShifterRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                   ))
                   ))
                {
                    bReturn = FALSE;
                    SendMessageToPC(oShifter, "This creature is a different racial type.");
                }
            }
        }// end if - Check shifting list specific stuff
    }
    // Failed one of the basic checks
    else
        bReturn = FALSE;

    return bReturn;
}

int ShiftIntoCreature(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities = FALSE)
{
    // Just grab the resref and move on
    return ShiftIntoResRef(oShifter, nShifterType, GetResRef(oTemplate), bGainSpellLikeAbilities);
}

int ShiftIntoResRef(object oShifter, int nShifterType, string sResRef, int bGainSpellLikeAbilities = FALSE)
{
    // Make sure there is nothing that would prevent the successfull execution of the shift from happening
    if(!_prc_inc_shifting_GetCanShift(oShifter))
        return FALSE;

    /* Create the template to shift into */
    // Get the waypoint in Limbo where shifting template creatures are spawned
    object oSpawnWP = GetWaypointByTag(SHIFTING_TEMPLATE_WP_TAG);
    // Paranoia check - the WP should be built into the area data of Limbo
    if(!GetIsObjectValid(oSpawnWP))
    {
        if(DEBUG) DoDebug("prc_inc_shifting: ShiftIntoResRef(): ERROR: Template spawn waypoint does not exist.");
        // Create the WP
        oSpawnWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, SHIFTING_TEMPLATE_WP_TAG);
    }

    // Get the WP's location
    location lSpawn  = GetLocation(oSpawnWP);

    // And spawn an instance of the given template there
    object oTemplate = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);

    // Make sure the template creature was successfully created. We have nothing to do if it wasn't
    if(!GetIsObjectValid(oTemplate))
    {
        if(DEBUG) DoDebug("prc_inc_shifting: ShiftIntoResRef(): ERROR: Failed to create creature from template resref: " + sResRef);
        SendMessageToPCByStrRef(oShifter, STRREF_TEMPLATE_FAILURE); // "Polymorph failed: Failed to create a template of the creature to polymorph into."
    }
    else
    {
        // See if the shifter can in fact shift into the given template
        if(GetCanShiftIntoCreature(oShifter, nShifterType, oTemplate))
        {
            // It can - activate mutex
            SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, TRUE);

            // Unshift if already shifted and then proceed with shifting into the template
            // Also, give other stuff 100ms to execute in between
            if(GetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER))
                DelayCommand(0.1f, _prc_inc_shifting_UnShiftAux(oShifter, nShifterType, oTemplate, bGainSpellLikeAbilities));
            else
                DelayCommand(0.1f, _prc_inc_shifting_ShiftIntoTemplateAux(oShifter, nShifterType, oTemplate, bGainSpellLikeAbilities));

            // Return that we were able to successfully start shifting
            return TRUE;
        }
    }

    // We didn't reach the success branch for some reason
    return FALSE;
}

int UnShift(object oShifter, int bRemovePoly = TRUE, int bIgnoreShiftingMutex = FALSE)
{
    // Shifting mutex is set and we are not told to ignore it, so abort right away
    if(GetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX) && !bIgnoreShiftingMutex)
        return UNSHIFT_FAIL;

    // Check for polymorph effects
    int bHadPoly = FALSE;
    effect eTest = GetFirstEffect(oShifter);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            // Depending on whether we are supposed to remove them or not either remove the effect or abort
            if(bRemovePoly)
            {
                bHadPoly = UNSHIFT_FAIL;
                RemoveEffect(oShifter, eTest);
            }
            else
                return FALSE;

        eTest = GetNextEffect(oShifter);
    }

    // Check for true form being stored
    if(!GetPersistantLocalInt(oShifter, SHIFTER_TRUEAPPEARANCE))
        return UNSHIFT_FAIL;

    // The unshifting should always proceed succesfully from this point on, so set the mutex
    SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, TRUE);

    // If we had a polymorph effect present, start the removal monitor
    if(bHadPoly)
    {
        DelayCommand(0.1f, _prc_inc_shifting_UnShiftAux_SeekPolyEnd(oShifter, GetItemInSlot(INVENTORY_SLOT_CARMOUR, oShifter)));
        return UNSHIFT_SUCCESS_DELAYED;
    }
    else
    {
        _prc_inc_shifting_UnShiftAux(oShifter, SHIFTER_TYPE_NONE, OBJECT_INVALID, FALSE);
        DeletePersistantLocalInt(oShifter, "TempShifted");
        return UNSHIFT_SUCCESS;
    }
}


// Appearance data functions

struct appearancevalues GetAppearanceData(object oTemplate)
{
   struct appearancevalues appval;
   // The appearance type
    appval.nAppearanceType         = GetAppearanceType(oTemplate);
    // Body parts
    appval.nBodyPart_RightFoot     = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,     oTemplate);
    appval.nBodyPart_LeftFoot      = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,      oTemplate);
    appval.nBodyPart_RightShin     = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,     oTemplate);
    appval.nBodyPart_LeftShin      = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,      oTemplate);
    appval.nBodyPart_RightThigh    = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,    oTemplate);
    appval.nBodyPart_LeftThight    = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,     oTemplate);
    appval.nBodyPart_Pelvis        = GetCreatureBodyPart(CREATURE_PART_PELVIS,         oTemplate);
    appval.nBodyPart_Torso         = GetCreatureBodyPart(CREATURE_PART_TORSO,          oTemplate);
    appval.nBodyPart_Belt          = GetCreatureBodyPart(CREATURE_PART_BELT,           oTemplate);
    appval.nBodyPart_Neck          = GetCreatureBodyPart(CREATURE_PART_NECK,           oTemplate);
    appval.nBodyPart_RightForearm  = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,  oTemplate);
    appval.nBodyPart_LeftForearm   = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,   oTemplate);
    appval.nBodyPart_RightBicep    = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,    oTemplate);
    appval.nBodyPart_LeftBicep     = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,     oTemplate);
    appval.nBodyPart_RightShoulder = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, oTemplate);
    appval.nBodyPart_LeftShoulder  = GetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,  oTemplate);
    appval.nBodyPart_RightHand     = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,     oTemplate);
    appval.nBodyPart_LeftHand      = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND,      oTemplate);
    appval.nBodyPart_Head          = GetCreatureBodyPart(CREATURE_PART_HEAD,           oTemplate);
    // Wings
    appval.nWingType               = GetCreatureWingType(oTemplate);
    // Tail
    appval.nTailType               = GetCreatureTailType(oTemplate);
    // Portrait ID
    appval.nPortraitID             = GetPortraitId(oTemplate);
    // Portrait resref
    appval.sPortraitResRef         = GetPortraitResRef(oTemplate);
    // Footstep type
    appval.nFootStepType           = GetFootstepType(oTemplate);
    // Gender
    appval.nGender                 = GetGender(oTemplate);
    /* Commented out until 1.69
    // Skin color
    appval.nSkinColor              = GetColor(oTemplate, COLOR_CHANNEL_SKIN);
    // Hair color
    appval.nHairColor              = GetColor(oTemplate, COLOR_CHANNEL_HAIR);
    // Tattoo 1 color
    appval.nTat1Color              = GetColor(oTemplate, COLOR_CHANNEL_TATTOO_1);
    // Tattoo 2 color
    appval.nTat2Color              = GetColor(oTemplate, COLOR_CHANNEL_TATTOO_2);
    */


    return appval;
}

void SetAppearanceData(object oTarget, struct appearancevalues appval)
{
//DoDebug("Setting the appearance of " + DebugObject2Str(oTarget) + "to:\n" + DebugAppearancevalues2Str(appval));
   // The appearance type
   SetCreatureAppearanceType(oTarget, appval.nAppearanceType);
   // Body parts - Delayed, since it seems not delaying this makes the body part setting fail, instead resulting in no visible
   // parts. Some interaction with SetCreatureAppearance(), maybe?
   // Applies to NWN1 1.68. Kudos to Primogenitor for originally figuring this out - Ornedan
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT     , appval.nBodyPart_RightFoot     , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT      , appval.nBodyPart_LeftFoot      , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN     , appval.nBodyPart_RightShin     , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN      , appval.nBodyPart_LeftShin      , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH    , appval.nBodyPart_RightThigh    , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH     , appval.nBodyPart_LeftThight    , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_PELVIS         , appval.nBodyPart_Pelvis        , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_TORSO          , appval.nBodyPart_Torso         , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_BELT           , appval.nBodyPart_Belt          , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_NECK           , appval.nBodyPart_Neck          , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM  , appval.nBodyPart_RightForearm  , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM   , appval.nBodyPart_LeftForearm   , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP    , appval.nBodyPart_RightBicep    , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP     , appval.nBodyPart_LeftBicep     , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER , appval.nBodyPart_RightShoulder , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER  , appval.nBodyPart_LeftShoulder  , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND     , appval.nBodyPart_RightHand     , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_LEFT_HAND      , appval.nBodyPart_LeftHand      , oTarget));
   DelayCommand(1.0f, SetCreatureBodyPart(CREATURE_PART_HEAD           , appval.nBodyPart_Head          , oTarget));
   // Wings
   SetCreatureWingType(appval.nWingType, oTarget);
   // Tail
    SetCreatureTailType(appval.nTailType, oTarget);
    // Footstep type
    SetFootstepType(appval.nFootStepType, oTarget);

    /* Portrait stuff */
    // If the portrait ID is not PORTRAIT_INVALID, use it. This will also set the resref
    if(appval.nPortraitID != PORTRAIT_INVALID)
        SetPortraitId(oTarget, appval.nPortraitID);
    // Otherwise, use the portrait resref. This will set portrait ID to PORTRAIT_INVALID
    else
        SetPortraitResRef(oTarget, appval.sPortraitResRef);

    //replace with SetGender if 1.69 adds it
    if(GetGender(oTarget) != appval.nGender && appval.nAppearanceType < 7)
    {
        if(GetFirstArcaneClass(oTarget) != CLASS_TYPE_INVALID)
            SetPortraitId(oTarget, 1061); //generic wizard port
        else if(GetFirstDivineClass(oTarget) != CLASS_TYPE_INVALID)
            SetPortraitId(oTarget, 1033); //generic cleric port
        else
            SetPortraitId(oTarget, 1043); //generic fighter port
    }

    /* Commented out until 1.69
    // Skin color
    SetColor(oTarget, COLOR_CHANNEL_SKIN, appval.nSkinColor);
    // Hair color
    SetColor(oTemplate, COLOR_CHANNEL_HAIR, appval.nHairColor);
    // Tattoo 2 color
    SetColor(oTemplate, COLOR_CHANNEL_TATTOO_1, appval.nTat1Color);
    // Tattoo 1 color
    SetColor(oTemplate, COLOR_CHANNEL_TATTOO_2, appval.nTat2Color);
    */
}

struct appearancevalues GetLocalAppearancevalues(object oStore, string sName)
{
    struct appearancevalues appval;
   // The appearance type
    appval.nAppearanceType         = GetLocalInt(oStore, sName + "nAppearanceType");
    // Body parts
    appval.nBodyPart_RightFoot     = GetLocalInt(oStore, sName + "nBodyPart_RightFoot");
    appval.nBodyPart_LeftFoot      = GetLocalInt(oStore, sName + "nBodyPart_LeftFoot");
    appval.nBodyPart_RightShin     = GetLocalInt(oStore, sName + "nBodyPart_RightShin");
    appval.nBodyPart_LeftShin      = GetLocalInt(oStore, sName + "nBodyPart_LeftShin");
    appval.nBodyPart_RightThigh    = GetLocalInt(oStore, sName + "nBodyPart_RightThigh");
    appval.nBodyPart_LeftThight    = GetLocalInt(oStore, sName + "nBodyPart_LeftThight");
    appval.nBodyPart_Pelvis        = GetLocalInt(oStore, sName + "nBodyPart_Pelvis");
    appval.nBodyPart_Torso         = GetLocalInt(oStore, sName + "nBodyPart_Torso");
    appval.nBodyPart_Belt          = GetLocalInt(oStore, sName + "nBodyPart_Belt");
    appval.nBodyPart_Neck          = GetLocalInt(oStore, sName + "nBodyPart_Neck");
    appval.nBodyPart_RightForearm  = GetLocalInt(oStore, sName + "nBodyPart_RightForearm");
    appval.nBodyPart_LeftForearm   = GetLocalInt(oStore, sName + "nBodyPart_LeftForearm");
    appval.nBodyPart_RightBicep    = GetLocalInt(oStore, sName + "nBodyPart_RightBicep");
    appval.nBodyPart_LeftBicep     = GetLocalInt(oStore, sName + "nBodyPart_LeftBicep");
    appval.nBodyPart_RightShoulder = GetLocalInt(oStore, sName + "nBodyPart_RightShoulder");
    appval.nBodyPart_LeftShoulder  = GetLocalInt(oStore, sName + "nBodyPart_LeftShoulder");
    appval.nBodyPart_RightHand     = GetLocalInt(oStore, sName + "nBodyPart_RightHand");
    appval.nBodyPart_LeftHand      = GetLocalInt(oStore, sName + "nBodyPart_LeftHand");
    appval.nBodyPart_Head          = GetLocalInt(oStore, sName + "nBodyPart_Head");
    // Wings
    appval.nWingType               = GetLocalInt(oStore, sName + "nWingType");
    // Tail
    appval.nTailType               = GetLocalInt(oStore, sName + "nTailType");
    // Portrait ID
    appval.nPortraitID             = GetLocalInt(oStore, sName + "nPortraitID");
    // Portrait resref
    appval.sPortraitResRef         = GetLocalString(oStore, sName + "sPortraitResRef");
    // Footstep type
    appval.nFootStepType           = GetLocalInt(oStore, sName + "nFootStepType");
    // Gender
    appval.nGender                 = GetLocalInt(oStore, sName + "nGender");

    // Skin color
    appval.nSkinColor              = GetLocalInt(oStore, sName + "nSkinColor");
    // Hair color
    appval.nHairColor              = GetLocalInt(oStore, sName + "nHairColor");
    // Tattoo 1 color
    appval.nTat1Color              = GetLocalInt(oStore, sName + "nTat1Color");
    // Tattoo 2 color
    appval.nTat2Color              = GetLocalInt(oStore, sName + "nTat2Color");


    return appval;
}

void SetLocalAppearancevalues(object oStore, string sName, struct appearancevalues appval)
{
   // The appearance type
    SetLocalInt(oStore, sName + "nAppearanceType"        , appval.nAppearanceType         );
    // Body parts
    SetLocalInt(oStore, sName + "nBodyPart_RightFoot"    , appval.nBodyPart_RightFoot     );
    SetLocalInt(oStore, sName + "nBodyPart_LeftFoot"     , appval.nBodyPart_LeftFoot      );
    SetLocalInt(oStore, sName + "nBodyPart_RightShin"    , appval.nBodyPart_RightShin     );
    SetLocalInt(oStore, sName + "nBodyPart_LeftShin"     , appval.nBodyPart_LeftShin      );
    SetLocalInt(oStore, sName + "nBodyPart_RightThigh"   , appval.nBodyPart_RightThigh    );
    SetLocalInt(oStore, sName + "nBodyPart_LeftThight"   , appval.nBodyPart_LeftThight    );
    SetLocalInt(oStore, sName + "nBodyPart_Pelvis"       , appval.nBodyPart_Pelvis        );
    SetLocalInt(oStore, sName + "nBodyPart_Torso"        , appval.nBodyPart_Torso         );
    SetLocalInt(oStore, sName + "nBodyPart_Belt"         , appval.nBodyPart_Belt          );
    SetLocalInt(oStore, sName + "nBodyPart_Neck"         , appval.nBodyPart_Neck          );
    SetLocalInt(oStore, sName + "nBodyPart_RightForearm" , appval.nBodyPart_RightForearm  );
    SetLocalInt(oStore, sName + "nBodyPart_LeftForearm"  , appval.nBodyPart_LeftForearm   );
    SetLocalInt(oStore, sName + "nBodyPart_RightBicep"   , appval.nBodyPart_RightBicep    );
    SetLocalInt(oStore, sName + "nBodyPart_LeftBicep"    , appval.nBodyPart_LeftBicep     );
    SetLocalInt(oStore, sName + "nBodyPart_RightShoulder", appval.nBodyPart_RightShoulder );
    SetLocalInt(oStore, sName + "nBodyPart_LeftShoulder" , appval.nBodyPart_LeftShoulder  );
    SetLocalInt(oStore, sName + "nBodyPart_RightHand"    , appval.nBodyPart_RightHand     );
    SetLocalInt(oStore, sName + "nBodyPart_LeftHand"     , appval.nBodyPart_LeftHand      );
    SetLocalInt(oStore, sName + "nBodyPart_Head"         , appval.nBodyPart_Head          );
    // Wings
    SetLocalInt(oStore, sName + "nWingType"              , appval.nWingType               );
    // Tail
    SetLocalInt(oStore, sName + "nTailType"              , appval.nTailType               );
    // Portrait ID
    SetLocalInt(oStore, sName + "nPortraitID"            , appval.nPortraitID             );
    // Portrait resref
    SetLocalString(oStore, sName + "sPortraitResRef"     , appval.sPortraitResRef         );
    // Footstep type
    SetLocalInt(oStore, sName + "nFootStepType"          , appval.nFootStepType           );
    //Gender
    SetLocalInt(oStore, sName + "nGender"                , appval.nGender                 );

    // Skin color
    SetLocalInt(oStore, sName + "nSkinColor"             , appval.nSkinColor              );
    // Hair color
    SetLocalInt(oStore, sName + "nHairColor"             , appval.nHairColor              );
    // Tattoo 1 color
    SetLocalInt(oStore, sName + "nTat1Color"             , appval.nTat1Color              );
    // Tattoo 2 color
    SetLocalInt(oStore, sName + "nTat2Color"             , appval.nTat2Color              );

}

void DeleteLocalAppearancevalues(object oStore, string sName)
{
   // The appearance type
    DeleteLocalInt(oStore, sName + "nAppearanceType");
    // Body parts
    DeleteLocalInt(oStore, sName + "nBodyPart_RightFoot");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftFoot");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightShin");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftShin");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightThigh");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftThight");
    DeleteLocalInt(oStore, sName + "nBodyPart_Pelvis");
    DeleteLocalInt(oStore, sName + "nBodyPart_Torso");
    DeleteLocalInt(oStore, sName + "nBodyPart_Belt");
    DeleteLocalInt(oStore, sName + "nBodyPart_Neck");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightForearm");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftForearm");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightBicep");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftBicep");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightShoulder");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftShoulder");
    DeleteLocalInt(oStore, sName + "nBodyPart_RightHand");
    DeleteLocalInt(oStore, sName + "nBodyPart_LeftHand");
    DeleteLocalInt(oStore, sName + "nBodyPart_Head");
    // Wings
    DeleteLocalInt(oStore, sName + "nWingType");
    // Tail
    DeleteLocalInt(oStore, sName + "nTailType");
    // Portrait ID
    DeleteLocalInt(oStore, sName + "nPortraitID");
    // Portrait resref
    DeleteLocalString(oStore, sName + "sPortraitResRef");
    // Footstep type
    DeleteLocalInt(oStore, sName + "nFootStepType");
    // Gender
    DeleteLocalInt(oStore, sName + "nGender");
    // Skin color
    DeleteLocalInt(oStore, sName + "nSkinColor");
    // Hair color
    DeleteLocalInt(oStore, sName + "nHairColor");
    // Tattoo 1 color
    DeleteLocalInt(oStore, sName + "nTat1Color");
    // Tattoo 2 color
    DeleteLocalInt(oStore, sName + "nTat2Color");
}

struct appearancevalues GetPersistantLocalAppearancevalues(object oStore, string sName)
{
    object oToken = GetHideToken(oStore);
    return GetLocalAppearancevalues(oToken, sName);
}

void SetPersistantLocalAppearancevalues(object oStore, string sName, struct appearancevalues appval)
{
    object oToken = GetHideToken(oStore);
    SetLocalAppearancevalues(oToken, sName, appval);
}

void DeletePersistantLocalAppearancevalues(object oStore, string sName)
{
    object oToken = GetHideToken(oStore);
    DeleteLocalAppearancevalues(oToken, sName);
}

void ForceUnshift(object oShifter, int nShiftedNumber)
{
    if(GetPersistantLocalInt(oShifter, "nTimesShifted") == nShiftedNumber)
        UnShift(oShifter);
}

string DebugAppearancevalues2Str(struct appearancevalues appval)
{
    return "Appearance type            = " + IntToString(appval.nAppearanceType) + "\n"
         + "Body part - Right Foot     = " + IntToString(appval.nBodyPart_RightFoot    ) + "\n"
         + "Body part - Left Foot      = " + IntToString(appval.nBodyPart_LeftFoot     ) + "\n"
         + "Body part - Right Shin     = " + IntToString(appval.nBodyPart_RightShin    ) + "\n"
         + "Body part - Left Shin      = " + IntToString(appval.nBodyPart_LeftShin     ) + "\n"
         + "Body part - Right Thigh    = " + IntToString(appval.nBodyPart_RightThigh   ) + "\n"
         + "Body part - Left Thigh     = " + IntToString(appval.nBodyPart_LeftThight   ) + "\n"
         + "Body part - Pelvis         = " + IntToString(appval.nBodyPart_Pelvis       ) + "\n"
         + "Body part - Torso          = " + IntToString(appval.nBodyPart_Torso        ) + "\n"
         + "Body part - Belt           = " + IntToString(appval.nBodyPart_Belt         ) + "\n"
         + "Body part - Neck           = " + IntToString(appval.nBodyPart_Neck         ) + "\n"
         + "Body part - Right Forearm  = " + IntToString(appval.nBodyPart_RightForearm ) + "\n"
         + "Body part - Left Forearm   = " + IntToString(appval.nBodyPart_LeftForearm  ) + "\n"
         + "Body part - Right Bicep    = " + IntToString(appval.nBodyPart_RightBicep   ) + "\n"
         + "Body part - Left Bicep     = " + IntToString(appval.nBodyPart_LeftBicep    ) + "\n"
         + "Body part - Right Shoulder = " + IntToString(appval.nBodyPart_RightShoulder) + "\n"
         + "Body part - Left Shoulder  = " + IntToString(appval.nBodyPart_LeftShoulder ) + "\n"
         + "Body part - Right Hand     = " + IntToString(appval.nBodyPart_RightHand    ) + "\n"
         + "Body part - Left Hand      = " + IntToString(appval.nBodyPart_LeftHand     ) + "\n"
         + "Body part - Head           = " + IntToString(appval.nBodyPart_Head         ) + "\n"
         + "Wings                      = " + IntToString(appval.nWingType) + "\n"
         + "Tail                       = " + IntToString(appval.nTailType) + "\n"
         + "Portrait ID                = " + (appval.nPortraitID == PORTRAIT_INVALID ? "PORTRAIT_INVALID" : IntToString(appval.nPortraitID)) + "\n"
         + "Portrait ResRef            = " + appval.sPortraitResRef + "\n"
         + "Footstep type              = " + IntToString(appval.nFootStepType) + "\n"
         + "Gender                     = " + IntToString(appval.nGender) + "\n"
         + "Skin color                 = " + IntToString(appval.nSkinColor) + "\n"
         + "Hair color                 = " + IntToString(appval.nHairColor) + "\n"
         + "Tattoo 1 color             = " + IntToString(appval.nTat1Color) + "\n"
         + "Tattoo 2 color             = " + IntToString(appval.nTat2Color) + "\n"
         ;
}

// @DUG
void pnpsMsg(string msg, object oPC = OBJECT_SELF, int bFloating = TRUE)
{
   if (bFloating)
   {
      FloatingTextStringOnCreature(msg, oPC, FALSE);
      WriteTimestampedLogEntry(msg);
   }
   else
   {
      SendMessageToPC(oPC, msg);
   }
}

// @DUG
void scrubSkillBonuses(object oShifter = OBJECT_SELF)
{
   effect eEffect = GetFirstEffect(oShifter);
   while (GetIsEffectValid(eEffect))
   {
      if (GetEffectType(eEffect) == EFFECT_TYPE_SKILL_INCREASE &&
          GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
      {
         RemoveEffect(oShifter, eEffect);
      }
      eEffect = GetNextEffect(oShifter);
   }
}

// Test main
//void main(){}
