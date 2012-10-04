//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** ListBox
**
class ListBox : ContentBox
{
  Rom[] roms := [,]

  new make(|This| f) : super(f) {}
  
  override Void paintContents(Graphics g)
  {
    // scale the font so it looks about the same on an old CRT(low res but large pixels) as a new LCD
    fontSize := 22 * window.bounds.h / 1000 
    gap := (fontSize * 1.6f).toInt
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    y:=30
    
    g.brush = Color.yellow    
    g.drawText("Number of roms in this list : $roms.size", 30, y)
            
    y+=gap * 2
    g.brush = Color.white
    
    roms[1 .. 30].each |rom|
    {
      g.drawText(rom.desc, 30, y)
      y+= gap
    }
  }  
}