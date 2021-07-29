import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.generic import NumberObject
from PyPDF4.pdf import PageObject, PdfFileReader
from helper import intToRoman
from Page import Page

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
            result.append(Page(pageLabels, (pageIndex,numberOfPages), page))
    return result
    
if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    i = 0
    for page in resultList:
        if i < 5:
            print(page)
            print("\n\n\n")     
        i = i + 1