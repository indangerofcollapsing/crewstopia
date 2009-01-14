// Could take level 1 in Weapon Master
int StartingConditional()
{
  if (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)>0) return FALSE;
  else if (GetBaseAttackBonus(OBJECT_SELF)<5) return FALSE;
  else if (GetSkillRank(SKILL_INTIMIDATE)<4) return FALSE;
  else if (!GetHasFeat(FEAT_DODGE)) return FALSE;
  else if (!GetHasFeat(FEAT_MOBILITY)) return FALSE;
  else if (!GetHasFeat(FEAT_EXPERTISE)) return FALSE;
  else if (!GetHasFeat(FEAT_SPRING_ATTACK)) return FALSE;
  else if (!GetHasFeat(FEAT_WHIRLWIND_ATTACK)) return FALSE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER)) return TRUE;
  else if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP)) return TRUE;
  else return FALSE;
}

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole modified    //
// or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

