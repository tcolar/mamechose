//
// History:
//   Oct 2, 2012 tcolar Creation
//
using fwt

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
  
  const Str keyUp := Key.up.toStr
  const Str keyDown := Key.down.toStr 
  const Str keyLeft := Key.left.toStr
  const Str keyRight := Key.right.toStr 
  const Str keyStart := Key.num1.toStr 
  const Str keyCoin := Key.num5.toStr 
  const Str keyQuit := Key.esc.toStr 
  const Str keyButton1 := Key.ctrl.toStr 
  const Str keyButton2 := Key.alt.toStr 
  
  const Str[] mameGlobalArgs := [,] 
  const Str:Str[] mameRomArgs := [:] 
  
  new make(File f)
  {
    if(! f.exists)
      throw Err("Missing config file : $f")
      
    confFile = f.normalize
    echo("Config file: $confFile.osPath")
    
    romInfoFile = confFile.parent.plus(`mamechose-roms.json`)
    crcInfoFile = confFile.parent.plus(`mamechose-crc.json`)
    listXml = confFile.parent.plus(`mame-list.xml`)
    
    Str:Str[] romArgs := [:]    
    confFile.readAllLines.each |line|
    {
      if( ! line.isEmpty && line[0] != '#' && line.contains("="))
      {
        parts := line.split('=')
        k := parts[0].trim
        v := parts[1 .. -1].join("=").trim
        if(k == "mame.executable")
          mameExec = File.os(v).normalize
        else if(k == "rom.folder")
          romFolder = File.os(v).normalize
        else if(k == "snap.folder")
          snapFolder = File.os(v).normalize
        else if(k == "key.up")
          keyUp = v
        else if(k == "key.down")
          keyDown = v
        else if(k == "key.left")
          keyLeft = v
        else if(k == "key.right")
          keyRight = v
        else if(k == "key.quit")
          keyQuit = v
        else if(k == "key.start")
          keyStart = v
        else if(k == "key.button1")
          keyButton1 = v
        else if(k == "key.button2")
          keyButton2 = v
        else if(k == "key.coin")
          keyCoin = v
        else if( k == "mame.args.global")
          mameGlobalArgs = v.split(' ')
        else if( k.startsWith("mame.args.rom."))
          romArgs[k[k.indexr(".")+1 .. -1]] = v.split(' ')
      }        
    }
    mameRomArgs = romArgs
    
    // validate
    if(mameExec==null || !mameExec.exists || mameExec.isDir)
      throw Err("Missing or invalid mame.executable")
        
    if(romFolder==null || !romFolder.exists || !romFolder.isDir)
      throw Err("Missing or invalid rom.folder")
        
    if(snapFolder==null || !snapFolder.exists || !snapFolder.isDir)
      throw Err("Missing or invalid snap.folder")
  }  
}