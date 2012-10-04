//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** NavBox
**
class NavBox : ContentBox
{
  new make(|This| f) : super(f) {}
  
  override Void paintContents(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000
    gap := (fontSize * 1.6f).toInt
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    g.brush = Color.white
    
    y:= 30 
    g.drawText("By List", 30, y); y += gap// all, random, favs, mylist   
    g.drawText("By Category", 30, y); y += gap
    g.drawText("By Play status", 30, y); y += gap //played / not played
    g.drawText("By NbPlayers", 30, y); y += gap
    g.drawText("By Year", 30, y); y += gap
    g.drawText("By Publisher", 30, y); y += gap * 2
    
    g.drawText("Filters", 30, y); y += gap 
    /*
    - show "hidden" roms ?
    - show failed verification roms
    - show unverified roms
    - show missing roms
    - show incomplete status romss
    - show preliminary status roms
    - show unknown status roms
    - show Mature games (*mature*)
    - show Casino games -> sucks
    */
    
  }
}