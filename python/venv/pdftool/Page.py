from PyPDF4.generic import NumberObject
from helper import intToRoman

class Page:
    def __init__(self, pageLabels, pageIndex, pageObject):
        self.__pageLabels = pageLabels
        self.__pageIndex = pageIndex
        self.__pageObject = pageObject
    def __getLogicalPageNumber(self):
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

    def __str__(self):
        return 'page ' + self.__getLogicalPageNumber() + ' (' + str(self.__pageIndex) + '): \n----------------------\n' + self.__pageObject.extractText()    