import os, sys
currentdir = os.path.dirname(os.path.realpath(__file__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

from helper import intToRoman
import unittest

class TestHelper(unittest.TestCase):
    def test_intToRoman(self):
        self.assertEqual(intToRoman(1), 'I')
        self.assertEqual(intToRoman(4), 'IV')
        self.assertEqual(intToRoman(2944), 'MMCMXLIV')

if __name__ == '__main__':
    unittest.main()
