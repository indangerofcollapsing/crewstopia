/*

    Marker script for PRC Companion for:
        PRC
        CEP2
        
    This script is called "HakMarker" and when run
    sets certain local variables on the module.
    These variables can be tested against later
    and resolved appropriately
*/

void main()
{
    object oMod = GetModule();
    SetLocalInt(oMod, "Marker_PRC", TRUE);
    SetLocalInt(oMod, "Marker_CEP2", TRUE);
}