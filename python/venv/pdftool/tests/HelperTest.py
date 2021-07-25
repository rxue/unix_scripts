import os, sys
currentdir = os.path.dirname(os.path.realpath(__file__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

from helper import intToRoman
import unittest

class TestHelper(unittest.TestCase):
    def test_intToRoman(self):
        with self.assertRaises(ValueError):
            intToRoman(0)
        self.assertEqual(intToRoman(1), 'I')
        self.assertEqual(intToRoman(2), 'II')
        self.assertEqual(intToRoman(4), 'IV')
        self.assertEqual(intToRoman(5), 'V')
        self.assertEqual(intToRoman(6), 'VI')
        self.assertEqual(intToRoman(7), 'VII')
        self.assertEqual(intToRoman(2944), 'MMCMXLIV')
        with self.assertRaises(ValueError):
            intToRoman(4000)

if __name__ == '__main__':
    unittest.main()
