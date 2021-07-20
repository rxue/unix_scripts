import unittest
from unittest.mock import Mock
import SearchFromPdf
from SearchFromPdf import _getLogicalPageNumber

#https://www.youtube.com/watch?v=6tNS--WetLI&t=468s
class TestSearchFromPdf(unittest.TestCase):
    def test_getLogicalPageNumber(self):
        pageLabelNum = Mock()
        pageLabelNum.getObject.return_value = {'/P':'Cover'}
        result = _getLogicalPageNumber([0, pageLabelNum], 0)
        self.assertEquals(result, 0)


if __name__ == '__main__':
    unittest.main()

