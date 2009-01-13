//*********************************************************
// FileName: horse_bag_hrtbt
/*
    Created by Gregg Anderson
    10/1/2006
*/
//*********************************************************
void main()
{
    object oBag = OBJECT_SELF;

    object oItem = GetFirstItemInInventory(oBag);
    int nStatus = GetLocalInt(OBJECT_SELF,"status");

    if((oItem == OBJECT_INVALID)&&(nStatus != 1))
        DestroyObject(oBag);
}
