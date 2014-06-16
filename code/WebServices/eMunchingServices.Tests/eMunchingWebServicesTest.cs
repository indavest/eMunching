using eMunching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;
using System.Xml;

namespace eMunchingServices.Tests
{
    
    
    /// <summary>
    ///This is a test class for eMunchingWebServicesTest and is intended
    ///to contain all eMunchingWebServicesTest Unit Tests
    ///</summary>
    [TestClass()]
    public class eMunchingWebServicesTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for GetCouponCodes
        ///</summary>
        // TODO: Ensure that the UrlToTest attribute specifies a URL to an ASP.NET page (for example,
        // http://.../Default.aspx). This is necessary for the unit test to be executed on the web server,
        // whether you are testing a page, web service, or a WCF service.
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("E:\\Projects\\emunching\\website-dev\\trunk\\WebServices\\eMunchingServices\\eMunchingServices", "/")]
        [UrlToTest("http://localhost:4629/")]
        public void GetCouponCodesTest()
        {
            eMunchingWebServices target = new eMunchingWebServices(); // TODO: Initialize to an appropriate value
            string UserName = string.Empty; // TODO: Initialize to an appropriate value
            string PassWord = string.Empty; // TODO: Initialize to an appropriate value
            string emailAddress = string.Empty; // TODO: Initialize to an appropriate value
            int restaurantId = 0; // TODO: Initialize to an appropriate value
            bool isRedeemed = false; // TODO: Initialize to an appropriate value
            XmlDocument expected = null; // TODO: Initialize to an appropriate value
            XmlDocument actual;
            actual = target.GetCouponCodes(UserName, PassWord, emailAddress, restaurantId, isRedeemed);
            Assert.AreEqual(expected, actual);
            Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for LoyaltyBootstrap
        ///</summary>
        // TODO: Ensure that the UrlToTest attribute specifies a URL to an ASP.NET page (for example,
        // http://.../Default.aspx). This is necessary for the unit test to be executed on the web server,
        // whether you are testing a page, web service, or a WCF service.
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("E:\\Projects\\emunching\\website-dev\\trunk\\WebServices\\eMunchingServices\\eMunchingServices", "/")]
        [UrlToTest("http://localhost:4629/")]
        public void LoyaltyBootstrapTest()
        {
            eMunchingWebServices target = new eMunchingWebServices(); // TODO: Initialize to an appropriate value
            string UserName = string.Empty; // TODO: Initialize to an appropriate value
            string PassWord = string.Empty; // TODO: Initialize to an appropriate value
            string RestaurantID = string.Empty; // TODO: Initialize to an appropriate value
            string EmailAddress = string.Empty; // TODO: Initialize to an appropriate value
            XmlDocument expected = null; // TODO: Initialize to an appropriate value
            XmlDocument actual;
            actual = target.LoyaltyBootstrap(UserName, PassWord, RestaurantID, EmailAddress);
            Assert.AreEqual(expected, actual);
            Assert.Inconclusive("Verify the correctness of this test method.");
        }
    }
}
