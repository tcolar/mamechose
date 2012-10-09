//
// History:
//   Oct 4, 2012 tcolar Creation
//
using fwt

**
** Scrollable List helper
**
mixin Scrollable
{
  abstract Int scrollIndex // current index
  abstract Int scrollTop // current index of first showing item
  abstract Int scrollSize // size of the scroll (where to wrap around)
  abstract Int scrollItems // How many items total we have to scroll though

  ** scroll by offset : can be negative or positive
  Int scroll(Int offset := 1)
  {
    return (offset > 0) ? scrollDown(offset) : scrollUp(offset.negate)
  }

  ** scroll down the list
  internal Int scrollDown(Int by)
  {
    scrollIndex += by
    if(scrollIndex >= scrollTop + scrollSize)
    { 
      //scroll down 
      scrollTop += by
    }
    if(scrollIndex >= scrollItems)
    {
      // roll back to top  
      scrollTop = 0
      scrollIndex = 0  
    }  
    if(scrollTop >= scrollItems)
      scrollTop = 0
    if(scrollTop > scrollItems - scrollSize)
      scrollTop = scrollItems - scrollSize
    if(scrollTop < 0)
      scrollTop = 0  
    return scrollIndex
  }
  
  internal Int scrollUp(Int by)
  {
    scrollIndex -= by
    if(scrollIndex < 0)
    {
      // scroll to lits bottom
      scrollIndex = scrollItems - 1
      scrollTop = scrollItems - scrollSize  
    }    
    if(scrollIndex < scrollTop)
    {  
      // scroll down 1
      scrollTop -= by
    }  
    if(scrollTop < 0)
      scrollTop = 0
    return scrollIndex  
  }
}