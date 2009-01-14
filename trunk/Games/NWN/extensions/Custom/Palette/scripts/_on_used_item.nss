// Event processing for an item
#include "x2_inc_switches"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("[script_name]", OBJECT_SELF);

   // Only Cast Spell Unique Power Self Only should fire
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

   object oPC;
   object oItem;
   switch (GetUserDefinedItemEventNumber())
   {
      case X2_ITEM_EVENT_ONHITCAST: // OnHitCastSpell
         oItem =  GetSpellCastItem(); // The item which triggered this
//         object oSpellOrigin = OBJECT_SELF;
//         object oSpellTarget = GetSpellTargetObject();
         oPC = OBJECT_SELF;
         break;
      case X2_ITEM_EVENT_ACTIVATE: // Cast Spell: Unique Power [Self Only]
         oPC = GetItemActivator();
         oItem = GetItemActivated();
         break;
      case X2_ITEM_EVENT_EQUIP: // Equip Item
         oPC = GetPCItemLastEquippedBy();
         oItem = GetPCItemLastEquipped();
         break;
      case X2_ITEM_EVENT_UNEQUIP: // Unequip Item
         oPC = GetPCItemLastUnequippedBy();
         oItem = GetPCItemLastUnequipped();
         break;
      case X2_ITEM_EVENT_ACQUIRE: // Acquire Item
         oPC = GetModuleItemAcquiredBy();
         oItem = GetModuleItemAcquired();
         break;
      case X2_ITEM_EVENT_UNACQUIRE: // Unacquire Item
         oPC = GetModuleItemLostBy();
         oItem = GetModuleItemLost();
         break;
      case X2_ITEM_EVENT_SPELLCAST_AT: // Cast Spell At Item
         oPC = GetLastSpellCaster();
         oItem = GetSpellTargetObject();
         break;
      default:
         logError("Unknown User Defined Item Event Number in [script_name]: " +
            IntToString(GetUserDefinedItemEventNumber()));
   }
}

