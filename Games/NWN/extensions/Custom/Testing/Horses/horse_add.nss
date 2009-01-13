//*********************************
// Filename:  horse_add
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = OBJECT_SELF;

    SetLocalObject(oPC,"pc_mount",oHorse);
    AddHenchman(oPC, oHorse);
}
