
//
// History:
//   Oct 1, 2012 tcolar Creation
//
using fwt
using gfx

**
** ContentBox
**
class ContentBox : Canvas
{
  Color fg := Color.makeArgb(255, 100, 255, 100)
  Color bg := Color.makeArgb(255, 40, 40, 40)
  Color titleBg := Color.makeArgb(255, 50, 50, 50)
  
  Bool highlight
  
  new make(|This| f) 
  {
    f(this)
    doubleBuffered = true
  }
  
  override Void onPaint(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000 
    spacing := (fontSize * 1.6f).toInt / 3
    Int arc := spacing * 4
    
    g.antialias = true
    g.brush = Color.black

    g.fillRect(0,0, size.w, size.h)
    g.brush = bg
    g.fillRoundRect(spacing, spacing, size.w - (spacing * 2), size.h - (spacing * 2), arc, arc)
    g.brush = fg
    if(highlight)
    {
      g.pen = Pen{width = 4}
      g.brush = fg.lighter(.5f)
    } 
    else
    {
      g.pen = Pen{width = 2}      
    }   
    g.drawRoundRect(spacing, spacing, size.w - (spacing * 2), size.h - (spacing * 2), arc, arc)
    paintContents(g)
  }
  
  virtual Void paintContents(Graphics g){}
}