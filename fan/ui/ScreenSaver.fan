//
// History:
//   Oct 5, 2012 tcolar Creation
//
using gfx
using fwt

**
** ScreenSaver
** Show screenshots in random places on the screen
**
class ScreenSaver : Canvas
{
  Str[] roms := RomHelper.allRoms.roms.keys
  
  new make(Rect bounds) : super()
  {
    this.bounds = bounds
    visible = false
  }
  
  override Void onPaint(Graphics g)
  {
    if( ! roms.isEmpty)
    {  
      romName := roms[Int.random(0 .. roms.size-1)]
      rom := RomHelper.rom(romName)
      if(! rom.category.lower.contains("*mature*"))
      {
        img := RomHelper.getSnapshot(rom)  
        if(img!=null)
          g.drawImage(img ,Int.random(0 .. bounds.w - 50), Int.random(0 .. bounds.h - 50))
        img?.dispose
      }  
    }
  }
}