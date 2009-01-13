int StartingConditional()
{
    // Inspect local variables
    if(!(GetLocalInt(OBJECT_SELF, "lmpPerformOneLiner") == 2))
        return FALSE;

    return TRUE;
}
