/* $Source$$Revision$$Date$ */

/*****************************************************************************
 * Demon True Name Generator
 * <p>
 * Copyright 2004 Douglas Crews </p>
 * @version $Revision$$Date$
 * @author Douglas Crews
 */
public class DemonTrueNameGenerator
{

// ------------------------ data members ------------------------

   // ------------------- static variables ----------------------

   static final String firstLetters =
      "€£¥§ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖØÙÚÛÜİßQAZXSWTGBYHKP";
   static final String allLetters =
      "€¡¢£¤¥§ª²°µ¹º»¿ÅÆÇÊÏĞÑÒÓÔÕÖ×ØÛİŞßàáâãäåæçèéêëìíîïğñòóõôöøùúûüışÿaxzsqecthviou!~";
   static final int numFirst = firstLetters.length();
   static final int numAll = allLetters.length();

   // ------------------ instance variables ---------------------

// ----------------------- public methods -----------------------

// constructors

// accessors/mutators (get & set)

// public, static methods

   public static void main(String[] args)
      throws Exception
   {
//      System.out.println("allLetters = " + allLetters);
      int nameSize = ((int)(Math.random() * 20)) + 10;
//      System.out.println("size = " + nameSize);
      StringBuffer sb = new StringBuffer(nameSize);
      sb.append(firstLetters.charAt((int)(Math.random() * numFirst)));
      for (int ii = 1; ii < nameSize; ii++)
      {
         sb.append(allLetters.charAt((int)(Math.random() * numAll)));
      }

      System.out.println(sb.toString());
   } // main(String[])

// public, overriding methods

// public, class-specific methods

// ---------------------- protected methods ---------------------

// ----------------------- private methods ----------------------

// ----------------------- private classes ----------------------

} // class DemonTrueNameGenerator
