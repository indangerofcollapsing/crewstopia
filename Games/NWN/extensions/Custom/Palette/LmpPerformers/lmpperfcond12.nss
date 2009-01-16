int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "lmpBeginPerform") != 0
        && GetLocalInt(OBJECT_SELF, "lmpPerform") == 1
        && GetLocalInt(OBJECT_SELF, "lmpPerfAct") == 2;
}
