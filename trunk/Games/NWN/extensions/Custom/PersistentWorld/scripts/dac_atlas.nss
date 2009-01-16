#include "x2_inc_switches"
#include "inc_atlas"
void main()
{
   // Acquire, Unacquire, etc., should not do anything -- only Activate
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   useAtlas(GetItemActivator());
}
