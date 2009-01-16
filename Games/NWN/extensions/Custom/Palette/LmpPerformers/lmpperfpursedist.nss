// Collection Purse: OnDisturbed
// Signal the performers if something is taken. (Except it doesn't work for
// gold - see OnHeartbeat.)

#include "lmpperfmisc"

void main()
{
   int nDisturbance = GetInventoryDisturbType();
   object oThief = GetLastDisturbed();
   //lmpDebugMsg("OnDisturbed: Disturbance type", nDisturbance);
   //lmpDebugMsg("OnDisturbed: Disturber: " + GetName(oThief));
   switch(nDisturbance)
   {
      case INVENTORY_DISTURB_TYPE_REMOVED:
      case INVENTORY_DISTURB_TYPE_STOLEN:
         SignalPurseStolenBoth(oThief);
         break;
      case INVENTORY_DISTURB_TYPE_ADDED:
         if (GetGoldPieceValue(GetInventoryDisturbItem()) > 0) StartPerformBoth();
         break;
   }
}
