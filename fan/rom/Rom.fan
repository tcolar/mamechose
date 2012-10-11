
//
// History:
//   Oct 1, 2012 tcolar Creation
//

**
** Rom
**
@Serializable
const class Rom
{
  const Str name
  const Str desc := "Unknown"
  const Str year := "Unknown"
  const Str publisher := "Unknown"
  const Str status := "Unknown" // -> todo
  const Str nbPlayers := "Unknown" //-> todo
  const Str category := "Unknown" //-> todo
  const Str? cloneOf // null means not a clone
  
  const Bool? installed // whether installed or not
  const Bool? verified // whether checked or not (crc/sha1))
  
  new make(|This| f) { f(this) }
  
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