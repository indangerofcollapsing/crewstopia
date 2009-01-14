SELECT p.description AS palette
     , i.name
     , i.cost
  FROM nwn_palettes p
     , nwn_items i
 WHERE p.id NOT IN (0,1,2,3,4,13,14,55,56,59,63,99,118)
   AND p.palette_type IN ("I")
   AND p.id = i.palette_id
   AND i.cost BETWEEN 0 AND 100
 ORDER BY p.description ASC, i.name ASC;
