import sys
from typing import List
import PyPDF4 as pypdf
from PyPDF4.pdf import PageObject

def searchFromFile(path:str,keyword:str) -> List[str]:
    pdf = pypdf.PdfFileReader(open(path, "rb"))
    if pdf.isEncrypted:
        pdf.decrypt('')
    numberOfPages = pdf.getNumPages()
    result = [str]
    for pageNumber in range(0,numberOfPages):
        page = pdf.getPage(pageNumber)
        text = page.extractText()
        if keyword in text:
            result.append(text)
    return result
    #try:
    #    page_label_type = pdf.trailer["/Root"]["/PageLabels"]["/Nums"]
    #    print(page_label_type.getObject())
    #    print(page_label_type[3].getObject())
    #except:
    #    print("No /PageLabel object")

if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    for page in resultList:
        print("page content:",page)
        print("\n\n\n")     