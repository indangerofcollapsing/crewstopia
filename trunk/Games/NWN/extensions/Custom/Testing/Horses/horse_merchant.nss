//::///////////////////////////////////////////////
//:: FileName horse_merchant
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/1/2006 12:40:01 PM
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("horse_merchant");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		gplotAppraiseOpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
