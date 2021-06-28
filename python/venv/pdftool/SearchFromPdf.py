import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.generic import NumberObject
from PyPDF4.pdf import PageObject, PdfFileReader

def _getLogicalPageNumber(pageLabelNums:list,pageIndex:int):
    leftBound = -1
    rightBound = -1
    bothBoundsFound = False
    dicionary = None
    for pageLabelNum in pageLabelNums:
        if type(pageLabelNum) is NumberObject:
            if pageLabelNum <= pageIndex:
                leftBound = pageLabelNum
                if pageLabelNum == pageIndex:
                    rightBound = pageLabelNum
                    bothBoundsFound = True
            else:
                rightBound = pageLabelNum
                break
        else:
            dictionary = pageLabelNum.getObject()
            if bothBoundsFound:
                break
    key = dictionary.keys()
    if '/P' in key:
                print(dictionary['/P'])
        

def searchFromFile(path:str,keyword:str) -> List[PageObject]:
    pdf = pypdf.PdfFileReader(open(path, "rb"))
    if pdf.isEncrypted:
        pdf.decrypt('')
    numberOfPages = pdf.getNumPages()
    pageLabelNums = pdf.trailer["/Root"]["/PageLabels"]["/Nums"]
    print(pageLabelNums)
    result = []
    for pageIndex in range(0,numberOfPages):
        page = pdf.getPage(pageIndex)
        text = page.extractText()
        if keyword in text:
            result.append(page)
    return result
    
if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    #for page in resultList:
    #    print("page content:",page.extractText())
    #    print("\n\n\n")     