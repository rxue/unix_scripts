import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.generic import NumberObject
from PyPDF4.pdf import PageObject, PdfFileReader
from helper import intToRoman
from Page import Page
import glob
import os

def searchFromPdf(path:str,keyword:str) -> List[Page]:
    pdf = pypdf.PdfFileReader(open(path, "rb"))
    if pdf.isEncrypted:
        pdf.decrypt('')
    numberOfPages = pdf.getNumPages()
    pageLabels = None
    try:
        pageLabels = pdf.trailer["/Root"]["/PageLabels"]["/Nums"]
    except KeyError as e:
        print('KeyError in argument', e.args)
    result = []
    for pageIndex in range(0,numberOfPages):
        page = pdf.getPage(pageIndex)
        text = page.extractText()
        print("DEBUG::",text)
        if keyword in text:
            result.append(Page(pageLabels, (pageIndex,numberOfPages), page))
    return result
    
def searchFromDirectory(directory:str,keyword:str) -> list:
    result = []
    for filePath in glob.iglob(directory + '**/**', recursive=True):
        if not os.path.isdir(filePath):
            if filePath.endswith('.pdf'):
                singleSearchResult = searchFromPdf(filePath,keyword)
                if len(singleSearchResult) > 0:
                    result.append((filePath, singleSearchResult))
    return result

if __name__ == '__main__':
    resultList = searchFromPdf(sys.argv[1], sys.argv[2])
    i = 0
    for page in resultList:
        if i < 5:
            print(page)
            print("\n\n\n")     
        i = i + 1