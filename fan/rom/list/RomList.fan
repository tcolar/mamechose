
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** RomList
** A named list of roms
**
mixin RomList
{
  abstract Str[] roms
  abstract Str name
  
  virtual Str[] filteredCopy(RomListFilter filter)
  {
    return filter.filterList(roms)
  }
}