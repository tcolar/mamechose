//
// History:
//   Oct 4, 2012 tcolar Creation
//

**
** RomListFilter
**
class RomListFilter
{
  // List of flags we don't want to show'
  FilterFlag[] hideFlags := [,]
  
  // By's 
  Str? category
  Str? nbPlayers
  Bool? played
  Str? publisher
  Str? year
  
  ** Apply the filters to the given list
  ** and returns a NEW filtered list (leave inputList alone)
  Rom[] filterList(Rom[] inputList)
  {
    Rom[] roms := [,]
    inputList.each |rom|
    {
      if(matchRom(rom))
        roms.add(rom)
    }
    return roms
  }
  
  ** Check if a rom matches the filter
  Bool matchRom(Rom rom)
  {
    // do the "by" filters
    if(category != null && rom.category != category)
      return false
    if(nbPlayers != null && ! rom.nbPlayers.contains(nbPlayers))
      return false
    if(publisher != null && rom.publisher != publisher)
      return false
    if(year!= null && rom.year != year)
      return false
      
    // TODO: Played / not played
    
    // Now filter according to the flags
    excluded := hideFlags.eachWhile |flag -> Bool?|
    {
      switch(flag)
      {
        case FilterFlag.missing:
          if(rom.installed == false) 
          return true
        case FilterFlag.failedVerif:
          if(rom.verified == false) 
          return true
        case FilterFlag.clones:
          if(rom.cloneOf != null) 
          return true
        case FilterFlag.preliminary:
          if(rom.status.lower == "preliminary") 
          return true
        case FilterFlag.incomplete:
          if(rom.status.lower == "incomplete") 
          return true
        case FilterFlag.casino:
          if(rom.category.lower.startsWith("casino")) 
          return true
        case FilterFlag.tabletop:
          if(rom.category.lower.startsWith("tabletop")) 
          return true
        case FilterFlag.electro:
          if(rom.category.lower.startsWith("electromechanical")) 
          return true
        case FilterFlag.hidden:
          echo("TODO: hidden list")          
      }
      return null // keep going
    }
    
    return excluded != true  
  }
}

enum class FilterFlag
{
  missing("Missing"),
  failedVerif("Failed verification"),
  clones("Clones"),
  preliminary("Preliminary status"),
  incomplete("Incomplete status"),
  electro("Pinball roms"),
  tabletop("TableTop roms"),
  casino("Casino roms"),
  mature("Mature roms"),
  hidden("Hidden list")
  
  private new make(Str desc) {this.desc = desc}
  
  const Str desc
}