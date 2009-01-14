// On Heartbeat for a creature or object which acts as a travel coordinator
#include "inc_travel"
void main()
{
   onHeartbeatTravel();
   ExecuteScript("x2_def_heartbeat", OBJECT_SELF);
}
