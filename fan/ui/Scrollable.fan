//
// History:
//   Oct 4, 2012 tcolar Creation
//

**
** Scrollable List helper
**
mixin Scrollable
{
  abstract Int scrollIndex // current index
  abstract Int scrollTop // current index of first showing item
  abstract Int scrollSize // size of the scroll (where to wrap around)
  abstract Int scrollItems // How many items total we have to scroll though

  Int scrollDown()
  {
    scrollIndex += 1
    if(scrollIndex >= scrollTop + scrollSize)
    { 
      //scroll down 
      scrollTop += 1
    }  
    if(scrollIndex >= scrollItems)
    {
      // roll back to top  
      scrollTop = 0
      scrollIndex = 0  
    }  
    if(scrollTop >= scrollItems)
      scrollTop = 0
    return scrollIndex
  }
  
  Int scrollUp()
  {
    scrollIndex -= 1
    if(scrollIndex < 0)
    {
      // scroll to lits bottom
      scrollIndex = scrollItems - 1
      scrollTop = scrollItems - scrollSize  
    }    
    if(scrollIndex < scrollTop)
    {  
      // scroll down 1
      scrollTop -= 1
    }  
    if(scrollTop < 0)
      scrollTop = 0
    return scrollIndex  
  }
}