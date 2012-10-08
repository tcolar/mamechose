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
  Rom[] roms
  
  new make(Rect bounds, Rom[] roms) : super()
  {
    this.bounds = bounds
    this.roms = roms
    visible = false
  }
  
  override Void onPaint(Graphics g)
  {
    if( ! roms.isEmpty)
    {  
      rom := roms[Int.random(0 .. roms.size-1)]
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