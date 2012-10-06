//
// History:
//   Oct 4, 2012 tcolar Creation
//
using fwt
using concurrent
 
**
** EventHandler
** Handles key events (incl. joystick) across the board
**
class EventHandler
{
  MameExec? me := Service.find(MameExec#) as MameExec
  MainCanvas ui
  
  private ContentBox currentBox
  
  new make(MainCanvas canvas)
  {
    this.ui = canvas
    
    currentBox = ui.list
    ui.context.byItems(ui.nav.lists.keys) |Str str| {ui.nav.lists[str].call(this)}
    
    currentBox.onSelect(true)
    
    ui.onKeyDown.add |Event e| 
    {
      keyEvent(e)
    }
    
    Actor.locals["mamechose.ui"] = ui 
    screenSaver.send("start")
  }
  
  internal Void changeBox(Bool right := true)
  {
    currentBox.onSelect(false)
    switch(currentBox.typeof)
    {
      case ListBox#:
        currentBox = right ? currentBox : ui.context
      case ContextBox#:
        currentBox = right ? ui.list : ui.nav
      case NavBox#:
        currentBox = right ? ui.context : currentBox
    }
    currentBox.onSelect(true)
  } 
  
  ** set the rom list with this fiter applied (if roms is not specified, use the full list as the base)
  Void applyList(RomListFilter filter, Rom[] roms := ui.allRoms.roms.vals)
  {
    ui.setRomList(filter.filterList(roms))
  }
  
  Void keyEvent(Event e)
  {
    switch(e.key.toStr.lower)
    {
      // Global buttons            
      case me.config.keyQuit.lower:
        ui.window.close   
                  
      case me.config.keyRight.lower:
        changeBox(true) 
            
      case me.config.keyLeft.lower: 
        changeBox(false)                  
        
        // Contextual buttons                                               
      case me.config.keyStart.lower:
      case Key.enter.toStr.lower:
        currentBox.keyStart(this)
                
      case me.config.keyUp.lower:
        currentBox.keyUp(this)  
                    
      case me.config.keyDown.lower:
        currentBox.keyDown(this)  
                     
      case me.config.keyButton1.lower:
        currentBox.keyButton1(this)  
                      
      case me.config.keyButton2.lower:
        currentBox.keyButton2(this)  
    } 
       
    ui.lastEvent = DateTime.now
    
    ui.screenSaverOn(false)
  }
  
  Actor screenSaver := Actor(ActorPool()) |msg -> Bool?|
  {
    while(true)
    { 
      Desktop.callAsync |->| 
      {
        MainCanvas canvas := Actor.locals["mamechose.ui"]
        if(DateTime.now > canvas.lastEvent + 3min)
        {      
          canvas.screenSaverOn(true) 
          canvas.screenSaverPaint        
        }       
      }      
      Actor.sleep(5sec)
    }                 
    return null
  } 
}