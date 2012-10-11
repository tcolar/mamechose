
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** NeverPlayedRomList
**
class NeverPlayedRomList : DynamicRomList
{
  new make(FileRomList played) : super("Never Played")
  {
    RomHelper.allRoms.roms.keys.each
    {
      if(! played.roms.contains(it))
        roms.add(it)
    }
  }
}