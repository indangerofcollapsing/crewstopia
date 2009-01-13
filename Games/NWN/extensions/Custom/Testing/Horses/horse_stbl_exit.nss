//*************************************
//    Filename:  horse_stbl_exit
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*************************************
void main()
{
    object oPC = GetExitingObject();

    FloatingTextStringOnCreature("You are exiting a stable area.",oPC,FALSE);
    DeleteLocalInt(oPC,"stables");
}
