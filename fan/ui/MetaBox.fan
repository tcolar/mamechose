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
  
  new make(|This| f) : super(f) 
  {
    config := Service.find(Config#) as Config
    snapFolder = config.snapFolder 
  }
  
  Void showRom(Rom rom)
  {
    curRom = rom
    repaint
  }
  
  override Void paintContents(Graphics g)
  {
    if(curRom != null)
    {  
      fontSize := 22 * window.bounds.h / 1000 
      gap := (fontSize * 1.6f).toInt
      
      g.clip(Rect(gap, 0, size.w - (gap * 2), size.h))
  
      g.font = Font.fromStr("${fontSize}pt Arial Bold")
      g.brush = text
    
      g.drawText(curRom.desc, gap, gap / 2)
    
      // TODO: Keep aspect ratio during resize
      imgMaxH := size.h - gap * 3
      imgMaxW := (size.w - gap * 2) / 2  
      img := Image.makeFile(snapFolder.plus(`${curRom.name}.png`), false)
      if(img != null)
      {  
        imgSize := img.size
        ratio1 := imgMaxH / imgSize.h.toFloat
        ratio2 := imgMaxW / imgSize.w.toFloat
        ratio := ratio1 < ratio2 ? ratio1 : ratio2
        img = img.resize(Size((imgSize.w * ratio).toInt, (imgSize.h * ratio).toInt))
        x := gap + (imgMaxW - img.size.w) / 2 
        y := gap * 2 + (imgMaxH - img.size.h) / 2
        g.drawImage(img, x, y)
        
        img.dispose
      }
      x := size.w /2 + gap / 2
      y := gap * 2
      
      g.drawText("Name: $curRom.name", x, y); y+=gap
      g.drawText("Status: $curRom.status", x, y); y+=gap
      g.drawText("Cat.: $curRom.category", x, y); y+=gap
      g.drawText("Pub.: $curRom.publisher", x, y); y+=gap
      g.drawText("Year: $curRom.year", x, y); y+=gap
      g.drawText("CloneOf: $curRom.cloneOf", x, y); y+=gap
      g.drawText("NbPlayers: $curRom.nbPlayers", x, y); y+=gap
      g.drawText("Installed: $curRom.installed", x, y); y+=gap
      g.drawText("Verified: $curRom.verified", x, y); y+=gap
    }
  }
}