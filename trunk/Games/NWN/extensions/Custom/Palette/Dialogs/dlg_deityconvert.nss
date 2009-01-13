void main()
{
   object oPC = GetPCSpeaker();
   SetDeity(oPC, GetDeity(OBJECT_SELF));
   object oHolySymbol = CreateItemOnObject("dac_holysymbol", oPC);
   SetName(oHolySymbol, "Holy Symbol of " + GetDeity(OBJECT_SELF));
}

