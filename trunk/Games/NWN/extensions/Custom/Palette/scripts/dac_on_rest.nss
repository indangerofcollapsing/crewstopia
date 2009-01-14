#include "inc_bindstone"
#include "inc_debug_dac"
void setRestEffects(object oPC);
void removeRestEffects(object oPC);

void main()
{
   object oPC = GetLastPCRested();

   switch(GetLastRestEventType())
   {
      case REST_EVENTTYPE_REST_STARTED:
         setLastRestLoc(oPC, GetLocation(oPC));
         setRestEffects(oPC);
         break;
      case REST_EVENTTYPE_REST_FINISHED:
         removeRestEffects(oPC);
         break;
      case REST_EVENTTYPE_REST_CANCELLED:
         removeRestEffects(oPC);
         break;
      case REST_EVENTTYPE_REST_INVALID:
         // nothing
         break;
      default:
         logError("unknown event in dac_on_rest");
         break;
   }

   // Standard OnRest event processing
//debug("executing standard onrest");
   ExecuteScript("x2_mod_def_rest", OBJECT_SELF);
}

void setRestEffects(object oPC)
{
   effect eBlind = SupernaturalEffect(EffectBlindness());
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oPC);
}

void removeRestEffects(object oPC)
{
   effect eEffect = GetFirstEffect(oPC);
   while (GetIsEffectValid(eEffect))
   {
      if (GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
      {
         switch(GetEffectType(eEffect))
         {
            case EFFECT_TYPE_BLINDNESS:
               RemoveEffect(oPC, eEffect);
               break;
            default:
               break;
         }
      }
   }
}

