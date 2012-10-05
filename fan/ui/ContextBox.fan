//
// History:
//   Oct 4, 2012 tcolar Creation
//
using gfx

**
** ContextBox
**
class ContextBox : ContentBox, Scrollable
{
  Color text := Color.white
  Color hlBg := Color.makeArgb(255, 80, 120, 120) // highlighted background

  override Int scrollIndex := 0
  override Int scrollTop := 0
  override Int scrollSize := 0
  override Int scrollItems := 0
  
  Str[] items := [,]
  |Str| selectCallback := |Str str| {}
  
  new make(|This| f) : super(f) 
  {    
  }
  
  Void byItems(Str[] items, |Str| onSelect)
  {
    this.items = items
    this.selectCallback = onSelect
    scrollItems = items.size
    scrollTop = 0
    scrollIndex = 0
    repaint
  }
  
  override Void keyUp(EventHandler evt) {scroll(-1); repaint}
  
  override Void keyDown(EventHandler evt) {scroll; repaint}

  override Void keyButton1(EventHandler evt) {selectCallback.call(items[scrollIndex])}
  
  override Void paintContents(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000
    gap := (fontSize * 1.6f).toInt
    if(scrollSize == 0)
      scrollSize = (size.h - (2 * gap)) / gap
      
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
  
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    y := gap
    
    (0 ..< scrollSize).each |index|
    {
      idx := scrollTop + index
      if(idx < scrollItems)
      {
        item := items[idx]
        if(idx == scrollIndex)
        {  
          g.brush = hlBg
          g.fillRect(gap, y, size.w - (gap * 2) , gap)        
        }
        g.brush = text
        g.drawText(item, gap, y);                     
        y += gap 
      }
    }
  }
}