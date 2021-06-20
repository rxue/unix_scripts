import sys
from PyPDF2 import PdfFileReader
def searchFromFile(path:str,keyword:str) -> list:
    with open(path, 'rb') as f:
        pdf = PdfFileReader(f)
        numberOfPages = pdf.getNumPages()
        result = []
        for pageNumber in range(0, numberOfPages):
            page = pdf.getPage(pageNumber)
            if keyword in page.extractText():
                result.append(page)
        return result

if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    for page in resultList:
        print(page.extractText())