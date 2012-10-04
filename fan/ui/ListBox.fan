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
  Rom[] roms := [,] {set {&roms = it ; curRomIndex = 0 }}
  
  private Int curRomIndex := 0

  new make(|This| f) : super(f) {}

  Rom? curRom()
  {
    return roms.size > curRomIndex ? roms[curRomIndex] : null
  }

  Rom? moveDown()
  {
    curRomIndex++
    if(curRomIndex >= roms.size)
        curRomIndex = 0
    repaint
    return curRom  
  }
  
  Rom? moveUp()
  {
    curRomIndex--
    if(curRomIndex < 0)
      curRomIndex = roms.size - 1  
    repaint 
    return curRom 
  }

  override Void paintContents(Graphics g)
  {
    hlBg := Color.makeArgb(255, 40, 80, 80)
    // scale the font so it looks about the same on an old CRT(low res but large pixels) as a new LCD
    fontSize := 22 * window.bounds.h / 1000 
    gap := (fontSize * 1.6f).toInt
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    y := gap
    
    g.brush = Color.yellow    
    g.drawText("Number of roms in this list : $roms.size", gap, y)
            
    y+=gap
    g.brush = Color.white
    
    roms[1 .. 30].each |rom, index|
    {
      if(index == curRomIndex)
      {  
        g.brush = hlBg
        g.fillRect(gap, y, size.w - gap , gap)
        g.brush = Color.white
      }
      g.drawText(rom.desc, gap, y)
      y+= gap
    }
  }  
}