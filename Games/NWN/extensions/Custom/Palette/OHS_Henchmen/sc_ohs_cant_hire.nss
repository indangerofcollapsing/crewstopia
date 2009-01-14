// Are we in an area where one cannot hire a henchman?
int StartingConditional()
{
   return FALSE; // (! GetLocalInt(GetArea(OBJECT_SELF), "OHS_HIRE_ENABLE"));
}
