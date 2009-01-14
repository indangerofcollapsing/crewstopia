// Mount the Ballista
#include "inc_ia_ballista"
void main()
{
   object oSeat = getSeat();
   float fFace = GetFacing(oSeat);
   int nElev = GetLocalInt(OBJECT_SELF, VAR_CURRENT_ELEVATION);
   int nBrng = GetLocalInt(OBJECT_SELF, VAR_CURRENT_BEARING);
   SetCustomToken(5000, IntToString(nBrng));
   SetCustomToken(5001, IntToString(nElev));
   SetCustomToken(5002, GetName(OBJECT_SELF));
   object oPC = GetLastUsedBy();
   SetLocalObject(OBJECT_SELF, VAR_IA_BALLISTA_USER, oPC);
   if (isUsing1stPersonView())
   {
      GestaltInvisibility(0.0, oPC, 0.0, "");
//      GestaltInvisibility(0.0, OBJECT_SELF, 0.0, "");
      GestaltStartCutscene(oPC, "", TRUE, TRUE, TRUE, TRUE, TRUE, 0);
      GestaltCameraMove(0.2, fFace - IntToFloat(nBrng), 1.5, 75.0,
         fFace - IntToFloat(nBrng), 1.5, 75.0, 0.1, 1.0, oPC, 2, 0, 0);
      GestaltActionJump(0.1, oPC, oSeat);
   }
//   GestaltActionConversation(0.0, oPC, OBJECT_SELF, "ia_ballista", "", FALSE);
   GestaltActionConversation(0.0, oPC, OBJECT_SELF, "", "", FALSE);
   adjustAim(0, 0);
}
