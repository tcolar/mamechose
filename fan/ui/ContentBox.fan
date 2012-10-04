
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
  Int arcW := 50
  Int arcH := 50
  
  Bool highlight
  
  new make(|This| f) 
  {
    f(this)
  }
  
  override Void onPaint(Graphics g)
  {
    g.antialias = true
    g.brush = Color.black

    g.fillRect(0,0, size.w, size.h)
    g.brush = bg
    g.fillRoundRect(10,10, size.w - 20, size.h - 20, arcW, arcH)
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
    g.drawRoundRect(10,10, size.w - 20, size.h - 20, arcW, arcH)
    paintContents(g)
  }
  
  virtual Void paintContents(Graphics g){}
}