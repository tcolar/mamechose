using gfx
using fwt

class MainCanvas : Canvas
{  
  NavBox nav
  ContentBox flags
  ListBox list
  MetaBox meta // + snapshot
  ContentBox help
    
  new make(Rom[] romList, Rect bounds)
  {
    this.bounds = bounds
    
    doubleBuffered = true
    
    w25 := (bounds.w * .25f).toInt
    h60 := (bounds.h * .6f).toInt 
    h80 := (bounds.h * .8f).toInt
    nav = NavBox{it.bounds = Rect(0, 0, w25, h60)}
    flags = ContentBox{it.bounds = Rect(w25 + 1, 0, w25, h60)}
    list = ListBox{it.bounds = Rect(w25 * 2 + 2, 0, bounds.w - w25 * 2 + 1, h80)}
    meta = MetaBox{it.bounds = Rect(0, h60 + 1, w25 * 2 , bounds.h - h60 - 2)}
    help = ContentBox{it.bounds = Rect(w25 * 2 + 1, h80 + 1, bounds.w - w25 * 2 - 1 , bounds.h - h80 - 2); highlight=true}
    
    list.roms = romList
    
    add(nav).add(flags).add(list).add(meta).add(help)
  }
  
  override Void onPaint(Graphics g)
  {
    g.antialias = true
    g.brush = Color.black
    g.fillRect(0, 0, bounds.w, bounds.h)
  }  
}