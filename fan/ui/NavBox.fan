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
  Color search := Color.makeArgb(255, 100, 100, 200)
  Color filter := Color.white
  Color filterOff := Color.darkGray
  Color hlBg := Color.makeArgb(255, 80, 120, 120) // highlighted background

  override Int scrollIndex := 0
  override Int scrollTop := 0
  override Int scrollSize := 0
  override Int scrollItems := 0
  
  RomListFilter filters := RomListFilter {}
  
  ListManager listManager := ListManager()
  
  Int gap
  
  new make(Rect bounds, Int fontSize) : super(bounds, fontSize) 
  { 
    this.fontSize = fontSize
    gap = (fontSize * 1.6f).toInt
    scrollSize = (size.h - (2 * gap)) / gap
    
    // NOTE: "items" is already filled in partially, see field definition    
    FilterFlag.vals.each |flag|
    {
      items.add(ListItem("(*) $flag.desc", filter, |EventHandler evt| {
            toggle(items[scrollIndex])
            filters.toggle(flag)
            evt.ui.context.apply // restart with the full selected list
            evt.changeBox(false) // context.apply would have moved it right
            evt.applyBy(filters, evt.ui.list.roms) // and then filter again
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
    navName := items[scrollIndex].name
    if( ! navName.startsWith("("))
      evt.ui.state.updateNav(navName)
    evt.ui.state.updateFilter(filters)
  }
  
  override Str[] getKeysHelp()
  {
    ["Quit(x3): Quit MameChose","",
     "Button1 : Select / toggle item"]
  }
  
  Void toggle(ListItem item)
  {
    if(item.name.startsWith("(*)"))
    {
      item.name = "(-)" + item.name[3..-1]
      item.color = filterOff
    }        
    else if(item.name.startsWith("(-)"))
    {
      item.name = "(*)" + item.name[3..-1]      
      item.color = filter
    }        
  }
  
  override Void paintContents(Graphics g)
  {
    g.clip(Rect(gap, gap, size.w - (gap * 2), size.h - (gap * 2)))
  
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    
    y := gap
    
    (0 ..< scrollSize).each |index|
    {
      idx := scrollTop + index
      if(idx < scrollItems)
      {
        item := items[idx]
        if(idx == scrollIndex)
        {  
          g.brush = hlBg
          g.fillRect(gap, y, size.w - (gap * 2) , gap)        
        }
        g.brush = item.color
        g.drawText(item.name, gap, y);                     
        y += gap 
      }
    }
  }
    
  ListItem[] items := [    
    ListItem("By List", by) |EventHandler evt| {
      filters.clearBys
      evt.changeBox
      evt.ui.context.byItems(listManager.lists.keys) |Str selected| {
        romList := listManager.lists[selected]?.filteredCopy(filters)  
        evt.ui.setRomList(romList)
        evt.changeBox
      }
    }, 
    
    ListItem("By Category", by) |EventHandler evt| {
      filters.clearBys
      evt.changeBox
      evt.ui.context.byItems(RomHelper.allRoms.getCategories) |Str selected| {
        filters.category = selected
        evt.applyBy(filters)
        evt.changeBox
      }
    }, 
    
    ListItem("By Nb Players", by) |EventHandler evt| {
      filters.clearBys
      evt.changeBox
      evt.ui.context.byItems(RomHelper.allRoms.getPlayers) |Str selected| {
        filters.nbPlayers = selected
        evt.applyBy(filters)
        evt.changeBox
      }
    }, 
    
    ListItem("By Year", by) |EventHandler evt| {
      filters.clearBys
      evt.changeBox
      evt.ui.context.byItems(RomHelper.allRoms.getYears) |Str selected| {
        filters.year = selected
        evt.applyBy(filters)
        evt.changeBox
      }
    }, 
    
    ListItem("By Publisher", by) |EventHandler evt| {
      evt.changeBox
      filters.clearBys
      evt.ui.context.byItems(RomHelper.allRoms.getPublishers) |Str selected| {
        filters.publisher = selected
        evt.applyBy(filters)
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

