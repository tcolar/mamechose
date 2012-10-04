
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
  new make(Rom[] roms) : super()
  {
    bounds := Desktop.bounds
    //bounds := Rect(0, 0, 350, 262) // testing low res like arcade montitor
    
    mode = WindowMode.sysModal
    resizable = false
    showTrim = false
    size = Size(bounds.w, bounds.h)
    
    content = MainCanvas(roms, bounds)
  }  
}

