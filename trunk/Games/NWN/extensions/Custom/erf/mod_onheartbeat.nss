// Template for On Heartbeat event for the module
#include "inc_debug_dac"
void main()
{
   ExecuteScript("re_modulehb", OBJECT_SELF); // BESIE On Heartbeat event
}
