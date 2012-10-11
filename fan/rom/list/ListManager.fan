
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** ListManager
** Manage rom lists
**
class ListManager
{
  Str:RomList lists := [:] {ordered = true}
  private File folder := RomHelper.configFolder 
  
  new make()
  {
    lists["All"] = AllRomList()
    lists["Favorites"] = FileRomList("favorites")
    lists["Random 20"] = RandomRomList()    
    lists["Played"] = FileRomList("played")
    lists["Never Played"] = NeverPlayedRomList(lists["Played"]) 
    // Add user lists (but not favs and played again!) 
    folder.listFiles.each
    {
      regex := Regex<|mamechose-(.*)\.list|>
      matcher := regex.matcher(name.lower)
      if(matcher.matches)
      {
        name := matcher.group(1)
        if(name != "played" && name != "favorites")
          lists[name.capitalize] = FileRomList(name)
      }  
    }
  }
  
  ** mark a rom as played, if not yet so
  Void setPlayed(Str rom)
  {
    if( ! lists["Played"].roms.contains(rom))
    {  
        played := (FileRomList?) lists["Played"]
        played?.add(rom)
        
        notPlayed := (NeverPlayedRomList?) lists["Never Played"]
        notPlayed?.roms.remove(rom)   
    }      
  }
}