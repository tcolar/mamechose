
//
// History:
//   Oct 2, 2012 tcolar Creation
//

**
** RomHelper
**
class RomHelper
{
  static Str countInfo(Str:Rom roms)
  {
    Int total := roms.size
    Int installed := 0
    Int invalid := 0
    roms.vals.each | rom |
    {
      if(rom.installed!=null && rom.installed)
        installed ++
      if(rom.verified != null && rom.verified == false)
        invalid ++
    }
    return "Total roms: ${total}. Installed: $installed ($invalid invalid)"
  }
}