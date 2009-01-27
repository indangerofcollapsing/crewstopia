//Begin Header File
//:://////////////////////////////////////////////
//::Declaration of utility functions
//:://////////////////////////////////////////////
int InString(string sString, string sPattern);
void CreateEquip(object oItem, object oTarget);

//:://////////////////////////////////////////////
//::Declaration of Damage Types
//:://////////////////////////////////////////////

int InString(string sString, string sPattern)
{
        int iFound;
        if ((sPattern == "") || (sString == ""))
        {
                return FALSE;
        }

        iFound = FindSubString(sString,sPattern);
        if (iFound >= 0)
        {
                return TRUE;
        }
        else
        {
                return FALSE;
        }
}
//required function for delaycommand.
void CreateEquip(object oItem, object oTarget)
{
        oItem = CreateItemOnObject(GetTag(oItem), oTarget);
        //SendMessageToPC(oTarget, "Item " + GetName(oItem)+" Created.");
        AssignCommand(oTarget, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
        //SendMessageToPC(oTarget, "Item " + GetName(oItem)+" Equipped.");
}
//End header file



//Begin main file
//::///////////////////////////////////////////////
//:: Throwing Weapons
//:: throwingweapon.nss
//:://////////////////////////////////////////////
/*
Scripts for activated throwing weapons
Axes and darts intentionally left out
due to inclusion in the game, but range info
left in for anyone to add as they wish.
Several magic types from the DMG intentionally
left out due to game mechanics / balance
This is to be placed in the OnItemActivate
in your module.

Additional Notes: All properties for throwing
are set via naming convention. i.e. if you want
a dagger to have the ability to return, and to
do additional fire damage, you'd name it:
"a flaming throwing dagger of returning"
*/
//:://////////////////////////////////////////////
//:: Created By: Jeggred
//:: Created On: 7/23/02
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//::Common D&D 3rd Edition Rules
//:://////////////////////////////////////////////
//::Weapon  Increment   Damage  Threat   Multiplier
//::Dagger:     10       d4     19-20       x2
//::Club:       10       d6       20        x2
//::Javelin:    30       d6       20        x2
//::Spear:      20      d6/d8     20        x3
//::Hammer:     20       d6       20        x2
//::Axe:        20       d6       20        x2
//::Dart:       20       d4       20        x2
//::Net:        10     Special
//:://////////////////////////////////////////////
//::Non-throwing weapons have a range increment of
//::10, an attack penalty of -4, and are currently
//::not implemented, though it'd be fairly easy
//::with this codebase.
//:://////////////////////////////////////////////
//::penalty for each step beyond first: -1
//::max range: 5 * increment
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//::Naming Conventions
//:://////////////////////////////////////////////
//::These must appear in some form or fashion
//::    in the item's name. Case Insensitive.
//:://////////////////////////////////////////////
//::                 Weapon Names
//:://////////////////////////////////////////////
//::throwing dagger
//::throwing club
//::throwing hammer
//::javelin
//::spear
//::net
//:://////////////////////////////////////////////
//::              Magical Properties
//:://////////////////////////////////////////////
//::returning
//::flaming
//::shock
//::frost
//::holy
//::unholy
//::lawful
//::chaotic
//::neutral
//::snaring
//::keen
//:://////////////////////////////////////////////

/* Example ***
//:://////////////////////////////////////////////
//::Begin Code
//:://////////////////////////////////////////////
//#include "throwheader"
void main()
{
        //modify these variables as necessary,
        //just make sure to do it to ALL instances of them
        object oPC = GetItemActivator();
        object oItem = GetItemActivated();
        object oTarget = GetItemActivatedTarget();
        location lTarget = GetItemActivatedTargetLocation();

        //Disregard following variable name. it's not actually the tag
        string sItemName = GetStringLowerCase(GetName(oItem));

        if (GetTag(oItem) == "OtherItems")
        {
                //put other activate item code in here.
        }
        else
        {
                if( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)!= oItem && GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC) != oItem)
                {
                        SendMessageToPC(oPC,"You must equip your weapon!");
                        return;
                }
                effect eDamage; //Damage effect.
                effect eExtraDamage; // Additional damage effect
                effect eVisualThrow = EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND); // Firing effect
                //        effect eVisualImpact = EffectVisualEffect(VFX_COM_SPARKS_PARRY, FALSE); // Impact effect
                effect eVisualImpact = EffectVisualEffect(VFX_DUR_LIGHT_RED_5, FALSE); // Impact effect
                int nDamage; // Amount of damage
                int nExtraDamage; // Additional damage from effect
                float fIncrement; // Range increment
                float fMaxRange; // Max range
                int nPenalty; // Range penalty
                float fDistance; // Distance to target
                int nCritMin = 20; // Minimum roll for crit
                int nCritMod = 2; // Critical Hit Multiplier
                object oNewItem; // Used on hit/miss
                float fSnare; // Duration of snare effect


                //Booleans for Weapon Type
                int bReturn = FALSE;
                int bFlaming = FALSE;
                int bShock = FALSE;
                int bFrost = FALSE;
                int bHoly = FALSE;
                int bUnholy = FALSE;
                int bLawful = FALSE;
                int bChaotic = FALSE;
                int bNeutral = FALSE;
                int bSnaring = FALSE;
                int bKeen = FALSE;

                //Boolean for Hit Check
                int bHit;

                //:://////////////////////////////////////////////
                //::Determine weapon type
                //:://////////////////////////////////////////////
                if(InString(sItemName,"throwing dagger"))
                {
                        fIncrement = FeetToMeters(10.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = d4();
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                        nCritMin = 19;
                        if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER,oPC))
                        nDamage = nDamage + 2;
                        if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC))
                        nPenalty--;
                        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER,oPC))
                        nCritMin = nCritMin - 2;

                }
                if(InString(sItemName,"throwing club"))
                {
                        fIncrement = FeetToMeters(10.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = d6();
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                        if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CLUB,oPC))
                        nDamage = nDamage + 2;
                        if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC))
                        nPenalty--;
                        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB,oPC))
                        nCritMin--;
                }
                if(InString(sItemName,"javelin"))
                {
                        fIncrement = FeetToMeters(30.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = d6();
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                        if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SPEAR,oPC))
                        nDamage = nDamage + 2;
                        if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC))
                        nPenalty--;
                        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR,oPC))
                        nCritMin--;
                }
                if(InString(sItemName,"spear"))
                {
                        fIncrement = FeetToMeters(20.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = d6();
                        nCritMod = 3;
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                        if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SPEAR,oPC))
                        nDamage = nDamage + 2;
                        if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC))
                        nPenalty--;
                        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR,oPC))
                        nCritMin--;
                }
                if(InString(sItemName,"throwing hammer"))
                {
                        fIncrement = FeetToMeters(20.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = d6();
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                        if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,oPC))
                        nDamage = nDamage + 2;
                        if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC))
                        nPenalty--;
                        if (GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER,oPC))
                        nCritMin--;
                }
                if(InString(sItemName,"net"))
                {
                        fIncrement = FeetToMeters(10.0);
                        fMaxRange = 5 * fIncrement;
                        nDamage = 0;
                        bSnaring = TRUE;
                        fSnare = IntToFloat(d20());
                }

                //:://////////////////////////////////////////////
                //::Magical Properties Checks
                //:://////////////////////////////////////////////
                if(InString(sItemName,"returning"))
                bReturn=TRUE;
                if(InString(sItemName,"flaming"))
                bFlaming=TRUE;
                if(InString(sItemName,"shock"))
                bShock=TRUE;
                if(InString(sItemName,"frost"))
                bFrost=TRUE;
                if(InString(sItemName,"holy"))
                bHoly=TRUE;
                if(InString(sItemName,"unholy"))
                bUnholy=TRUE;
                if(InString(sItemName,"lawful"))
                bLawful=TRUE;
                if(InString(sItemName,"chaotic"))
                bChaotic=TRUE;
                if(InString(sItemName,"neutral"))
                bNeutral=TRUE;
                if(InString(sItemName,"snaring"))
                bSnaring=TRUE;
                if(InString(sItemName,"keen"))
                bKeen=TRUE;

                //Additionals, just in case someone does this
                if(GetItemHasItemProperty(oItem,ITEM_PROPERTY_KEEN))
                bKeen=TRUE;
                // @DUG if(GetItemHasItemProperty(oItem,ITEM_PROPERTY_BOOMERANG)) bReturn=TRUE;

                //:://////////////////////////////////////////////
                //::Begin Combat Checks
                //:://////////////////////////////////////////////
                fDistance = GetDistanceBetween(oPC, oTarget);
                if (fDistance > fMaxRange)
                {
                        SendMessageToPC(oPC, "Your Target is Out of Range");
                        return;
                }
                //Determine penalty via distance to target / increment
                nPenalty = nPenalty + (FloatToInt(fDistance / fIncrement) - 1);

                //+1 to thrown weapons for being a halfling
                if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING)
                nPenalty--;

                //modify penalty to reflect dex modifier
                nPenalty = nPenalty - GetAbilityModifier(ABILITY_DEXTERITY, oPC);

                int nRoll = d20();
                //roll to see if it hit.
                AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisualThrow, oTarget, 0.15));
                if (nRoll - nPenalty >= GetAC(oTarget))
                bHit = TRUE;

                //On hit:
                if (bHit == TRUE)
                {
                        switch(Random(3)+1)
                        {
                                case 1:
                                PlayVoiceChat(VOICE_CHAT_PAIN1,oTarget);
                                break;
                                case 2:
                                PlayVoiceChat(VOICE_CHAT_PAIN1,oTarget);
                                break;
                                case 3:
                                PlayVoiceChat(VOICE_CHAT_PAIN3,oTarget);                    break;
                        }
                        //            AssignCommand(oPC,ActionUnequipItem(oItem));
                        //            AssignCommand(oPC,ActionPutDownItem(oItem));
                        //            AssignCommand(oItem,JumpToLocation(GetLocation(oTarget)));
                        oNewItem = CreateItemOnObject(GetTag(oItem), oTarget);
                        DestroyObject(oItem);
                        //            AssignCommand(oTarget, ActionTakeItem(oItem, oPC));
                        if (bKeen == TRUE) //Is Weapon Keen?
                        {
                                nCritMin = 20 - ( (20 - nCritMin) * 2);
                        }
                        if (bReturn == TRUE) //Does Weapon Return?
                        {
                                AssignCommand(oPC, DelayCommand(1.0,SendMessageToPC(oPC, "Your " + GetName(oNewItem) + " begins to return to you.")));
                                AssignCommand(oPC, DelayCommand(6.0, CreateEquip(oNewItem, oPC)));
                                DelayCommand(7.0, DestroyObject(oNewItem));
                                //                oNewItem = CreateItemOnObject(GetTag(oItem), oPC);
                                //                AssignCommand(oPC, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND));
                        }
                        SendMessageToPC(oPC, "Attack Roll: " + IntToString(nRoll) + " Range Penalty: " + IntToString(nPenalty) + " (" + IntToString(nRoll)+"-"+IntToString(nPenalty)+"="+IntToString(nRoll-nPenalty)+ "): Hit");
                        if (nRoll >= nCritMin) //above threat range?
                        {
                                if ( d20()-nPenalty > GetAC(oTarget)) //is it a real crit?
                                {
                                        SendMessageToPC(oPC, "Critical Hit!");
                                        //                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisualImpact, oTarget, 0.15);
                                        nDamage = nDamage * (nCritMod);
                                        SendMessageToPC(oPC, "Hit " + GetName(oTarget) + " for " + IntToString(nDamage) + " damage.");
                                        eDamage = EffectLinkEffects(EffectDamage(nDamage),eDamage);
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                                }
                        }
                        else //not a crit
                        {
                                //                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisualImpact, oTarget, 0.15);
                                SendMessageToPC(oPC, "Hit " + GetName(oTarget) + " for " + IntToString(nDamage) + " damage.");
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                        }
                        //Additional damage modifiers;
                        //Elemental
                        if (bFlaming==TRUE)
                        nExtraDamage=d6();
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_FIRE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_FIRE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if (bFrost==TRUE)
                        nExtraDamage=d6();
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_COLD);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_FROST);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if (bShock==TRUE)
                        nExtraDamage=d6();
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_ELECTRICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));

                        //Alignment-based
                        if (bHoly==TRUE && GetAlignmentGoodEvil(oTarget)== ALIGNMENT_EVIL)
                        nExtraDamage=d6(2);
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_POSITIVE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_DIVINE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if (bUnholy==TRUE && GetAlignmentGoodEvil(oTarget)== ALIGNMENT_GOOD)
                        nExtraDamage=d6(2);
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_NEGATIVE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if (bLawful==TRUE && GetAlignmentLawChaos(oTarget)== ALIGNMENT_LAWFUL)
                        nExtraDamage=d6(2);
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_MAGICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_SONIC);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if (bChaotic==TRUE && GetAlignmentLawChaos(oTarget)== ALIGNMENT_CHAOTIC)
                        nExtraDamage=d6(2);
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_MAGICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_SONIC);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));
                        if ((bNeutral==TRUE && GetAlignmentLawChaos(oTarget)== ALIGNMENT_NEUTRAL) ||
                        (bNeutral==TRUE && GetAlignmentGoodEvil(oTarget)== ALIGNMENT_NEUTRAL))
                        nExtraDamage=d6(2);
                        eExtraDamage = EffectDamage(nExtraDamage,DAMAGE_TYPE_MAGICAL);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExtraDamage, oTarget);
                        eVisualImpact = EffectVisualEffect(VFX_COM_HIT_SONIC);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisualImpact, oTarget);
                        SendMessageToPC(oPC, "Additional Damage: " + IntToString(nExtraDamage));

                        //Miscellaneous
                        if (bSnaring==TRUE)
                        eExtraDamage = EffectEntangle();
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExtraDamage, oTarget, fSnare);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ENTANGLE), oTarget, fSnare);
                        SendMessageToPC(oPC, GetName(oTarget) + " is entangled in the net!");
                }
                //On Miss:
                else
                {
                        oNewItem = CreateObject(OBJECT_TYPE_ITEM, GetTag(oItem), GetLocation(oTarget));
                        DestroyObject(oItem);
                        SendMessageToPC(oPC, "Attack Roll: " + IntToString(nRoll) + " Range Penalty: " + IntToString(nPenalty) + " (" + IntToString(nRoll)+"-"+IntToString(nPenalty)+"="+IntToString(nRoll-nPenalty)+"): Miss");
                        //            AssignCommand(oTarget, ActionTakeItem(oItem, oPC));
                        if (bReturn == TRUE) //Does Weapon Return?
                        {
                                //                oNewItem = CreateItemOnObject(GetTag(oItem), oPC);
                                //                AssignCommand(oPC, ActionEquipItem(oNewItem, INVENTORY_SLOT_RIGHTHAND));
                                AssignCommand(oPC, DelayCommand(1.0,SendMessageToPC(oPC, "Your " + GetName(oNewItem) + " begins to return to you.")));
                                AssignCommand(oPC, DelayCommand(6.0, CreateEquip(oNewItem, oPC)));
                                DelayCommand(7.0, DestroyObject(oNewItem));
                        }
                        else
                        {
                                SendMessageToPC(oPC, "The " + GetName(oItem) + " skitters across the ground after missing its mark.");
                        }
                }
                if(oTarget!=OBJECT_INVALID)
                {
                        AssignCommand(oTarget,ActionAttack(oPC));
                }
                return;
        }
}
//End main file
* Example ***/