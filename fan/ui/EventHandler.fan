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
  
  new make(MainCanvas canvas)
  {
    this.ui = canvas
    
    ui.onKeyDown.add |Event e| 
    {
      keyEvent(e)
    }
  }
  
  Void keyEvent(Event e)
  {
      switch(e.key.toStr.lower)
      {
        case me.config.keyStart.lower:
          rom := ui.list.curRom  
          if(me!=null && rom != null)
            me.startGame(rom.name)
        case me.config.keyQuit.lower:
          ui.window.close         
        case me.config.keyLeft.lower:                 
        case me.config.keyRight.lower:
          echo("n/a")        
        case me.config.keyUp.lower:
          ui.meta.showRom(ui.list.moveUp)          
        case me.config.keyDown.lower:
          ui.meta.showRom(ui.list.moveDown)          
      }    
  } 
}