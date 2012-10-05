//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** NavBox
**
class NavBox : ContentBox, Scrollable
{
  Color by := Color.yellow
  Color search := Color.blue
  Color filter := Color.white
  Color hlBg := Color.makeArgb(255, 80, 120, 120) // highlighted background

  override Int scrollIndex := 0
  override Int scrollTop := 0
  override Int scrollSize := 0
  override Int scrollItems := 0
  
  new make(|This| f) : super(f) 
  {
     scrollItems = 6 + FilterFlag.vals.size
  }
  
  override Void keyUp(EventHandler evt) {scroll(-1); repaint}
  
  override Void keyDown(EventHandler evt) {scroll; repaint}

  override Void keyButton1(EventHandler evt) 
  {
    // TODO: handle
  }
  
  override Void paintContents(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000
    gap := (fontSize * 1.6f).toInt
    if(scrollSize == 0)
      scrollSize = (size.h - (2 * gap)) / gap
      
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
  
    g.brush = hlBg
    g.fillRect(gap, gap + scrollIndex * gap, size.w - (gap * 2) , gap)        

    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    g.brush = by
    
    y:= gap 
    g.drawText("By List", gap, y); y += gap// all, random, played, never played, favs, mylist   
    g.drawText("By Category", gap, y); y += gap
    g.drawText("By Nb Players", gap, y); y += gap
    g.drawText("By Year", gap, y); y += gap
    g.drawText("By Publisher", gap, y); y += gap * 2
    //g.brush = search
    //g.drawText("Search", gap, y); y += gap // -> show "keyboard" ?
    g.brush = filter
    FilterFlag.vals.each |filter|
    {
      g.drawText("(*) $filter.desc", gap, y); y += gap
    }
  }
}