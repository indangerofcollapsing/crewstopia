package CharacterCreator;

import CharacterCreator.util.ChkHex;
import java.io.IOException;
import javax.swing.ImageIcon;
import java.lang.Comparable;

public class Feat implements Comparable {

   public String toString()
   {
      return "Feat:{" +
         "Index=" + Index + ";" +
         "Feat=" + Feat + ";" +
         "Description=" + Description + ";" +
         "iconName=" + iconName + ";" +
         "MinAttackBonus=" + MinAttackBonus + ";" +
         "MinStr=" + MinStr + ";" +
         "MinDex=" + MinDex + ";" +
         "MinInt=" + MinInt + ";" +
         "MinWis=" + MinWis + ";" +
         "MinCon=" + MinCon + ";" +
         "MinCha=" + MinCha + ";" +
         "MinSpellLvl=" + MinSpellLvl + ";" +
         "PreReqFeat1=" + PreReqFeat1 + ";" +
         "PreReqFeat2=" + PreReqFeat2 + ";" +
         "AllClassesCanUse=" + AllClassesCanUse + ";" +
         "MasterFeat=" + MasterFeat + ";" +
         "OrReqFeat0=" + OrReqFeat0 + ";" +
         "OrReqFeat1=" + OrReqFeat1 + ";" +
         "OrReqFeat2=" + OrReqFeat2 + ";" +
         "OrReqFeat3=" + OrReqFeat3 + ";" +
         "OrReqFeat4=" + OrReqFeat4 + ";" +
         "ReqSkill=" + ReqSkill + ";" +
         "ReqSkillMinRanks=" + ReqSkillMinRanks + ";" +
         "ReqSkill2=" + ReqSkill2 + ";" +
         "ReqSkillMinRanks2=" + ReqSkillMinRanks2 + ";" +
         "MinLevel=" + MinLevel + ";" +
         "MinLevelClass=" + MinLevelClass + ";" +
         "MinFortSave=" + MinFortSave + ";" +
         "PreReqEpic=" + PreReqEpic + "}";
   }

   public int Index;
   public Integer IntegerIndex;
   public String Feat;
   public String Description;
   private ImageIcon icon;
   private String iconName;
   public int MinAttackBonus;
   public int MinStr;
   public int MinDex;
   public int MinInt;
   public int MinWis;
   public int MinCon;
   public int MinCha;
   public int MinSpellLvl;
   public int PreReqFeat1;
   public int PreReqFeat2;
   public boolean AllClassesCanUse;
   public int MasterFeat;
   public int OrReqFeat0;
   public int OrReqFeat1;
   public int OrReqFeat2;
   public int OrReqFeat3;
   public int OrReqFeat4;
   public int ReqSkill;
   public int ReqSkillMinRanks;
   public int ReqSkill2;
   public int ReqSkillMinRanks2;
    public int MinLevel;
    public int MinLevelClass;
   public int MinFortSave;
   public boolean PreReqEpic;

    public static int INDEX = 0;
    public static int LABEL = 1;
    public static int FEAT = 2;
    public static int DESCRIPTION = 3;
    public static int ICON = 4;
    public static int MINATTACKBONUS = 5;
    public static int MINSTR = 6;
    public static int MINDEX = 7;
    public static int MININT = 8;
    public static int MINWIS = 9;
    public static int MINCON = 10;
    public static int MINCHA = 11;
    public static int MINSPELLLEVEL = 12;
    public static int PREREQFEAT1 = 13;
    public static int PREREQFEAT2 = 14;
    public static int GAINMULTIPLE = 15;
    public static int EFFECTSSTACK = 16;
    public static int ALLCLASSESCANUSE = 17;
    public static int CATEGORY = 18;
    public static int MAXCR = 19;
    public static int SPELLID = 20;
    public static int SUCCESSOR = 21;
    public static int CRVALUE = 22;
    public static int USESPERDAY = 23;
    public static int MASTERFEAT = 24;
    public static int TARGETSELF = 25;
    public static int ORREQFEAT0 = 26;
    public static int ORREQFEAT1 = 27;
    public static int ORREQFEAT2 = 28;
    public static int ORREQFEAT3 = 29;
    public static int ORREQFEAT4 = 30;
    public static int REQSKILL = 31;
    public static int MINSKILLRANKS = 32;
    public static int REQSKILL2 = 33;
    public static int MINSKILLRANKS2 = 34;
    public static int CONSTANT = 35;
    public static int TOOLSCATEGORIES = 36;
    public static int HOSTILEFEAT = 37;
    public static int MINLEVEL = 38;
    public static int MINLEVELCLASS = 39;
    public static int MAXLEVEL = 40;
    public static int MINFORTSAVE = 41;
    public static int PREREQEPIC = 42;

   public static TLKFactory tlkFactory;
   public static ResourceFactory resFactory;

   public Integer Index() {
      if (IntegerIndex == null)
         IntegerIndex = new Integer(Index);

      return IntegerIndex;
   }

   public ImageIcon Icon() {
      if (icon == null) {
         if (iconName == null) {
            icon = new ImageIcon(
                  getClass().getResource(
                  "/CharacterCreator/resource/folder.gif")
               );
         }
         else {
            try {
               icon = resFactory.getIcon(iconName);
            }
            catch (IOException ioe) {
            }
         }
      }

      return icon;
   }

   // This should be changed to allow named column parsing
   private Feat(int index, String[] data) {
      // Use the recommended index
      Index = index;
      IntegerIndex = null;

      Feat = tlkFactory.getEntry(data[FEAT]);
      Description = tlkFactory.getEntry(data[DESCRIPTION]);

      // Store the icon name, load actual icon on demand
      iconName = (data[ICON] == null) ? null : data[ICON].toLowerCase();
      icon = null;

      MinAttackBonus = ChkHex.ChkHex(data[MINATTACKBONUS], 0);
      MinStr = ChkHex.ChkHex(data[MINSTR], 0);
      MinDex = ChkHex.ChkHex(data[MINDEX], 0);
      MinInt = ChkHex.ChkHex(data[MININT], 0);
      MinWis = ChkHex.ChkHex(data[MINWIS], 0);
      MinCon = ChkHex.ChkHex(data[MINCON], 0);
      MinCha = ChkHex.ChkHex(data[MINCHA], 0);
      MinSpellLvl = ChkHex.ChkHex(data[MINSPELLLEVEL], -1);
      PreReqFeat1 = ChkHex.ChkHex(data[PREREQFEAT1], -1);
      PreReqFeat2 = ChkHex.ChkHex(data[PREREQFEAT2], -1);
      AllClassesCanUse = (ChkHex.ChkHex(data[ALLCLASSESCANUSE]) == 1);
      MasterFeat = ChkHex.ChkHex(data[MASTERFEAT], -1);
      OrReqFeat0 = ChkHex.ChkHex(data[ORREQFEAT0], -1);
      OrReqFeat1 = ChkHex.ChkHex(data[ORREQFEAT1], -1);
      OrReqFeat2 = ChkHex.ChkHex(data[ORREQFEAT2], -1);
      OrReqFeat3 = ChkHex.ChkHex(data[ORREQFEAT3], -1);
      OrReqFeat4 = ChkHex.ChkHex(data[ORREQFEAT4], -1);
      ReqSkill = ChkHex.ChkHex(data[REQSKILL], -1);
      ReqSkillMinRanks = ChkHex.ChkHex(data[MINSKILLRANKS], 0);
      ReqSkill2 = ChkHex.ChkHex(data[REQSKILL2], -1);
      ReqSkillMinRanks2 = ChkHex.ChkHex(data[MINSKILLRANKS2], 0);
      MinLevel = ChkHex.ChkHex(data[MINLEVEL], 0);
      MinLevelClass = ChkHex.ChkHex(data[MINLEVELCLASS], -1);
      MinFortSave = ChkHex.ChkHex(data[MINFORTSAVE], 0);
      PreReqEpic = (ChkHex.ChkHex(data[PREREQEPIC]) == 1);
   }

   public static Feat ParseFeat(int index, String[] data) {
      Feat feat = null;
      if (data[FEAT] != null)
         feat = new Feat(index, data);

      return feat;
   }

   public int compareTo(Object o) {
      return (Feat.compareTo(((Feat)o).Feat));
   }

   public static void InitializeStatics(TLKFactory tlk, ResourceFactory res) {
      tlkFactory = tlk;
      resFactory = res;
   }
}
