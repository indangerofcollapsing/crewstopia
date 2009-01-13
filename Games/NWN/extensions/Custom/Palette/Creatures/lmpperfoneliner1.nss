int StartingConditional()
{
    // Inspect local variables
    if(!(GetLocalInt(OBJECT_SELF, "lmpPerformOneLiner") == 1))
        return FALSE;

    return TRUE;
}
