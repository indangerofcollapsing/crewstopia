// Buff us (the whole party)
const int nMaxCR = 99;
const int T_ENH_AREA = TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT;
const int T_PROT_AREA = TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT;
const int T_ENH_SINGLE = TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE;
const int T_PROT_SINGLE = TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE;

#include "x0_i0_talent"

void ActionSpeakTalentName(talent tTalent)
{
  int nType = GetTypeFromTalent(tTalent);
  int nId   = GetIdFromTalent(tTalent);
  int nStrRef;
  if (nType==TALENT_TYPE_SPELL)
  {
    nStrRef = StringToInt(Get2DAString("spells","Name",nId));
  }
  else if (nType==TALENT_TYPE_FEAT)
  {
    nStrRef = StringToInt(Get2DAString("feat","FEAT",nId));
  }
  else if (nType==TALENT_TYPE_SKILL)
  {
    nStrRef = StringToInt(Get2DAString("skills","Name",nId));
  }
  else nStrRef = 0;

  if (nStrRef>0) ActionSpeakStringByStrRef(nStrRef);

}

void BuffArea()
{
  talent tTalent;
  string sTalentsUsed;
  string sTalentId;
  object oPC = GetPCSpeaker();

  tTalent = GetCreatureTalentBest(T_ENH_AREA,nMaxCR);
  if (!GetIsTalentValid(tTalent)) tTalent = GetCreatureTalentBest(T_PROT_AREA,nMaxCR);

  int bUseThisTalent = TRUE;
  if (GetIsTalentValid(tTalent))
  {
    sTalentId = "~" + IntToString(GetTypeFromTalent(tTalent)) + "." + 
      IntToString(GetIdFromTalent(tTalent)) + "~";
    sTalentsUsed = GetLocalString(OBJECT_SELF, "BUFF_TALENTS_USED");
    if (FindSubString(sTalentsUsed, sTalentId) != -1) bUseThisTalent = FALSE;
  }
  
  if (bUseThisTalent)
  {
    ActionSpeakTalentName(tTalent);
    ActionUseTalentOnObject(tTalent,oPC);
    SetLocalString(OBJECT_SELF, "BUFF_TALENTS_USED", sTalentsUsed + sTalentId);
    ActionDoCommand(BuffArea());
  }
  else
  {
    DeleteLocalString(OBJECT_SELF, "BUFF_TALENTS_USED");
    ActionResumeConversation();
  }
}

void main()
{
  DeleteLocalString(OBJECT_SELF, "BUFF_TALENTS_USED");
  ActionPauseConversation();
  ActionDoCommand(BuffArea());
}
