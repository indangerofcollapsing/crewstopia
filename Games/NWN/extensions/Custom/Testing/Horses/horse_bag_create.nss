//*************************************
//    Filename:  horse_bag_create
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*************************************

void main()
{
    object oPC = GetPCSpeaker();
    int nObjectType = OBJECT_TYPE_PLACEABLE;
    string sResRef = "saddlebag";
    string sHorseTag = GetTag(OBJECT_SELF);
    string sNewTag = sHorseTag + "_sb";

    location lLoc = GetLocation(oPC);

    object oBag = CreateObject(nObjectType, sResRef, lLoc, FALSE, sNewTag);

    SetLocalObject(oPC,"PC_Bag",oBag);
    SetLocalInt(oPC, "PC_Saddle",1);
}
