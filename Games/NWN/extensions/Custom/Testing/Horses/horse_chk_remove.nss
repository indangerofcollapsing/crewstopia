//*********************************************************
// FileName: horse_chk_remove
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
#include "horse_include"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oHorse = OBJECT_SELF;

    if (GPA_GetIsHench(oPC, OBJECT_SELF, 0))
        return TRUE;

    return FALSE;
} // end function
