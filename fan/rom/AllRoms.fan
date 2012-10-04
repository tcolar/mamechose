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
  const Str mameVersion 
  
  Str:Rom roms := [:]
  
  new make(Str mameVersion)
  {
    this.mameVersion = mameVersion
  }
  
  ** Make from json map
  static AllRoms? fromMo(Map? mo)
  {
    if(mo == null)
      return null
    allRoms := AllRoms(mo["mameVersion"] as Str ?: "Unknown")
    roms := (Map?) mo["roms"]
    roms?.each |v, k|
    {
      rom := Rom.fromMo(v)
      if(rom != null)
        allRoms.roms[k] = rom
    }
    return allRoms
  }
}