//
// History:
//   Oct 1, 2012 tcolar Creation
//
using util

**
** Main
**
class Main : AbstractMain
{
  @Opt { help = "List missing roms"; aliases=["m"] }
  Bool listMissing := false
  
  @Opt { help = "List invalid roms"; aliases=["i"] }
  Bool listInvalid := false
  
  @Opt { help = "Fully regenerate the ROM list from mame infos (do this after mame is updated)"; aliases=["g"] }
  Bool generate := false
  
  //@Opt { help = "Fully revalidate the roms, check for corrupt or wrong version roms (slow)"; aliases=["v"] }
  //Bool validate := false
  
  @Opt { help = "Config file path (mamechose.conf)"; aliases=["c"] }
  Str? configPath
  
  **
  ** Main method
  **
  override Int run()
  {
    in := Env.cur.in
    
    if(configPath == null)
    {
      echo("It is required to provide the config file (-c option)")
      Env.cur.exit(-1)
    }  
    
    Config conf := Config(File.os(configPath))
    conf.install
    
    mameExec := MameExec(conf)
    mameExec.install
    
    Str mameVersion := mameExec.getVersion
    echo("Mame Version: $mameVersion")
    
    romInfo := RomInfoBuilder(conf).load
    
    if(generate)
    { 
      doGenerate(mameExec, conf, romInfo)     
    }  
    
    /*if(validate)
    {      
    doValidate
    }*/
    romInfoVersion := romInfo.allRoms?.mameVersion ?: "Missing"
    echo("RomInfo version: $romInfoVersion")
    
    if(romInfo.allRoms == null || romInfoVersion != mameVersion)
    {
      echo("!! The roms have never been indexed for the current mame version ($mameVersion).")
      echo("?? Would you like to index them now? (HIGHLY recommanded) : Y/n")
      answer := in.readLine()
      if(answer.lower != "n")
        doGenerate(mameExec, conf, romInfo)
      /*echo("Would you like to also verify the roms are valid (recommanded but slow) : Y/n")
      answer = in.readLine()
      if(answer.lower != "n")
      doValidate*/
    }  
    
    if(listMissing)
    {
      
    } 
    else if(listInvalid)
    {
      
    }
    else
    {    
      echo(RomHelper.countInfo(romInfo.allRoms.roms)) 
      roms := romInfo.allRoms?.roms?.vals ?: [,]
      // sort alphabeticaly by description
      roms.sort |Rom a, Rom b -> Int| {a.desc <=> b.desc}   
      MainWindow(roms).open
    } 
    
    return 0 
  }
  
  Void doGenerate(MameExec mameExec, Config conf, RomInfoBuilder romInfo) 
  {
    // create standard mame list.xml
    mameExec.listXml(conf.listXml)
    // parse it into our own format
    romInfo.generateList(conf.listXml)
  }
  
  Void doValidate() 
  {
    // TODO
  }
}