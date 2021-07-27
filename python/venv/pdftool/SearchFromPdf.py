import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.generic import NumberObject
from PyPDF4.pdf import PageObject, PdfFileReader
from helper import intToRoman
from Page import Page

def test_getLogicalPageNumber0():
    return 0

# Reference: https://www.w3.org/TR/WCAG20-TECHS/PDF17.html
def _getLogicalPageNumber(pageLabelNums:list,pageIndex:int):
    leftBound = -1
    rightBound = pageIndex
    dicionary = None
    for pageLabelNum in pageLabelNums:
        if type(pageLabelNum) is NumberObject:
            if pageLabelNum <= pageIndex:
                leftBound = pageLabelNum
            else:
                rightBound = pageLabelNum
                break
        else:
            dictionary = pageLabelNum.getObject()
            if rightBound > pageIndex:
                break
    keys = dictionary.keys()
    if '/P' in keys:
        return dictionary['/P']
    elif '/S' in keys:
        if dictionary['/S'] == '/r':
            return intToRoman(pageIndex - leftBound + 1).lower()
        elif dictionary['/S'] == '/D':
            return pageIndex - leftBound + 1
def searchFromFile(path:str,keyword:str) -> List[Page]:
    pdf = pypdf.PdfFileReader(open(path, "rb"))
    if pdf.isEncrypted:
        pdf.decrypt('')
    numberOfPages = pdf.getNumPages()
    pageLabels = pdf.trailer["/Root"]["/PageLabels"]["/Nums"]
    result = []
    for pageIndex in range(0,numberOfPages):
        page = pdf.getPage(pageIndex)
        text = page.extractText()
        if keyword in text:
            result.append(Page(pageLabels, pageIndex, page))
    return result
    
if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    for page in resultList:
        print(page)
        print("\n\n\n")     