int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "lmpBeginPerform") != 0
        && GetLocalInt(OBJECT_SELF, "lmpPerform") == 2;
}
