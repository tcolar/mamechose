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
  
  Int fontSize
  Int gap
  
  new make(Rect bounds, Int fontSize) : super(bounds) 
  {
    this.fontSize = fontSize
    gap = (fontSize * 1.6f).toInt
    scrollSize = (size.h - (2 * gap)) / gap
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
  
  ** Apply the current selection (filter / refresh the list)
  Void apply()
  {
    selectCallback.call(items[scrollIndex])
  }

  override Void keyUp(EventHandler evt) {scroll(-1); repaint}
  
  override Void keyDown(EventHandler evt) {scroll; repaint}

  override Void keyButton1(EventHandler evt) 
  {
    apply
    evt.ui.state.updateCtxSelection(items[scrollIndex])
  }
  
  override Str[] getKeysHelp()
  {
    ["Quit(x3): Quit MameChose",
     "Start   : Start selected game",
     "Button1 : Select item"]
  }
  
  override Void paintContents(Graphics g)
  {
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