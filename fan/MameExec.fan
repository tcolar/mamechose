//
// History:
//   Oct 3, 2012 tcolar Creation
//
using concurrent

**
** MameExec
**
const class MameExec : Service
{
  const File mame
  const Config config
  
  new make(Config config)
  { this.config = config
    this.mame = config.mameExec
  }
  
  ** Retrieve mame version, such as 0.142b
  Str getVersion()
  {
    p := Process([mame.osPath, "-h"])
    buf := Buf()
    p.out = buf.out
    p.run.join
    line :=  buf.flip.readLine
    return line[10 .. line.index(")", 10)].trim
  }
  
  ** Generate the list.xml (full blown rom list)
  Void listXml(File to)
  {
    echo("Calling mame -list.xml to get the rom list. Might take a few minutes !")
    p := Process([mame.osPath, "-listxml"])
    p.out = to.out
    p.run.join
    p.out.flush    
    p.out.close
  }
  
  ** Starts a mame game
  Void startGame(Str romName)
  {
    // TODO: append to gameplayed.txt if never played before ?
    echo("Starting game: $romName")
    p := Process([mame.osPath, romName])
    p.run
  }
}