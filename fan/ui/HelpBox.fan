//
// History:
//   Oct 8, 2012 tcolar Creation
//
using gfx

**
** HelpBox
**
class HelpBox : ContentBox
{
  Color text := Color.white
  
  Str[] helpItems := [,]
  
  Int gap
  
  new make(Rect bounds, Int fontSize) : super(bounds, fontSize) 
  {
    this.fontSize = fontSize
    gap = (fontSize * 1.6f).toInt
  }

  Void update(Str[] helpItems)
  {
    this.helpItems = helpItems
    repaint
  }
  
  override Void paintContents(Graphics g)
  {
      g.clip(Rect(gap, 0, size.w - (gap * 2), size.h))
  
      g.font = Font.fromStr("${fontSize}pt Arial Bold")
      g.brush = text
 
      y := gap
      helpItems.each
      {  
        g.drawText(it, gap, y); y += gap
      }  
  }
}