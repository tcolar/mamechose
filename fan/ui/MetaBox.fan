//
// History:
//   Oct 3, 2012 tcolar Creation
//
using gfx
using fwt

**
** MetaBox
**
class MetaBox : ContentBox
{
  File snapFolder
  
  private Rom? curRom
  
  Color text := Color.white
  
  Int gap
  
  new make(Rect bounds, Int fontSize) : super(bounds, fontSize) 
  {
    config := Service.find(Config#) as Config
    snapFolder = config.snapFolder 
    this.fontSize = fontSize
    gap = (fontSize * 1.6f).toInt
  }
  
  Void showRom(Rom? rom)
  {
    if(rom != null)
    {  
      curRom = rom
      repaint
    }  
  }
  
  override Void paintContents(Graphics g)
  {
    if(curRom != null)
    {        
      g.clip(Rect(gap, 0, size.w - (gap * 2), size.h))
  
      g.font = Font.fromStr("${fontSize}pt Arial Bold")
      g.brush = text
    
      g.drawText(curRom.desc, gap, gap / 2)
    
      imgMaxH := size.h - gap * 3
      imgMaxW := (size.w - gap * 2) / 2  
      img := RomHelper.getSnapshot(curRom)
      if(img != null)
      {  
        imgSize := img.size
        ratio1 := imgMaxH / imgSize.h.toFloat
        ratio2 := imgMaxW / imgSize.w.toFloat
        ratio := ratio1 < ratio2 ? ratio1 : ratio2
        try
        {  
          img2 := img.resize(Size((imgSize.w * ratio).toInt, (imgSize.h * ratio).toInt))
          x := gap + (imgMaxW - img2.size.w) / 2 
          y := gap * 2 + (imgMaxH - img2.size.h) / 2
          g.drawImage(img2, x, y)
          img2.dispose
        } catch(Err e) {} //  resize sometimes fails, not sure why
        img.dispose
      }
      x := size.w /2 + gap / 2
      y := gap * 2
      
      g.drawText("Name: $curRom.name", x, y); y+=gap
      g.drawText("Status: $curRom.status", x, y); y+=gap
      g.drawText("Cat.: $curRom.category", x, y); y+=gap
      g.drawText("Pub.: $curRom.publisher", x, y); y+=gap
      g.drawText("Year: $curRom.year", x, y); y+=gap
      clone := curRom.cloneOf ?: "N/A"
      g.drawText("CloneOf: $clone", x, y); y+=gap
      g.drawText("NbPlayers: $curRom.nbPlayers", x, y); y+=gap
      installed := curRom.installed ?: "N/A"
      g.drawText("Installed: $installed", x, y); y+=gap
      verified := curRom.verified ?: "N/A"
      g.drawText("Verified: $verified", x, y); y+=gap
    }
  }
}