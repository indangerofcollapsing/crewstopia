// Interactive Ballista and other siege engines
// Based on "Interactive Ballista" by Roy Boscowan
// (http://nwvault.ign.com/View.php?view=Prefabs.Detail&id=869)
#include "zep_inc_main"
#include "inc_g_cutscene"
#include "inc_heartbeat"
//#include "x0_i0_spells"
//#include "inc_debug_dac"

/* For future reference, and setting variables on placeables:

IA_BALLISTA_MISSILE_TYPE: (not all of these have been tested)
SPELL_BOMBARDMENT = 423
SPELL_DELAYED_BLAST_FIREBALL = 39
SPELL_EARTHQUAKE, = 426
SPELL_ELECTRIC_JOLT = 439
SPELL_ENTANGLE = 53
SPELL_EPIC_RUIN = 640
SPELL_FLAME_ARROW, = 59
SPELL_FLAME_STRIKE = 61
SPELL_FLYING_DEBRIS = 620
SPELL_GRENADE_ACID, = 469
SPELL_GRENADE_CHOKING = 467
SPELL_GRENADE_FIRE = 464
SPELL_GRENADE_HOLY, = 466
SPELL_GRENADE_TANGLE = 465
SPELL_GRENADE_THUNDERSTONE = 468
SPELL_ICE_DAGGER, = 543
SPELL_LIGHTNING_BOLT = 101
SPELL_MAGIC_MISSILE = 107
SPELL_NEGATIVE_ENERGY_BURST, = 370
SPELL_NEGATIVE_ENERGY_RAY = 371
SPELL_QUILLFIRE = 425
SPELL_RAY_OF_ENFEEBLEMENT, = 143
SPELL_RAY_OF_FROST = 144
SPELL_SHADES_FIREBALL = 341
SPELL_SOUND_BURST, = 167
SPELL_STINKING_CLOUD = 171
SPELL_TRAP_ARROW = 487
SPELL_TRAP_BOLT = 488
SPELL_TRAP_DART, = 493
SPELL_TRAP_SHURIKEN = 494

IA_BALLISTA_DAMAGE_TYPE:
DAMAGE_TYPE_ACID = 16
DAMAGE_TYPE_BASE_WEAPON = 4096
DAMAGE_TYPE_BLUDGEONING = 1
DAMAGE_TYPE_COLD = 32
DAMAGE_TYPE_DIVINE = 64
DAMAGE_TYPE_ELECTRICAL = 128
DAMAGE_TYPE_FIRE = 256
DAMAGE_TYPE_MAGICAL = 8
DAMAGE_TYPE_NEGATIVE = 512
DAMAGE_TYPE_PIERCING = 2
DAMAGE_TYPE_POSITIVE = 1024
DAMAGE_TYPE_SLASHING = 4
DAMAGE_TYPE_SONIC = 2048

IA_BALLISTA_DAMAGE_RADIUS:
RADIUS_SIZE_SMALL =        1.670000076
RADIUS_SIZE_MEDIUM =        3.329999924
RADIUS_SIZE_LARGE =        5.000000000
RADIUS_SIZE_HUGE =        6.670000076
RADIUS_SIZE_GARGANTUAN =        8.329999924
RADIUS_SIZE_COLOSSAL =       10.000000000

IA_BALLISTA_DAMAGE_DICE:
(defaults to HP/10, all variants use d8 for damage)
(i.e., if HP = 70, the engine will do 7d8 damage)

IA_BALLISTA_RANGE_MULTIPLIER:
(defaults to HP/50)

IA_BALLISTA_MIN_RANGE:
(defaults to 10+HP/25 for catapults, 10 for ballistae)
*/

// Variable names
const string VAR_MAX_ELEVATION = "MAX_ELEVATION";
const string VAR_MIN_ELEVATION = "MIN_ELEVATION";
const string VAR_MAX_BEARING = "MAX_BEARING";
const string VAR_CURRENT_ELEVATION = "CURRENT_ELEVATION";
const string VAR_CURRENT_BEARING = "CURRENT_BEARING";
const string VAR_AIMER = "IA_BALLISTA_AIMER";
const string VAR_IS_RELOADING = "IS_RELOADING";
const string VAR_RELOAD_DELAY = "RELOAD_DELAY";
const string VAR_SEAT = "IA_BALLISTA_SEAT";
// DAMAGE_TYPE_*
const string VAR_IA_BALLISTA_DAMAGE_TYPE = "IA_BALLISTA_DAMAGE_TYPE";
// SPELL_*
const string VAR_IA_BALLISTA_MISSILE_TYPE = "IA_BALLISTA_MISSILE_TYPE";
const string VAR_IA_BALLISTA_DAMAGE_DICE = "IA_BALLISTA_DAMAGE_DICE";
const string VAR_IA_BALLISTA_DAMAGE_RADIUS = "IA_BALLISTA_DAMAGE_RADIUS";
const string VAR_IA_BALLISTA_RANGE_MULTIPLIER = "IA_BALLISTA_RANGE_MULTIPLIER";
const string VAR_IA_BALLISTA_MIN_RANGE = "IA_BALLISTA_MIN_RANGE";
const string VAR_IA_BALLISTA_USE_3RD_PERSON_VIEW = "IA_BALLISTA_3RD_PERSON";
const string VAR_IA_BALLISTA_USER = "IA_BALLISTA_USER";

// Constants
const string IA_BALLISTA_WP_PREFIX = "WP_IA_BAL_SEAT";
const string AIMER_TAG = "IA_BALLISTA_AIMER";
const string AIMER_RESREF = "dac_siege_target";

int getReloadDelay(object obj = OBJECT_SELF);
int getMaxBearing(object obj = OBJECT_SELF);
int getMaxElev(object obj = OBJECT_SELF);
int getMinElev(object obj = OBJECT_SELF);
object getAimer(object obj = OBJECT_SELF);
object getSeat(object obj = OBJECT_SELF);
object getUser(object obj = OBJECT_SELF);
void adjustAim(int nElev, int nBrng, object obj = OBJECT_SELF);
int getDamageType(object obj = OBJECT_SELF);
int getMissileType(object obj = OBJECT_SELF);
void launchMissile(object obj = OBJECT_SELF);
void toggleView(object obj = OBJECT_SELF);
int isUsing1stPersonView(object obj = OBJECT_SELF);
int getDamageDice(object obj = OBJECT_SELF);
float getDamageRadius(object obj = OBJECT_SELF);
float getRangeMultiplier(object obj = OBJECT_SELF);
float getMinRange(object obj = OBJECT_SELF);
int isBallista(object obj = OBJECT_SELF);
int isCatapult(object obj = OBJECT_SELF);
void seigeEnginePiercingAttack(object oSiegeEngine);
void seigeEngineBludgeoningAttack(object oSiegeEngine);

int getReloadDelay(object obj = OBJECT_SELF)
{
   int nDelay = GetLocalInt(obj, VAR_RELOAD_DELAY);
   if (nDelay == 0)
   {
      nDelay = GetMaxHitPoints(obj) / 10;
      SetLocalInt(obj, VAR_RELOAD_DELAY, nDelay);
   }
   return nDelay;
}

int getMaxBearing(object obj = OBJECT_SELF)
{
   int nMaxBearing = GetLocalInt(obj, VAR_MAX_BEARING);
   if (nMaxBearing == 0)
   {
      nMaxBearing = 45;
      SetLocalInt(obj, VAR_MAX_BEARING, nMaxBearing);
   }
   return nMaxBearing;
}

int getMaxElev(object obj = OBJECT_SELF)
{
   int nMaxElev = GetLocalInt(obj, VAR_MAX_ELEVATION);
   if (nMaxElev == 0)
   {
      nMaxElev = 45;
      SetLocalInt(obj, VAR_MAX_ELEVATION, nMaxElev);
   }
   return nMaxElev;
}

int getMinElev(object obj = OBJECT_SELF)
{
   int nMinElev = GetLocalInt(obj, VAR_MIN_ELEVATION);
   if (nMinElev == 0)
   {
      nMinElev = 0;
      SetLocalInt(obj, VAR_MIN_ELEVATION, nMinElev);
   }
   return nMinElev;
}

object getAimer(object obj = OBJECT_SELF)
{
   return GetLocalObject(obj, VAR_AIMER);
}

object getSeat(object obj = OBJECT_SELF)
{
   object oSeat = GetLocalObject(obj, VAR_SEAT);
   if (oSeat == OBJECT_INVALID)
   {
      // Bioware ballista is offset by 90, CEP versions are not
      float fFace = GetFacing(obj); // + 90;
      float fRange = 1.5;
      float x = fRange * cos(fFace);
      float y = fRange * sin(fFace);
      vector vSelf = GetPosition(obj);
      vSelf.x += x;
      vSelf.y += y;
      location lSeat = Location(GetArea(obj), vSelf, fFace);
      oSeat = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lSeat, FALSE);
      SetLocalObject(obj, VAR_SEAT, oSeat);
   }
   return oSeat;
}

object getUser(object obj = OBJECT_SELF)
{
   object oUser = GetLocalObject(obj, VAR_IA_BALLISTA_USER);
   if (! GetIsObjectValid(oUser)) oUser = OBJECT_SELF;
   return oUser;
}

void adjustAim(int nElev, int nBrng, object obj = OBJECT_SELF)
{
   //debugVarObject("adjustAim()", obj);
   object oAimer = getAimer(obj);
   SetPlotFlag(oAimer, FALSE);
   DestroyObject(oAimer, 0.0);
   int nElevation = GetLocalInt(obj, VAR_CURRENT_ELEVATION);
   nElevation += nElev;
   SetLocalInt(obj, VAR_CURRENT_ELEVATION, nElevation);
   int nBearing = GetLocalInt(obj, VAR_CURRENT_BEARING);
   nBearing += nBrng;
   SetLocalInt(obj, VAR_CURRENT_BEARING, nBearing);
   SetCustomToken(5000, IntToString(nBearing));
   SetCustomToken(5001, IntToString(nElevation));
   object oSeat = getSeat(obj);
   float fFace = GetFacing(oSeat);
   object oPC = getUser(obj);
   if (isUsing1stPersonView(oPC))
   {
      GestaltCameraMove(0.2, fFace - IntToFloat(nBearing), 1.5, 75.0,
         fFace - IntToFloat(nBearing), 1.5, 75.0, 0.1, 1.0, oPC, 2, 0, 0);
   }
   float fFire = fFace - IntToFloat(nBearing);
   float fRange = (nElevation) * getRangeMultiplier(obj) + getMinRange(obj);
   float x = fRange * cos(fFire);
   float y = fRange * sin(fFire);
   vector vSelf = GetPosition(obj);
   vSelf.x += x;
   vSelf.y += y;
   location lAimer = Location(GetArea(obj), vSelf, fFire);
//   effect eAimer = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE, FALSE);
//   oAimer = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lAimer,
//      FALSE, AIMER_TAG);
   oAimer = CreateObject(OBJECT_TYPE_PLACEABLE, AIMER_RESREF, lAimer,
      FALSE);
//   SetPlotFlag(oAimer, TRUE);
//   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAimer, oAimer, 9999.0);
   SetLocalObject(obj, VAR_AIMER, oAimer);
}

int getDamageType(object obj = OBJECT_SELF)
{
   int nDamageType = GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE);
   if (nDamageType == 0)
   {
      string sName = GetStringLowerCase(GetName(obj));
      if (isBallista(obj))
      {
         nDamageType = DAMAGE_TYPE_PIERCING;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE, SPELL_TRAP_BOLT);
         }
      }
      else if (isCatapult(obj))
      {
         nDamageType = DAMAGE_TYPE_BLUDGEONING;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE, SPELL_FLYING_DEBRIS);
         }
      }
      else
      {
         nDamageType = DAMAGE_TYPE_FIRE;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE, SPELL_FIREBALL);
         }
      }

      SetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE, nDamageType);
   }
   return nDamageType;
}

// Also may be useful:
// SPELL_BOMBARDMENT, SPELL_DELAYED_BLAST_FIREBALL, SPELL_EARTHQUAKE,
// SPELL_ELECTRIC_JOLT, SPELL_ENTANGLE, SPELL_EPIC_RUIN, SPELL_FLAME_ARROW,
// SPELL_FLAME_STRIKE, SPELL_FLYING_DEBRIS, SPELL_GRENADE_ACID,
// SPELL_GRENADE_CHOKING, SPELL_GRENADE_FIRE, SPELL_GRENADE_HOLY,
// SPELL_GRENADE_TANGLE, SPELL_GRENADE_THUNDERSTONE, SPELL_ICE_DAGGER,
// SPELL_LIGHTNING_BOLT, SPELL_MAGIC_MISSILE, SPELL_NEGATIVE_ENERGY_BURST,
// SPELL_NEGATIVE_ENERGY_RAY, SPELL_QUILLFIRE, SPELL_RAY_OF_ENFEEBLEMENT,
// SPELL_RAY_OF_FROST, SPELL_SHADES_FIREBALL, SPELL_SOUND_BURST,
// SPELL_STINKING_CLOUD, SPELL_TRAP_ARROW, SPELL_TRAP_BOLT, SPELL_TRAP_DART,
// SPELL_TRAP_SHURIKEN
int getMissileType(object obj = OBJECT_SELF)
{
   int nMissileType = GetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE);
   if (nMissileType == 0)
   {
      if (isBallista(obj))
      {
         nMissileType = SPELL_TRAP_BOLT;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE, DAMAGE_TYPE_PIERCING);
         }
      }
      else if (isCatapult(obj))
      {
         nMissileType = SPELL_FLYING_DEBRIS;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE, DAMAGE_TYPE_BLUDGEONING);
         }
      }
      else
      {
         nMissileType = SPELL_FIREBALL;
         if (GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE) == 0)
         {
            SetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE, DAMAGE_TYPE_FIRE);
         }
      }

      SetLocalInt(obj, VAR_IA_BALLISTA_MISSILE_TYPE, nMissileType);
   }
   return nMissileType;
}

void launchMissile(object obj = OBJECT_SELF)
{
   location lTarget = GetLocation(getAimer(obj));
/*
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget,
      TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   while (GetIsObjectValid(oTarget))
   {
      SetIsTemporaryEnemy(oTarget, obj, FALSE, DURATION_1_ROUND);
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget,
         TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   }
*/
//   ActionCastSpellAtLocation(getMissileType(obj), lTarget,
//      METAMAGIC_MAXIMIZE, TRUE, PROJECTILE_PATH_TYPE_BALLISTIC, TRUE);
   PlaySound("dac_ballista");
   ActionCastFakeSpellAtLocation(getMissileType(obj), lTarget,
      PROJECTILE_PATH_TYPE_BALLISTIC);
   //debugVarObject("siege engine user", getUser(obj));
   float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(obj)) / 15;
   switch (getDamageType(obj))
   {
      case DAMAGE_TYPE_PIERCING:
         AssignCommand(getUser(obj), DelayCommand(fDelay,
            seigeEnginePiercingAttack(obj)));
         break;
      case DAMAGE_TYPE_BLUDGEONING:
      default:
         AssignCommand(getUser(obj), DelayCommand(fDelay,
            seigeEngineBludgeoningAttack(obj)));
   }
   // Reload
   SetLocalInt(obj, VAR_IS_RELOADING, TRUE);
   DelayCommand(getReloadDelay(obj) * 1.0f,
      SetLocalInt(obj, VAR_IS_RELOADING, FALSE));
}

void toggleView(object obj = OBJECT_SELF)
{
   //debugVarObject("toggleView()", obj);
   object oPC = getUser(obj);
   SetLocalInt(oPC, VAR_IA_BALLISTA_USE_3RD_PERSON_VIEW,
      ! GetLocalInt(oPC, VAR_IA_BALLISTA_USE_3RD_PERSON_VIEW));

   GestaltClearFX(obj);
   GestaltStopCutscene(0.1, oPC, "", TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 0);
   if (isUsing1stPersonView(oPC))
   {
      GestaltInvisibility(0.0, oPC, 0.0, "");
//      GestaltInvisibility(0.0, obj, 0.0, "");
      GestaltStartCutscene(oPC, "", TRUE, TRUE, TRUE, TRUE, TRUE, 0);
      GestaltActionJump(0.1, oPC, getSeat(obj));
      SetCameraMode(oPC, CAMERA_MODE_CHASE_CAMERA);
   }
   else
   {
      SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
   }

   if (! IsInConversation(oPC))
   {
      GestaltActionConversation(0.0, oPC, obj, "ia_ballista", "", FALSE);
   }

   ActionDoCommand(adjustAim(0, 0, obj));
}

int isUsing1stPersonView(object obj = OBJECT_SELF)
{
   object oPC = GetIsPC(obj) ? obj : getUser(obj);
   return (! GetLocalInt(oPC, VAR_IA_BALLISTA_USE_3RD_PERSON_VIEW));
}

int getDamageDice(object obj = OBJECT_SELF)
{
   int nDice = GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_DICE);
   if (nDice == 0)
   {
      nDice = GetMaxHitPoints(obj) / 10;
      SetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_DICE, nDice);
   }
   return nDice;
}

float getDamageRadius(object obj = OBJECT_SELF)
{
   float fRadius = GetLocalFloat(obj, VAR_IA_BALLISTA_DAMAGE_RADIUS);
   if (fRadius == 0.0)
   {
      if (GetLocalInt(obj, VAR_IA_BALLISTA_DAMAGE_TYPE) == DAMAGE_TYPE_PIERCING)
      {
         fRadius = 5.0f;
      }
      else
      {
         fRadius = GetMaxHitPoints(obj) / 5.0f;
      }
      SetLocalFloat(obj, VAR_IA_BALLISTA_DAMAGE_RADIUS, fRadius);
   }

   return fRadius;
}

float getRangeMultiplier(object obj = OBJECT_SELF)
{
   float fRangeMult = GetLocalFloat(obj, VAR_IA_BALLISTA_RANGE_MULTIPLIER);
   if (fRangeMult == 0.0)
   {
      fRangeMult = GetMaxHitPoints(obj) / 50.0;
      SetLocalFloat(obj, VAR_IA_BALLISTA_RANGE_MULTIPLIER, fRangeMult);
   }

   return fRangeMult;
}

float getMinRange(object obj = OBJECT_SELF)
{
   float fMinRange = GetLocalFloat(obj, VAR_IA_BALLISTA_MIN_RANGE);
   if (fMinRange == 0.0)
   {
      if (isBallista(obj))
      {
         fMinRange = 10.0;
      }
      else if (isCatapult(obj))
      {
         fMinRange = 10.0 + GetMaxHitPoints(obj) / 25.0;
      }
      else
      {
         fMinRange = 10.0;
      }
      SetLocalFloat(obj, VAR_IA_BALLISTA_MIN_RANGE, fMinRange);
   }

   return fMinRange;
}

int isBallista(object obj = OBJECT_SELF)
{
   string sName = GetStringLowerCase(GetName(obj));
   return (FindSubString(sName, "arbalest") != -1 ||
           FindSubString(sName, "ballista") != -1 ||
           FindSubString(sName, "crossbow") != -1 ||
           FindSubString(sName, "oxebeles") != -1);
}

int isCatapult(object obj = OBJECT_SELF)
{
   string sName = GetStringLowerCase(GetName(obj));
   return (FindSubString(sName, "bricole") != -1 ||
           FindSubString(sName, "catapult") != -1 ||
           FindSubString(sName, "couillard") != -1 ||
           FindSubString(sName, "mangonneau") != -1 ||
           FindSubString(sName, "mangonel") != -1 ||
           FindSubString(sName, "onager") != -1 ||
           FindSubString(sName, "perrier") != -1 ||
           FindSubString(sName, "scorpion") != -1 ||
           FindSubString(sName, "springal") != -1 ||
           FindSubString(sName, "trebuchet") != -1);
}

void seigeEnginePiercingAttack(object oSiegeEngine)
{
   //debugVarObject("seigeEnginePiercingAttack()", OBJECT_SELF);
   float fFacing = GetFacing(getSeat(oSiegeEngine)) -
      GetLocalInt(oSiegeEngine, VAR_CURRENT_BEARING);
   SetFacing(fFacing);
   object oAimer = getAimer(oSiegeEngine);
   location lTarget = GetLocation(oAimer);
   // Would be nice to use a cone, as that's more realistic for a ballista-type,
   // but I can't get either SHAPE_CONE or SHAPE_SPELLCONE to find anything,
   // so we're assuming that you're firing over the heads of anything in the way.
   int nShape = SHAPE_SPHERE;
   float fMinDistance = 9999.0;
   float fDistance;
   int bTargetValid;
   object oTargetFound = OBJECT_INVALID;
   object oTarget = GetFirstObjectInShape(nShape, getDamageRadius(oSiegeEngine),
      lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
   while (GetIsObjectValid(oTarget))
   {
      //debugVarObject("possible target", oTarget);
      if (! GetPlotFlag(oTarget))
      {
         bTargetValid = FALSE;
         if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
         {
            switch (GetGameDifficulty())
            {
               case GAME_DIFFICULTY_EASY:
               case GAME_DIFFICULTY_VERY_EASY:
               case GAME_DIFFICULTY_NORMAL:
                  if (GetIsReactionTypeHostile(oTarget)) bTargetValid = TRUE;
                  break;
               case GAME_DIFFICULTY_CORE_RULES:
               case GAME_DIFFICULTY_DIFFICULT:
               default:
                  bTargetValid = TRUE;
                  break;
            }
         }
         else
         {
            bTargetValid = TRUE;
         }

         // Since these are line-of-sight weapons, the closest object is hit
         if (bTargetValid)
         {
            fDistance = GetDistanceBetween(oAimer, oTarget);
            if (fDistance < fMinDistance)
            {
               oTargetFound = oTarget;
               fMinDistance = fDistance;
            }
         }
      }
      oTarget = GetNextObjectInShape(nShape, getDamageRadius(oSiegeEngine),
         lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
   }

   if (oTargetFound == OBJECT_INVALID)
   {
      SendMessageToPC(OBJECT_SELF, "No targets found!");
      return;
   }

   int nVfx;
   switch (GetObjectType(oTargetFound))
   {
      case OBJECT_TYPE_CREATURE:
         nVfx = VFX_COM_BLOOD_REG_RED;
         break;
      case OBJECT_TYPE_PLACEABLE:
      case OBJECT_TYPE_DOOR:
      default:
         nVfx = VFX_COM_CHUNK_RED_BALLISTA;
         break;
   }

   int nTouch = TouchAttackRanged(oTargetFound);
   int nDamageDice = getDamageDice(oSiegeEngine);
   if (nTouch == 0) // Miss
   {
      SendMessageToPC(OBJECT_SELF, "Missed the " + GetName(oTargetFound) + "!");
      return;
   }
   else if (nTouch == 2) // Critical Hit
   {
      SendMessageToPC(OBJECT_SELF, "Critical hit on the " +
         GetName(oTargetFound) + "!");
      nDamageDice *= 2;
   }

   int nDamage = d8(nDamageDice);

   effect eDam = EffectDamage(nDamage, getDamageType(oSiegeEngine));
   effect eVis = EffectVisualEffect(nVfx);
   // Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTargetFound);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTargetFound);
}

void seigeEngineBludgeoningAttack(object oSiegeEngine)
{
   //debugVarObject("seigeEngineBludgeoningAttack()", OBJECT_SELF);
   object oAimer = getAimer(oSiegeEngine);
   location lTarget = GetLocation(oAimer);
   float fDamageRadius = getDamageRadius(oSiegeEngine);
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fDamageRadius, lTarget,
      FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
   int nDamageDice = getDamageDice(oSiegeEngine);
   int nDamageType = getDamageType(oSiegeEngine);
   while (GetIsObjectValid(oTarget) && !GetPlotFlag(oTarget))
   {
      int bTargetValid = FALSE;
      switch (GetGameDifficulty())
      {
         case GAME_DIFFICULTY_EASY:
         case GAME_DIFFICULTY_VERY_EASY:
         case GAME_DIFFICULTY_NORMAL:
            if (GetIsReactionTypeHostile(oTarget)) bTargetValid = TRUE;
            break;
         case GAME_DIFFICULTY_CORE_RULES:
         case GAME_DIFFICULTY_DIFFICULT:
         default:
            bTargetValid = TRUE;
            break;
      }

      if (bTargetValid)
      {
         //debugVarObject("damaging", oTarget);
         int nDamage = d8(nDamageDice);
         if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
         {
            switch (ReflexSave(oTarget, 15, SAVING_THROW_TYPE_NONE, oSiegeEngine))
            {
               case 0: // Failure
                  if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)) nDamage /= 2;
                  break;
               case 1: // Success
                  nDamage = (GetHasFeat(FEAT_EVASION, oTarget) ? 0 : nDamage / 2);
                  break;
               case 2: // Immune
                  nDamage = 0;
                  break;
            }
         }

         int nVfx = VFX_COM_CHUNK_STONE_SMALL;
         switch (getDamageType(oSiegeEngine))
         {
            case DAMAGE_TYPE_ACID:
               nVfx = VFX_COM_HIT_ACID;
               break;
            case DAMAGE_TYPE_BLUDGEONING:
               nVfx = VFX_COM_CHUNK_STONE_SMALL;
               break;
            case DAMAGE_TYPE_COLD:
               nVfx = VFX_COM_HIT_FROST;
               break;
            case DAMAGE_TYPE_DIVINE:
               nVfx = VFX_COM_HIT_DIVINE;
               break;
            case DAMAGE_TYPE_ELECTRICAL:
               nVfx = VFX_COM_HIT_ELECTRICAL;
               break;
            case DAMAGE_TYPE_FIRE:
               nVfx = VFX_COM_HIT_FIRE;
               break;
            case DAMAGE_TYPE_MAGICAL:
               nVfx = VFX_COM_SPECIAL_PINK_ORANGE;
               break;
            case DAMAGE_TYPE_NEGATIVE:
               nVfx = VFX_COM_HIT_NEGATIVE;
               break;
            case DAMAGE_TYPE_PIERCING:
               nVfx = VFX_COM_BLOOD_REG_RED;
               break;
            case DAMAGE_TYPE_POSITIVE:
               nVfx = VFX_COM_HIT_DIVINE;
               break;
            case DAMAGE_TYPE_SLASHING:
               nVfx = VFX_COM_BLOOD_REG_RED;
               break;
            case DAMAGE_TYPE_SONIC:
               nVfx = VFX_COM_HIT_SONIC;
               break;
            default:
               nVfx = VFX_COM_CHUNK_STONE_SMALL;
               break;
         }
         effect eVis = EffectVisualEffect(nVfx);
         float fDistance = GetDistanceBetween(oTarget, oAimer);
         //debugVarFloat("distance from " + GetName(oTarget), fDistance);
         //debugVarFloat("fDamageRadius", fDamageRadius);
         //debugVarInt("raw damage", nDamage);
         nDamage = FloatToInt(nDamage * (fDamageRadius - fDistance) /
            (fDamageRadius + 0.01));
         //debugVarInt("ranged damage", nDamage);
         // Apply the VFX impact and effects
         if (nDamage > 0)
         {
            effect eDam = EffectDamage(nDamage, nDamageType);
            float fDelay = GetDistanceBetweenLocations(lTarget,
               GetLocation(oSiegeEngine)) / 15;
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,
               oTarget));
            //debugVarInt("damage to " + GetName(oTarget), nDamage);
            DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,
               eVis, oTarget));
         }
      }

      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fDamageRadius, lTarget,
         FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
   }
}

//void main() {} // testing/compiling purposes
