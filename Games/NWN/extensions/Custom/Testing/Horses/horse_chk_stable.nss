//*********************************************************
// FileName: horse_chk_stable
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
#include "nw_i0_tool"
#include "horse_include"

int StartingConditional()
{
    int nCheckStables, nCheckHench;
    object oPC = GetPCSpeaker();

    if((GetLocalInt(GetArea(oPC),"stables")==1)||(GetLocalInt(oPC,"stables")==1))
        nCheckStables =1;

    if(GetItemPossessedBy(oPC,"horseoverride")!= OBJECT_INVALID)
        nCheckStables =1;

    if (GPA_GetIsHench(oPC, OBJECT_SELF, 1))
        nCheckHench = 1;

    if (nCheckStables && nCheckHench)
        return TRUE;

    return FALSE;
} // end function
