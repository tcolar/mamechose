
//
// History:
//   Oct 1, 2012 tcolar Creation
//
using fwt
using gfx

**
** MainWindow
**
class MainWindow : Window
{
  MameExec? me := Service.find(MameExec#) as MameExec
          
  new make(Rom[] roms) : super()
  {
    bounds := Desktop.bounds
    //bounds := Rect(0, 0, 350, 262) // testing low res like arcade montitor
    
    mode = WindowMode.sysModal
    resizable = false
    showTrim = false
    size = Size(bounds.w, bounds.h)
    
    onKeyUp.add |Event e| 
    {
      keyEvent(e)
    }
    
    content = MainCanvas(roms, bounds)
  }
  
  ** Handle key events (incl. joystick) across the board
  Void keyEvent(Event e)
  {
      switch(e.key.toStr)
      {
        case Key.ctrl.toStr:
          if(me!=null)
            me.startGame("abcop")
        case Key.esc.toStr:
          window.close         
      }    
  }
}

