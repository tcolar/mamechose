//
// History:
//   Oct 1, 2012 tcolar Creation
//

**
** All the roms that mame supports (from mame list.xml)
**
@Serializable
class AllRoms
{
  Str mameVersion   
  
  Str:Rom roms := [:]
  
  new make(Str mameVersion := "")
  {
    this.mameVersion = mameVersion
  }
  
  ** Lazy loaded list of unique categories in the rom list
  Str[] getCategories()
  {
    if(categories == null)
    {
      categories = [,]
      roms.each |rom|
      {
        addHit(categories, rom.category)
      }
      categories = categories.sort |a, b -> Int| {a <=> b}
    } 
    return categories
  }
  
  ** Lazy loaded list of unique NbPlayers categories in the rom list
  Str[] getPlayers()
  {
    if(players == null)
    {
      players = [,]
      roms.each |rom|
      {
        addHit(players, rom.nbPlayers)
      }
      players = players.sort |a, b -> Int| {a <=> b}
    } 
    return players
  }
  
  Str[] getPublishers()
  {
    if(publishers == null)
    {
      publishers = [,]
      roms.each |rom|
      {
        addHit(publishers, rom.publisher)
      }
      publishers = publishers.sort |a, b -> Int| {a <=> b}
    } 
    return publishers
  }

  Str[] getYears()
  {
    if(years == null)
    {
      years = [,]
      roms.each |rom|
      {
        addHit(years, rom.year)
      }
      years = years.sort |a, b -> Int| {a <=> b}
    } 
    return years
  }
  
  internal Void addHit(Str[] list, Str item)
  {
    if( ! list.contains(item))
      list.add(item); 
  }
  
  private Str[]? categories
  private Str[]? players
  private Str[]? publishers
  private Str[]? years
}