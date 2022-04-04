import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(1 + 1, 2, "Test fail - First value and second value are not equal !")

if __name__ == '__main__':
    unittest.main()
