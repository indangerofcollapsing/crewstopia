//*********************************
// Filename:  horse_include
/*
    Modified/Combined Rideable Horses
    DG & NIC/AB rideables

    Modified by Gregg Anderson
    11 / 2 / 2005

    Revision 2
    10 / 1 / 2006

    Included as part of the Hylis PW Server
*/
//**  INCLUDES  *********************
#include "zep_inc_phenos"
//#include "h2_persistence_c"


//**  FUNCTION DECLARATIONS  *******
void GPA_ActivateHorseIcon(object oPC, string sTag);
void GPA_SummonHorse(object oPC, string sResRef, string sIconTag);
void GPA_SpawnHorse(object oPC, string sResRef, string sIconTag);
void GPA_MountHorse(object oRider, object oMount);
void GPA_DismountHorse(object oPC);
void GPA_FallOnGround(object oPC);
int GPA_GetIsHench(object oPC, object oHorse, int nAssociateCheck);
void GPA_HorseOCE(object oPC);
void GPA_HorseOCL(object oPC);
object GPA_InitializeIcon(object oPC, object oIcon);
void GPA_HorseDiedInventoryMove(object oHorse);
void GPA_OnActivate(object oPC,object oItem);


//**  FUNCTION DEFINITIONS  ********

//////////////////////////////////////////////////////////////////
void GPA_ActivateHorseIcon(object oPC, string sTag)
/*
    A horse or pony may only be summoned up if the PC activating
    a horses corresponding Horse Icon is within a designated
    stables area.  There are three ways to trigger this response:
    1.  Put a variable on the area called "stables" and set it to 1.
    2.  Place a Trigger that the PC can enter. Found in the custom
        trigger pallette.
    3.  Have a DM give a PC the Horse Summon Override.  This is useful
        in the cases where there was a crash and PCs are no longer
        near a stables area.
*/
//////////////////////////////////////////////////////////////////
{
    int nOverride;
    string sResRef;

    if(GetItemPossessedBy(oPC,"horseoverride")!=OBJECT_INVALID)
        nOverride = 1;

        if((GetLocalInt(GetArea(oPC),"stables")==1)||(GetLocalInt(oPC,"stables")==1)||(nOverride==1))
        {
            sResRef = GetStringLeft(sTag,12) + "0";
            GPA_SummonHorse(oPC, sResRef, sTag);
        }
        else
            SendMessageToPC(oPC,"You must be in a stables to summon your mount");
}  // end function


//////////////////////////////////////////////////////////////////
void GPA_SummonHorse(object oPC, string sResRef, string sIconTag)
//////////////////////////////////////////////////////////////////
{
    int nHorseSummon = GetLocalInt(oPC,"HorseSummon");

    if(nHorseSummon == 0)
    {
        int nPheno = GetPhenoType(oPC);
//        h2_SetCampaignInt("horses","PhenoType",nPheno,oPC);
//        h2_FlushCampaignDatabase("horses");
        SetCampaignInt("horses","PhenoType",nPheno,oPC);
        GPA_SpawnHorse(oPC,sResRef,sIconTag);
    }
} // end function


//////////////////////////////////////////////////////////////////
void GPA_SpawnHorse(object oPC, string sResRef, string sIconTag)
//////////////////////////////////////////////////////////////////
{
    location  lPC = GetLocation(oPC);
    int nObjectType = OBJECT_TYPE_CREATURE;

    int nMaxHenchmen = GetMaxHenchmen();

    int i;
    for (i=1; i<= nMaxHenchmen; i++)
    {
        if (GetTag(GetHenchman(oPC,i)) == sIconTag)
            return;
        if (GetTag(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC,i)) == sIconTag)
            return;
    }  // end for loop

    object oHorse = CreateObject(nObjectType, sResRef, lPC, TRUE, sIconTag);

    SetLocalObject(oPC,"pc_mount",oHorse);
    SetLocalInt(oPC,"HorseSummon",1);
    AddHenchman(oPC, oHorse);
}  // end function


//////////////////////////////////////////////////////////////////
void GPA_MountHorse(object oRider, object oMount)
//////////////////////////////////////////////////////////////////
{
    float fWalk_Speed;
    int nAppearance = GetAppearanceType(oMount);

    switch (nAppearance)
    {
    case 1855:
        fWalk_Speed = fSPEED_PONY_SPOT;
      break;
    case 1856:
        fWalk_Speed = fSPEED_PONY_BROWN;
      break;
    case 1857:
        fWalk_Speed = fSPEED_PONY_LTBROWN;
      break;
    case 1858:
        fWalk_Speed = fSPEED_HORSE_BROWN;
      break;
    case 1859:
        fWalk_Speed = fSPEED_HORSE_WHITE;
      break;
    case 1860:
        fWalk_Speed = fSPEED_HORSE_BLACK;
      break;
    case 1861:
        fWalk_Speed = fSPEED_HORSE_NIGHTMARE;
      break;
    case 1862:
        fWalk_Speed = fSPEED_AURENTHIL;
      break;
    default:
        fWalk_Speed = 2.2;
     break;
    }

    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oRider);
    object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oRider);

    AssignCommand(oRider,ActionUnequipItem(oRightHand));
    AssignCommand(oRider,ActionUnequipItem(oLeftHand));

    zep_Mount(oRider, oMount, 0, fWalk_Speed, "dismount");
}  // end function


//////////////////////////////////////////////////////////////////
void GPA_DismountHorse(object oRider)
//////////////////////////////////////////////////////////////////
{
    zep_Dismount(oRider, "dismount");
}  // end function


//////////////////////////////////////////////////////////////////
int GPA_GetIsHench(object oPC, object oHorse, int nAssociateCheck)
//////////////////////////////////////////////////////////////////
{
    int nMaxHenchmen = GetMaxHenchmen();
    int i;
    for (i==1;i<=nMaxHenchmen; i++)
    {
        if (GetHenchman(oPC,i) == oHorse)
            return TRUE;
        if (nAssociateCheck != 0)
            if(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC,i) == oHorse)
                return TRUE;
    } // end for

    return FALSE;
} // end function


//////////////////////////////////////////////////////////////////
void GPA_HorseOCE(object oPC)        // On Client Enter
//////////////////////////////////////////////////////////////////
{
    int nHorseSummon = GetLocalInt(oPC,"HorseSummon");
    if(nHorseSummon)
        SetLocalInt(oPC,"stables",1);

    object oHorse = GetLocalObject(oPC,"pc_mount");
    DeleteLocalInt(oPC,"HorseSummon");
    DeleteLocalObject(oPC,"pc_mount");
    RemoveHenchman(oPC,oHorse);
    AssignCommand(oHorse,SetIsDestroyable(TRUE,FALSE,FALSE));
    DestroyObject(oHorse);

    zep_Dismount(oPC, "dismount");
} // end function


//////////////////////////////////////////////////////////////////
void GPA_HorseOCL(object oPC)
//////////////////////////////////////////////////////////////////
{
    zep_Dismount(oPC, "dismount");
} // end function


//////////////////////////////////////////////////////////////////
object GPA_InitializeIcon(object oPC, object oItem)
//////////////////////////////////////////////////////////////////
{
    if(!GetIsPC(oPC))
        return OBJECT_INVALID;

    string sResRef = GetResRef(oItem);

//    int nIndex = h2_GetCampaignInt("horses", sResRef);
    int nIndex = GetCampaignInt("horses", sResRef);
    nIndex = nIndex +1;

    string sIndex;
    string sIndex1 = IntToString(nIndex);

    if(nIndex <= 9)
        sIndex = "00" + sIndex1;
    else if(nIndex <= 99)
        sIndex = "0" + sIndex1;
    else if(nIndex <= 999)
        sIndex = sIndex1;
    else
    {
        SendMessageToPC(oPC,"Horse index out of range!");
        return OBJECT_INVALID;
    }

    string sNewTag = sResRef + sIndex;
    location lLoc = GetLocation(oPC);

    object oIcon = CopyObject(oItem,lLoc,oPC,sNewTag);
    DestroyObject(oItem);
    SetLocalInt(oIcon,"status",1);

//    h2_SetCampaignInt("hylis", sResRef, nIndex);
//    h2_FlushCampaignDatabase("horses");
    SetCampaignInt("horses", sResRef, nIndex);

    return oIcon;
}  // end function


//////////////////////////////////////////////////////////////////
void GPA_HorseDiedInventoryMove(object oHorse)
//////////////////////////////////////////////////////////////////
{
    location lLoc = GetLocation(oHorse);
    int nObjectType = OBJECT_TYPE_PLACEABLE;
    string sResRef = "mountinventory";

    object oBag = CreateObject(nObjectType, sResRef, lLoc);

    object oItem = GetFirstItemInInventory(oHorse);
    while (GetIsObjectValid(oItem) == TRUE)
    {
        if(GetStringLeft(GetTag(oItem),2)!="pl")
            CopyItem(oItem,oBag);

        oItem = GetNextItemInInventory(GetFirstPC());
    }
}  // end function


//////////////////////////////////////////////////////////////////
void GPA_OnActivate(object oPC,object oItem)
//////////////////////////////////////////////////////////////////
{
    string sTag = GetTag(oItem);

    if((sTag == "blckhorsehvy")||(sTag == "blckhorselig")||(sTag == "blckhorserid")||
       (sTag == "brwnhorsehvy")||(sTag == "brwnhorselig")||(sTag == "brwnhorserid")||
       (sTag == "whtehorsehvy")||(sTag == "whtehorselig")||(sTag == "whtehorserid")||
       (sTag == "whiteponystd")||(sTag == "whiteponydwr")||(sTag == "whiteponywar")||
       (sTag == "pintoponystd")||(sTag == "pintoponydwr")||(sTag == "pintoponywar")||
       (sTag == "brownponystd")||(sTag == "brownponydwr")||(sTag == "brownponywar"))
        {
            object oIcon = GPA_InitializeIcon(oPC, oItem);
            if (oIcon != OBJECT_INVALID)
                GPA_ActivateHorseIcon(oPC, GetTag(oIcon));
        }

    if ((GetSubString(sTag,4,5) == "horse")||(GetSubString(sTag,5,4) == "pony"))
        GPA_ActivateHorseIcon(oPC, sTag);

    if(sTag == "dismount")
        GPA_DismountHorse(oPC);
}  // end function
