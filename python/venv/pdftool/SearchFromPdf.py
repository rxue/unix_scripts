import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.pdf import PageObject, PdfFileReader
from pdfminer import high_level
from helper import intToRoman
from PdfMinerClient import searchFromPdfWithPdfMiner
from Page import Page
import glob
import os

def searchFromPdf(filePath:str,keyword:str) -> List[Page]:
    pdf = pypdf.PdfFileReader(open(filePath, "rb"))
    if pdf.isEncrypted:
        pdf.decrypt('')
    numberOfPages = pdf.getNumPages()
    pageLabels = None
    try:
        pageLabels = pdf.trailer["/Root"]["/PageLabels"]["/Nums"]
    except KeyError as e:
        print('KeyError in argument', e.args)
    result = []
    pageIndexWithPageTextList = searchFromPdfWithPdfMiner(filePath, keyword)
    for pageIndexWithPageText in pageIndexWithPageTextList:
        occurrences = pageIndexWithPageText[1].lower().count(keyword.lower())
        result.append(Page(pageLabels, (pageIndexWithPageText[0],numberOfPages), pageIndexWithPageText[1], occurrences))
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
    path = sys.argv[1]
    if os.path.isdir(path):
        resultList = searchFromDirectory(path, sys.argv[2])
    for filePath, pageList in resultList:
        occurrences = sum(page.occurrences for page in pageList)
        print(filePath, "has", occurrences, "occurrences")