import sys
from io import StringIO

from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.pdfpage import PDFPage
from pdfminer.pdfparser import PDFParser

# https://pdfminersix.readthedocs.io/en/latest/tutorial/composable.html
def searchFromPdfWithPdfMiner(filePath:str,keyword:str):
    output_string = StringIO()
    with open(filePath, 'rb') as in_file:
        parser = PDFParser(in_file)
        doc = PDFDocument(parser)
        rsrcmgr = PDFResourceManager()
        device = TextConverter(rsrcmgr, output_string, laparams=LAParams())
        interpreter = PDFPageInterpreter(rsrcmgr, device)
        result = []
        pageIndex = 0
        lowerKeyword = keyword.lower()
        for page in PDFPage.create_pages(doc):
            interpreter.process_page(page)
            text = output_string.getvalue()
            if lowerKeyword in text.lower():
                result.append((pageIndex, text))
            pageIndex = pageIndex + 1
            text = ''
            output_string.truncate(0)
            output_string.seek(0)
        return result
if __name__ == '__main__':
    result = searchFromPdfWithPdfMiner(sys.argv[1], sys.argv[2])
    for p in result:
        print(p[1])
        print("-------------------------------------")