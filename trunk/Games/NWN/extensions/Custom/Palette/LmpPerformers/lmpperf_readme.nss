/*
Buskers
by Len Popp lpopp@igs.net
Version 1.0

A pair of buskers that perform songs and magic tricks several times per day.

NOTE: Requires Neverwinter Nights version 1.25 or later

How To Use
----------
1. Import the file buskers.erf into your NWN module.
2. Place the two NPC's in the area where you want them to perform:
    Alia (lmpPerformer1) and Donie (lmpPerformer2)
3. Optional: Place any or all of the following objects near the performers:
  - The waypoints where they perform: lmpPerformer1Perform, lmpPerformer2Perform
  - The waypoints where they wait: lmpPerformer1Home, lmpPerformer2Home
  - Their Collection Purse (lmpPerformPurse)
  - Their sign (lmpPerformSign)
  - Chairs, stools, bedrolls or rugs to sit on at the home waypoints
4. Optional: Change the frequency of performances by editing the script
    lmpperfmisc and changing the value of nHoursBetweenPerformances. Build the
    module after editing the script.

Upgrading
---------
If you have a previous version of this package in your module, import this
version of buskers.erf and select all resources to overwrite the old ones.
NOTE: The "Collection Purse" placeable was updated in versin 0.9.2, so you
should select it in the palette and Update All Instances. (Or not, it's not a
critical change.)

What They Do
------------
At various times during the day, the two performers move to their "perform"
waypoints and put on a little show for whoever is around. Sometimes Alia sings,
sometimes Donie does a magic trick (or tries to). If anyone has an idea how to
simulate juggling in NWN, I'd like to hear it.

Players who enjoy the show may put money (or other goodies) in the collection
purse. Players who are caught stealing from the purse will be asked to give it
back; if they refuse a fight ensues.

Between shows, the performers sit at their home waypoint or on a chair or stool
nearby.

Thanks to Rhodan for RemoveEffectType.

Version History
---------------
1.0     Oct 13 2002     Added "Greensleeves"
0.9.3   Sept 23 2002    Fix bug that flagged a donator as a thief come night-time.
                        Bashing the collection purse is seen as theft.
0.9.2   Sept 22 2002    Better scheduling, variable number of shows per day.
                        Conversations to pay buskers to perform at other times.
                        Waypoints are now optional.
                        Sit on a chair or stool near the idle point.
0.9.1   Sept 18 2002    Removed some dead code, added some comments and this doc.
*/
void main() {}
