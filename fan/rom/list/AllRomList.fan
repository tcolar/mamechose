
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** AllRomsList
**
class AllRomList : DynamicRomList
{
  new make() : super("All") {}
  
  override Str[] filteredCopy(RomListFilter filter)
  {
    if(roms.isEmpty)
      roms = RomHelper.allRoms.roms.keys
      
    return super.filteredCopy(filter)
  }
}