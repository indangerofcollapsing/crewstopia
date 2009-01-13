//*********************************************************
// FileName: horse_chk_add
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
#include "nw_i0_tool"
#include "horse_include"

int StartingConditional()
{
    int nCheckItem, nCheckHench;

    object oPC = GetPCSpeaker();

    string sHorseTag = GetTag(OBJECT_SELF);
    string sHorse = GetStringLeft(sHorseTag,9);
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem) == TRUE)
    {
        string sItem = GetStringLeft(GetTag(oItem),9);
        if(sItem == sHorse)
            nCheckItem = 1;

        oItem = GetNextItemInInventory(oPC);
    } // end while

    if (GPA_GetIsHench(oPC, OBJECT_SELF, 1))
        nCheckHench = 1;

    if (nCheckItem && !nCheckHench)
        return TRUE;
    else
        return FALSE;
} // end function
