
//
// History:
//   Oct 8, 2012 tcolar Creation
//
using util

**
** AppState
** State persistance (UI state)
**
@Serializable
class AppState
{
  private RomListFilter? filter
  private Str? currentNav 
  private Str? ctxSelection // item selected in list context
  private Str? curRom // last ran game

  private Bool dirty

  Void updateFilter(RomListFilter filter)
  {
    dirty = true
    this.filter = filter
  } 
  
  Void updateNav(Str navName)
  {
    dirty = true
    currentNav = navName
  }
  
  Void updateCtxSelection(Str itemName)
  {
    dirty = true
    ctxSelection = itemName
  }
  
  Void updateCurRom(Str romName)
  {
    dirty = true
    curRom = romName
  }
  
  Void save()
  {
    if(dirty)
    {
      config := Service.find(Config#) as Config       
      out := JsonOutStream(config.stateFile.out)
      try
      {  
        out.writeJson(this)
      }  
      finally
      {  
        out.close
      }
    }        
    dirty = false    
  } 
  
  static AppState load()
  { 
    config := Service.find(Config#) as Config       
    state := AppState()
    if(config.stateFile.exists)
    {  
      in := JsonInStream(config.stateFile.in)
      Obj? obj
      try
      {  
        obj = in.readJson
      }  
      finally 
      {       
        in.close
      }  
    
      if(obj!=null)
      {
        map := (Map) obj
        state.currentNav = map["currentNav"]
        state.ctxSelection = map["ctxSelection"]
        state.curRom = map["curRom"]
        f := map["filter"]
        state.filter = RomListFilter.fromMo(f)
      } 
    }
    return state   
  }
  
  Void restoreTo(MainCanvas ui)
  {
    ui.nav.filters = filter
    filter.hideFlags.each |flag|
    {
      ListItem? item := ui.nav.items.eachWhile |val, index| {return val.name.endsWith(flag.desc) ? val : null}
      if(item != null)
        ui.nav.toggle(item)
    }
    si := ui.nav.items.eachWhile |item, index -> Obj?| {return item.name==currentNav ? index : null}  
    if(si != null)
    {  
      ui.nav.scrollDown(si)
      ui.nav.items.get(ui.nav.scrollIndex).func.call(ui.evtHandler)
      ui.nav.repaint
      
      // TODO: now deal with the context item
      csi := ui.context.items.eachWhile |item, index -> Obj?| {return item==ctxSelection ? index : null}
      if(csi != null)
      {
        ui.context.scrollDown(csi) 
        ui.context.selectCallback.call(ctxSelection) 
        ui.context.repaint
        
        // Now the rom
        if(curRom != null)
        {  
          rsi := ui.list.roms.eachWhile |rom, index -> Obj?| {return rom.name==curRom ? index : null} 
          if(rsi!=null)
          {  
            ui.list.scrollDown(rsi)
            // Todo: scrolltop ?
            ui.list.repaint
          }
        }
      }
    }
  }
}