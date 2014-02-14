import unittest
import os
import testLib
        
class TestMySignup(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddMultiple(self):
        user1 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u1', 'password' : 'p1'} )
        self.assertResponse(user1, count = 1)
        user2 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u2', 'password' : 'p2'} )
        self.assertResponse(user2, count = 1)

    def testAddFailureNoUser(self):
        user7 = self.makeRequest("/users/add", method="POST", data = { 'user' : '', 'password' : 'password'} )
        self.assertResponse(user7, count = None, errCode = -3)
        
    def testAddFailureBadPass(self):
        badPass = ''
        for i in range(0, 150):
            badPass = badPass + 'b'
        user7 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u8', 'password' : badPass } )
        self.assertResponse(user7, count = None, errCode = -4)

class TestMyLogin(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLoginCount(self):
        user3 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u3', 'password' : 'p3'} )
        self.assertResponse(user3, count = 1)
        user3 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u3', 'password' : 'p3'} )
        self.assertResponse(user3, count = 2)
        
    def testLoginMultipleCount(self):
        user4 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u4', 'password' : 'p4'} )
        self.assertResponse(user4, count = 1)
        user4 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u4', 'password' : 'p4'} )
        user4 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u4', 'password' : 'p4'} )
        self.assertResponse(user4, count = 3)

        user5 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u5', 'password' : 'p5'} )
        self.assertResponse(user5, count = 1)
        user5 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u5', 'password' : 'p5'} )
        user5 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u5', 'password' : 'p5'} )
        user5 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u5', 'password' : 'p5'} )
        self.assertResponse(user5, count = 4)

    def testLoginFailure(self):
        user6 = self.makeRequest("/users/add", method="POST", data = { 'user' : 'u6', 'password' : 'p6'} )
        self.assertResponse(user6, count = 1)

        user6 = self.makeRequest("/users/login", method="POST", data = { 'user' : 'u6', 'password' : 'p6'} )
        self.assertResponse(user6, count = 2)

        badCred = self.makeRequest("/users/login", method="POST", data = { 'user' : 'BADUSER', 'password' : 'BADPASS'} )
        self.assertResponse(badCred, count = None, errCode = -1)