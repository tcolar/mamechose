//
// History:
//   Oct 1, 2012 tcolar Creation
//
using xml
using util

**
** RomInfoBuilder
** Generate a list of all roms that mame support (from mame -listxml output)
class RomInfoBuilder
{
  Config config
  
  AllRoms? allRoms
  // TODO: crc
  
  new make(Config config)
  {
    this.config = config
  }
  
  ** Load instance from the files
  RomInfoBuilder load()
  {
    if(config.romInfoFile.exists)
    {
      in := config.romInfoFile.in
      Map? map := JsonInStream(config.romInfoFile.in).readJson
      in.close 
      allRoms = AllRoms.fromMo(map)
    } 
    return this 
  }
  
  ** Generate the full list of all the roms from mame list.xml
  internal Void generateList(File listXml)
  {
    // TODO: check CRC/SHA1 of roms ... should do during xml parsing so not to have to save all those crc/sha1's'
    
    echo("Parsing all the roms from $listXml, this might take a few minutes ...")
     
    Str:Rom roms := Str:Rom[:]
    
    // use streaming/pull parser as this file is GIGANTIC(~100 MB) and could cause OOM easily
    parser := XParser(listXml.in)
    Str? mameVersion
    Rom? curRom
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
            curRom = Rom(elem.attr("name").val)
            curRom.cloneOf = elem.attr("cloneof", false)?.val ?: null
        } 
        else if(nt == XNodeType.elemEnd)
        {
          roms[curRom.name] = curRom
        }       
        
        case "description":
          if(nt == XNodeType.text)
          curRom.desc = parser.text?.val ?: "Unknown"      
        case "year":
          if(nt == XNodeType.text)
          curRom.year = parser.text?.val ?: "Unknown"
        case "manufacturer":
          if(nt == XNodeType.text)
          curRom.publisher = parser.text?.val ?: "Unknown" 
        case "driver":
          curRom.status = elem.attr("status", false)?.val ?: "Unknown"
      } 
    }
    parser.close
    
    if(mameVersion == null)
    {
      echo("Something went wrong, mame version was not found.")
      Env.cur.exit(-1)            
    }
      
    allRoms = AllRoms(mameVersion)
    allRoms.roms = roms
    echo("Done ... parsed $roms.size roms") 
    
    populatePlayers
    populateCategories
    populateInstalled
    
    JsonOutStream(config.romInfoFile.out).writeJson(allRoms).close
    // TODO: romFolder.plus(`mamechose-crcs.txt`).writeObj(allRoms, ["overwrite":true])
  }

  ** Populate the list with the number of players information
  AllRoms populatePlayers()
  {
    echo("Adding number of players data")
    file := this.typeof.pod.file(`/data/external/nplayers.ini`)
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
    // populate romList
    allRoms.roms.each |rom| 
    {
      if(romPlayers.containsKey(rom.name))
        rom.nbPlayers = romPlayers[rom.name] 
      else if(romPlayers.containsKey(rom.cloneOf?:"-"))
        rom.nbPlayers = romPlayers[rom.cloneOf]                 
    }
    return allRoms
  }

  ** Populate the list with categories
  AllRoms populateCategories()
  {
    echo("Adding category data")
    file := this.typeof.pod.file(`/data/external/Catver.ini`)
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
    // populate romList
    allRoms.roms.each |rom| 
    {
      if(romCategories.containsKey(rom.name))
        rom.category = romCategories[rom.name] 
      else if(romCategories.containsKey(rom.cloneOf?:"-"))
        rom.category = romCategories[rom.cloneOf]   
    }
    return allRoms
  }
  
  Void populateInstalled()
  {
    echo("Adding installed or not data")
    allRoms.roms.each |rom| 
    {
        rom.installed = config.romFolder.plus(`${rom.name}.zip`).exists
    }
  }
  
  Void validateRoms()
  {
    // TODO, using mamechose-crc.txt
  }  
}