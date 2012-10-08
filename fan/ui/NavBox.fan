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
  
  RomListFilter filters := RomListFilter()
  
  Str:Func lists := [:] {ordered = true}
  
  new make(|This| f) : super(f) 
  { 
    lists["All"] = |EventHandler evt| {evt.applyList(filters)}
    
    lists["Random 20"] =  |EventHandler evt| {
      filtered := filters.filterList(evt.ui.allRoms.roms.vals, false)
      evt.ui.setRomList(RomHelper.randomRoms(filtered))
    }
   
    FilterFlag.vals.each |flag|
    {
      items.add(ListItem("(*) $flag.desc", filter, |EventHandler evt| {
            toggle(items[scrollIndex])
            filters.toggle(flag)
            evt.ui.context.apply // restart with the full selected list
            evt.applyList(filters, evt.ui.list.roms) // and then filer
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
    
  ListItem[] items := [    
    ListItem("By List", by) |EventHandler evt| {
          filters.clearBys
          evt.changeBox
          evt.ui.context.byItems(lists.keys) |Str selected| {
            lists[selected]?.call(evt)  
            evt.changeBox
          }
      }, 
    
    ListItem("By Category", by) |EventHandler evt| {
          filters.clearBys
          evt.changeBox
          evt.ui.context.byItems(evt.ui.allRoms.getCategories) |Str selected| {
            filters.category = selected
            evt.applyList(filters)
            evt.changeBox
          }
        }, 
    
    ListItem("By Nb Players", by) |EventHandler evt| {
          filters.clearBys
          evt.changeBox
          evt.ui.context.byItems(evt.ui.allRoms.getPlayers) |Str selected| {
            filters.nbPlayers = selected
            evt.applyList(filters)
            evt.changeBox
          }
        }, 
    
    ListItem("By Year", by) |EventHandler evt| {
          filters.clearBys
          evt.changeBox
          evt.ui.context.byItems(evt.ui.allRoms.getYears) |Str selected| {
            filters.year = selected
            evt.applyList(filters)
            evt.changeBox
          }
        }, 
    
    ListItem("By Publisher", by) |EventHandler evt| {
          evt.changeBox
          filters.clearBys
          evt.ui.context.byItems(evt.ui.allRoms.getPublishers) |Str selected| {
            filters.publisher = selected
            evt.applyList(filters)
            evt.changeBox
          }
        },

    ListItem("Search (TODO)", search, |EventHandler evt| {})
]
  

}

class ListItem
{
  Str name
  Func func
  Color color 

  new make(Str name, Color color, |EventHandler| onSelect)
  {
    this.name = name
    this.color = color
    this.func = onSelect
  }
}