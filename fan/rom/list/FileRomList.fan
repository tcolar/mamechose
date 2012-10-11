
//
// History:
//   Oct 10, 2012 tcolar Creation
//

**
** FileRomList
** File backed ROM list
** Saved as comma separated rom names in a text file
**
class FileRomList : RomList
{
  override Str name
  override Str[] roms := [,]

  new make(Str name)
  {
    this.name = name
    roms.clear
    f := file
    echo(f.osPath)
    if(f.exists)
    {
      f.readAllStr.split(',').each
      {
        val := it.trim
        if(! val.isEmpty)
          roms.add(val)
      }
    }  
  }
  
  ** add a rom, immediately append it to list file if not in this list yet 
  Void add(Str rom)
  {
    if(! roms.contains(rom))
    {  
      roms.add(rom)
      file.out(true).writeUtf(",${rom}").close
    }  
  }
  
  ** add a rom, immediately save the file after the change
  Void remove(Str rom)
  {
    if(roms.contains(rom))
    {  
      roms.remove(rom)
      save
    }  
  }
  
  Void save()
  {
    out := file.out
    try
    {  
      out.writeUtf(roms.join(","))
    }
    finally
    {
      out.close
    }  
  }
  
  ** The file that backs this list
  internal File file() 
  {
    Config config := Service.find(Config#)
    return config.confFile.parent.plus(`mamechose-${name}.list`)
  }  
}