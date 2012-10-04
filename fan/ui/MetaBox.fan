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
  
  new make(|This| f) : super(f) 
  {
    config := Service.find(Config#) as Config
    snapFolder = config.snapFolder 
  }
  
  override Void paintContents(Graphics g)
  {
    fontSize := 22 * window.bounds.h / 1000 
    gap := (fontSize * 1.6f).toInt
    g.font = Font.fromStr("${fontSize}pt Arial Bold")
    g.brush = Color.white
    
    g.drawText("Blah Blah Blah blah blah", 30, 30)
    
    // TODO: Keep aspect ratio during resize
    imgMaxH := size.h - 80
    imgMaxW := (size.w - 60) / 2  
    img := Image.makeFile(snapFolder.plus(`abcop.png`))
    imgSize := img.size
    ratio1 := imgMaxH / imgSize.h.toFloat
    ratio2 := imgMaxW / imgSize.w.toFloat
    ratio := ratio1 < ratio2 ? ratio1 : ratio2
    img = img.resize(Size((imgSize.w * ratio).toInt, (imgSize.h * ratio).toInt))
    x := 30 + (imgMaxW - img.size.w) / 2 
    y := 60 + (imgMaxH - img.size.h) / 2
    g.drawImage(img, x, y)
  }
}