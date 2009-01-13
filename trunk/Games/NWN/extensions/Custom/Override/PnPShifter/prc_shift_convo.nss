//:://////////////////////////////////////////////
//:: Shifter shifting options management conversation
//:: prc_shift_convo
//:://////////////////////////////////////////////
/** @file
    PnP Shifter shifting & shifting options management
    conversation script.


    @author Ornedan
    @date   Created  - 2006.03.01
    @date   Modified - 2006.10.07 - Finished
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_shifting" // @DUG recompile only

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                   = 0;
const int STAGE_CHANGESHAPE             = 1;
const int STAGE_LISTQUICKSHIFTS         = 2;
const int STAGE_DELETESHAPE             = 3;
const int STAGE_SETTINGS                = 4;
const int STAGE_SELECTQUICKSHIFTTYPE    = 5;
const int STAGE_SELECTQUICKSHIFTSHAPE   = 6;
const int STAGE_COULDNTSHIFT            = 7;


const int CHOICE_CHANGESHAPE            = 1;
const int CHOICE_CHANGESHAPE_EPIC       = 2;
const int CHOICE_LISTQUICKSHIFTS        = 3;
const int CHOICE_DELETESHAPE            = 6;
const int CHOICE_SETTINGS               = 7;

const int CHOICE_DRUIDWS                = 1;
const int CHOICE_STORE_TRUEAPPEARANCE   = 2;

const int CHOICE_NORMAL                 = 1;
const int CHOICE_EPIC                   = 2;

const int CHOICE_BACK_TO_MAIN           = -1;
const int STRREF_BACK_TO_MAIN           = 16824794; // "Back to main menu"

const string EPICVAR        = "PRC_ShiftConvo_Epic";
const string QSMODIFYVAR    = "PRC_ShiftConvo_QSToModify";

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void GenerateShapeList(object oPC)
{
    int i, nArraySize = GetNumberOfStoredTemplates(oPC, SHIFTER_TYPE_SHIFTER);

    for(i = 0; i < nArraySize; i++)
        AddChoice(GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, i), i, oPC);
}




//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                SetHeader(GetStringByStrRef(16824364) + " :"); // "Shifter Options :"


                AddChoiceStrRef(16828366,     CHOICE_CHANGESHAPE,      oPC); // "Change shape"
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) > 10) // Show the epic shift choice only if the character could use it
                    AddChoiceStrRef(16828367, CHOICE_CHANGESHAPE_EPIC, oPC); // "Change shape (epic)"
                AddChoiceStrRef(16828368,     CHOICE_LISTQUICKSHIFTS,  oPC); // "View / Assign shapes to your 'Quick Shift Slots'"
                AddChoiceStrRef(16828369,     CHOICE_DELETESHAPE,      oPC); // "Delete shapes you do not want anymore"
                AddChoiceStrRef(16828370,     CHOICE_SETTINGS,         oPC); // "Special settings"

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens();          // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CHANGESHAPE)
            {
                SetHeaderStrRef(GetLocalInt(oPC, EPICVAR) ?
                          16828371 : // "Select epic shape to become"
                          16828372   // "Select shape to become"
                          );

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_COULDNTSHIFT)
            {
                SetHeaderStrRef(16828373); // "You didn't have (Epic) Greater Wildshape uses available."

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);
            }
            else if(nStage == STAGE_LISTQUICKSHIFTS)
            {
                SetHeader("Select a 'Quick Shift Slot' to change the shape stored in it");

                int i;
                for(i = 1; i <= 10; i++)
                    AddChoice(GetStringByStrRef(16828374) + " " + IntToString(i) + " - " // "Quick Shift Slot N - "
                            + (GetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_ResRef") != "" ?
                               GetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_Name") :
                               GetStringByStrRef(16825282) // "Blank"
                               ),
                              i, oPC);

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
            {
                SetHeaderStrRef(16828375); // "Select whether you want this 'Quick Shift Slot' to use a normal shift or an epic shift."

                AddChoiceStrRef(66788, CHOICE_NORMAL, oPC); // "Normal"
                AddChoiceStrRef(83333, CHOICE_EPIC,   oPC); // "Epic"

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
            {
                SetHeaderStrRef(GetLocalInt(oPC, EPICVAR) ?
                                16828376 : // "Select epic shape to store"
                                16828377   // "Select shape to store"
                                );

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_DELETESHAPE)
            {
                SetHeaderStrRef(16828378); // "Select shape to delete.\nNote that if the shape is stored in any quickslots, the shape will still remain in those until you change their contents."

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SETTINGS)
            {
                SetHeaderStrRef(16828384); // "Select special setting to alter."

                AddChoice(GetStringByStrRef(16828379) // "Toggle using Druid Wildshape uses for Shifter Greater Wildshape when out of GWS uses. Current state: "
                        + (GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") ?
                           GetStringByStrRef(16828380) : // "On"
                           GetStringByStrRef(16828381)   // "Off"
                           ),
                          CHOICE_DRUIDWS, oPC);
                AddChoiceStrRef(16828385, CHOICE_STORE_TRUEAPPEARANCE, oPC); // "Store your current appearance as your true appearance (will not work if polymorphed or shifted)."

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        ClearCurrentStage(oPC);
        if(nStage == STAGE_ENTRY)
        {
            switch(nChoice)
            {
                case CHOICE_CHANGESHAPE_EPIC:
                    SetLocalInt(oPC, EPICVAR, TRUE);
                case CHOICE_CHANGESHAPE:
                    nStage = STAGE_CHANGESHAPE;
                    break;

                case CHOICE_LISTQUICKSHIFTS:
                    nStage = STAGE_LISTQUICKSHIFTS;
                    break;
                case CHOICE_DELETESHAPE:
                    nStage = STAGE_DELETESHAPE;
                    break;
                case CHOICE_SETTINGS:
                    nStage = STAGE_SETTINGS;
                    break;

                default:
                    DoDebug("prc_shift_convo: ERROR: Unknown choice value at STAGE_ENTRY: " + IntToString(nChoice));
            }
        }
        else if(nStage == STAGE_CHANGESHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be shifted into
            else
            {
                // Make sure the character has uses left for shifting
                int bPaid = FALSE;
                if(!GetLocalInt(oPC, EPICVAR)) // Normal shapechange
                {
                    // First try paying using Greater Wildshape uses
                    if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC))
                    {
                        DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);

                        // If we would reach 0 uses this way, see if we could pay with Druid Wildshape uses instead
                        if(!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC)    &&
                           GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
                           GetHasFeat(FEAT_WILD_SHAPE, oPC)
                           )
                        {
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
                      DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
                        }

                        bPaid = TRUE;
                    }
                    // Otherwise try paying with Druid Wildshape uses
                    else if(GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
                            GetHasFeat(FEAT_WILD_SHAPE, oPC)
                            )
                    {
                   DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
                   bPaid = TRUE;
                    }
                }
                // Epic shift, uses Epic Greater Wildshape
                else if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1, oPC))
                {
                    DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
                    bPaid = TRUE;
                }

                // If the user could pay for the shifting, do it
                if(bPaid)
                {
                    // Choice is index into the template list
                    if(!ShiftIntoResRef(oPC, SHIFTER_TYPE_SHIFTER,
                                        GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice),
                                        GetLocalInt(oPC, EPICVAR)
                                        )
                       )
                    {
                        // In case of shifting failure, refund the shifting use
                        if(GetLocalInt(oPC, EPICVAR))
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
                        else
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
                    }
                    // The convo should end now
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                // Otherwise, move to nag at them about it
                else
                    nStage = STAGE_COULDNTSHIFT;
            }
        }
        else if(nStage == STAGE_COULDNTSHIFT)
        {
            // Clear the epicness variable and return to main menu
            DeleteLocalInt(oPC, EPICVAR);

            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_LISTQUICKSHIFTS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something slot chosen to be modified
            else
            {
                // Store the number of the slot to be modified
                SetLocalInt(oPC, QSMODIFYVAR, nChoice);
                // If the character is an epic shifter, they can select whether the quickselection is normal or epic shift
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) > 10)
                    nStage = STAGE_SELECTQUICKSHIFTTYPE;
                else
                    nStage = STAGE_SELECTQUICKSHIFTSHAPE;
            }
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
        {
            // Set the marker variable if they chose epic
            if(nChoice == CHOICE_EPIC)
                SetLocalInt(oPC, EPICVAR, TRUE);

            nStage = STAGE_SELECTQUICKSHIFTSHAPE;
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be stored
            else
            {
                // Store the chosen template into the quickslot, choice is the template's index in the main list
                int nSlot = GetLocalInt(oPC, QSMODIFYVAR);
                int bEpic = GetLocalInt(oPC, EPICVAR);
                SetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_ResRef",
                                         GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                                         );
                SetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Name",
                                         GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                                       + (bEpic ? " (epic)" : "")
                                         );
                SetPersistantLocalInt(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Epic", bEpic);

                // Clean up
                DeleteLocalInt(oPC, EPICVAR);
                DeleteLocalInt(oPC, QSMODIFYVAR);

                // Return to main menu
                nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_DELETESHAPE)
        {
            // Something was chosen for deletion?
            if(nChoice != CHOICE_BACK_TO_MAIN)
            {
                // Choice is index into the template list
                DeleteStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice);
            }

            // Return to main menu in any case
            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_SETTINGS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Toggle using Druid Wildshape for Greater Wildshape
            else if(nChoice == CHOICE_DRUIDWS)
            {
                SetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS", !GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS"));
                nStage = STAGE_ENTRY;
            }
            else if(nChoice == CHOICE_STORE_TRUEAPPEARANCE)
            {
                // Probably should give feedback about whether this was successfull or not. Though the warning in the selection text could be enough
                StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
                nStage = STAGE_ENTRY;
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
