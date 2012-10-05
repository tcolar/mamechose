//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** NavBox
**
class NavBox : ContentBox, Scrollable
{
  Color by := Color.yellow
  Color search := Color.blue
  Color filter := Color.white
  Color hlBg := Color.makeArgb(255, 80, 120, 120) // highlighted background

  override Int scrollIndex := 0
  override Int scrollTop := 0
  override Int scrollSize := 0
  override Int scrollItems := 0
  
  ListItem[] items := [,]
  
  RomListFilter filters := RomListFilter()
  
  new make(|This| f) : super(f) 
  {
    items.add(ListItem("By List", by, |EventHandler evt| {echo("a")})) 
    items.add(ListItem("By Category", by, |EventHandler evt| {})) 
    items.add(ListItem("By Nb Players", by, |EventHandler evt| {})) 
    items.add(ListItem("By Year", by, |EventHandler evt| {})) 
    items.add(ListItem("By Publisher", by, |EventHandler evt| {}))

    items.add(ListItem("Search (TODO)", search, |EventHandler evt| {}))
    
    FilterFlag.vals.each |flag|
    {
      items.add(ListItem("(*) $flag.desc", filter, |EventHandler evt| {
        toggle(items[scrollIndex])
        filters.toggle(flag)
        evt.updateList(filters)
        repaint
      }))
    }
    
    scrollItems = items.size
  }
  
  override Void keyUp(EventHandler evt) {scroll(-1); repaint}
  
  override Void keyDown(EventHandler evt) {scroll; repaint}

  override Void keyButton1(EventHandler evt) 
  {
    items[scrollIndex].func.call(evt)
  }
  
  Void toggle(ListItem item)
  {
    if(item.name.startsWith("(*)"))
    {
      item.name = "(-)" + item.name[3..-1]
    }        
    else if(item.name.startsWith("(-)"))
    {
      item.name = "(*)" + item.name[3..-1]      
    }        
  }
  
  override Void paintContents(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000
    gap := (fontSize * 1.6f).toInt
    if(scrollSize == 0)
      scrollSize = (size.h - (2 * gap)) / gap
      
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
  
    g.brush = hlBg
    g.fillRect(gap, gap + scrollIndex * gap, size.w - (gap * 2) , gap)        

    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    y := 0
    items.each |item|
    {
      g.brush = item.color
      y += gap 
      g.drawText(item.name, gap, y);         
    }
  }
}

class ListItem
{
  Str name
  Func func
  Color color 

  new make(Str name, Color color, Func func)
  {
    this.name = name
    this.color = color
    this.func = func
  }
}