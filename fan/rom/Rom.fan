
//
// History:
//   Oct 1, 2012 tcolar Creation
//

**
** Rom
**
@Serializable
class Rom
{
  Str name
  Str desc := "Unknown"
  Str year := "Unknown"
  Str publisher := "Unknown"
  Str status := "Unknown" // -> todo
  Str nbPlayers := "Unknown" //-> todo
  Str category := "Unknown" //-> todo
  Str? cloneOf // null means not a clone
  
  Bool? installed // whether installed or not
  Bool? verified // whether checked or not (crc/sha1))
  Bool played //whether was played or not
  
  //Int timesPlayed := 0 -> separate file
  // rating -> separate file
  
  new make(Str name) { this.name = name}
  
  static Rom? fromMo(Map? mo)
  {
    if(mo == null || ! mo.containsKey("name"))
      return null
    rom := Rom(mo["name"])
    if(mo.containsKey("desc"))
      rom.desc = mo["desc"]
    if(mo.containsKey("year"))
      rom.year = mo["year"]
    if(mo.containsKey("publisher"))
      rom.publisher = mo["publisher"]
    if(mo.containsKey("status"))
      rom.status = mo["status"]
    if(mo.containsKey("nbPlayers"))
      rom.nbPlayers = mo["nbPlayers"]
    if(mo.containsKey("category"))
      rom.category = mo["category"]
    if(mo.containsKey("cloneOf"))
      rom.cloneOf = mo["cloneOf"]
    if(mo.containsKey("installed"))
      rom.installed = mo["installed"]
    if(mo.containsKey("verified"))
      rom.verified = mo["verified"]
    if(mo.containsKey("played"))
      rom.played = mo["played"]
      
    return rom
  }
  
  override Str toStr()
  {
    return(  """Rom $name 
                  Desc: $desc
                  Category: $category
                  Players: $nbPlayers
                  Year: $year
                  Publisher: $publisher""")
  }
}