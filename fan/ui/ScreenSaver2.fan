// History:
//  Jan 01 13 tcolar Creation
//
using fwt
using gfx

**
** ScreenSaver2 : Scaled o fit screen ROM images with name/description
**
class ScreenSaver2: Canvas
{
  Str[] roms := RomHelper.allRoms.roms.keys

  Int fontSize

  new make(Rect bounds, Int fontSize) : super()
  {
    this.bounds = bounds
    visible = false
    this.fontSize = fontSize
  }

  override Void onPaint(Graphics g)
  {
    g.brush = Color.black
    g.fillRect(0, 0, bounds.w -1 , bounds.h -1)

    if( ! roms.isEmpty)
    {
      Rom? rom := (0..50).toList.eachWhile |Int i, Int index -> Rom?|
      {
        romName := roms[Int.random(0 .. roms.size-1)]
        r := RomHelper.rom(romName)
        if(RomHelper.hasSnapshot(r) && ! r.category.lower.contains("mature"))
          return r
        return null
      }

      if(rom == null) return

      img := RomHelper.getSnapshot(rom)
      if(img != null)
      {
        imgSize := img.size
        ratio1 := bounds.h / imgSize.h.toFloat
        ratio2 := bounds.w / imgSize.w.toFloat
        ratio := ratio1 < ratio2 ? ratio1 : ratio2
        try
        {
          img2 := img.resize(Size((imgSize.w * ratio).toInt, (imgSize.h * ratio).toInt))
          x := (bounds.w - img2.size.w) / 2
          y := (bounds.h - img2.size.h) / 2
          g.drawImage(img2, x, y)
          img2.dispose
        } catch(Err e) {e.trace} //  resize sometimes fails, not sure why
        img?.dispose
      }
      text := "[${rom.name}] - $rom.desc"
      g.alpha = 150
      g.brush = Color.black
      g.fillRect(0, bounds.h - fontSize * 2, bounds.w, bounds.h)
      g.font = Font.fromStr("${fontSize}pt Arial Bold")
      g.brush = Color.yellow
      g.alpha = 255
      g.drawText(text, 20, bounds.h - fontSize * 2)
    }
  }
}