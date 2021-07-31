import unittest
from unittest.mock import Mock
import os, sys
currentdir = os.path.dirname(os.path.realpath(__file__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

from Page import Page 
from PyPDF4.generic import NumberObject

#https://www.youtube.com/watch?v=6tNS--WetLI&t=468s
class TestPage(unittest.TestCase):
    def testGetLogicalPageNumber_None(self):
        page = Page(None, (0,100), Mock())
        result = page.getLogicalPageNumber()
        self.assertEqual(result, None)

    def testGetLogicalPageNumber(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        page = Page([NumberObject(0), pageLabelNum], (0,100), Mock())
        result = page.getLogicalPageNumber()
        self.assertEqual(result, 'Cover')

    def testGetLogicalPageNumber_LowerCaseRoman(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        pageLabelNum2 = Mock()
        pageLabelNum2.getObject.return_value = {'/S':'/r'}
        page = Page([NumberObject(0), pageLabelNum, NumberObject(1), pageLabelNum2], (1,100), Mock())
        result = page.getLogicalPageNumber()
        self.assertEqual(result, 'i')

    def testGetLogicalPageNumber_NormalNumberAfterRoman(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        pageLabelNum2 = Mock()
        pageLabelNum2.getObject.return_value = {'/S':'/r'}
        pageLabelNum3 = Mock()
        pageLabelNum3.getObject.return_value = {'/S':'/D'}
        pageLabels = [NumberObject(0), pageLabelNum, NumberObject(1), pageLabelNum2, NumberObject(23), pageLabelNum3]
        page1 = Page(pageLabels, (23,100), Mock())
        self.assertEqual(page1.getLogicalPageNumber(), '1')
        page2 = Page(pageLabels, (24,100), Mock())
        self.assertEqual(page2.getLogicalPageNumber(), '2')

if __name__ == '__main__':
    unittest.main()

