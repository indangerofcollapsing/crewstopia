#include "prc_alterations"
#include "prc_inc_smite" // @DUG recompile only

void main()
{
    DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_GOOD_ANTIPALADIN);
}
