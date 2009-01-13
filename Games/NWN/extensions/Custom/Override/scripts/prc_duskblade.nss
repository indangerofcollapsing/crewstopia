#include "prc_alterations"
#include "inc_debug_dac" // @DUG

// Armour and Shield combined, up to Medium/Large shield.
void ReducedASF(object oCreature)
{
   object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
   object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
   object oSkin = GetPCSkin(oCreature);
   int nAC = GetBaseAC(oArmor);
   int nClass = GetLevelByClass(CLASS_TYPE_DUSKBLADE, oCreature);
   int iBonus = GetLocalInt(oSkin, "DuskbladeArmourCasting");
   int nASF = -1;
   itemproperty ip;

   // First thing is to remove old ASF (in case armor is changed.)
   if (iBonus != -1)
      RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "DuskbladeArmourCasting");

   // As long as they meet the requirements, just give em max ASF reduction
   // I know it could cause problems if they have increased ASF, but thats unlikely
/* @DUG
   if (5 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && nClass >= 7)
      nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT;
   else if (5 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD && nClass >= 4)
      nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;
   else if (3 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD && nClass >= 1)
      nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;
@DUG */

   // @DUG
   int nPct = 0;
   if (nAC >= 6 && nClass >= 12) nPct += 45; // new: heavy armor at level 12
   else if (nAC <= 5 && nClass >= 4) nPct += 30;
   else if (nAC <= 3 && nClass >= 1) nPct += 20;
   switch (GetBaseItemType(oShield))
   {
      case BASE_ITEM_SMALLSHIELD:
         if (nClass >= 1) nPct += 5;
         break;
      case BASE_ITEM_LARGESHIELD:
         if (nClass >= 7) nPct += 15;
         break;
      case BASE_ITEM_TOWERSHIELD: // new: tower shields at level 15
         if (nClass >= 15) nPct += 50;
         break;
      default:
         break;
   }
   // Due to limitations in the engine, max ASF bonus is -50%, which sort of
   // makes sense.  Choose heavy armor or tower shield, not both.
   switch(nPct)
   {
      case 5:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
         break;
      case 10:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
         break;
      case 15:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
         break;
      case 20:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
         break;
      case 25:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;
         break;
      case 30:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT;
         break;
      case 35:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;
         break;
      case 40:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT;
         break;
      case 45:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT;
         break;
      case 50:
         nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
         break;
      default:
         if (nASF >= 50) nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
         else
         {
            // default fallback value
            nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
            logError("Invalid nASF in prc_duskblade.nss: " + IntToString(nASF));
         }
         break;
   }

   // Apply the ASF to the skin.
   ip = ItemPropertyArcaneSpellFailure(nASF);

   AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
   SetLocalInt(oSkin, "DuskbladeArmourCasting", nASF);
}

void main()
{
   object oPC = OBJECT_SELF;
   object oItem;
      int nClass = GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC);
      int nEvent = GetRunningEvent();

   // Duskblade can cast in light armour.
   if (GetIsPC(oPC)) ReducedASF(oPC);

    // We aren't being called from any event, instead from EvalPRCFeats, so set up the eventhooks
    // Don't start doing this until the Duskblade is level 2
    if(nEvent == FALSE && nClass >= 6)
    {
        oPC = OBJECT_SELF;
        if(DEBUG) DoDebug("prc_duskblade: Adding eventhooks");

        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_duskblade", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_duskblade", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_duskblade: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to melee weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
         // Thats all we do here
      SetLocalInt(oTarget, "DuskbladeSpellPower", TRUE);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
        else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
        {
            oPC   = GetItemLastEquippedBy();
            oItem = GetItemLastEquipped();
            if(DEBUG) DoDebug("prc_duskblade - OnEquip");

            // Only applies to melee weapons
            if(IPGetIsMeleeWeapon(oItem))
            {
                // Add eventhook to the item
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_duskblade", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
        }
        // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
        else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
        {
            oPC   = GetItemLastUnequippedBy();
            oItem = GetItemLastUnequipped();
            if(DEBUG) DoDebug("prc_duskblade - OnUnEquip");

            // Only applies to melee weapons
            if(IPGetIsMeleeWeapon(oItem))
            {
                // Add eventhook to the item
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_duskblade", TRUE, FALSE);

                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
            }
    }
}
