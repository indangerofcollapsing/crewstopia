// On Death event for respawnable placeable, made of wood
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_wood_rs", OBJECT_SELF);
   location lSelf = GetLocation(OBJECT_SELF);
   string sResRef;
   int nItems;
   for (nItems = d4() - 2; nItems > 0; nItems--)
   {
      switch (d12())
      {
         case 1:
            sResRef = "x2_it_cmat_elmw"; // Plank of Elm Wood
            break;
         case 2:
            sResRef = "x2_it_cmat_oakw"; // Plank of Oak Wood
            break;
         case 3:
            sResRef = "dac_wblcl001"; // Makeshift Club
            break;
         case 4:
            sResRef = "dac_dagger001"; // Sharpened Stick
            break;
         case 5:
            sResRef = "dac_wblcl002"; // Makeshift Heavy Club
            break;
         case 6:
            sResRef = "nw_it_msmlmisc18"; // Ironwood
            break;
         case 7:
            sResRef = "nw_wblcl001"; // Club
            break;
         case 8:
            sResRef = "x2_it_cmat_ironw"; // Ironwood Planks
            break;
         case 9:
            sResRef = "dac_it_torch001"; // Makeshift Torch
            break;
         case 10:
            sResRef = "nw_it_torch001"; // Torch
            break;
         case 11:
            sResRef = "x2_it_amt_iband"; // Iron Bands
            break;
         case 12:
            sResRef = "x2_it_amt_spikes"; // Iron Spikes
            break;
      }
      CreateObject(OBJECT_TYPE_ITEM, sResRef, lSelf, TRUE);
   }

   respawnPlaceable();
}

