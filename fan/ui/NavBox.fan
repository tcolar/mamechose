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
    
    y:= gap 
    g.drawText("By List", gap, y); y += gap// all, random, favs, mylist   
    g.drawText("By Category", gap, y); y += gap
    g.drawText("By Play status", gap, y); y += gap //played / not played
    g.drawText("By NbPlayers", gap, y); y += gap
    g.drawText("By Year", gap, y); y += gap
    g.drawText("By Publisher", gap, y); y += gap * 2
    g.drawText("Search", gap, y); y += gap * 2 // -> show "keyboard" ?
    
    g.drawText("Filters", gap, y); y += gap 
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