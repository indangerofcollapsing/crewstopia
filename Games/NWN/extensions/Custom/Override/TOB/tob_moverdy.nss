//:://////////////////////////////////////////////
//:: Maneuver Readying Conversation
//:: tob_moverdy
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which maneuvers to ready.


    @author Stratovarius
    @date   Created  - 25.3.2007
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "tob_inc_recovery"
#include "inc_debug_dac" // @DUG

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL           = 0;
const int STAGE_SELECT_MANEUVER        = 1;
const int STAGE_CONFIRM_SELECTION      = 2;
const int STAGE_ALL_MANEUVERS_SELECTED = 3;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16829723; // "Return to maneuver level selection."
const int STRREF_LEVELLIST_HEADER   = 16829724; // "Select level of maneuver to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's maneuvers."
const int STRREF_MOVELIST_HEADER1   = 16829725; // "Select a maneuver to gain.\nYou can select"
const int STRREF_MOVELIST_HEADER2   = 16829726; // "more maneuvers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16829727; // "You will be able to select more maneuvers after you gain another level in a blade magic initiator class."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"
const int STRREF_MOVESTANCE_HEADER  = 16829729; // "Choose Maneuver or Stances."
const int STRREF_STANCE             = 16829730; // "Stances"
const int STRREF_MANEUVER           = 16829731; // "Maneuvers"


//////////////////////////////////////////////////
/* Aid Functions                                */
//////////////////////////////////////////////////

int _GetLoopEnd(int nClass)
{
   if (nClass == CLASS_TYPE_CRUSADER) return 73;
   else if (nClass == CLASS_TYPE_SWORDSAGE) return 141;
   else if (nClass == CLASS_TYPE_WARBLADE) return 110;

   return -1;
}

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
   debugVarObject("tob_moverdy", OBJECT_SELF);
    object oPC = GetPCSpeaker();
    debugVarObject("oPC", oPC);
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    debugVarInt("nValue", nValue);
    int nStage = GetStage(oPC);
    debugVarInt("nStage", nStage);

    int nClass = GetLocalInt(oPC, "nClass");
    debugVarInt("nClass", nClass);
    string sPsiFile = GetAMSKnownFileName(nClass);
    debugVarString("sPsiFile", sPsiFile);
    string sManeuverFile = GetAMSDefinitionFileName(nClass);
    debugVarString("sManeuverFile", sManeuverFile);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        debugVarInt("tob_moverdy: setup stage", nStage);
        if(DEBUG) DoDebug("tob_moverdy: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            debugMsg("tob_moverdy: stage not setup");
            if(DEBUG) DoDebug("tob_moverdy: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                debugMsg("tob_moverdy: building level selection");
                if(DEBUG) DoDebug("tob_moverdy: Building level selection");
                SetHeader("Select the level of maneuvers to ready.");

                // Determine maximum maneuver level
                // Initiators get new maneuvers at the same levels as wizards
                // See ToB p39, table 3-1
                int nMaxLevel = (GetInitiatorLevel(oPC, nClass) + 1)/2;
                debugVarInt("nMaxLevel", nMaxLevel);

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    debugVarString("choice added", GetStringByStrRef(LEVEL_STRREF_START - i));
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_MANEUVER)
            {
                debugMsg("tob_moverdy: building maneuvers");
                if(DEBUG) DoDebug("tob_moverdy: Building maneuver selection");
                int nBrowseLevel = GetLocalInt(oPC, "nManeuverLevelToBrowse");
                debugVarInt("nBrowseLevel", nBrowseLevel);
                int nMaxReady   = GetMaxReadiedCount(oPC, nClass);
                debugVarInt("nMaxReady", nMaxReady);
                int nCountReady = GetReadiedCount(oPC, nClass);
                debugVarInt("nCountReady", nCountReady);
                int nMoveId;
                string sToken = "Select a Maneuver to ready. \n" + "You can select ";
                sToken += IntToString(nMaxReady-nCountReady) + " more maneuvers to ready.";
                SetHeader(sToken);

                // Start at the beginning of the level and scroll through to the end
                int i;
      for(i = 0; i < _GetLoopEnd(nClass); i++)
      {  // Checks to see if its the appropriate level
         int nMoveId = StringToInt(Get2DACache(sManeuverFile, "RealSpellID", i));
         debugVarInt("level from 2da", StringToInt(Get2DACache(sManeuverFile, "Level", i)));
         debugVarInt("stance from 2da", StringToInt(Get2DACache(sManeuverFile, "Stance", i)));
         if (GetHasManeuver(nMoveId, oPC) &&
             nBrowseLevel == StringToInt(Get2DACache(sManeuverFile, "Level", i)) &&
             1 != StringToInt(Get2DACache(sManeuverFile, "Stance", i)))
         {
            if (!GetIsManeuverReadied(oPC, nClass, nMoveId))
            {
               debugVarString("adding maneuver", GetManeuverName(nMoveId));
               AddChoice(GetManeuverName(nMoveId), i);
            }
else { debugVarInt("maneuver not readied", nMoveId); }
         }
                }
                debugVarInt("tob_moverdy: getendloop", _GetLoopEnd(nClass));
                if(DEBUG) DoDebug("tob_moverdy: GetEndLoop: " + IntToString(_GetLoopEnd(nClass)));

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                debugMsg("tob_moverdy: building selection confirm");
                if(DEBUG) DoDebug("tob_moverdy: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nManeuver = GetLocalInt(oPC, "nManeuver");
                int nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", nManeuver));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_MANEUVERS_SELECTED)
            {
                debugMsg("tob_moverdy: building finish note");
                if(DEBUG) DoDebug("tob_moverdy: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        debugMsg("tob_moverdy: exit handler");
        if(DEBUG) DoDebug("tob_moverdy: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nManeuver");
        DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
        DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        debugMsg("tob_moverdy: abort handler");
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_moverdy: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        debugMsg("tob_moverdy: PC response handler");
        int nChoice = GetChoice(oPC);
        debugVarInt("nChoice", nChoice);
        if(DEBUG) DoDebug("tob_moverdy: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
            if(DEBUG) DoDebug("tob_moverdy: Level selected");
            SetLocalInt(oPC, "nManeuverLevelToBrowse", nChoice);
            nStage = STAGE_SELECT_MANEUVER;
        }
        else if(nStage == STAGE_SELECT_MANEUVER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("tob_moverdy: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("tob_moverdy: Entering maneuver confirmation");
                SetLocalInt(oPC, "nManeuver", nChoice);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_MANEUVER, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("tob_moverdy: Handling maneuver confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("tob_moverdy: Adding maneuver readied");
                int nManeuver = GetLocalInt(oPC, "nManeuver");
                int nMoveId = StringToInt(Get2DACache(sManeuverFile, "RealSpellID", nManeuver));
                if(DEBUG) DoDebug("tob_moverdy: nReadyMoveId: " + IntToString(nMoveId));
                ReadyManeuver(oPC, nClass, nMoveId);

                // Delete the stored offset
                DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
            }

            // Determine whether they're missing maneuvers or stances
            int nMaxReady   = GetMaxReadiedCount(oPC, nClass);
            int nCountReady = GetReadiedCount(oPC, nClass);
            if(DEBUG) DoDebug("tob_moverdy: nCountReady: " + IntToString(nCountReady));
            if(DEBUG) DoDebug("tob_moverdy: nMaxReady: " + IntToString(nMaxReady));
            // Go to the end, and set all maneuvers as not expended
            if(nCountReady >= nMaxReady)
            {
                nStage = STAGE_ALL_MANEUVERS_SELECTED;
                RecoverExpendedManeuvers(oPC, nClass);
            }
            else
                nStage = STAGE_SELECT_LEVEL;
        }

        if(DEBUG) DoDebug("tob_moverdy: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
