/**
 * Populate custom attributes for the dialog.
 * Caveat emptor: No attempt is made here to break up the list
 * into small chunks for readability.
 */
void main()
{
   int nRow = 0;
   string demonTrueName = Get2DAString("fiendishwords", "TrueName", nRow);
   while (demonTrueName != "")
   {
      SetCustomToken(200 + nRow, demonTrueName);
      nRow++;
   }
}
