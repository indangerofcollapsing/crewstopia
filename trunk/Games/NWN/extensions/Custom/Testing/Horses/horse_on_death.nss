//*******************************************
//  Filename:  horse_on_death
/*
    Created by Gregg Anderson
    10/1/2006
*/
//***********************************
#include "horse_include"

void main()
{
    object oHorse = OBJECT_SELF;
    object oPC = GetMaster(oHorse);

    string sHorseTag = GetTag(oHorse);

    object oIcon = GetItemPossessedBy(oPC, sHorseTag);
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(oIcon);

    int nObjectType = OBJECT_TYPE_PLACEABLE;
    string sResRef = "saddlebag";
    string sNewTag = sHorseTag + "_sb";
    location lLoc = GetLocation(oHorse);
    object oBag = CreateObject(nObjectType, sResRef, lLoc, FALSE, sNewTag);

    GPA_HorseDiedInventoryMove(oHorse);

    DeleteLocalObject(oPC,"pc_mount");
    DeleteLocalInt(oPC,"HorseSummon");

    object oSaddleBag = GetLocalObject(oPC,"PC_Bag");
    if(oSaddleBag != OBJECT_INVALID)
    {
        DeleteLocalInt(oPC, "PC_Saddle");

        object oItem = GetFirstItemInInventory(oSaddleBag);
        while( oItem != OBJECT_INVALID )
        {
            DestroyObject(oItem);

            oItem = GetNextItemInInventory(oSaddleBag);
        }

        DestroyObject(oSaddleBag);
    }

    SetPlotFlag(OBJECT_SELF,FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
    SetIsDestroyable(TRUE, FALSE, FALSE);
    DestroyObject(OBJECT_SELF, 0.2);
}
