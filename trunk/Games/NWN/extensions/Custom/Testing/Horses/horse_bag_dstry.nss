//*************************************
//    Filename:  horse_bag_dstry
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*************************************

void main()
{
    object oPC = GetPCSpeaker();
    object oBag = GetLocalObject(oPC,"PC_Bag");

    object oItem = GetFirstItemInInventory(oBag);
    while( oItem != OBJECT_INVALID )
    {
        DestroyObject(oItem);

        oItem = GetNextItemInInventory(oBag);
    }

    DestroyObject(oBag);

    DeleteLocalInt(oPC,"PC_Saddle");
}
