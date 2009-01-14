#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("save_pc", OBJECT_SELF);
   setLastKnownLocation(OBJECT_SELF);
   int saveDelay = GetLocalInt(GetModule(), VAR_PC_SAVE_DELAY);
   if (saveDelay)
   {
      DelayCommand(saveDelay * 1.0f, ExecuteScript("save_pc", OBJECT_SELF));
   }
}
