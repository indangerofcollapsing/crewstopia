//*********************************************************
// FileName: horse_mount
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
#include "horse_include"

void main()
{
    object oRider = GetPCSpeaker();
    object oMount = OBJECT_SELF;

    GPA_MountHorse(oRider, oMount);
}
