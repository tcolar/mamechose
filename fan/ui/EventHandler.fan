//
// History:
//   Oct 4, 2012 tcolar Creation
//
using fwt

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
    currentBox.onSelect(true)
    
    ui.onKeyDown.add |Event e| 
    {
      keyEvent(e)
    }
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
  
  ** Set a new list of roms as the active list
  Void updateList(RomListFilter filter)
  {
    ui.setRomList(filter.filterList(ui.allRoms))
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
  } 
}