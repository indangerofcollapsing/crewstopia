// On Item Unacquire event for the module
void main()
{
    ExecuteScript("x2_mod_def_unaqu", OBJECT_SELF);
    ExecuteScript("prc_onunaquire", OBJECT_SELF);
}
