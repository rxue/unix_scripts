import unittest
from unittest.mock import Mock
import os, sys
currentdir = os.path.dirname(os.path.realpath(__file__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

import SearchFromPdf
from PyPDF4.generic import NumberObject
from SearchFromPdf import _getLogicalPageNumber

#https://www.youtube.com/watch?v=6tNS--WetLI&t=468s
class TestSearchFromPdf(unittest.TestCase):
    def test_getLogicalPageNumber(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        result = _getLogicalPageNumber([NumberObject(0), pageLabelNum], 0)
        self.assertEqual(result, 'Cover')

    def test_getLogicalPageNumber_LowerCaseRoman(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        pageLabelNum2 = Mock()
        pageLabelNum2.getObject.return_value = {'/S':'/r'}
        result = _getLogicalPageNumber([NumberObject(0), pageLabelNum, NumberObject(1), pageLabelNum2], 1)
        self.assertEqual(result, 'i')

if __name__ == '__main__':
    unittest.main()

