/*
 * FeatMenu.java
 *
 * Created on March 16, 2003, 11:57 PM
 */

package CharacterCreator;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.EtchedBorder;
import CharacterCreator.WordWrap;
import CharacterCreator.defs.*;
import CharacterCreator.util.*;
/**
 *
 * @author  James
 */
public class FeatMenu extends javax.swing.JFrame implements ActionListener {

   // Call back for FeatButton
   public void actionPerformed(ActionEvent evt) {
      Feat feat = ((FeatButton.InternalFeatButton)evt.getSource()).Feat();
      int index = featlist.indexOf(feat);
      int featsleft = Integer.parseInt(FeatRemainingText.getText());

      if (index == -1) {
         featlist.add(feat);
         --featsleft;
      }
      else {
         featlist.remove(index);
         ++featsleft;
      }

      FeatRemainingText.setText(Integer.toString(featsleft));
      RefreshFeatAvailable();
      RefreshFeatSelected();
   }

    /** Creates new form FeatMenu */
    public FeatMenu() {
        int i;
        initComponents();

        menucreate = TLKFactory.getCreateMenu();

        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        if ( (screenSize.getWidth() > getContentPane().getWidth()) && (screenSize.getHeight() > getContentPane().getHeight())) {
            int intwidth = new Double(((screenSize.getWidth()-getContentPane().getWidth())/2)).intValue();
            int intheight = new Double(((screenSize.getHeight()-getContentPane().getHeight())/2)).intValue();
            setLocation(intwidth, intheight);
        } else {
            setLocation(0,0);
        }

        featlist = new ArrayList();
        ccskill = new ArrayList();
        startfeatlist = new ArrayList();
        availclassfeatlist = new ArrayList();
        bonusfeatlist = new ArrayList();

        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
      featmap = FeatMap.GetFeatMap();
      skillmap = SkillMap.GetSkillMap();

        //Initialize values for the Class and Race feats -> Featlist
        int classn = Integer.parseInt(menucreate.MainCharDataAux[3][0]);
        String attack2da = menucreate.MainCharDataAux[3][classes.AttackBonusTable];
        String racefeat2da = menucreate.MainCharDataAux[1][racialtypes.FeatsTable];
        String classfeat2da = menucreate.MainCharDataAux[3][classes.FeatsTable];
        String classskill2da = menucreate.MainCharDataAux[3][classes.SkillsTable];
        String bonusfeat2da = menucreate.MainCharDataAux[3][classes.BonusFeatsTable];
      String SpellGainTable = menucreate.MainCharDataAux[3][classes.SpellGainTable];
        try {
            attackmap = RESFAC.getResourceAs2DA(attack2da);
            classskill2damap = RESFAC.getResourceAs2DA(classskill2da);
            if(racefeat2da != null)
                racefeat2damap = RESFAC.getResourceAs2DA(racefeat2da);
            if(classfeat2da != null)
                classfeat2damap = RESFAC.getResourceAs2DA(classfeat2da);
            if(bonusfeat2da != null)
                bonusfeat2damap = RESFAC.getResourceAs2DA(bonusfeat2da);
         if (SpellGainTable != null)
            spellgain2damap = RESFAC.getResourceAs2DA(SpellGainTable);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + attack2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }

      // Scan the class feat file
        for(i = 0; i < classfeat2damap.length; i++) {
            if(classfeat2damap[i][clsfeat.FeatIndex] != null
               && classfeat2damap[i][clsfeat.List] != null
               && classfeat2damap[i][clsfeat.GrantedOnLevel] != null) {

            // Extract the numbers
            int list = Integer.parseInt(classfeat2damap[i][clsfeat.List]);
            int granted = Integer.parseInt(classfeat2damap[i][clsfeat.GrantedOnLevel]);
            Feat feat = featmap[Integer.parseInt(classfeat2damap[i][clsfeat.FeatIndex])];

            if (granted <= 1) {
               // Feats that are granted at a given level
               if (list == 3) {
                  featlist.add(feat);
                  startfeatlist.add(feat);
               }

               // These can be taken as bonus feats
               if (list == 1 || list == 2)
                  bonusfeatlist.add(feat);

               // These feats can be taken
               if (list == 0 || list == 1)
                  availclassfeatlist.add(feat);
            }
         }
        }

        for(i = 0; i < racefeat2damap.length; i++) {
            if(racefeat2damap[i][racefeat.FeatIndex] != null) {
            Feat feat = featmap[Integer.parseInt(racefeat2damap[i][racefeat.FeatIndex])];
                featlist.add(feat);
                startfeatlist.add(feat);
            }
        }

        for(i = 0; i < skillmap.length; i++) {
            ccskill.add(null);
        }
        for(i = 0; i < classskill2damap.length; i++) {
            if(classskill2damap[i][clsskill.SkillIndex] != null) {
                int skillchange = Integer.parseInt(classskill2damap[i][clsskill.SkillIndex]);
                String tmpstr = classskill2damap[i][clsskill.ClassSkill];
                int clssk;
                if(tmpstr == null) {
                    clssk = 0;
                } else {
                    clssk = Integer.parseInt(tmpstr);
                }
                ccskill.set(skillchange, (new Integer(clssk)));
            }
        }

        numfeats = 1;
      // Adjust the number of feats based on
      // Quick to Master (humans) and bonus feats for classes
        if(featlist.contains(featmap[258]))
            numfeats++;

      // This is tricky, if the class getsa bonus feat, we need to carefully select
      // our behavior
        //if(bonusfeat2damap != null && bonusfeat2damap[0][1] != null)
         //   numfeats += Integer.parseInt(bonusfeat2damap[0][1]);

        FeatRemainingText.setText(Integer.toString(numfeats));
        RefreshFeatAvailable();
        RefreshFeatSelected();

        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));

        pack();
    }

    private void RefreshFeatSelected() {
        FeatSelectedButtonList.removeAll();
      for(int i = 0; i < featlist.size(); i++) {
         Feat feat = (Feat)featlist.get(i);
         FeatSelectedButtonList.add(
               new FeatButton(feat,
               !startfeatlist.contains(feat),
               this),
               -1
            );
      }

        pack();
    }

   // Iterate through each feat and select the availables ones
    private void RefreshFeatAvailable() {
        FeatAvailableButtonList.removeAll();

      // If we have feat slots available, regenerate the current list
        if (Integer.parseInt(FeatRemainingText.getText()) > 0) {
         ArrayList al = new ArrayList();
         Feat[] nonClassFeats = FeatMap.GetNonClassFeats();

         for(int ii = 0; ii < nonClassFeats.length; ii++)
            if (isValidFeat(nonClassFeats[ii]))
               al.add(nonClassFeats[ii]);
         for(int ii = 0; ii < availclassfeatlist.size(); ii++)
            if (!al.contains(availclassfeatlist.get(ii)) && isValidFeat((Feat)availclassfeatlist.get(ii)))
               al.add(availclassfeatlist.get(ii));

         Collections.sort(al);
         for (int ii=0; ii < al.size(); ++ii)
            FeatAvailableButtonList.add(new FeatButton((Feat)al.get(ii), true, this), -1);
      }

        pack();
    }

   private int calcSkill(int skillnum) {
      // Skill is unknown and requires training
      int retval = -1;

      // Is this skill known?  If so return the amount.
      if(menucreate.MainCharData[8] != null) {
         Integer skill = new Integer(skillnum);
         skill = (Integer)menucreate.MainCharData[8].get(skill);
         if (skill.intValue() > 0)
            retval = skill.intValue();
      }

      // Skill doesn't require training so we get 0 as a default value
      if (retval < 0 && skillmap[skillnum].Untrained)
         retval = 0;

      return retval;
   }

    private boolean isValidFeat(Feat feat) {
      // Test that this feat is valid
      if (feat == null)
         return false;

      // Debug variable
        boolean extra = false;

        //If you have no feats available, then we're shutting down
        if (Integer.parseInt(FeatRemainingText.getText()) == 0) {
            if (extra)
            System.out.println("All available Feat slots are filled: " + feat.Feat);

            return false;
        }

        //If you already HAVE the feat, then you don't need it again
        if (featlist.contains(feat)) {
            if (extra)
            System.out.println("Feat is already taken: " + feat.Feat);

            return false;
        }

      // Thirdly, remove all non-global feats not listed in the class file
      if (!feat.AllClassesCanUse && !availclassfeatlist.contains(feat)) {
         if (extra)
            System.out.println("Feat isn't available to this class: " + feat.Feat);

         return false;
      }

      return CheckFeatRequirements(feat);
    }

   private boolean CheckFeatRequirements(Feat feat) {
      // Test that this feat is valid
      if (feat == null)
         return false;

      boolean extra = false;

      // Verify we satisfy the min level requirement
      if (feat.MinLevel > 1) {
         if (extra)
            System.out.println("Feat feat requirements aren't satisfied: " + feat.Feat);

         return false;
      }

      // Verify we satisfy the min level class requirement
      // W
      if (feat.MinLevel > 0 && feat.MinLevelClass > -1
            && Integer.parseInt(menucreate.MainCharDataAux[3][classes.Index]) != feat.MinLevelClass) {
         if (extra)
            System.out.println("Feat feat requirements aren't satisfied: " + feat.Feat);

         return false;
      }

      // Next we check to see if we satisfy the one _or_ the other requirements
      int[] altreq = new int[5];
      altreq[0] = feat.OrReqFeat0;
      altreq[1] = feat.OrReqFeat1;
      altreq[2] = feat.OrReqFeat2;
      altreq[3] = feat.OrReqFeat3;
      altreq[4] = feat.OrReqFeat4;

      boolean required = false;
      boolean satisfied = false;
      for (int ii = 0; ii < altreq.length; ++ii) {
         if (altreq[ii] > -1) {
            required = true;
            satisfied = satisfied || featlist.contains(featmap[altreq[ii]]);
         }
      }
      if (required && !satisfied) {
         if (extra)
            System.out.println("Feat feat requirements aren't satisfied: " + feat.Feat);

         return false;
      }

      // Verify any required skills
      if (feat.ReqSkill > -1) {
         // If this char doesn't have access to the skill
         if (calcSkill(feat.ReqSkill) < feat.ReqSkillMinRanks) {
            if (extra)
               System.out.println("Feat skill requirements aren't satisfied: " + feat.Feat);

            return false;
         }
      }
      // Verify any required skills
      if (feat.ReqSkill2 > -1) {
         // If this char doesn't have access to the skill
         if (calcSkill(feat.ReqSkill2) < feat.ReqSkillMinRanks2) {
            if (extra)
               System.out.println("Feat skill requirements aren't satisfied: " + feat.Feat);

            return false;
         }
      }

      // Determine if the Mandatory Feat Prerequisites are satisfied
      if (feat.PreReqFeat1 > -1 && !featlist.contains(featmap[feat.PreReqFeat1])) {
         if (extra)
            System.out.println("Feat feat requirements weren't satisfied: " + feat.Feat);

         return false;
      }
      if (feat.PreReqFeat2 > -1 && !featlist.contains(featmap[feat.PreReqFeat2])) {
         if (extra)
            System.out.println("Feat feat requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // This is ugly, but I don't feel like trying to make this prettier.  I already wanna nix it.
        int realstr = new Integer(((String)menucreate.MainCharData[5].get(new Integer(0)))).intValue();
        int realdex = new Integer(((String)menucreate.MainCharData[5].get(new Integer(1)))).intValue();
        int realcon = new Integer(((String)menucreate.MainCharData[5].get(new Integer(2)))).intValue();
        int realint = new Integer(((String)menucreate.MainCharData[5].get(new Integer(3)))).intValue();
        int realwis = new Integer(((String)menucreate.MainCharData[5].get(new Integer(4)))).intValue();
        int realcha = new Integer(((String)menucreate.MainCharData[5].get(new Integer(5)))).intValue();

      // Check Str Requirements
      if (realstr < feat.MinStr) {
         if (extra)
            System.out.println("Feat STR requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check Dex Requirements
      if (realdex < feat.MinDex) {
         if (extra)
            System.out.println("Feat DEX requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check Con Requirements
      if (realcon < feat.MinCon) {
         if (extra)
            System.out.println("Feat CON requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check Int Requirements
      if (realint < feat.MinInt) {
         if (extra)
            System.out.println("Feat INT requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check Wis Requirements
      if (realwis < feat.MinWis) {
         if (extra)
            System.out.println("Feat WIS requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check Cha Requirements
      if (realcha < feat.MinCha) {
         if (extra)
            System.out.println("Feat CHA requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check for attack bonus
      int attackBonus = (attackmap == null || attackmap[0][1] == null)
            ? 0 : Integer.parseInt(attackmap[0][1]);
      if (attackBonus < feat.MinAttackBonus) {
         if (extra)
            System.out.println("Feat Attack Bonus requirements weren't satisfied: " + feat.Feat);

         return false;
      }

      // Check for Fortitude save
        //If it requires a base fortitude save, you can't start with it, all of them are too high
        //Yes, this is a workaround - otherwise, we'd need to query the saves, and that's extra time
        if (feat.MinFortSave > 0) {
            if (extra)
            System.out.println("Feat Fortitude Save requirements weren't satisfied: " + feat.Feat);

            return false;
        }

      // Check for Epic requirement.  1st level chars aren't epic
        if (feat.PreReqEpic) {
            if (extra)
            System.out.println("Feat requires Epic Stature: " + feat.Feat);

            return false;
        }

        //If you're not a spell user, or you don't have the right spell level, then no
        if (feat.MinSpellLvl > -1) {
            if (Integer.parseInt(menucreate.MainCharDataAux[3][classes.SpellCaster]) == 0) {
                if (extra)
               System.out.println("Feat requires spell caster: " + feat.Feat);

                return false;
            }
            if (feat.MinSpellLvl > 1) {
                if (extra)
               System.out.println("Feat requires higher spell level: " + feat.Feat);

                return false;
            }
         int spells = 0;
         if (feat.MinSpellLvl == 1) {
            // Read the given line of the spell progression table
            if (spellgain2damap != null && spellgain2damap[0][4] != null) {
               spells = Integer.parseInt(spellgain2damap[0][4]);
               if (spells == 0) {
                  if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("WIS") && realwis >= 12)
                     ++spells;
                  else if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("INT") && realint >= 12)
                     ++spells;
                  else if (menucreate.MainCharDataAux[3][classes.PrimaryAbil].equalsIgnoreCase("CHA") && realcha >= 12)
                     ++spells;
               }
            }
         }
         else if (feat.MinSpellLvl == 0) {
            // Read the given line of the spell progression table
            if (spellgain2damap != null && spellgain2damap[0][3] != null)
               spells = Integer.parseInt(spellgain2damap[0][3]);
         }

         if (spells == 0) {
                if (extra)
               System.out.println("Feat requires spell casting abilities: " + feat.Feat);

                return false;
         }
        }

        return true;
   }

    private void DoRecommended() {
        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));

        DoReset();
        String featpref2da = menucreate.MainCharDataAux[7][packages.FeatPref2DA];
        String[][] featpref2damap = null;
        try {
            if(featpref2da != null)
                featpref2damap = RESFAC.getResourceAs2DA(featpref2da);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + featpref2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        int i;
        int featposition = 0;
        for(i = 0; i < numfeats; i++) {
            //Uh, check to see if the feat is valid for this character - DUH
            int featnum = Integer.parseInt(featpref2damap[featposition][1]);
            if(featmap[featnum] != null && isValidFeat(featmap[featnum])) {
                featlist.add(featmap[Integer.parseInt(featpref2damap[featposition++][1])]);
            } else {
                featposition++;
                i--;
            }
        }
        FeatRemainingText.setText("0");
        RefreshFeatAvailable();
        RefreshFeatSelected();

        setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
    }

    private void DoReset() {
        featlist = new ArrayList();
        startfeatlist = new ArrayList();
        int i;
        for(i = 0; i < classfeat2damap.length; i++) {
            if(classfeat2damap[i][4] != null) {
                if(classfeat2damap[i][4].equalsIgnoreCase("1")) {
               Feat feat = featmap[Integer.parseInt(classfeat2damap[i][2])];
                    featlist.add(feat);
                    startfeatlist.add(feat);
                }
            }
        }
        for(i = 0; i < racefeat2damap.length; i++) {
            if(racefeat2damap[i][2] != null) {
            Feat feat = featmap[Integer.parseInt(racefeat2damap[i][2])];
                featlist.add(feat);
                startfeatlist.add(feat);
            }
        }
        FeatRemainingText.setText(Integer.toString(numfeats));
        RefreshFeatAvailable();
        RefreshFeatSelected();
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        java.awt.GridBagConstraints gridBagConstraints;

        FeatButtonContainer = new javax.swing.JScrollPane();
        FeatButtonBak = new javax.swing.JPanel();
        FeatSelectedButtonList = new javax.swing.JPanel();
        FeatButtonContainer1 = new javax.swing.JScrollPane();
        FeatButtonBak1 = new javax.swing.JPanel();
        FeatAvailableButtonList = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel11 = new javax.swing.JPanel();
        jPanel12 = new javax.swing.JPanel();
        jPanel13 = new javax.swing.JPanel();
        FeatAvailableLabel = new javax.swing.JLabel();
        FeatSelectedTable = new javax.swing.JLabel();
        FeatRemainingText = new javax.swing.JTextField();
        FeatRemainingLabel = new javax.swing.JLabel();
        RecommendedButton = new javax.swing.JButton();
        ResetButton = new javax.swing.JButton();
        OKButton = new javax.swing.JButton();
        CancelButton = new javax.swing.JButton();

        getContentPane().setLayout(new java.awt.GridBagLayout());
      setTitle("Feat Menu");
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }
        });

        FeatButtonContainer.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        FeatButtonContainer.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        FeatButtonContainer.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        FeatButtonContainer.setMaximumSize(new java.awt.Dimension(32767, 300));
        FeatButtonContainer.setPreferredSize(new java.awt.Dimension(373, 300));
        FeatButtonContainer.setAutoscrolls(true);
      FeatButtonContainer.getVerticalScrollBar().setUnitIncrement(52);
      FeatButtonContainer.getVerticalScrollBar().setBlockIncrement(52);
        FeatButtonBak.setLayout(new java.awt.GridBagLayout());

        FeatButtonBak.setBackground(new java.awt.Color(0, 0, 0));
        FeatButtonBak.setForeground(new java.awt.Color(255, 255, 255));
        FeatButtonBak.setAlignmentX(0.0F);
        FeatButtonBak.setAlignmentY(0.0F);
        FeatButtonBak.setAutoscrolls(true);
        FeatSelectedButtonList.setLayout(new java.awt.GridLayout(0, 1));

        FeatSelectedButtonList.setBackground(new java.awt.Color(0, 0, 0));
        FeatSelectedButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        FeatButtonBak.add(FeatSelectedButtonList, gridBagConstraints);

        FeatButtonContainer.setViewportView(FeatButtonBak);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.gridheight = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(FeatButtonContainer, gridBagConstraints);

        FeatButtonContainer1.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        FeatButtonContainer1.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        FeatButtonContainer1.setViewportBorder(new javax.swing.border.MatteBorder(new java.awt.Insets(10, 10, 10, 10), new java.awt.Color(0, 0, 0)));
        FeatButtonContainer1.setMaximumSize(new java.awt.Dimension(32767, 300));
        FeatButtonContainer1.setPreferredSize(new java.awt.Dimension(373, 300));
        FeatButtonContainer1.setAutoscrolls(true);
      FeatButtonContainer1.getVerticalScrollBar().setUnitIncrement(52);
      FeatButtonContainer1.getVerticalScrollBar().setBlockIncrement(52);

        FeatButtonBak1.setLayout(new java.awt.GridBagLayout());

        FeatButtonBak1.setBackground(new java.awt.Color(0, 0, 0));
        FeatButtonBak1.setForeground(new java.awt.Color(255, 255, 255));
        FeatButtonBak1.setAlignmentX(0.0F);
        FeatButtonBak1.setAlignmentY(0.0F);
        FeatButtonBak1.setAutoscrolls(true);
        FeatAvailableButtonList.setLayout(new java.awt.GridLayout(0, 1));

        FeatAvailableButtonList.setBackground(new java.awt.Color(0, 0, 0));
        FeatAvailableButtonList.setBorder(new javax.swing.border.EmptyBorder(new java.awt.Insets(3, 3, 3, 3)));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.gridwidth = 2;
        gridBagConstraints.gridheight = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        FeatButtonBak1.add(FeatAvailableButtonList, gridBagConstraints);

        FeatButtonContainer1.setViewportView(FeatButtonBak1);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.gridheight = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        getContentPane().add(FeatButtonContainer1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel1, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 7;
        getContentPane().add(jPanel2, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        getContentPane().add(jPanel11, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel12, gridBagConstraints);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 4;
        gridBagConstraints.gridy = 0;
        getContentPane().add(jPanel13, gridBagConstraints);

        FeatAvailableLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FeatAvailableLabel.setText("Feats Available");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(FeatAvailableLabel, gridBagConstraints);

        FeatSelectedTable.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FeatSelectedTable.setText("Feats Selected");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(FeatSelectedTable, gridBagConstraints);

        FeatRemainingText.setEditable(false);
        FeatRemainingText.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FeatRemainingText.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        FeatRemainingText.setText("0");
        FeatRemainingText.setBorder(null);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.VERTICAL;
        gridBagConstraints.ipadx = 10;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(FeatRemainingText, gridBagConstraints);

        FeatRemainingLabel.setFont(new java.awt.Font("Trebuchet MS", 0, 10));
        FeatRemainingLabel.setText("Feats Remaining");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        gridBagConstraints.insets = new java.awt.Insets(0, 0, 0, 25);
        getContentPane().add(FeatRemainingLabel, gridBagConstraints);

        RecommendedButton.setText("Recommended");
        RecommendedButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RecommendedButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(RecommendedButton, gridBagConstraints);

        ResetButton.setText("Reset");
        ResetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ResetButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(ResetButton, gridBagConstraints);

        OKButton.setText("OK");
        OKButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                OKButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        getContentPane().add(OKButton, gridBagConstraints);

        CancelButton.setText("Cancel");
        CancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                CancelButtonActionPerformed(evt);
            }
        });

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 3;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.EAST;
        getContentPane().add(CancelButton, gridBagConstraints);

        pack();
    }//GEN-END:initComponents

    private void CancelButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_CancelButtonActionPerformed
        // Add your handling code here:
        setVisible(false);
        dispose();
    }//GEN-LAST:event_CancelButtonActionPerformed

    private void OKButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_OKButtonActionPerformed
        // Add your handling code here:
        if(new Integer(FeatRemainingText.getText()).intValue() > 0) {
            DoRecommended();
        }
        menucreate.MainCharData[9] = new HashMap();
        menucreate.MainCharData[9].put(new Integer(0),new Integer(featlist.size()));
        for(int i = 0; i < featlist.size(); i++) {
            if (featlist != null && featlist.get(i) != null) { // @DUG
               menucreate.MainCharData[9].put(new Integer(i+1),((Feat)featlist.get(i)).Index());
            }
            else // @DUG
            {
               System.err.println("*** Bad featlist in FeatMenu.");
               System.err.println("    featlist = " + featlist);
               System.err.println("    featlist.get(" + i + ") = " +
                  featlist.get(i));
            }
        }



        menucreate.MainCharData[16] = new HashMap();
        menucreate.RedoAll();
        //RANGER CLASS

        if(bonusfeat2damap != null && bonusfeat2damap[0][1] != null
            && Integer.parseInt(bonusfeat2damap[0][1]) > 0) {
            //numfeats += Integer.parseInt(bonusfeat2damap[0][1]);

        //if(Integer.parseInt(menucreate.MainCharDataAux[3][0]) == 7) {

         ArrayList al = new ArrayList();
         for (int ii=0; ii<bonusfeatlist.size(); ++ii) {
            Feat feat = (Feat)bonusfeatlist.get(ii);
            if (!featlist.contains(feat) && CheckFeatRequirements(feat))
               al.add(feat);
         }

            (new BonusFeatMenu(al, Integer.parseInt(bonusfeat2damap[0][1]))).show();
            setVisible(false);
            dispose();
            return;
        }

        //Put handling code here to check to see what menu goes next.
        //First of all, determine whether or not the character is a spellcaster AT ALL.
        if(menucreate.MainCharDataAux[3][classes.SpellCaster].equalsIgnoreCase("1")) {
            //You ARE a spell caster. Arcane or divine?
            if(menucreate.MainCharDataAux[7][packages.School] != null) {
                //ARCANE = true
                //Can you specialize?
                //System.out.println("Data in 7:6: " + menucreate.MainCharDataAux[3][classes.SpellKnownTable]);
                if(menucreate.MainCharDataAux[3][classes.SpellKnownTable] == null) {
                    //Yes. Wizard class.
                    (new SchoolMenu()).show();
                    setVisible(false);
                    dispose();
                    return;
                } else {
                    //No. Other caster
                    (new SpellMenu()).show();
                    setVisible(false);
                    dispose();
                    return;
                }
            } else {
                //DIVINE = true
                //Do you have 2 domains?
                if(menucreate.MainCharDataAux[7][packages.Domain1] != null
                  || menucreate.MainCharDataAux[7][packages.Domain2] != null) {
                    (new DomainMenu()).show();
                    setVisible(false);
                    dispose();
                    return;
                }
                //You are not a cleric type, so you don't care about domains
                //You have all clerical spells, or spells for your class
            }
        }
        //Spellcaster = false
        menucreate.MainCharData[14] = new HashMap();
        //Animal companion
        if(featlist.contains(featmap[199]) && !featlist.contains(featmap[303])) {
            (new CompanionMenu()).show();
            setVisible(false);
            dispose();
            return;
        }
        //Familiar
        if(featlist.contains(featmap[303]) && !featlist.contains(featmap[199])) {
            (new FamiliarMenu()).show();
            setVisible(false);
            dispose();
            return;
        }
        //BOTH
        if(featlist.contains(featmap[303]) && featlist.contains(featmap[199])) {
            //Companion first
            (new CompanionMenu()).show();
            setVisible(false);
            dispose();
            return;
        }
        menucreate.CustomizeButton.setEnabled(true);

        setVisible(false);
        dispose();

    }//GEN-LAST:event_OKButtonActionPerformed

    private void RecommendedButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RecommendedButtonActionPerformed
        // Add your handling code here:
        DoRecommended();
    }//GEN-LAST:event_RecommendedButtonActionPerformed

    private void ResetButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ResetButtonActionPerformed
        // Add your handling code here:
        DoReset();
    }//GEN-LAST:event_ResetButtonActionPerformed

    /** Exit the Application */
    private void exitForm(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_exitForm
        setVisible(false);
        dispose();
    }//GEN-LAST:event_exitForm


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel jPanel13;
    private javax.swing.JScrollPane FeatButtonContainer;
    private javax.swing.JPanel FeatAvailableButtonList;
    private javax.swing.JPanel FeatButtonBak1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel FeatButtonBak;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JLabel FeatSelectedTable;
    private javax.swing.JButton OKButton;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel FeatSelectedButtonList;
    private javax.swing.JButton CancelButton;
    private javax.swing.JButton RecommendedButton;
    private javax.swing.JLabel FeatRemainingLabel;
    private javax.swing.JButton ResetButton;
    private javax.swing.JScrollPane FeatButtonContainer1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField FeatRemainingText;
    private javax.swing.JLabel FeatAvailableLabel;
    // End of variables declaration//GEN-END:variables
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private Feat[] featmap;
    private Skill[] skillmap;
    private String[][] attackmap;
    private String[][] racefeat2damap;
    private String[][] classfeat2damap;
    private String[][] classskill2damap;
   private String[][] bonusfeat2damap;
   private String[][] spellgain2damap;
    private CreateMenu menucreate;
    private ArrayList ccskill;

    private ArrayList featlist;
    private ArrayList startfeatlist; // Feat
    private ArrayList availclassfeatlist; // Feat
   private ArrayList bonusfeatlist; // Feat
    private int numfeats;
}
