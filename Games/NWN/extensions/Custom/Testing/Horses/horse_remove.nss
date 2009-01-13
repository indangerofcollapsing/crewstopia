//*********************************
// Filename:  horse_remove
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = GetHenchman(oPC);

    DeleteLocalObject(oPC,"pc_mount");
    RemoveHenchman(oPC, oHorse);
}
