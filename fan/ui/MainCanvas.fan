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
  Int fontSize
  
  EventHandler evtHandler
  
  private ScreenSaver screenSaver
  
  DateTime lastEvent := DateTime.now
  
  AppState state
  
  new make(AllRoms allRoms, Rect bounds, Int fontSize)
  {
    this.allRoms = allRoms
    this.bounds = bounds
    this.fontSize = fontSize
        
    doubleBuffered = true
    w25 := (bounds.w * .25f).toInt
    h60 := (bounds.h * .6f).toInt 
    h80 := (bounds.h * .8f).toInt
    nav = NavBox(Rect(0, 0, w25, h60), fontSize)
    context = ContextBox(Rect(w25 + 1, 0, w25, h60), fontSize)
    list = ListBox(Rect(w25 * 2 + 2, 0, bounds.w - w25 * 2 + 1, h80), fontSize)
    meta = MetaBox(Rect(0, h60 + 1, w25 * 2 , bounds.h - h60 - 2), fontSize)
    help = HelpBox(Rect(w25 * 2 + 1, h80 + 1, bounds.w - w25 * 2 - 1 , bounds.h - h80 - 2), fontSize)
        
    screenSaver = ScreenSaver(bounds, allRoms.roms.vals)

    add(screenSaver).add(nav).add(context).add(list).add(meta).add(help)

    evtHandler = EventHandler(this)    

    //context.byItems(nav.lists.keys) |Str str| {nav.lists[str].call(evtHandler)}    

    // Restore state
    state = AppState.load
    state.restoreTo(this)
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