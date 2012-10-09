//
// History:
//   Oct 4, 2012 tcolar Creation
//
using gfx
using fwt
using concurrent

** Main canvas that contains all the subpanels (box)
** 
** This also handle all the eventing
** 
class MainCanvas : Canvas
{
  AllRoms allRoms
      
  NavBox nav
  ContextBox context
  ListBox list
  MetaBox meta // + snapshot
  HelpBox help
  
  Int? curRom
  
  Color bg := Color.black
  
  EventHandler evtHandler
  
  private ScreenSaver screenSaver
  
  DateTime lastEvent := DateTime.now
  
  new make(AllRoms allRoms, Rect bounds)
  {
    this.allRoms = allRoms
    this.bounds = bounds
        
    doubleBuffered = true
    
    w25 := (bounds.w * .25f).toInt
    h60 := (bounds.h * .6f).toInt 
    h80 := (bounds.h * .8f).toInt
    nav = NavBox{it.bounds = Rect(0, 0, w25, h60)}
    context = ContextBox{it.bounds = Rect(w25 + 1, 0, w25, h60)}
    list = ListBox{it.bounds = Rect(w25 * 2 + 2, 0, bounds.w - w25 * 2 + 1, h80)}
    meta = MetaBox{it.bounds = Rect(0, h60 + 1, w25 * 2 , bounds.h - h60 - 2)}
    help = HelpBox{it.bounds = Rect(w25 * 2 + 1, h80 + 1, bounds.w - w25 * 2 - 1 , bounds.h - h80 - 2)}
    
    setRomList(allRoms.roms.vals.sort |Rom a, Rom b -> Int| {a.desc.lower <=> b.desc.lower}   
    )
    
    screenSaver = ScreenSaver(bounds, allRoms.roms.vals)

    add(screenSaver).add(nav).add(context).add(list).add(meta).add(help)
    
    evtHandler = EventHandler(this)    
  }

  Void screenSaverOn(Bool on)
  {
    if(on && screenSaver.visible == false)
    {
      screenSaver.visible = true
      screenSaverPaint
    }
    else if(!on && screenSaver.visible == true)
    {
      screenSaver.visible = false
      repaint
    }    
  }
  
  ** Called every few seconds by screensaver thread to apint some more stuff
  Void screenSaverPaint()
  {
    screenSaver.repaint
  }

  ** Paint this and children
  override Void onPaint(Graphics g)
  {
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