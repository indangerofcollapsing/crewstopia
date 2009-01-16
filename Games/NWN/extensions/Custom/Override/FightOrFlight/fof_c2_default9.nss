// Call from NW_C2_DEFAULT9
// ExecuteScript("fof_c2_default9", OBJECT_SELF);

//#include "x0_i0_anims"
//#include "x0_i0_treasure"
//#include "x2_inc_switches"

// @DUG
//#include "inc_equip"
//#include "inc_nbde"

void main()
{
   // FIGHT_OR_FLIGHT: Added a comment-out feature to set a local
   // int on creatures to signal FIGHT_OR_FLIGHT. Disable this
   // function by commenting it out. Only affects non-undead,
   // non-dominated creatures with int > 5, CR or HD < 5, and
   // no fear-specific feats.
   ExecuteScript("fof_set", OBJECT_SELF);

   // FIGHT_OR_FLIGHT:: A comment-in feature for leaders, works with
   // the morale system. Creatures fleeing will look for a leader in
   // range, then rally to him. If no leader and no other rallying
   // point, they will run away rather willy-nilly.
   //SetLocalInt(OBJECT_SELF, "I_AM_A_LEADER", 1);
}
