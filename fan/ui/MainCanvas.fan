using gfx
using fwt

** Main canvas that contains all the subpanels (box)
** 
** This also handle all the eventing
** 
class MainCanvas : Canvas
{  
  NavBox nav
  ContentBox flags
  ListBox list
  MetaBox meta // + snapshot
  ContentBox help
  
  Int? curRom
  
  Color bg := Color.black
  
  EventHandler evtHandler
    
  new make(Rom[] romList, Rect bounds)
  {
    this.bounds = bounds
    
    doubleBuffered = true
    
    w25 := (bounds.w * .25f).toInt
    h60 := (bounds.h * .6f).toInt 
    h80 := (bounds.h * .8f).toInt
    nav = NavBox{it.bounds = Rect(0, 0, w25, h60)}
    flags = ContentBox{it.bounds = Rect(w25 + 1, 0, w25, h60)}
    list = ListBox{highlight=true; it.bounds = Rect(w25 * 2 + 2, 0, bounds.w - w25 * 2 + 1, h80)}
    meta = MetaBox{it.bounds = Rect(0, h60 + 1, w25 * 2 , bounds.h - h60 - 2)}
    help = ContentBox{it.bounds = Rect(w25 * 2 + 1, h80 + 1, bounds.w - w25 * 2 - 1 , bounds.h - h80 - 2)}
    
    setRomList(romList)
    
    add(nav).add(flags).add(list).add(meta).add(help)
    
    evtHandler = EventHandler(this)
  }

  ** Paint this and children
  override Void onPaint(Graphics g)
  {
    g.antialias = true
    g.brush = bg
    g.fillRect(0, 0, bounds.w, bounds.h)
  } 
  
  ** Set the current rom list
  Void setRomList(Rom[] roms)
  {
    list.roms = roms
    meta.showRom(list.curRom)
  }  
}