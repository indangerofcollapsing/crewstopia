//::///////////////////////////////////////////////
//:: Name ohs_reg_sit
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   The Registrar likes his pile of books.
   He takes them with him everywhere and
   sits down on them when not in conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-11-29
//:://////////////////////////////////////////////
#include "x0_i0_position"

void main()
{
  object oBooks = GetLocalObject(OBJECT_SELF,"OHS_REG_BOOKS");
  if (GetIsObjectValid(oBooks))
  {
    if (
         GetArea(oBooks)!=GetArea(OBJECT_SELF) ||
         GetDistanceToObject(oBooks)>10.0f ||
         !LineOfSightObject(oBooks,OBJECT_SELF)
       )
    {
      // Destroy the old pile and forget about it
      DestroyObject(oBooks);
      oBooks = OBJECT_INVALID;
      SetLocalObject(OBJECT_SELF,"OHS_REG_BOOKS",OBJECT_INVALID);
    }
  }
  if (!GetIsObjectValid(oBooks))
  {
    // Create a new pile of books
    object oArea = GetArea(OBJECT_SELF);
    vector vBooks = GetPosition(OBJECT_SELF)-1.5f*AngleToVector(GetFacing(OBJECT_SELF));
    float fFacing = GetFacing(OBJECT_SELF);
    location lBooks = Location(GetArea(OBJECT_SELF),vBooks,fFacing);
    oBooks = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_bookpiles",lBooks,FALSE,"OHS_REG_BOOKS");
    SetLocalObject(OBJECT_SELF,"OHS_REG_BOOKS",oBooks);
  }
  // Now sit on the convenient pile of books
  ClearAllActions();
  ActionSit(oBooks);
}

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole modified    //
// or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

