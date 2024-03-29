//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** ListBox
**
class ListBox : ContentBox, Scrollable
{
  Bool inGame := false
  
  Str[] roms := [,] 
  {
    set 
    {
      &roms = it ; 
      scrollItems = it.size 
      scrollTop = 0
      scrollIndex = 0
      repaint
    }
  }
  
  Color hlBg := Color.makeArgb(255, 80, 120, 120) // highlighted background
  Color regular := Color.white
  Color title := Color.yellow 
  Color missing := Color.makeArgb(255, 116, 116, 116) // gray
  Color imperfect := Color.makeArgb(255, 220, 130, 30) // orange
  Color preliminary := Color.makeArgb(255, 160, 20, 20) // red
  
  private Bool movingDown := true

  override Int scrollIndex // current index
  override Int scrollTop // current index of first showing item
  override Int scrollSize // size of the scroll (where to wrap around)
  override Int scrollItems // How many items total we have to scroll though
  
  Int gap 
   
  new make(Rect bounds, Int fontSize) : super(bounds, fontSize) 
  {
    this.fontSize = fontSize
    gap = (fontSize * 1.6f).toInt
    scrollSize = (size.h - (3 * gap)) / gap
  }

  Rom? curRom()
  {
    if(scrollIndex<0) 
      return null
    name := scrollItems > scrollIndex ? roms[scrollIndex] : null
    return name == null ? null : RomHelper.rom(name)
  }

  override Void keyStart(EventHandler evt)
  {
    inGame = true
    try
    {  
      if(evt.me!=null && curRom != null)
      {  
        evt.ui.state.updateCurRom(curRom.name)
        evt.ui.state.save
        evt.ui.nav.listManager.setPlayed(curRom.name)
        evt.me.startGame(curRom.name)
      }
    }
    finally
    {     
      inGame = false
    }  
  }

  override Void keyUp(EventHandler evt)
  {
    evt.ui.meta.showRom(move(-1))  
  }
  
  override Void keyDown(EventHandler evt)
  {
    evt.ui.meta.showRom(move)  
  }
  
  override Void keyButton1(EventHandler evt)
  {
    evt.ui.meta.showRom(moveFast)  
  }
  
  override Void keyButton2(EventHandler evt)
  {
    evt.ui.meta.showRom(moveFast(false))  
  }

  override Str[] getKeysHelp()
  {
    ["Quit(x3): Quit MameChose",
     "Start   : Start selected game",
     "Button1 : Scroll Down 5%",
     "Button2 : Scroll Up 5%"]
  }

  ** Scroll the list and repaint
  Rom? move(Int by := 1)
  {
    scroll(by)
    repaint
    return curRom 
  }
  
  ** Move by 5% of the list size (by can be negative)
  Rom? moveFast(Bool forward := true)
  {
    by := scrollItems / 20
    if(! forward)
      by = by.negate
    scroll(by)
    repaint 
    return curRom     
  }

  override Void paintContents(Graphics g)
  {
    // scale the font so it looks about the same on an old CRT(low res but large pixels) as a new LCD
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
    
    y := gap
    
    g.brush = title    
    g.drawText("Number of roms in this list : $scrollItems", gap, y)
            
    y+=gap
    g.brush = regular
    
    (0 ..< scrollSize).each |index|
    {
      idx := scrollTop + index
      if(idx < scrollItems)
      {
        rom := RomHelper.rom(roms[idx])
        if(idx == scrollIndex)
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