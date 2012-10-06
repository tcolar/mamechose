//
// History:
//   Oct 2, 2012 tcolar Creation
//
using gfx

**
** RomHelper
**
class RomHelper
{
  static const Config? config := Service.find(Config#) as Config

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
  
  static Rom[] randomRoms(Rom[] list, Int nbRoms := 20)
  {
    Rom[] roms := [,]
    (0 ..< nbRoms).each
    {
      roms.add(list[Int.random(0 ..< list.size)])
    }
    return roms
  }
  
  static Image? getSnapshot(Rom rom)
  {
    Image.makeFile(config.snapFolder.plus(`${rom.name}.png`), false)
  }
}