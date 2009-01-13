// Set custom token 2112 to the number of rounds remaining of travel time.
#include "inc_travel"
void main()
{
   SetCustomToken(2112, IntToString(GetLocalInt(OBJECT_SELF, VAR_TRAVEL_TIME)));
}
