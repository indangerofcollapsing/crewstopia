//:://////////////////////////////////////////////
//:: Shifter - Class evaluation
//:: prc_shifter
//:://////////////////////////////////////////////
/** @file
    Stores the PC's true form if it has not been
    stored already.
    Adds the default creatures to templates
    known list.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting" // @DUG recompile only

const string SHIFTER_DEFAULT_TEMPLATES = "shifterlist";

void DelayedStoreTemplate(object oPC, location lSpawn, string sResRef)
{
    object oTemplate = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
    StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTemplate);
    DestroyObject(oTemplate, 0.5f);
}

void main()
{
    // Called from EvalPRCFeats(), so the PC is OBJECT_SELF
    object oPC = OBJECT_SELF;

    // Store true form if not stored already. But not if affected by a polymorph effect
    if(!GetPersistantLocalInt(oPC, SHIFTER_TRUEAPPEARANCE))
        StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // Variables for the default templates granting
    int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
    int nGainedUpTo   = GetLocalInt(oPC, "PRC_Shifter_AutoGranted");
    int nLevel, i     = 0;
    string sLevel;
    object oSpawnWP   = GetWaypointByTag(SHIFTING_TEMPLATE_WP_TAG);
    object oTemplate;

    // Paranoia check - the WP should be built into the area data of Limbo
    if(!GetIsObjectValid(oSpawnWP))
    {
        if(DEBUG) DoDebug("prc_shifter: ERROR: Template spawn waypoint does not exist.");
        // Create the WP
        oSpawnWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, SHIFTING_TEMPLATE_WP_TAG);
    }

    // Get the WP's location
    location lSpawn  = GetLocation(oSpawnWP);

    // Check if there could be something in the 2da that could be granted, but hasn't been yet
    if(nShifterLevel > nGainedUpTo)
    {
        // The file ends at the first blank row
        while((sLevel = Get2DACache(SHIFTER_DEFAULT_TEMPLATES, "SLEVEL", i)) != "")
        {
            nLevel = StringToInt(sLevel);
            if(nLevel <= nShifterLevel && nLevel > nGainedUpTo)
            {
                DelayCommand(0.01f * i, DelayedStoreTemplate(oPC, lSpawn, Get2DACache(SHIFTER_DEFAULT_TEMPLATES, "CResRef", i)));
            }

            i++;
        }

        // Update the variable listing the highest level of autogranted templates
        SetLocalInt(oPC, "PRC_Shifter_AutoGranted", nShifterLevel);
    }
}
