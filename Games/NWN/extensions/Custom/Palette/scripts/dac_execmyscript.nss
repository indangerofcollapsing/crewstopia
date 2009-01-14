// Execute a script with the same name as my tag or defined in a variable.
// Use this in dialogs when a Skill Check is successful or you want the speaker
// to perform some standard action such as unlocking a gate, etc.
void main()
{
   string sScript = GetLocalString(OBJECT_SELF, "MY_SCRIPT");
   if (sScript == "") sScript = GetTag(OBJECT_SELF);

   ExecuteScript(sScript, OBJECT_SELF);
}
