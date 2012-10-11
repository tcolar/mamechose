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
  private Int quitCounter := 0
  
  new make(MainCanvas canvas)
  {
    this.ui = canvas
    
    currentBox = ui.list
    changeBox(true)
    
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
    ui.help.update(currentBox.getKeysHelp)
  } 
  
  ** set the rom list with this fiter applied (if roms is not specified, use the full list as the base)
  Void applyBy(RomListFilter filter, Str[] roms := RomHelper.allRoms.roms.keys)
  {
    ui.setRomList(filter.filterList(roms))
  }
  
  Void keyEvent(Event e)
  {
    switch(e.key.toStr.lower)
    {
      // Global buttons            
      case me.config.keyQuit.lower:
        quitCounter += 1
        if(quitCounter==3)
        {
          ui.state.save
          ui.window.close 
      }    
                  
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
    
    if(e.key.toStr.lower != me.config.keyQuit.lower)  
      quitCounter = 0
           
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
        if(DateTime.now > canvas.lastEvent + 1min)
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