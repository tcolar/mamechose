
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
  new make(AllRoms allRoms) : super()
  {
    bounds := Desktop.bounds
    //bounds := Rect(0, 0, 350, 262) // testing low res like arcade montitor
    
    mode = WindowMode.sysModal
    resizable = false
    showTrim = false
    size = Size(bounds.w, bounds.h)

    fontSize := 24 * bounds.w / 2000 
    
    content = MainCanvas(allRoms, bounds, fontSize)
  }  
}

