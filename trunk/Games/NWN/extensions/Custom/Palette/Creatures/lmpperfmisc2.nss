// lmpperfmisc2
// Miscellaneous functions for the Performer NPC's.
// Split off from lmpperfmisc because adding the generic include file slows down
// compiling immensely.

#include "nw_i0_generic"
#include "lmpperfmisc"

void AttackCreature(object oTarget)
{
    if (oTarget != OBJECT_INVALID) {
        ClearAllActions();
        AdjustReputation(oTarget, OBJECT_SELF, -100);
        SetIsTemporaryEnemy(oTarget);
        SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
        DetermineCombatRound(oTarget);
    }
}

void BothAttackThief()
{
    object oThief = GetLocalObject(OBJECT_SELF, "lmpPerformThief");
    if (oThief != OBJECT_INVALID && !GetIsDM(oThief)) {
        ClearAllActions();
        object oOther= GetOtherGuy();
        if (oOther != OBJECT_INVALID)
            AssignCommand(oOther, AttackCreature(oThief));
        ActionMoveToObject(oThief, /*bRun*/TRUE, /*fRange*/5.0);
        ActionDoCommand(AttackCreature(oThief));
    }
}

void MakePerformersAttackThief(object oThief)
{
    if (oThief != OBJECT_INVALID) {
        object oPerf1 = GetObjectByTag("lmpPerformer1");
        SetLocalObject(oPerf1, "lmpPerformThief", oThief);
        AssignCommand(oPerf1, BothAttackThief());
    }
}
