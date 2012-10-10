
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
  
  new make(Str name := "") { this.name = name}
  
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