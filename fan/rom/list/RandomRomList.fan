
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** RandomList
**
class RandomRomList : DynamicRomList
{
  Int size
  
  new make(Int size := 20) : super("Random")
  {
    this.size = size
  } 

  ** This one is a different implementaion in that it generates a new (random) list each time it's called
  override Str[] filteredCopy(RomListFilter filter)
  {
    roms.clear
    list := filter.filterList(RomHelper.allRoms.roms.keys, false) // random is never sorted
    if(list.size == 0)
      return roms
    (0 ..< size).each
    {
      roms.add(list[Int.random(0 ..< list.size)])
    }
    
    return roms
  }  
}