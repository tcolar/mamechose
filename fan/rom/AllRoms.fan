//
// History:
//   Oct 1, 2012 tcolar Creation
//

**
** All the roms that mame supports (from mame list.xml)
**
@Serializable
const class AllRoms
{
  const Str mameVersion   
  
  const Str:Rom roms
  
  @Transient const Str[] categories
  @Transient const Str[] players
  @Transient const Str[] publishers
  @Transient const Str[] years

  new make(|This| f)
  {
    f(this)
    
    categories = getCategories
    players = getPlayers
    publishers = getPublishers
    years = getYears
  }
  
  **  unique categories in the rom list
  internal Str[] getCategories()
  {
      categories := [,]
      roms.each |rom|
      {
        addHit(categories, rom.category)
      }
      categories = categories.sort |a, b -> Int| {a <=> b}
      return categories  
  }
  
  **  unique NbPlayers categories in the rom list
  internal Str[] getPlayers()
  {
      players := [,]
      roms.each |rom|
      {
        addHit(players, rom.nbPlayers)
      }
      players = players.sort |a, b -> Int| {a <=> b}
    return players
  }
  
  internal Str[] getPublishers()
  {
      publishers := [,]
      roms.each |rom|
      {
        addHit(publishers, rom.publisher)
      }
      publishers = publishers.sort |a, b -> Int| {a <=> b}
    return publishers
  }

  internal Str[] getYears()
  {
      years := [,]
      roms.each |rom|
      {
        addHit(years, rom.year)
      }
      years = years.sort |a, b -> Int| {a <=> b}
    return years
  }
  
  internal Void addHit(Str[] list, Str item)
  {
    if( ! list.contains(item))
      list.add(item); 
  }  
}