//*********************************************************
// FileName: horse_chk_bag0
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
#include "horse_include"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nCheckBag, nCheckHench;

    if((GetLocalInt(oPC,"PC_Saddle") == 1))
        nCheckBag =1;

    if (GPA_GetIsHench(oPC, OBJECT_SELF, 1))
        nCheckHench = 1;

    if (!nCheckBag && nCheckHench)
        return TRUE;
    else
        return FALSE;
}
