Note that the PrC Pack (as of 3.3b1 at least) includes the following overrides to Bioware event scripts:

nw_c2_default9.nss   On-Spawn event for MOBs
nw_c2_defaultd.nss   On-User-Defined event for MOBs
nw_ch_ac1.nss        On-Heartbeat event for Henchmen
nw_ch_ac9.nss        On-Spawn event for Henchmen
nw_ch_acd.nss        On-User-Defined event for Henchmen

If your module needs to modify these events, you *must* remove these scripts (and their compiled versions) from the PrC Hakpack (prc_scripts.hak) as well as any override Hakpacks you have added on top of it.