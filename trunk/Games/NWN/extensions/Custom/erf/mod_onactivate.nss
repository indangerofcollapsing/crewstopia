// On-Item-Activated event for the module
void main()
{
    ExecuteScript("x2_mod_def_act", OBJECT_SELF);
    ExecuteScript("prc_onactivate", OBJECT_SELF);
}
