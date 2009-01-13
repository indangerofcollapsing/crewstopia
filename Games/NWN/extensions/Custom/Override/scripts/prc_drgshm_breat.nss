//:://////////////////////////////////////////////////////
//:: Breath Weapon for Dragon Shaman Class
//:: prc_drgshm_breath.nss
//:://////////////////////////////////////////////////////

#include "prc_inc_breath"
#include "prc_inc_dragsham"
#include "inc_debug_dac" // @DUG

//////////////////////////
// Constant Definitions //
//////////////////////////

const string DSHMBREATHLOCK = "DragonShamanBreathLock";

int IsLineBreath()
{
   return (GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF) ||
       GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF) ||
       GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF) ||
       GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF) ||
       GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF));
}

// PHB II Dragon Shaman has no mention of size being taken into account
// with breath weapons on players. Once this is looked at further, this may
// or may not be taken into account. These rules are gone over in more detail
// in the draconomicon which has a lot more rules for dragon breath weapons.

/* @DUG */
float GetRangeFromSize(int nSize)
{
   float fRange = 30.0;
   switch(nSize)
   {
      case CREATURE_SIZE_FINE:
      case CREATURE_SIZE_DIMINUTIVE:
      case CREATURE_SIZE_TINY:        fRange = 15.0; break;
      case CREATURE_SIZE_SMALL:       fRange = 20.0; break;
      case CREATURE_SIZE_MEDIUM:      fRange = 30.0; break;
      case CREATURE_SIZE_LARGE:       fRange = 40.0; break;
      case CREATURE_SIZE_HUGE:        fRange = 50.0; break;
      case CREATURE_SIZE_GARGANTUAN:  fRange = 60.0; break;
      case CREATURE_SIZE_COLOSSAL:    fRange = 70.0; break;
   }
   return fRange;
} // @DUG */

void main()
{
   //debugVarObject("prc_dgrshm_breat", OBJECT_SELF);

   //Declare main variables.
   object oPC   = OBJECT_SELF;
   object oSkin = GetPCSkin(oPC);
   float fRange = GetRangeFromSize(PRCGetCreatureSize(OBJECT_SELF)); // @DUG
   struct breath ShamanBreath;

   // Check the dragon breath delay lock
   if (GetLocalInt(oPC, DSHMBREATHLOCK))
   {
      SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
      return;
   }

   // Set the lock
   SetLocalInt(oPC, DSHMBREATHLOCK, TRUE);

   //set the breath range
   if (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) >= 20)
   {
      fRange *= 2.0; // @DUG 60.0;
   }
   else if(GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN) < 12)
   {
      fRange *= 0.5; // @DUG 15.0;
   }

   if (IsLineBreath()) fRange *= 2.0;

   int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC);

   // Sets the save DC for Dragon Breath attacks.  This is a reflex
   // save to halve the damage.
   // Save is 10+CON+1/2 Dragon Shaman level.
   int nSaveDCBoost = nLevel / 2;

   // Starts with 2 dice at level 4
   int nDamageDice = 2;
   // Gets one more die every 2 levels
   nDamageDice += (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC) - 4) / 2;

   // Only Dragons with Breath Weapons will have damage caused by their
   // breath attack.
   // Any Dragon type not listed here will have a breath attack, but it will not
   // cause damage or create a visual effect.
   int nBreed = GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC) ? DAMAGE_TYPE_FIRE :
      GetHasFeat(FEAT_DRAGONSHAMAN_BRASS,     oPC) ? DAMAGE_TYPE_FIRE :
      GetHasFeat(FEAT_DRAGONSHAMAN_GOLD,      oPC) ? DAMAGE_TYPE_FIRE :
      GetHasFeat(FEAT_DRAGONSHAMAN_BLACK,     oPC) ? DAMAGE_TYPE_ACID :
      GetHasFeat(FEAT_DRAGONSHAMAN_GREEN,     oPC) ? DAMAGE_TYPE_ACID :
      GetHasFeat(FEAT_DRAGONSHAMAN_COPPER,    oPC) ? DAMAGE_TYPE_ACID :
      GetHasFeat(FEAT_DRAGONSHAMAN_SILVER,    oPC) ? DAMAGE_TYPE_COLD :
      GetHasFeat(FEAT_DRAGONSHAMAN_WHITE,     oPC) ? DAMAGE_TYPE_COLD :
      GetHasFeat(FEAT_DRAGONSHAMAN_BLUE,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
      GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE,    oPC) ? DAMAGE_TYPE_ELECTRICAL :
      DAMAGE_TYPE_MAGICAL;

   if (nBreed == DAMAGE_TYPE_MAGICAL)
   {
      logError("ERROR: unknown dragon shaman type in prc_drgshm_breat");
   }

   //debugMsg("creating ShamanBreath");
   ShamanBreath = CreateBreath(oPC, IsLineBreath(), fRange, nBreed, 6,
      nDamageDice, ABILITY_CONSTITUTION, nSaveDCBoost);

   // Enlarge Breath is not accounted for until you call ApplyBreath()
   if (GetLocalInt(oPC, "EnlargeBreath")) fRange *= 1.5;

   //debugVarFloat("fRange", fRange);

   object oTarget = PRCGetSpellTargetObject();
   //debugVarObject("oTarget", oTarget);

   //debugVarFloat("distance", GetDistanceBetween(oPC, oTarget));
   if (oTarget != OBJECT_INVALID &&
       GetDistanceBetween(oPC, oTarget) > fRange)
   {
      // Move closer and try again
      SendMessageToPC(oPC, "Too far away for breath to reach!");
      SetLocalInt(oPC, DSHMBREATHLOCK, FALSE);
      float fDistanceToMove = GetDistanceBetween(oPC, oTarget) - fRange + 1;
      //debugVarFloat("fDistanceToMove", fDistanceToMove);
      vector vMoveTo = GetChangedPosition(GetPosition(oPC), fDistanceToMove,
         GetFacing(oPC));
      location lMoveTo = Location(GetArea(oPC), vMoveTo, GetFacing(oPC));
      //debugVarLoc("lMoveTo", lMoveTo);
      ActionDoCommand(ActionMoveToLocation(lMoveTo, TRUE));
      //ActionDoCommand(ActionMoveToObject(oTarget, TRUE, fRange));
      ActionDoCommand(ActionCastSpellAtObject(3771, oTarget, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      return;
   }

   //debugVarObject("calling ApplyBreath()", oPC);
   ApplyBreath(ShamanBreath, PRCGetSpellTargetLocation());
   //breath VFX
   /* - Taken out until we have real breath VFX - Fox
   effect eVis;

   if(GetHasFeat(FEAT_DRAGONSHAMAN_RED, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
   }
   else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_BEAM_LIGHTNING);
   }
   else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
   }
   else if(GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, OBJECT_SELF) || GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
   }
   else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_BEAM_FIRE_W);
   }
   else if(GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, OBJECT_SELF))
   {
      eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
   }

   // Apply the visual effect.
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
   */

   //debugMsg("attacking the target?");
   // @DUG
   if (oTarget != OBJECT_INVALID)
   {
      AssignCommand(OBJECT_SELF, ActionAttack(oTarget));
   }

   // Schedule opening the delay lock
   float fDelay = RoundsToSeconds(ShamanBreath.nRoundsUntilRecharge);
   //debugVarFloat("fDelay", fDelay);
   SendMessageToPC(oPC, IntToString(ShamanBreath.nRoundsUntilRecharge) + " rounds until you can use your breath.");
   DelayCommand(fDelay, DeleteLocalInt(oPC, DSHMBREATHLOCK));
   DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));
   // @DUG visual display of being out of breath
   effect eOutOfBreath = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   //debugVarFloat("fDelay", fDelay);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOutOfBreath, oPC, fDelay);
}
