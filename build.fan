
//
// History:
//   Oct 1, 2012  tcolar  Creation
//
using build

**
** Build: mameChose
**
class Build : BuildPod
{
  new make()
  {
    podName = "mameChose"
    summary = "Mame chose is a Mame Cabnet frontend, meant to be simple but powerful."
    depends = ["sys 1.0+", "fwt 1.0+", "gfx 1.0+", "xml 1.0+", "util 1.0+", "concurrent 1.0+"]
    srcDirs = [`fan/`, `fan/ui/`, `fan/rom/`]
    resDirs = [`data/external/`]
  }
}
