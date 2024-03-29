
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
    summary = "MameChose is a MAME Cabinet frontend with powerful ROM search & filtering."
    depends = ["sys 1.0+", "fwt 1.0+", "gfx 1.0+", "xml 1.0+", "util 1.0+", "concurrent 1.0+", "netColarUtils 0.0.2+"]
    srcDirs = [`fan/`, `fan/ui/`, `fan/rom/`, `fan/rom/list/`]
    resDirs = [`data/external/`]
    version = Version("1.0.0")
    meta = ["vcs.uri" : "https://bitbucket.org/tcolar/mamechose", "license.name" : "MIT"]
  }
}