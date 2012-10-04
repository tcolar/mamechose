//
// History:
//   Oct 2, 2012 tcolar Creation
//

**
** Config
**
const class Config : Service
{
  const File confFile
  const File romInfoFile
  const File crcInfoFile
  const File listXml
    
  const File? mameExec
  const File? romFolder
  const File? snapFolder
  
  new make(File f)
  {
    if(! f.exists)
      throw Err("Missing config file : $f")
      
    confFile = f.normalize
    echo("Config file: $confFile.osPath")
    
    romInfoFile = confFile.parent.plus(`mamechose-roms.json`)
    crcInfoFile = confFile.parent.plus(`mamechose-crc.json`)
    listXml = confFile.parent.plus(`mame-list.xml`)
      
    confFile.readAllLines.each |line|
    {
      if( ! line.isEmpty && line[0] != '#' && line.contains("="))
      {
        parts := line.split('=')
        k := parts[0].trim
        v := parts[1 .. -1].join.trim
        if(k == "mame.executable")
          mameExec = File.os(v).normalize
        else if(k == "rom.folder")
          romFolder = File.os(v).normalize
        else if(k == "snap.folder")
          snapFolder = File.os(v).normalize
      }        
    }
    
    // validate
    if(mameExec==null || !mameExec.exists || mameExec.isDir)
      throw Err("Missing or invalid mame.executable")
        
    if(romFolder==null || !romFolder.exists || !romFolder.isDir)
      throw Err("Missing or invalid rom.folder")
        
    if(snapFolder==null || !snapFolder.exists || !snapFolder.isDir)
      throw Err("Missing or invalid snap.folder")
  }  
}