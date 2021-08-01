from PyPDF4.generic import NumberObject
from helper import intToRoman

class Page:
    def __init__(self, pageLabels, pageIndexWithPageCount, pageText):
        self.__pageLabels = pageLabels
        self.__pageIndex = pageIndexWithPageCount[0]
        self.__pageCount = str(pageIndexWithPageCount[1])
        self.__pageText = pageText
    # Reference: https://www.w3.org/TR/WCAG20-TECHS/PDF17.html
    def getLogicalPageNumber(self) -> str:
        if self.__pageLabels is None:
            return None
        leftBound = -1
        rightBound = self.__pageIndex
        dicionary = None
        for pageLabelNum in self.__pageLabels:
            if type(pageLabelNum) is NumberObject:
                if pageLabelNum <= self.__pageIndex:
                    leftBound = pageLabelNum
                else:
                    rightBound = pageLabelNum
                    break
            else:
                dictionary = pageLabelNum.getObject()
                if rightBound > self.__pageIndex:
                    break
        keys = dictionary.keys()
        if '/P' in keys:
            return dictionary['/P']
        elif '/S' in keys:
            if dictionary['/S'] == '/r':
                return intToRoman(self.__pageIndex - leftBound + 1).lower()
            elif dictionary['/S'] == '/D':
                return str(self.__pageIndex - leftBound + 1)

    def __pageDescription(self):
        result = str(self.__pageIndex + 1) + ' of ' + self.__pageCount
        if not self.getLogicalPageNumber() is None:
            result = self.getLogicalPageNumber() + ' (' + result + ')'
        return result

    def __str__(self):
        return 'Page ' + self.__pageDescription() + '\n----------------------\n' + self.__pageText    