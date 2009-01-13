#include "prc_alterations"
#include "inc_leto_prc"
#include "x2_inc_switches"
#include "prc_inc_teleport"
#include "prc_inc_leadersh"
#include "prc_inc_domain"
#include "prc_inc_shifting" // @DUG recompile only
#include "true_inc_trufunc"
#include "prc_craft_inc"
#include "prc_inc_dragsham"
#include "inc_debug_dac" // @DUG

/**
 * Reads the 2da file onenter_locals.2da and sets local variables
 * on the entering PC accordingly. 2da format same as personal_switches.2da,
 * see prc_inc_switches header comment for details.
 *
 * @param oPC The PC that just entered the module
 */
void DoAutoLocals(object oPC)
{
    int i = 0;
    string sSwitchName, sSwitchType, sSwitchValue;
    // Use Get2DAString() instead of Get2DACache() to avoid caching.
    while((sSwitchName = Get2DAString("onenter_locals", "SwitchName", i)) != "")
    {
        // Read rest of the line
        sSwitchType  = Get2DAString("onenter_locals", "SwitchType",  i);
        sSwitchValue = Get2DAString("onenter_locals", "SwitchValue", i);

        // Determine switch type and set the var
        if     (sSwitchType == "float")
            SetLocalFloat(oPC, sSwitchName, StringToFloat(sSwitchValue));
        else if(sSwitchType == "int")
            SetLocalInt(oPC, sSwitchName, StringToInt(sSwitchValue));
        else if(sSwitchType == "string")
            SetLocalString(oPC, sSwitchName, sSwitchValue);

        // Increment loop counter
        i += 1;
    }
}

//Restores object itemprops
void RestoreObjects(object oCreature)
{
    int i = 0;
    int j = 0;
    int nIP = 0;
    object oItem;
    string sItem;
    itemproperty ip;
    string sIP;
    struct ipstruct iptemp;
    string sCreature = GetName(oCreature);
    string sItemName;
    int nSize = persistant_array_get_size(oCreature, "PRC_NPF_ItemList_obj");
    for(i = 0; i < nSize; i++)
    {
        oItem = persistant_array_get_object(oCreature, "PRC_NPF_ItemList_obj", i);
        sItem = persistant_array_get_string(oCreature, "PRC_NPF_ItemList_str", i);
        sItemName = GetName(oItem);
        if(DEBUG)
        {
            DoDebug("RestoreObjects: " + sCreature + ", " + sItemName + ", " + sItem + ", " + ObjectToString(oItem));
        }
        nIP = persistant_array_get_size(oCreature, "PRC_NPF_ItemList_" + sItem);
        for(j = 0; j < nIP; j++)
        {
            sIP = persistant_array_get_string(oCreature, "PRC_NPF_ItemList_" + sItem, j);
            iptemp = GetIpStructFromString(sIP);
            ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);
            debugVarItemProperty("prc_onenter ip", ip);
            IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            if(DEBUG) DoDebug("RestoreObjects: " + sCreature + ", " + sItem + ", " + sIP);
        }
        persistant_array_delete(oCreature, "PRC_NPF_ItemList_" + sItem);
    }
    persistant_array_delete(oCreature, "PRC_NPF_ItemList_obj");
    persistant_array_delete(oCreature, "PRC_NPF_ItemList_str");
}

void main()
{
    debugVarObject("prc_onenter", OBJECT_SELF);
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
    object oPC = GetEnteringObject();
    debugVarObject("oPC", oPC);

    //FloatingTextStringOnCreature("PRC on enter was called", oPC, FALSE);

    // Since OnEnter event fires for the PC when loading a saved game (no idea why,
    // since it makes saving and reloading change the state of the module),
    // make sure that the event gets run only once
    // but not in MP games, so check if it's single player or not!!
    if(GetLocalInt(oPC, "PRC_ModuleOnEnterDone") && (GetPCPublicCDKey(oPC) == ""))
    { // @DUG
        debugMsg("saved game, returning immediately");
        return;
    } // @DUG
    // Use a local integer to mark the event as done for the PC, so that it gets
    // cleared when the character is saved.
    else
        SetLocalInt(oPC, "PRC_ModuleOnEnterDone", TRUE);

    //if server is loading, boot player
    if(GetLocalInt(GetModule(), PRC_PW_LOGON_DELAY+"_TIMER"))
    {
        debugMsg("server loading");
        BootPC(oPC);
        return;
    }

    // return here for DMs as they don't need all this stuff
    if(GetIsDM(oPC))
    { // @DUG
        debugMsg("DM, returning immediately");
        return;
    } // @DUG

    //do this first so other things dont interfere with it
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCEnter(oPC);
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE) && !GetIsDM(oPC)
        && !GetPRCSwitch(PRC_CONVOCC_CUSTOM_START_LOCATION) && ExecuteScriptAndReturnInt("prc_ccc_main", OBJECT_SELF))
    { // @DUG
        debugMsg("ConvoCC enabled, returning");
        return;
    } // @DUG

    object oSkin = GetPCSkin(oPC);
    debugVarObject("oSkin", oSkin);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    // Gives people the proper spells from their bonus domains
    // This should run before EvalPRCFeats, because it sets a variable
    CheckBonusDomains(oPC);
    // Set the uses per day for domains
    BonusDomainRest(oPC);
    // Clear old variables for Truenaming
    ClearLawLocalVars(oPC);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    DelayCommand(0.1, FeatSpecialUsePerDay(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    ExecuteScript("prc_psi_ppoints", oPC);
    ResetTouchOfVitality(oPC);
    if (GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) > 0)
    {
        ExecuteScript("prc_wwunpoly", oPC);
    }
    DelayCommand(0.15, DeleteLocalInt(oPC,"ONENTER"));

    //remove effects from hides, can stack otherwise
    effect eTest=GetFirstEffect(oPC);

    while (GetIsEffectValid(eTest))
    {
        if(GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
            && (GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
                || GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE
                //add other types here
                )
            && !GetIsObjectValid(GetEffectCreator(eTest))
            )
            RemoveEffect(oPC, eTest);
        eTest=GetNextEffect(oPC);
   }


    if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES) && !GetIsDM(oPC))
        PRCLetoEnter(oPC);

    //PW tracking starts here
    if(GetPRCSwitch(PRC_PW_HP_TRACKING))
    {
        int nHP = GetPersistantLocalInt(oPC, "persist_HP");
        if(nHP != 0)  // 0 is not stored yet i.e. first logon
        {
            int nDamage=GetCurrentHitPoints(oPC)-nHP;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDamage), oPC);
        }

    }
    if(GetPRCSwitch(PRC_PW_TIME))
    {
        struct time tTime = GetPersistantLocalTime(oPC, "persist_Time");
            //first pc logging on
        if(GetIsObjectValid(GetFirstPC())
            && !GetIsObjectValid(GetNextPC()))
        {
            SetTimeAndDate(tTime);
        }
        RecalculateTime();
    }
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        struct metalocation lLoc = GetPersistantLocalMetalocation(oPC, "persist_loc");
        DelayCommand(6.0, AssignCommand(oPC, JumpToLocation(MetalocationToLocation(lLoc))));
    }
    if(GetPRCSwitch(PRC_PW_MAPPIN_TRACKING)
        && !GetLocalInt(oPC, "PRC_PW_MAPPIN_TRACKING_Done"))
    {
        //this local is set so that this is only done once per server session
        SetLocalInt(oPC, "PRC_PW_MAPPIN_TRACKING_Done", TRUE);
        int nCount = GetPersistantLocalInt(oPC, "MapPinCount");
        int i;
        for(i=1; i<=nCount; i++)
        {
            struct metalocation mlocLoc = GetPersistantLocalMetalocation(oPC, "MapPin_"+IntToString(i));
            CreateMapPinFromMetalocation(mlocLoc, oPC);
        }
    }
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING))
    {
        int bDead = GetPersistantLocalInt(oPC, "persist_dead");
        if(bDead == 1)
        {
            int nDamage=9999;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDamage), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }

    }
    if(GetPRCSwitch(PRC_PW_SPELL_TRACKING))
    {
        string sSpellList = GetPersistantLocalString(oPC, "persist_spells");
        string sTest;
        string sChar;
        while(GetStringLength(sSpellList))
        {
            sChar = GetStringLeft(sSpellList,1);
            if(sChar == "|")
            {
                int nSpell = StringToInt(sTest);
                DecrementRemainingSpellUses(oPC, nSpell);
                sTest == "";
            }
            else
                sTest += sChar;
            sSpellList = GetStringRight(sSpellList, GetStringLength(sSpellList)-1);
        }
    }
    //check for persistant golems
    if(persistant_array_exists(oPC, "GolemList"))
    {
        MultisummonPreSummon(oPC, TRUE);
        int i;
        for(i=1;i<persistant_array_get_size(oPC, "GolemList");i++)
        {
            string sResRef = persistant_array_get_string(oPC, "GolemList",i);
            effect eSummon = SupernaturalEffect(EffectSummonCreature(sResRef));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummon, oPC);
        }
    }

    // Create map pins from marked teleport locations if the PC has requested that such be done.
    if(GetLocalInt(oPC, PRC_TELEPORT_CREATE_MAP_PINS))
        DelayCommand(10.0f, TeleportLocationsToMapPins(oPC));

    if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD)
        && !GetXP(oPC))
    {
        int nRealRace = GetRacialType(oPC);
        int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRealRace));
        int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRealRace));
        if(nRacialHD)
        {
            if(!GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP))
            {
                int nNewXP = nRacialHD*(nRacialHD+1)*500; //+1 for the original class level
                SetXP(oPC, nNewXP);
                if(GetPRCSwitch(PRC_XP_USE_SIMPLE_LA))
                    DelayCommand(1.0, SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, nNewXP));
            }
            if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION))
            {
                int i;
                for(i=0;i<nRacialHD;i++)
                {
                    LevelUpHenchman(oPC, nRacialClass, TRUE);
                }
            }
        }
    }

    // Insert various messages here
    if(DEBUG)
    {
        // Duplicate PRCItemPropertyBonusFeat monitor
        SpawnNewThread("PRC_Duplicate_IPBFeat_Mon", "prc_debug_hfeatm", 30.0f, oPC);
    }

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC) && GetThreadState("PRC_Spellfire", oPC) == THREAD_STATE_DEAD)
        SpawnNewThread("PRC_Spellfire", "prc_spellfire_hb", 6.0f, oPC);

    //if the player logged off while being registered as a cohort
    if(GetPersistantLocalInt(oPC, "RegisteringAsCohort"))
        AssignCommand(GetModule(), CheckHB(oPC));

    // If the PC logs in shifted, unshift them
    if(GetPersistantLocalInt(oPC, SHIFTER_ISSHIFTED_MARKER))
        UnShift(oPC);

    // Set up local variables based on a 2da file
    DoAutoLocals(oPC);

    if(GetPersistantLocalInt(oPC, "NullPsionicsField")) //NPF persistence
    {
        DeleteLocalInt(oPC, "NullPsionicsField");
        RestoreObjects(oPC);
    }

    debugVarObject("calling tob_evnt_recover", oPC);
    ExecuteScript("tob_evnt_recover", oPC);

    // Execute scripts hooked to this event for the player triggering it
    //How can this work? The PC isnt a valid object before this. - Primogenitor
    //Some stuff may have gone "When this PC next logs in, run script X" - Ornedan
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTENTER);

    debugVarObject("prc_onenter COMPLETE", OBJECT_SELF);
}
