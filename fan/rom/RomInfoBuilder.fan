//
// History:
//   Oct 1, 2012 tcolar Creation
//
using xml
using netColarUtils

**
** RomInfoBuilder
** Generate a list of all roms that mame support (from mame -listxml output)
const class RomInfoBuilder : Service
{
  static const Config config := Service.find(Config#)
  
  const AllRoms? allRoms
  
  ** Load instance from the files
  new make()
  {
    if(config.romInfoFile.exists)
    {
      in := config.romInfoFile.in
      allRoms = JsonUtils.load(config.romInfoFile.in, AllRoms#)
    }
  }
  
  ** Generate the full list of all the roms from mame list.xml
  ** Note: Needs to be reloaded after that
  internal static Void generateList(File listXml)
  {
    romPlayers := readPlayers()
    romCategories := readCategories()
    
    // TODO: check CRC/SHA1 of roms ... should do during xml parsing so not to have to save all those crc/sha1's'
    
    echo("Parsing all the roms from $listXml, this might take a few minutes ...")
     
    Str:Rom roms := Str:Rom[:]
    
    // use streaming/pull parser as this file is GIGANTIC(~100 MB) and could cause OOM easily
    parser := XParser(listXml.in)
    Str? mameVersion
    
    Str? curRom
    Str? cloneOf
    Str? desc
    Str? publisher
    Str? status
    Str? year
    
    XNodeType? nt
    while((nt = parser.next) != null)
    {
      elem := parser.elem
      switch(elem.name)
      {
        case "mame":
          mameVersion = elem.attr("build").val
        case "game":
          if(nt == XNodeType.elemStart)
          {
            curRom = elem.attr("name").val
            cloneOf = elem.attr("cloneof", false)?.val ?: null
        } 
        else if(nt == XNodeType.elemEnd)
        {
          Str? nbPlayers := "Unknown"
          if(romPlayers.containsKey(curRom))
            nbPlayers = romPlayers[curRom] 
          else if(romPlayers.containsKey(cloneOf?:"-"))
            nbPlayers = romPlayers[cloneOf]
                     
          Str category := "Unknown"
          if(romCategories.containsKey(curRom))
            category = romCategories[curRom] 
          else if(romCategories.containsKey(cloneOf?:"-"))
            category = romCategories[cloneOf]  
           
          installed := config.romFolder.plus(`${curRom}.zip`).exists
         
          roms[curRom] = Rom {
            it.category = category
            it.cloneOf = cloneOf
            it.desc = desc
            it.installed = installed
            it.name = curRom
            it.nbPlayers = nbPlayers
            it.publisher = publisher
            it.status = status
            // TODO : it.verified =
            it.year = year
          }
        }       
        
        case "description":
          if(nt == XNodeType.text)
          desc = parser.text?.val ?: "Unknown"      
        case "year":
          if(nt == XNodeType.text)
          year = parser.text?.val ?: "Unknown"
        case "manufacturer":
          if(nt == XNodeType.text)
          publisher = parser.text?.val ?: "Unknown" 
        case "driver":
          status = elem.attr("status", false)?.val ?: "Unknown"
      } 
    }
    parser.close
    
    if(mameVersion == null)
    {
      echo("Something went wrong, mame version was not found.")
      Env.cur.exit(-1)            
    }
      
    echo("Done ... parsed $roms.size roms") 
        
    JsonUtils.save(config.romInfoFile.out, AllRoms{it.roms=roms; it.mameVersion=mameVersion})
    // TODO: romFolder.plus(`mamechose-crcs.txt`).writeObj(allRoms, ["overwrite":true])
  }

  ** Read the number of players info file
  static Str:Str readPlayers()
  {
    echo("Reading number of players data")
    file := Pod.find("mameChose").file(`/data/external/nplayers.ini`)
    // read data out of the file
    Str:Str romPlayers := [:]
    file.readAllLines.each |line|
    {
      parts := line.split('=')
      if(parts.size == 2)
      {
        romPlayers[parts[0].trim] = parts[1].trim
      }      
    }
    return romPlayers    
  }

  ** Read the categories info file
  static Str:Str readCategories()
  {
    echo("Reading category data")
    file := Pod.find("mameChose").file(`/data/external/Catver.ini`)
    // read data out of the file
    Str:Str romCategories := [:]
    Bool started
    file.readAllLines.eachWhile |Str line -> Str?|
    {
      if(! started)
      {
        if(line.trim.startsWith("[Category"))
          started = true
        return null
      }  
      if(line.startsWith("["))
        return "done" // we reached some other ini part we don't care about'
      parts := line.split('=')
      if(parts.size == 2)
      {
        romCategories[parts[0].trim] = parts[1].trim
      } 
      return null    
    }
    return romCategories
  }
  
  Void validateRoms()
  {
    // TODO, using mamechose-crc.txt
  }  
}