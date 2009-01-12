package CharacterCreator;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;

public class FeatButton extends JPanel {

   public class InternalFeatButton extends JButton {

      private Feat feat;
      public Feat Feat() { return feat; }

      public InternalFeatButton(Feat _feat, boolean enabled, ActionListener al) {
try // @DUG
{
         feat = _feat;

         setBackground(new Color(0, 0, 0));
         setForeground(new Color(222, 200, 120));
         setHorizontalAlignment(2);
         setIconTextGap(15);
         setPreferredSize(new Dimension(330, 52));

         setText(feat.Feat);
         setEnabled(enabled);

         setIcon(feat.Icon());
         setDisabledIcon(feat.Icon());

         if (al != null)
            addActionListener(al);

         addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
               if (evt.getButton() == 3)
                  JOptionPane.showMessageDialog(
                        null,
                        WordWrap.wrap(feat.Description, 80),
                        feat.Feat,
                        JOptionPane.PLAIN_MESSAGE,
                        feat.Icon()
                     );
            }
         });
}
catch (NullPointerException npe)
{
   System.out.println("Invalid Feat in FeatButton.java: " + _feat);
   return;
}
      }
   }

   public FeatButton(Feat _feat, boolean enabled, ActionListener al) {
      setLayout(new GridBagLayout());
      GridBagConstraints gridBagConstraints = new GridBagConstraints();
      gridBagConstraints.fill = 2;
      add(new InternalFeatButton(_feat, enabled, al), gridBagConstraints);
   }
}
