
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** DynamicRomList
** "Transient" Dynamic rom list (calculated)
**
abstract class DynamicRomList : RomList
{
  override Str name
  override Str[] roms := [,]
  
  new make(Str name) 
  {
    this.name = name
  }  
}