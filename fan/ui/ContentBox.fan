
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
  Color fgOn := Color.yellow
  Color bg := Color.makeArgb(255, 40, 40, 40)
  Color titleBg := Color.makeArgb(255, 50, 50, 50)
  
  private Bool focused
  
  new make(Rect bounds) 
  {
    this.bounds = bounds
    doubleBuffered = true
  }
  
  override Void onPaint(Graphics g)
  {
    fontSize := 22 * bounds.h / 1000 
    spacing := (fontSize * 1.6f).toInt / 3
    Int arc := spacing * 4
    
    g.antialias = true
    g.brush = Color.black

    g.fillRect(0,0, size.w, size.h)
    g.brush = bg
    g.fillRoundRect(spacing, spacing, size.w - (spacing * 2), size.h - (spacing * 2), arc, arc)
    g.brush = fg
    if(focused)
    {
      g.pen = Pen{width = 4}
      g.brush = fgOn
    } 
    else
    {
      g.pen = Pen{width = 2}      
    }   
    g.drawRoundRect(spacing, spacing, size.w - (spacing * 2), size.h - (spacing * 2), arc, arc)
    paintContents(g)
  }
  
  virtual Void paintContents(Graphics g){}
  
  ** Receive the event when this box is selected or de-selected 
  virtual Void onSelect(Bool selected) {focused = selected ; repaint}
  
  ** Contextual help for which buttons does what
  virtual Str[] getKeysHelp() {[,]}
  
  virtual Void keyStart(EventHandler evt) {}
  virtual Void keyButton1(EventHandler evt) {}
  virtual Void keyButton2(EventHandler evt) {}
  virtual Void keyUp(EventHandler evt) {}
  virtual Void keyDown(EventHandler evt) {}
}