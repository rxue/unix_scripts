import sys
import pdfplumber
def searchFromFile(path:str,keyword:str) -> list:
    with pdfplumber.open(path) as pdf:
        result = []
        for page in pdf.pages:
            pageText = page.extract_text()
            if pageText != None and keyword in pageText:
                result.append(page)
        return result

if __name__ == '__main__':
    resultList = searchFromFile(sys.argv[1], sys.argv[2])
    for page in resultList:
        print(page.extract_text())