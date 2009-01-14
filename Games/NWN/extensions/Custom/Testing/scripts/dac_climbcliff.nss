/*
Climbing up, climbing down, falling.
Author: Squid
Last Updated: May 24th, 2002
Version: 0.1a
http://nx.squid.org/script.html?id=15

Description:
Climbing up and down a cliff face with falling damage. Use the same conversation file for both triggers!


Instructions:
-Make 2 waypoints called WP_CLIMB_SUMMIT and WP_CLIMB_BASE.
-Place the base waypoint at the bottom of the cliff.
-Place the summit waypoint at the top.
-Orient waypoints so that you are happy with the direction they point.
-Modify the CLIMB_HEIGHT and CLIMB_DIFFICULTY in the script to match the situations for your specific climb!
-Create two triggers. Place one on the cliff wall, and one on the ground near the top of the cliff.
-Create "Climb the rockface? Yes/No" style conversation file.
-Attach this script to the "Actions Taken" on the Yes option of the conversation.
-Attach the conversation to both of the triggers, and give them a "Area transision" mouseover.
-Also helps to have a CLIMBERS_KIT object in your game world so players can take advantage of that as well! :-)
*/

//::///////////////////////////////////////////////
//:: FileName climb_check
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Joshua Hughes (jhvh@squid.org)
//:: Created On: 5/22/02 5:43:16 PM
//:://////////////////////////////////////////////
// Some ideas for upgrades to this script:
// * Make player climb over time
//  - "Stunned" while climbing.
//  - Fall immediately if taking damage.
//  - Climb speed of Movement Rate / 2
//  - Climb checks every round while climbing.
//  - Fall from height covered so far, if failure.
//////////////////////////////////////////////////

// DECLARES: Functions used later on.
void DealFallingDamage(object oCreature=OBJECT_SELF, int Height = 20, int SurfaceDifficulty=15);
int ClimbCheck(object oCreature, int SurfaceDifficulty);
int GetArmorCheckPenality(object oCreature);

// PRESETS:  Replace the following number values with your own.
int CLIMB_HEIGHT        = 20;   // 1 hill height looks about twenty feet.
int CLIMB_DIFFICULTY    = 15;   // see chart below for help


/*
Guide to setting your climbing difficulty:
(from the players handbook, page 65)

DC: CONDITIONS:
================================================================================
5   A rope w/ wall to brace against, or a knotted rope, or a rope affected by
the rope trick spell.
10  A surface with ledges to hold on to and stand on, such as a very rough wall
or a ship's rigging.
15  Any surface w/ adequate handholds and footholds (natural or artificial),
such as a very rough natural rock sruface or a tree.  An unknotted rope.
20  An uneven surface with some narrow handholds and footholds, such as a
typical wall in a dungeon or ruins.
25  A rough surface, such as a natural rock wall or a brick wall.
25  Overhang or ceiling with handholds but no footholds.

SITUATIONAL MODIFIERS:
================================================================================
-10 climbing a chimney where you can brace against 2 opposite walls
-5  Climbing a corner where you can brace against perepndicular walls.

+5  slippery surface
*/


void main() {
        object oPC = GetPCSpeaker();

        object oSummit = GetNearestObjectByTag("WP_CLIMB_SUMMIT", OBJECT_SELF);
        object oBase = GetNearestObjectByTag("WP_CLIMB_BASE", OBJECT_SELF);

        location lWaypointLoc;
        float fWaypointFacing;

        float fDistanceToSummit;
        float fDistanceToBase;
        int ClimbCheckResults = 0;

        // Run some error checks to make sure waypoints have been set.
        if (!GetIsObjectValid(oBase)) {
                SpeakString("You are unable to climb this surface! (error: WP_CLIMB_BASE is missing)", TALKVOLUME_WHISPER);
                return;
        }
        if (!GetIsObjectValid(oSummit)) {
                SpeakString("You are unable to climb this surface! (error: WP_CLIMB_SUMMIT is missing)", TALKVOLUME_WHISPER);
                return;
        }

        // See which object is closer, the summit or the base.
        // if the base is closer to us, then we are trying to climb up.
        // if the summit is closer to use, then we are trying to climb down.
        fDistanceToSummit = GetDistanceBetween(oPC, oSummit);
        fDistanceToBase = GetDistanceBetween(oPC, oBase);

        ClimbCheckResults = ClimbCheck(oPC, CLIMB_DIFFICULTY);

        if (fDistanceToBase >= fDistanceToSummit) {
                // on top, climbing down.
                if (ClimbCheckResults <= -5 ) {
                        SpeakString("You loose your grip and begin to fall!", TALKVOLUME_WHISPER);
                        DealFallingDamage(oPC, CLIMB_HEIGHT, CLIMB_DIFFICULTY);
                        ActionJumpToLocation(GetLocation(oBase));
                        AssignCommand(oPC, SetFacing(GetFacing(oBase)) );
                }
                else if ((ClimbCheckResults > -5) && (ClimbCheckResults < 0)) {
                        SpeakString("You fail to find any good footholds.", TALKVOLUME_WHISPER);
                }
                else {
                        SpeakString("You climb down successfully.",TALKVOLUME_WHISPER);
                        ActionJumpToLocation(GetLocation(oBase));
                        AssignCommand(oPC, SetFacing(GetFacing(oBase)) );
                }
        }
        else {
                // down, climbing up.
                if (ClimbCheckResults <= -5 ) {
                        SpeakString("You loose your grip and begin to fall!", TALKVOLUME_WHISPER);
                        DealFallingDamage(oPC, CLIMB_HEIGHT, CLIMB_DIFFICULTY);
                }
                else if ((ClimbCheckResults > -5) && (ClimbCheckResults < 0)) {
                        SpeakString("You fail to find any good footholds.", TALKVOLUME_WHISPER);
                }
                else {
                        SpeakString("You climb up successfully.",TALKVOLUME_WHISPER);
                        ActionJumpToLocation(GetLocation(oSummit));
                        AssignCommand(oPC, SetFacing(GetFacing(oSummit)) );
                }
        }
}

int ClimbCheck(object oCreature = OBJECT_SELF, int SurfaceDifficulty = 15) {

        // base modifer depending on strength ability.
        int ClimbModifier = GetAbilityModifier(ABILITY_STRENGTH, oCreature);
        object oClimbKit;
        int DiceRoll;
        int Level = 0;

        // +2 racial bonus for halflings (pg 65 player handbook)
        if (GetRacialType(oCreature) == RACIAL_TYPE_HALFLING) {
                ClimbModifier += 2;
        }

        // Check to see if PC is carrying a climbing kit.
        // if so, apply a +2 modifier.  (pg 65, pg 110)
        oClimbKit = GetItemPossessedBy(oCreature, "CLIMBERS_KIT");
        if (GetIsObjectValid(oClimbKit)) {
                ClimbModifier += 2;
        }

        // Fakey section to simulate points into the Climb skill.
        Level = GetLevelByClass(CLASS_TYPE_ROGUE, oCreature);
        if (Level) {
                ClimbModifier += (Level/4) + 1;
                Level = 0;
        }

        Level = GetLevelByClass(CLASS_TYPE_BARBARIAN, oCreature);
        if (Level) {
                ClimbModifier += (Level/4) + 1;
                Level = 0;
        }

        Level = GetLevelByClass(CLASS_TYPE_BARD, oCreature);
        if (Level) {
                ClimbModifier += (Level/5);
                Level = 0;
        }

        Level = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
        if (Level) {
                ClimbModifier += (Level/5);
                Level = 0;
        }

        Level = GetLevelByClass(CLASS_TYPE_RANGER, oCreature);
        if (Level) {
                ClimbModifier += (Level/4) + 1;
                Level = 0;
        }

        Level = GetLevelByClass(CLASS_TYPE_FIGHTER, oCreature);
        if (Level) {
                ClimbModifier += (Level/5);
                Level = 0;
        }

        // Apply penalties for wearing armor/shield.
        ClimbModifier -= GetArmorCheckPenality(oCreature);

        DiceRoll = d20(1);

        return (DiceRoll + ClimbModifier) - SurfaceDifficulty;
}

// Returns the Armor Check Penalty applied to the climb
// skill check, depending on what type of armor creature
// is wearing.  We have to guess based off of item AC
// value, so there are a couple of questionable spots
// but it's fairly accurate to table 7-5, page 104 in
// the players handbook.
int GetArmorCheckPenality(object oCreature) {

        object oArmor;
        int Penalty = 0;
        int ItemType = 0;
        int ACValue = 0;

        oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
        if (GetIsObjectValid(oArmor)) {
                ItemType = GetBaseItemType(oArmor);
                if (ItemType == BASE_ITEM_ARMOR) {
                        ACValue = GetItemACValue(oArmor);

                        // It doesn't look like magical AC bonuses are reflected in
                        // the ACValue returned above, so we can skip any kind of
                        // subtraction we'd have to do below.
                        //if (GetItemHasItemProperty(oArmor, ITEM_PROPERTY_AC_BONUS) {
                        //
                        //}

                        switch(ACValue) {
                                // Padded armor.
                                case 1: {
                                        Penalty = 0;
                                        break;
                                }
                                // Leather armor.
                                case 2: {
                                        Penalty = 0;
                                        break;
                                }
                                // Studded Leather. -1
                                // Hide armor       -3
                                case 3: {
                                        Penalty = -1;
                                        break;
                                }
                                // Scalemail: -4
                                case 4: {
                                        Penalty = -4;
                                        break;
                                }
                                // Chainmail: = 5;
                                case 5: {
                                        Penalty = -5;
                                        break;
                                }
                                // Splint mail -7, banded plate -6
                                case 6: {
                                        Penalty = -7;
                                        break;
                                }
                                // Half plate.
                                case 7: {
                                        Penalty = -7;
                                        break;
                                }
                                // Full plate
                                case 8: {
                                        Penalty = -6;
                                        break;
                                }

                        }
                }
        }

        // Check left hand for shield
        oArmor = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
        if (GetIsObjectValid(oArmor)) {
                switch(ItemType) {
                        case BASE_ITEM_LARGESHIELD: {
                                Penalty -= 1;
                        }
                        case BASE_ITEM_SMALLSHIELD: {
                                Penalty -= 2;
                        }
                        case BASE_ITEM_TOWERSHIELD: {
                                Penalty -= 10;
                        }
                }
        }

        return Penalty;
}

// 1D6 per 10 feet fallen to a maximum of 20D6
// for a successful jump (not fall) down a ledge, first 1d6 is subdual damage.
// I don't think subdual damage is part of NWN, so ignoring.
void DealFallingDamage(object oCreature=OBJECT_SELF, int Height = 20, int SurfaceDifficulty=15) {

        int damage = 0;
        int Height = ((Height-10)/10)+1;    // convert actual feet into 10 foot units.


        // Check to see if player can stop themselves from falling.
        if (ClimbCheck(oCreature, SurfaceDifficulty + 20) >= 0) {
                SpeakString("Thankfully, you manage to regain your grip and avoid injury.", TALKVOLUME_WHISPER);
                return;
        }

        //boundry checks
        if (Height > 20) { Height = 20; }
        if (Height < 1) { Height = 1; }

        // Uncomment this if you want to modify this to use in a script for
        // damage taken while jumping off a cliff or something:
        // Height -= 1;


        if (Height < 1) {
                return;
        }

        // deal damage to the player.
        damage = d6(Height);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(damage), oCreature);

        // Make player fall down if enough damage was taken.
        if (damage >= 5) {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectKnockdown(), oCreature, TurnsToSeconds(2));
                SpeakString("You hit the ground hard and collapse in a heap.", TALKVOLUME_WHISPER);
        }
        else {
                SpeakString("You land on your feet taking only minor damage from your fall.", TALKVOLUME_WHISPER);
        }
}

