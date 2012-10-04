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
  
  private Int curRomIndex := 0 // current selected rom
  private Int listTop := 0  // current first rom in the list
  
  Color hlBg := Color.makeArgb(255, 40, 80, 80) // highlighted background
  Color regular := Color.white
  Color title := Color.yellow 
  Color missing := Color.makeArgb(255, 116, 116, 116) // gray
  Color imperfect := Color.makeArgb(255, 220, 130, 30) // orange
  Color preliminary := Color.makeArgb(255, 160, 20, 20) // red
  
  private Int? fontSize
  private Int? gap  
  private Int? listSize

  new make(|This| f) : super(f) 
  {
  }

  Rom? curRom()
  {
    return roms.size > curRomIndex ? roms[curRomIndex] : null
  }

  Rom? moveDown()
  {
    curRomIndex++
      if(curRomIndex >= listTop + listSize)
    { 
      //scroll down 
      listTop++
      }  
    if(curRomIndex >= roms.size)
    {
      // roll back to top  
      listTop = 0
      curRomIndex = 0  
    }  
    if(listTop >= roms.size)
      listTop = 0
    repaint
    return curRom  
  }
  
  Rom? moveUp()
  {
    curRomIndex--
      if(curRomIndex < 0)
    {
      curRomIndex = roms.size - 1
      listTop = roms.size - listSize  
    }    
    if(curRomIndex < listTop)
    {  
      listTop--
      }  
    if(listTop < 0)
      listTop = 0
    repaint 
    return curRom 
  }

  override Void paintContents(Graphics g)
  {
    if(fontSize == null)
    {
      fontSize = 22 * window.bounds.h / 1000 
      gap = (fontSize * 1.6f).toInt
      listSize = (size.h - (3 * gap)) / gap
    }  
    
    // scale the font so it looks about the same on an old CRT(low res but large pixels) as a new LCD
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
    
    y := gap
    
    g.brush = title    
    g.drawText("Number of roms in this list : $roms.size", gap, y)
            
    y+=gap
    g.brush = regular
    
    (0 ..< listSize).each |index|
    {
      idx := listTop + index
      if(idx < roms.size)
      {
        rom := roms[idx]
        if(idx == curRomIndex)
        {  
          g.brush = hlBg
          g.fillRect(gap, y, size.w - (gap * 2) , gap)        
        }
        g.brush = regular
        if(rom.installed != null && rom.installed == false)
          g.brush = missing
        else if(rom.status == "imperfect")
          g.brush = imperfect
        else if(rom.status == "preliminary")
          g.brush = preliminary
        
        g.drawText(rom.desc, gap, y)
        y+= gap
      }
    }
  }  
}