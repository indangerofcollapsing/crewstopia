#include "horse_include"

void main ()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();

    GPA_OnActivate(oPC,oItem);
}
