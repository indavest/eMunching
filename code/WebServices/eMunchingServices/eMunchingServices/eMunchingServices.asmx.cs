
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Diagnostics;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Xml;
using System.Security.Cryptography;
using System.IO;
using System.Configuration;
using System.Text;
using System.Net.Mail;
using System.Net;
using Utilities;
using Newtonsoft.Json;
using eMunching_Loyalty_DataManager;
using eMunching;

namespace eMunching
{
    [System.Web.Services.WebService(Namespace = "http://emunching.org/")]
    [System.Web.Services.WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class eMunchingWebServices : System.Web.Services.WebService
    {
        string strConn;

        string strSQL;

        //common mail variables that will be used across all the methods in this class
        string RestName;
        string From;
        string Subj;
        string Cc;
        string To;
        string Msg;
        Hashtable connectionObject = ServiceHelper.getDBNamesAndConnectionStrings();


        #region Private Methods

        /// <summary>
        /// This method authenticates the web service request.
        /// </summary>
        /// <param name="UserName">UserName</param>
        /// <param name="PassWord">PassWord</param>
        private static void AuthenticateWebRequest(string UserName, string PassWord)
        {
            if (UserName == null | PassWord == null)
            {
                throw new NullReferenceException("No credentials were specified.");
            }
            else if (UserName == null)
            {
                throw new NullReferenceException("Username was not supplied for authentication.");
            }
            else if (PassWord == null)
            {
                throw new NullReferenceException("Password was not supplied for authentication.");
            }
            else if (UserName != "eMunch" || PassWord != "idnlgeah11")
            {
                throw new Exception("Please pass the proper username and password for this service.");
            }
        }
        #endregion

        #region Public Methods

        /// <summary>
        /// Gets Coupon Codes
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="emailAddress"></param>
        /// <param name="restaurantId"></param>
        /// <returns></returns>
        [WebMethod(Description = "Gets Coupon Codes for a specific restaurant's user")]
        public XmlDocument GetCouponCodes(string UserName, string PassWord, string emailAddress, int restaurantId, bool isRedeemed, string DeviceToken)
        {
            XmlDocument xmlDoc = new XmlDocument();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            string XDtl = "";
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                Repository loyaltyRepository = new Repository();
                List<string> couponCodes = loyaltyRepository.GetCouponCodes(emailAddress, restaurantId, isRedeemed);
                connection.Open();
                command = new SqlCommand("SELECT Count FROM LoyaltyNotifications WHERE DeviceToken='" + DeviceToken + "' AND Restaurant=" + restaurantId + " AND Email='" + emailAddress + "'", connection);
                int Count = Convert.ToInt32(command.ExecuteScalar());
                //TODO:Harsha
                if (couponCodes.Count > 0)
                {
                    XDtl = "<CouponCodes>";
                    foreach (string couponCode in couponCodes)
                    {
                        int isNew = (Count > 0) ? 1 : 0;
                        XDtl += "<CouponCode><Code>" + couponCode + "</Code><IsNew>" + isNew + "</IsNew></CouponCode>";
                        Count--;
                    }
                    XDtl += "</CouponCodes>";
                    xmlDoc.LoadXml(XDtl);
                    return xmlDoc;
                }
                else
                {
                    Output = "<error>No Rows</error>";
                }
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }

            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML Document of Restaurant data")]
        public XmlDocument GetRestaurantsXML(string UserName, string PassWord)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantData", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Restaurants>";
                    while (dr.Read())
                    {
                        XDtl += "<Restaurant><ID>" + dr[0].ToString() + "</ID><Name>" + dr[1].ToString() + "</Name></Restaurant>";
                    }
                    XDtl += "</Restaurants>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML Document of Restaurant Menu Item Groups.")]
        public XmlDocument GetRestaurantsMenuItemGroups_XML(string UserName, string PassWord, string RestID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetMenuItemGroups '" + RestID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantMenuGroups>";
                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();

                        XDtl += "<Group>" + "<ID>" + Str0.Trim() + "</ID>" + "<GroupName>" + Str1.Trim() + "</GroupName>" + "<GroupDesc>" + Str2.Trim() + "</GroupDesc>" + "<GroupImage>" + Str3.Trim() + "</GroupImage>" + "</Group>";
                    }
                    XDtl += "</RestaurantMenuGroups>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }


        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML Document of Restaurant Menu Item Groups.")]
        public XmlDocument GetRestaurantsMenuItemGroupsByParent_XML(string UserName, string PassWord, string RestID, string ParentID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("SELECT * FROM MenuItemGroups WHERE Parent=" + ParentID + " AND Restaurant='" + RestID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantMenuGroups>";
                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        Str0 = dr["MenuItemGroupID"] == null ? "" : dr["MenuItemGroupID"].ToString();
                        Str1 = dr["MenuItemGroup"] == null ? "" : dr["MenuItemGroup"].ToString();
                        Str2 = dr["MenuItemGroupDesc"] == null ? "" : dr["MenuItemGroupDesc"].ToString();
                        Str3 = dr["MenuItemGroupImage"] == null ? "" : dr["MenuItemGroupImage"].ToString();

                        XDtl += "<Group>" + "<ID>" + Str0.Trim() + "</ID>" + "<GroupName>" + Str1.Trim() + "</GroupName>" + "<GroupDesc>" + Str2.Trim() + "</GroupDesc>" + "<GroupImage>" + Str3.Trim() + "</GroupImage>" + "</Group>";
                    }
                    XDtl += "</RestaurantMenuGroups>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserID"></param>
        /// <param name="RestID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns Boolean value of Success|Failure for successfully sending an email with password.")]
        public XmlDocument GetForgottenPassword_XML(string UserName, string PassWord, string UserID, string RestID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetForgottenPwd '" + UserID + "','" + RestID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<ForgottenPwdSent>";
                    while (dr.Read())
                    {
                        To = dr[0].ToString();
                        Cc = dr[1].ToString();
                        Subj = dr[2].ToString();
                        Msg = dr[3].ToString();
                        From = dr[4].ToString();
                        RestName = dr[5].ToString();
                        bool Str0 = (MailHelper.SendMail(To, Cc.Trim(), Subj, Msg, From, RestName)) ? true : false;
                        XDtl += "<EmailSent>" + "<Sent>" + Str0 + "</Sent>" + "</EmailSent>";
                    }
                    XDtl += "</ForgottenPwdSent>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document of Restaurant Menu Items data")]
        public XmlDocument GetRestaurantMenuItems_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantMenuItems '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantMenuItems>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        string Str10 = null;
                        string Str11 = null;
                        string Str12 = null;
                        string Str13 = null;
                        string Str14 = null;
                        string Str15 = null;
                        string Str16 = null;
                        string Str17 = null;
                        string Str18 = null;
                        string Str19 = null;
                        string Str20 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        Str8 = dr[8] == null ? "" : dr[8].ToString();
                        Str9 = dr[9] == null ? "" : dr[9].ToString();
                        Str10 = dr[10] == null ? "" : dr[10].ToString();
                        Str11 = dr[11] == null ? "" : dr[11].ToString();
                        Str12 = dr[12] == null ? "" : dr[12].ToString();
                        Str13 = dr[13] == null ? "" : dr[13].ToString();
                        Str14 = dr[14] == null ? "" : dr[14].ToString();
                        Str15 = dr[15] == null ? "" : dr[15].ToString();
                        Str16 = dr[16] == null ? "" : dr[16].ToString();
                        Str17 = dr[17] == null ? "" : dr[17].ToString();
                        Str18 = dr[18] == null ? "" : dr[18].ToString();
                        Str19 = dr[19] == null ? "" : dr[19].ToString();
                        Str20 = dr["MenuType"] == null ? "" : dr["MenuType"].ToString();
                        XDtl += "<MenuItem>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<RestaurantName>" + Str2.Trim() + "</RestaurantName>" + "<MenuGroup>" + Str3.Trim() + "</MenuGroup>" + "<Breakfast>" + Str4.Trim() + "</Breakfast>" + "<MorningTeaElevenses>" + Str5.Trim() + "</MorningTeaElevenses>" + "<Brunch>" + Str6.Trim() + "</Brunch>" + "<Lunch>" + Str7.Trim() + "</Lunch>" + "<Dinner>" + Str8.Trim() + "</Dinner>" + "<AfternoonTea>" + Str9.Trim() + "</AfternoonTea>" + "<Supper>" + Str10.Trim() + "</Supper>" + "<Item>" + Str11.Trim() + "</Item>" + "<ItemDesc>" + Str12.Trim() + "</ItemDesc>" + "<ItemPrice>" + Str13.Trim() + "</ItemPrice>" + "<ComboPrice>" + Str14.Trim() + "</ComboPrice>" + "<PriceSchedule>" + Str15.Trim() + "</PriceSchedule>" + "<Archive>" + Str16.Trim() + "</Archive>" + "<ChildsPlate>" + Str17.Trim() + "</ChildsPlate>" + "<Veg>" + Str18.Trim() + "</Veg>" + "<ChefSpecial>" + Str19.Trim() + "</ChefSpecial>" + "<MenuItemType>" + Str20.Trim() + "</MenuItemType>" + "</MenuItem>";
                    }

                    XDtl += "</RestaurantMenuItems>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the Restaurant Reservation Configuration")]
        public XmlDocument GetRestaurantResvConfig_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantResvConfig '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantResvConfig>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        XDtl += "<ResvConfig>" + "<Enabled>" + Str0.Trim() + "</Enabled>" + "<WeeksInAdvance>" + Str1.Trim() + "</WeeksInAdvance>" + "<WeekDayStart>" + Str2.Trim() + "</WeekDayStart>" + "<WeekDayStop>" + Str3.Trim() + "</WeekDayStop>" + "<StartTime>" + Str4.Trim() + "</StartTime>" + "<StopTime>" + Str5.Trim() + "</StopTime>" + "<Interval>" + Str6.Trim() + "</Interval>" + "<TableThreshold>" + Str7.Trim() + "</TableThreshold>" + "</ResvConfig>";
                    }

                    XDtl += "</RestaurantResvConfig>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserID"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the specified UserID and Restaurant")]
        public XmlDocument GetMyReviews_XML(string UserName, string PassWord, string UserID, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetMyReviews '" + UserID + "','" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<MyReviews>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        XDtl += "<Review>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<Location>" + Str2.Trim() + "</Location>" + "<Rating>" + Str3.Trim() + "</Rating>" + "<ReviewText>" + Str4.Trim() + "</ReviewText>" + "<ReviewDate>" + Str5.Trim() + "</ReviewDate>" + "</Review>";
                    }

                    XDtl += "</MyReviews>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the User Reviews of a specified Restaurant")]
        public XmlDocument GetReviews_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetReviews '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Reviews>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        XDtl += "<Review>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<Location>" + Str2.Trim() + "</Location>" + "<Rating>" + Str3.Trim() + "</Rating>" + "<ReviewText>" + Str4.Trim() + "</ReviewText>" + "<ReviewDate>" + Str5.Trim() + "</ReviewDate>" + "<ReviewerName>" + Str6.Trim() + "</ReviewerName>" + "</Review>";
                    }

                    XDtl += "</Reviews>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the Events of a specified Restaurant")]
        public XmlDocument GetEvents_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetEvents '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Events>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        XDtl += "<Event>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<Location>" + Str2.Trim() + "</Location>" + "<EventTitle>" + Str3.Trim() + "</EventTitle>" + "<EventDesc>" + Str4.Trim() + "</EventDesc>" + "<EventDate>" + Str5.Trim() + "</EventDate>" + "<EventTime>" + Str6.Trim() + "</EventTime></Event>";
                    }

                    XDtl += "</Events>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the Deals of a specified Restaurant")]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public XmlDocument GetDeals_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            string jsonReturn = "";
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetDeals '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Deals>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        string Str10 = null;
                        Str0 = dr["id"] == null ? "" : dr["id"].ToString();
                        Str1 = dr["name"] == null ? "" : dr["name"].ToString();
                        Str2 = dr["title"] == null ? "" : dr["title"].ToString();
                        Str3 = dr["description"] == null ? "" : dr["description"].ToString();
                        Str4 = dr["thumbnail"] == null ? "" : dr["thumbnail"].ToString();
                        Str5 = dr["image"] == null ? "" : dr["image"].ToString();
                        Str6 = dr["DealType"] == null ? "" : dr["DealType"].ToString();
                        Str7 = dr["value"] == null ? "" : dr["value"].ToString();
                        Str8 = dr["startsFrom"] == null ? "" : dr["startsFrom"].ToString();
                        Str9 = dr["expiresOn"] == null ? "" : dr["expiresOn"].ToString();
                        XDtl += "<Deal>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<Title>" + Str2.Trim() + "</Title>" + "<Desc>" + Str3.Trim() + "</Desc>" + "<Thumbnail>" + Str4.Trim() + "</Thumbnail>" + "<Image>" + Str5.Trim() + "</Image>" + "<DealType>" + Str6.Trim() + "</DealType>" + "<Value>" + Str7.Trim() + "</Value>" + "<Starts>" + Str8.Trim() + "</Starts>" + "<Expires>" + Str9.Trim() + "</Expires></Deal>";
                    }

                    XDtl += "</Deals>";
                    xmlDoc.LoadXml(XDtl);

                    //jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    //return jsonReturn;
                    //this.Context.Response.Write(jsonReturn);
                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            //this.Context.Response.Write(jsonReturn);
            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the history and contact details of a specified Restaurant")]
        public XmlDocument GetRestaurantAbout_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantAbout '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<AboutUs>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        Str8 = dr[8] == null ? "" : dr[8].ToString();
                        Str9 = dr[9] == null ? "" : dr[9].ToString();

                        XDtl += "<About>" + "<ID>" + Str0.Trim() + "</ID>" + "<Restaurant>" + Str1.Trim() + "</Restaurant>" + "<eMunchingURL>" + Str2.Trim() + "</eMunchingURL>" + "<RestaurantURL>" + Str3.Trim() + "</RestaurantURL>" + "<FacebookURL>" + Str4.Trim() + "</FacebookURL>" + "<TwitterHandle>" + Str5.Trim() + "</TwitterHandle>" + "<PrimaryCountry>" + Str6.Trim() + "</PrimaryCountry>" + "<History>" + Str7.Trim() + "</History>" + "<MainEmailContact>" + Str8.Trim() + "</MainEmailContact>" + "<HoursOfOperation>" + Str9.Trim() + "</HoursOfOperation>" + "</About>";
                    }

                    XDtl += "</AboutUs>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="MealType"></param>
        /// <param name="DealType"></param>
        /// <param name="MenuItemType"></param>
        /// <param name="MealCategory"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document of Restaurant Menu Items according to the parameters passed:<br><br> MealType - Values: Breakfast, Brunch, Morning Tea (Elevenses), Lunch, Dinner, Afternoon Tea, Supper = 1,2,3,4,5,6,7<br>DealType - Values: All, ChefSpecials, FeaturedDeals = 0,1,2<br>MenuItemType - Values: All, Veg, NonVeg = 0,1,2<br>MenuItemCategory - Values: [Retrieved from the GetMealCategories Method].")]
        public XmlDocument GetRestaurantMenuItemsAll_XML(string UserName, string PassWord, string RestaurantID, string MealType, string DealType, string MenuItemType, string MealCategory)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantMenuItemsAll '" + RestaurantID + "','" + MealType + "','" + DealType + "','" + MenuItemType + "','" + MealCategory + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantMenuItems>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        Str8 = dr[8] == null ? "" : dr[8].ToString();
                        Str9 = dr["MenuType"] == null ? "" : dr["MenuType"].ToString();
                        XDtl += "<MenuItem>" + "<ID>" + Str0.Trim() + "</ID>" + "<ItemImage1>" + Str1.Trim() + "</ItemImage1>" + "<ItemImage2>" + Str2.Trim() + "</ItemImage2>" + "<ItemImage3>" + Str3.Trim() + "</ItemImage3>" + "<Item>" + Str4.Trim() + "</Item>" + "<ItemDesc>" + Str5.Trim() + "</ItemDesc>" + "<ItemPrice>" + Str6.Trim() + "</ItemPrice>" + "<ComboPrice>" + Str7.Trim() + "</ComboPrice>" + "<DiscountPrice>" + Str8.Trim() + "</DiscountPrice>" + "<MenuItemType>" + Str9.Trim() + "</MenuItemType>" + "</MenuItem>";
                    }

                    XDtl += "</RestaurantMenuItems>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document of Restaurant Locations")]
        public XmlDocument GetRestaurantLocations_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantLocations '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantLocations>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        string Str10 = null;
                        string Str11 = null;
                        string Str12 = null;
                        string Str13 = null;
                        string Str14 = null;
                        string Str15 = null;
                        int Str16 = 0;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        Str8 = dr[8] == null ? "" : dr[8].ToString();
                        Str9 = dr[9] == null ? "" : dr[9].ToString();
                        Str10 = dr[10] == null ? "" : dr[10].ToString();
                        Str11 = dr[11] == null ? "" : dr[11].ToString();
                        Str12 = dr[12] == null ? "" : dr[12].ToString();
                        Str13 = dr[13] == null ? "" : dr[13].ToString();
                        Str14 = dr[14] == null ? "" : dr[14].ToString();
                        Str15 = dr[15] == null ? "" : dr[15].ToString();
                        Str16 = dr[15] == null ? 0 : (Convert.ToInt32(dr[16]) == 0) ? 0 : 1;
                        XDtl += "<Location>" + "<LocaID>" + Str0.Trim() + "</LocaID>" + "<RName>" + Str1.Trim() + "</RName>" + "<LName>" + Str2.Trim() + "</LName>" + "<StreetAddress>" + Str3.Trim() + "</StreetAddress>" + "<City>" + Str4.Trim() + "</City>" + "<Region>" + Str5.Trim() + "</Region>" + "<Country>" + Str6.Trim() + "</Country>" + "<Latitude>" + Str7.Trim() + "</Latitude>" + "<Longitude>" + Str8.Trim() + "</Longitude>" + "<PhoneNumber>" + Str9.Trim() + "</PhoneNumber>" + "<EmailAddress>" + Str10.Trim() + "</EmailAddress>" + "<WebSite>" + Str11.Trim() + "</WebSite>" + "<FacebookUrl>" + Str12.Trim() + "</FacebookUrl>" + "<TwitterHandle>" + Str13.Trim() + "</TwitterHandle>" + "<HoursOfOperation>" + Str14.Trim() + "</HoursOfOperation>" + "<MultipleMenus>" + Str15.Trim() + "</MultipleMenus><DealsEnabled>" + Str16 + "</DealsEnabled>" + "</Location>";
                    }

                    XDtl += "</RestaurantLocations>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }


        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document of Restaurant Locations")]
        public XmlDocument GetRestaurantLocationsExtended_XML(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetRestaurantLocations '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantLocations>";
                    XDtl += "<Locations>";
                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        string Str6 = null;
                        string Str7 = null;
                        string Str8 = null;
                        string Str9 = null;
                        string Str10 = null;
                        string Str11 = null;
                        string Str12 = null;
                        string Str13 = null;
                        string Str14 = null;
                        string Str15 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        Str6 = dr[6] == null ? "" : dr[6].ToString();
                        Str7 = dr[7] == null ? "" : dr[7].ToString();
                        Str8 = dr[8] == null ? "" : dr[8].ToString();
                        Str9 = dr[9] == null ? "" : dr[9].ToString();
                        Str10 = dr[10] == null ? "" : dr[10].ToString();
                        Str11 = dr[11] == null ? "" : dr[11].ToString();
                        Str12 = dr[12] == null ? "" : dr[12].ToString();
                        Str13 = dr[13] == null ? "" : dr[13].ToString();
                        Str14 = dr[14] == null ? "" : dr[14].ToString();
                        Str15 = dr[15] == null ? "" : dr[15].ToString();
                        XDtl += "<Location>" + "<LocaID>" + Str0.Trim() + "</LocaID>" + "<RName>" + Str1.Trim() + "</RName>" + "<LName>" + Str2.Trim() + "</LName>" + "<StreetAddress>" + Str3.Trim() + "</StreetAddress>" + "<City>" + Str4.Trim() + "</City>" + "<Region>" + Str5.Trim() + "</Region>" + "<Country>" + Str6.Trim() + "</Country>" + "<Latitude>" + Str7.Trim() + "</Latitude>" + "<Longitude>" + Str8.Trim() + "</Longitude>" + "<PhoneNumber>" + Str9.Trim() + "</PhoneNumber>" + "<EmailAddress>" + Str10.Trim() + "</EmailAddress>" + "<WebSite>" + Str11.Trim() + "</WebSite>" + "<FacebookUrl>" + Str12.Trim() + "</FacebookUrl>" + "<TwitterHandle>" + Str13.Trim() + "</TwitterHandle>" + "<HoursOfOperation>" + Str14.Trim() + "</HoursOfOperation>" + "<MultipleMenus>" + Str15.Trim() + "</MultipleMenus>" + "</Location>";
                    }
                    XDtl += "</Locations>";
                    dr.Close();
                    sql = new SqlCommand("SELECT MenuItemGroupID, MenuItemGroup FROM MenuItemGroups WHERE Restaurant=" + RestaurantID + " AND Parent IS NULL", con);
                    dr = sql.ExecuteReader();
                    XDtl += "<MenuParentCategories>";
                    while (dr.Read())
                    {
                        string menuItemGroupID = null;
                        string menuItemGroup = null;
                        menuItemGroupID = dr["MenuItemGroupID"] == null ? "" : dr["MenuItemGroupID"].ToString();
                        menuItemGroup = dr["MenuItemGroup"] == null ? "" : dr["MenuItemGroup"].ToString();
                        XDtl += "<MenuParentCategory><MenuItemGroupID>" + menuItemGroupID.Trim() + "</MenuItemGroupID><MenuItemGroup>" + menuItemGroup.Trim() + "</MenuItemGroup></MenuParentCategory>";
                    }
                    XDtl += "</MenuParentCategories>";
                    XDtl += "</RestaurantLocations>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserId"></param>
        /// <param name="UserPassword"></param>
        /// <param name="Phone"></param>
        /// <param name="Location"></param>
        /// <returns></returns>
        [WebMethod(Description = "Update User Profile")]
        public object UpdateProfile(string UserName, string PassWord, string UserId, string UserPassword, string Phone, string Location)
        {

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "EXEC p_Svc_UpdateProfile @UserId,@UserPassword,@Phone,@Location";

            int recordsInserted = 0;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with1 = command;
                    _with1.Parameters.AddWithValue("@UserId", UserId);
                    _with1.Parameters.AddWithValue("@UserPassword", UserPassword);
                    _with1.Parameters.AddWithValue("@Phone", Phone);
                    _with1.Parameters.AddWithValue("@Location", Location);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserId"></param>
        /// <param name="UserPassword"></param>
        /// <param name="Phone"></param>
        /// <param name="Location"></param>
        /// <returns></returns>
        [WebMethod(Description = "Update User Profile")]
        public object UpdateProfileByRestaurant(string UserName, string PassWord, string UserId, string UserPassword, string Phone, string Location, string RestaurantID)
        {

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "EXEC p_Svc_UpdateProfileByRestaurant @UserId,@UserPassword,@Phone,@Location,@RestaurantID";

            int recordsInserted = 0;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with1 = command;
                    _with1.Parameters.AddWithValue("@UserId", UserId);
                    _with1.Parameters.AddWithValue("@UserPassword", UserPassword);
                    _with1.Parameters.AddWithValue("@Phone", Phone);
                    _with1.Parameters.AddWithValue("@Location", Location);
                    _with1.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }


        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserId"></param>
        /// <param name="UserPassword"></param>
        /// <param name="Phone"></param>
        /// <param name="Location"></param>
        /// <returns></returns>
        [WebMethod(Description = "Update User Profile")]
        public object UpdateProfileExtended(string UserName, string PassWord, string UserId, string FirstName, string LastName, string Phone, string Location, string RestaurantID)
        {

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "UPDATE MobileAppUsers SET FirstName=@FirstName, LastName=@LastName, Phone=@Phone WHERE ID=@UserId AND RestaurantID=@RestaurantID";

            int recordsInserted = 0;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with1 = command;
                    _with1.Parameters.AddWithValue("@FirstName", FirstName);
                    _with1.Parameters.AddWithValue("@LastName", LastName);
                    _with1.Parameters.AddWithValue("@Phone", Phone);
                    _with1.Parameters.AddWithValue("@UserId", UserId);
                    _with1.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserId"></param>
        /// <param name="FirstName"></param>
        /// <param name="LastName"></param>
        /// <param name="Phone"></param>
        /// <param name="Location"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Update User Profile")]
        public XmlDocument UpdateProfileXML(string UserName, string PassWord, string UserId, string FirstName, string LastName, string Phone, string Location, string RestaurantID)
        {
            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "UPDATE MobileAppUsers SET FirstName=@FirstName, LastName=@LastName, Phone=@Phone WHERE ID=@UserId AND RestaurantID=@RestaurantID";

            int recordsInserted = 0;
            string XDtl = null;
            XmlDocument xmlDoc = new XmlDocument();
            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with1 = command;
                    _with1.Parameters.AddWithValue("@FirstName", FirstName);
                    _with1.Parameters.AddWithValue("@LastName", LastName);
                    _with1.Parameters.AddWithValue("@Phone", Phone);
                    _with1.Parameters.AddWithValue("@UserId", UserId);
                    _with1.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                    XDtl = "<result>" + recordsInserted + "</result>";
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    XDtl = "<result>0</result>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }
            }

            strSQL = null;

            xmlDoc.LoadXml(XDtl);

            return xmlDoc;
        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserId"></param>
        /// <param name="Restaurant"></param>
        /// <param name="LocaID"></param>
        /// <param name="Rating"></param>
        /// <param name="Review"></param>
        /// <returns></returns>
        [WebMethod(Description = "Submit a Review")]
        public object CreateReview(string UserName, string PassWord, string UserId, string Restaurant, string LocaID, string Rating, string Review)
        {

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "EXEC p_Svc_CreateReview @UserId,@Restaurant,@LocaID,@Rating,@Review";

            int recordsInserted = 0;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with2 = command;
                    _with2.Parameters.AddWithValue("@UserId", UserId);
                    _with2.Parameters.AddWithValue("@Restaurant", Restaurant);
                    _with2.Parameters.AddWithValue("@LocaID", LocaID);
                    _with2.Parameters.AddWithValue("@Rating", Rating);
                    _with2.Parameters.AddWithValue("@Review", Review);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="UserID"></param>
        /// <param name="UserPassword"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns Bool value of Login Status")]
        public XmlDocument LoginUser(string UserName, string PassWord, string RestaurantID, string UserID, string UserPassword)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_LoginUser '" + UserID + "','" + UserPassword + "','" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Login>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();

                        XDtl += "<IsValid>" + Str0.Trim() + "</IsValid>" + "<FirstName>" + Str1.Trim() + "</FirstName>" + "<LastName>" + Str2.Trim() + "</LastName>" + "<PhoneNumber>" + Str3.Trim() + "</PhoneNumber>" + "<PrefLoca>" + Str4.Trim() + "</PrefLoca>";

                    }
                    XDtl += "</Login>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Get User Details By UserID")]
        public XmlDocument GetUserByUserID(string UserName, string PassWord, string UserID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetUserByUserID '" + UserID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No User Details Available</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<User>";
                    while (dr.Read())
                    {
                        XDtl += "<Details>" + "<ID>" + dr[0].ToString() + "</ID>" + "<FullName>" + dr[1].ToString() + "</FullName>" + "<Email>" + dr[2].ToString() + "</Email>" + "<Salt>" + dr[3].ToString() + "</Salt>" + "<Password>" + dr[4].ToString() + "</Password>" + "</Details>";
                    }
                    XDtl += "</User>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Get User Details By UserID")]
        public XmlDocument GetUserByUserIDAndRestaurant(string UserName, string PassWord, string UserID, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("SELECT ID, FirstName, LastName, Email, Phone FROM MobileAppUsers WHERE ID='" + UserID + "' AND RestaurantID=" + RestaurantID, con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No User Details Available</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<User>";
                    while (dr.Read())
                    {
                        XDtl += "<Details>" + "<ID>" + dr["ID"].ToString() + "</ID>" + "<FirstName>" + dr["FirstName"].ToString() + "</FirstName>" + "<LastName>" + dr["LastName"] + "</LastName>" + "<Email>" + dr["Email"].ToString() + "</Email>" + "<Phone>" + dr["Phone"].ToString() + "</Phone>" + "</Details>";
                    }
                    XDtl += "</User>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UserID"></param>
        /// <param name="AuthenticationCode"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns Bool value of Authentication Status")]
        public XmlDocument AuthenticateUser(string UserName, string PassWord, string UserID, string AuthenticationCode)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_AuthenticateUser '" + UserID + "','" + AuthenticationCode + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Authenticated>";
                    while (dr.Read())
                    {
                        XDtl += "<IsValid>" + dr[0].ToString() + "</IsValid>";
                    }
                    XDtl += "</Authenticated>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="RestaurantLocaID"></param>
        /// <param name="FirstName"></param>
        /// <param name="LastName"></param>
        /// <param name="Email"></param>
        /// <param name="Salt"></param>
        /// <param name="RPassword"></param>
        /// <param name="Phone"></param>
        /// <returns></returns>
        [WebMethod(Description = "Register User for Restaurant.")]
        public XmlDocument RegisterRestaurantUser(string UserName, string PassWord, string RestaurantID, string RestaurantLocaID, string FirstName, string LastName, string Email, string Salt, string RPassword, string Phone)
        {

            XmlDocument xmlDoc = new XmlDocument();
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "p_Svc_CreateRestaurantUser";

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    command.CommandType = CommandType.StoredProcedure;

                    SqlParameter Result = new SqlParameter("@Result", SqlDbType.NVarChar, 500);
                    Result.Direction = ParameterDirection.Output;

                    var _with3 = command;
                    _with3.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    _with3.Parameters.AddWithValue("@RestaurantLocaID", RestaurantLocaID);
                    _with3.Parameters.AddWithValue("@FirstName", FirstName);
                    _with3.Parameters.AddWithValue("@LastName", LastName);
                    _with3.Parameters.AddWithValue("@Salt", Salt);
                    _with3.Parameters.AddWithValue("@Password", RPassword);
                    _with3.Parameters.AddWithValue("@Email", Email);
                    _with3.Parameters.AddWithValue("@Phone", Phone);
                    _with3.Parameters.Add(Result);
                    cn.Open();
                    dr = command.ExecuteReader();
                    if (dr.HasRows == false)
                    {
                        Output = "<error>No Rows</error>";
                    }
                    else
                    {
                        string XDtl = null;
                        XDtl = "<ValidReturn>";
                        while (dr.Read())
                        {
                            XDtl += "<ReturnString>" + dr[0].ToString() + "</ReturnString>";
                            RestName = dr[1].ToString();
                            From = dr[2].ToString();
                            Subj = dr[3].ToString();
                            Cc = dr[4].ToString();
                            To = dr[5].ToString();
                            Msg = dr[6].ToString();

                        }
                        XDtl += "</ValidReturn>";
                        xmlDoc.LoadXml(XDtl);
                        MailHelper.SendMail(To, Cc, Subj, Msg, From, RestName);
                        return xmlDoc;
                    }

                }
                catch (Exception ex)
                {
                    Output = "<error>" + ex.ToString() + "</error>";
                }
                finally
                {
                    cn.Close();
                }
            }

            xmlDoc.LoadXml(Output);
            return xmlDoc;

        }

        /// <summary>
        /// Checks User exists or Not
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="EmailAddress"></param>
        /// <returns></returns>
        /// 
        [WebMethod(Description = "Check User already exists or not.")]
        public XmlDocument CheckUserExists(string UserName, string PassWord, string RestaurantID, string EmailAddress)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            int Count = 0;
            Output = "<nothing></nothing>";
            SqlDataReader dataReader = null;

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "SELECT COUNT(*) AS Count FROM MobileAppUsers WHERE RestaurantID=" + RestaurantID + " AND ID='" + EmailAddress + "'";

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    cn.Open();
                    string XDtl = "<ValidReturn>";
                    Count = (Int32)command.ExecuteScalar();
                    if (Count == 0)
                    {
                        XDtl += "<Response>" + false + "</Response>";
                    }
                    else
                    {
                        strSQL = "SELECT * FROM mobileAppUsers WHERE RestaurantID=" + RestaurantID + " AND ID='" + EmailAddress + "'";
                        command = new SqlCommand(strSQL, cn);
                        dataReader = command.ExecuteReader();
                        while (dataReader.Read())
                        {
                            XDtl += "<Response>" + true + "</Response><UserData><ID>" + dataReader["ID"] + "</ID><FirstName>" + dataReader["FirstName"] + "</FirstName><LastName>" + dataReader["LastName"] + "</LastName><Email>" + dataReader["Email"] + "</Email><Phone>" + dataReader["Phone"] + "</Phone></UserData>";
                        }
                    }
                    XDtl += "</ValidReturn>";
                    xmlDoc.LoadXml(XDtl);
                    return xmlDoc;
                }
                catch (Exception ex)
                {
                    Output = "<error>" + ex.ToString() + "</error>";
                }
                finally
                {
                    cn.Close();
                }
                xmlDoc.LoadXml(Output);
                return xmlDoc;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="RestaurantLocaID"></param>
        /// <param name="FirstName"></param>
        /// <param name="LastName"></param>
        /// <param name="Email"></param>
        /// <param name="Salt"></param>
        /// <param name="RPassword"></param>
        /// <param name="Phone"></param>
        /// <returns></returns>
        [WebMethod(Description = "Register User for Restaurant.")]
        public XmlDocument RegisterRestaurantUserExtended(string UserName, string PassWord, string RestaurantID, string RestaurantLocaID, string FirstName, string LastName, string Email, string Salt, string RPassword, string Phone)
        {

            XmlDocument xmlDoc = new XmlDocument();
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "p_Svc_CreateRestaurantUserExtended";

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    command.CommandType = CommandType.StoredProcedure;

                    SqlParameter Result = new SqlParameter("@Result", SqlDbType.NVarChar, 500);
                    Result.Direction = ParameterDirection.Output;
                    string result = "";
                    var _with3 = command;
                    _with3.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    _with3.Parameters.AddWithValue("@RestaurantLocaID", RestaurantLocaID);
                    _with3.Parameters.AddWithValue("@FirstName", FirstName);
                    _with3.Parameters.AddWithValue("@LastName", LastName);
                    _with3.Parameters.AddWithValue("@Salt", Salt);
                    _with3.Parameters.AddWithValue("@Password", RPassword);
                    _with3.Parameters.AddWithValue("@Email", Email);
                    _with3.Parameters.AddWithValue("@Phone", Phone);
                    _with3.Parameters.Add(Result);
                    cn.Open();
                    dr = command.ExecuteReader();
                    if (dr.HasRows == false)
                    {
                        Output = "<error>No Rows</error>";
                    }
                    else
                    {
                        string XDtl = null;
                        XDtl = "<ValidReturn>";
                        while (dr.Read())
                        {
                            XDtl += "<ReturnString>" + dr[0].ToString() + "</ReturnString>";
                            RestName = dr[1].ToString();
                            From = dr[2].ToString();
                            Subj = dr[3].ToString();
                            Cc = dr[4].ToString();
                            To = dr[5].ToString();
                            Msg = dr[6].ToString();
                            result = dr[0].ToString();
                        }
                        XDtl += "</ValidReturn>";
                        xmlDoc.LoadXml(XDtl);
                        if (result == "1")
                        {
                            MailHelper.SendMail(To, Cc, Subj, Msg, From, RestName);
                        }
                        return xmlDoc;
                    }

                }
                catch (Exception ex)
                {
                    Output = "<error>" + ex.ToString() + "</error>";
                }
                finally
                {
                    cn.Close();
                }
            }

            xmlDoc.LoadXml(Output);
            return xmlDoc;

        }
        /// <summary>
        /// This method creates an order.
        /// </summary>
        /// <param name="UserName">string UserName</param>
        /// <param name="PassWord">string PassWord</param>
        /// <param name="OrderName">string OrderName</param>
        /// <param name="RestaurantID">string RestaurantId</param>
        /// <param name="RestaurantLocaID">string RestaurantLocaID</param>
        /// <param name="UserId">string UserId</param>
        /// <param name="MenuItems">string MenuItems</param>
        /// <returns>An object that tells us how many records were inserted into the Order</returns>
        [WebMethod(Description = "Create Order for User, for Restaurant.")]
        public object CreateOrder(string UserName, string PassWord, string OrderName, string RestaurantID, string RestaurantLocaID, string UserId, string MenuItems)
        {
            SqlDataReader dr = null;

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "EXEC p_Svc_CreateOrder @OrderName,@UserId,@RestaurantID,@RestaurantLocaID,@MenuItems";

            bool recordsInserted = false;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with4 = command;
                    _with4.Parameters.AddWithValue("@OrderName", OrderName);
                    _with4.Parameters.AddWithValue("@UserId", UserId);
                    _with4.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    _with4.Parameters.AddWithValue("@RestaurantLocaID", RestaurantLocaID);
                    _with4.Parameters.AddWithValue("@MenuItems", MenuItems);
                    cn.Open();
                    //recordsInserted = command.ExecuteNonQuery();
                    dr = command.ExecuteReader();
                    if (dr.HasRows == true)
                    {
                        while (dr.Read())
                        {
                            To = dr[0].ToString();
                            Cc = dr[1].ToString();
                            Subj = dr[2].ToString();
                            Msg = dr[3].ToString();
                            From = dr[4].ToString();
                            RestName = dr[5].ToString();
                        }
                        recordsInserted = MailHelper.SendMail(To, Cc, Subj, Msg, From, RestName);
                    }
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// This method creates a reservation
        /// </summary>
        /// <param name="UserName">string UserName</param>
        /// <param name="PassWord">string PassWord</param>
        /// <param name="ResName">string that represents the Name on the reservation</param>
        /// <param name="CallBackNumber">string that represents a callback number for the reservation</param>
        /// <param name="RestaurantID">string RestaurantID</param>
        /// <param name="RestaurantLocaID">string RestaurantLocaID</param>
        /// <param name="UserID">string UserID</param>
        /// <param name="NumGuests">string NumGuests</param>
        /// <param name="TimeSlot">string TimeSlot</param>
        /// <returns></returns>
        [WebMethod(Description = "Create Reservation for User, for Restaurant.")]
        public XmlDocument CreateReservation(string UserName, string PassWord, string ResName, string CallBackNumber, string RestaurantID, string RestaurantLocaID, string UserID, string NumGuests, string TimeSlot)
        {

            XmlDocument xmlDoc = new XmlDocument();
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";

            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "p_Svc_CreateReservations";
            string resvAdmin = "";

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    command.CommandType = CommandType.StoredProcedure;

                    SqlParameter Result = new SqlParameter("@Result", SqlDbType.NVarChar, 500);
                    Result.Direction = ParameterDirection.Output;

                    var _with5 = command;
                    _with5.Parameters.AddWithValue("@ResName", ResName);
                    _with5.Parameters.AddWithValue("@CallBackNumber", CallBackNumber);
                    _with5.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    _with5.Parameters.AddWithValue("@RestaurantLocaID", RestaurantLocaID);
                    _with5.Parameters.AddWithValue("@UserID", UserID);
                    _with5.Parameters.AddWithValue("@NumGuests", NumGuests);
                    _with5.Parameters.AddWithValue("@TimeSlot", TimeSlot);
                    _with5.Parameters.Add(Result);

                    cn.Open();
                    dr = command.ExecuteReader();
                    if (dr.HasRows == false)
                    {
                        Output = "<error>No Rows</error>";
                    }
                    else
                    {
                        string XDtl = null;
                        XDtl = "<ValidReturn>";
                        while (dr.Read())
                        {
                            To = dr[1].ToString();
                            Cc = dr[2].ToString();
                            Subj = dr[3].ToString();
                            Msg = dr[4].ToString();
                            From = dr[5].ToString();
                            RestName = dr[6].ToString();
                            resvAdmin = dr[7].ToString();
                            XDtl += "<ReturnString>" + dr[0].ToString() + "</ReturnString>";
                        }
                        XDtl += "</ValidReturn>";
                        xmlDoc.LoadXml(XDtl);
                        string[] resvAdmins = resvAdmin.Split(';');
                        for (int loop = 0; loop < resvAdmins.Length; loop++)
                        {
                            MailHelper.SendMail(resvAdmins[loop].ToString(), Cc, Subj, Msg, From, RestName);
                        }
                        return xmlDoc;
                    }

                }
                catch (Exception ex)
                {
                    Output = "<error>" + ex.ToString() + "</error>";
                }
                finally
                {
                    cn.Close();
                }
            }

            xmlDoc.LoadXml(Output);
            return xmlDoc;

        }

        /// <summary>
        /// Given a ReservationId, and valid credentials, this method cancels the reservations
        /// </summary>
        /// <param name="UserName">string UserName</param>
        /// <param name="PassWord">string PassWord</param>
        /// <param name="ResId">string ReservationId</param>
        /// <returns></returns>
        [WebMethod(Description = "Cancel Reservation.")]
        public object CancelReservation(string UserName, string PassWord, string ResId)
        {
            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "EXEC p_Svc_CancelReservation @ResId";
            SqlDataReader dr = null;
            bool recordsInserted = false;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with6 = command;
                    _with6.Parameters.AddWithValue("@ResId", ResId);
                    cn.Open();
                    dr = command.ExecuteReader();
                    if (dr.HasRows == true)
                    {
                        while (dr.Read())
                        {
                            To = dr[0].ToString();
                            Cc = dr[1].ToString();
                            Subj = dr[2].ToString();
                            Msg = dr[3].ToString();
                            From = dr[4].ToString();
                            RestName = dr[5].ToString();
                        }
                        recordsInserted = MailHelper.SendMail(To, Cc, Subj, Msg, From, RestName);
                    }
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// Given a ReservationId, and valid credentials, this method cancels the reservations
        /// </summary>
        /// <param name="UserName">string UserName</param>
        /// <param name="PassWord">string PassWord</param>
        /// <param name="ResId">string ReservationId</param>
        /// <returns></returns>
        [WebMethod(Description = "Restaurant Display Settings for Menu, Events and Deals.<br> Display Setting: 1 - Traditional Menu, 2 - Thumb and Signature menu, 3 - Signature menu")]
        public XmlDocument GetRestaurantDisplaySettings_XML(string UserName, string PassWord, string ResId)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("SELECT * FROM dbo.MobileAppDisplaySettings WHERE Restaurant='" + ResId + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantLocations>";

                    while (dr.Read())
                    {
                        string Str0 = null;
                        string Str1 = null;
                        string Str2 = null;
                        string Str3 = null;
                        string Str4 = null;
                        string Str5 = null;
                        Str0 = dr[0] == null ? "" : dr[0].ToString();
                        Str1 = dr[1] == null ? "" : dr[1].ToString();
                        Str2 = dr[2] == null ? "" : dr[2].ToString();
                        Str3 = dr[3] == null ? "" : dr[3].ToString();
                        Str4 = dr[4] == null ? "" : dr[4].ToString();
                        Str5 = dr[5] == null ? "" : dr[5].ToString();
                        XDtl += "<Setting><Restaurant>" + Str1.Trim() + "</Restaurant>" + "<EventMenuDeal>" + Str2.Trim() + "</EventMenuDeal>" + "<Type>" + Str3.Trim() + "</Type>" + "<CreatedTime>" + Str4.Trim() + "</CreatedTime>" + "<LastModified>" + Str5.Trim() + "</LastModified></Setting>";
                    }

                    XDtl += "</RestaurantLocations>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="DeviceToken"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Submit a Review")]
        public object RegisterDeviceForNotification(string UserName, string PassWord, string DeviceToken, string RestaurantID)
        {
            string CurrentDate = Convert.ToString(System.DateTime.Now);
            AuthenticateWebRequest(UserName, PassWord);

            strConn = (string)connectionObject["connectionStringApp"];
            strSQL = "INSERT INTO [dbo].[DeviceToken] (DeviceToken, Restaurant, CreatedTime) VALUES (@DeviceToken, @RestaurantID, getDate())";

            int recordsInserted = 0;

            using (SqlConnection cn = new SqlConnection(strConn))
            {
                try
                {
                    SqlCommand command = new SqlCommand(strSQL, cn);
                    var _with4 = command;
                    _with4.Parameters.AddWithValue("@DeviceToken", DeviceToken);
                    _with4.Parameters.AddWithValue("@RestaurantID", RestaurantID);
                    cn.Open();
                    recordsInserted = command.ExecuteNonQuery();
                    cn.Close();
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.Message);
                    return recordsInserted;
                }
            }

            strSQL = null;

            return recordsInserted;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DeviceToken"></param>
        /// <param name="RestId"></param>
        /// <returns></returns>
        [WebMethod(Description = "Get All unread notifications sent by APNS per Device per Restaurant")]
        public XmlDocument GetNotificationsSentToAPNS_XML(string UserName, string PassWord, string DeviceToken, string RestId)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection connection = null;
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            string sql = "";
            dynamic Output = null;
            Output = "<nothing></nothing>";
            connection = new SqlConnection(connectionString);
            bool dealsEnabled = false;
            bool eventsEnabled = false;
            bool loyaltyEnabled = false;
            if (string.IsNullOrEmpty(DeviceToken))
            {
                Output = "<NotificationStatus>0</NotificationStatus>";
                xmlDoc.LoadXml(Output);
                return xmlDoc;
            }
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                dealsEnabled = ServiceHelper.checkNotificationsEnabledByRestByAction(Convert.ToInt32(RestId), 2);
                eventsEnabled = ServiceHelper.checkNotificationsEnabledByRestByAction(Convert.ToInt32(RestId), 1);
                loyaltyEnabled = ServiceHelper.checkNotificationsEnabledByRestByAction(Convert.ToInt32(RestId), 4);
                connection.Open();
                if (dealsEnabled)
                {
                    sql += "SELECT COUNT(*) as notificationCount, 'Deal' as ActionType FROM Deals WHERE Restaurant=" + RestId + " AND Active=1 AND id NOT IN (SELECT DealID FROM RestaurantDealsVisited WHERE Restaurant=" + RestId + " AND DeviceToken='" + DeviceToken + "')";
                    sql += " UNION ";
                }
                if (eventsEnabled)
                {
                    sql += "SELECT COUNT(*) as notificationCount, 'Event' as ActionType FROM RestaurantEvents WHERE Restaurant=" + RestId + " AND Active=1 AND EventID NOT IN (SELECT EventID FROM RestaurantEventsVisited WHERE Restaurant=" + RestId + " AND DeviceToken='" + DeviceToken + "')";
                    sql += " UNION ";
                }
                if (loyaltyEnabled)
                {
                    sql += "SELECT SUM(Count) as notificationCount, 'Loyalty' as ActionType FROM LoyaltyNotifications WHERE Restaurant=" + RestId + " AND DeviceToken='" + DeviceToken + "'";
                    sql += " UNION ";
                }
                sql += "SELECT null,null";
                command = new SqlCommand(sql, connection);
                dataReader = command.ExecuteReader();
                if (dataReader.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<RestaurantNotification>";

                    while (dataReader.Read())
                    {
                        string Str0 = dataReader["notificationCount"].ToString();
                        string Str1 = dataReader["ActionType"].ToString();
                        if (!string.IsNullOrEmpty(Str0) && !string.IsNullOrEmpty(Str1))
                        {
                            XDtl += "<Notification><NotificationCount>" + Str0.Trim() + "</NotificationCount>" + "<ActionType>" + Str1.Trim() + "</ActionType></Notification>";
                        }
                    }

                    XDtl += "</RestaurantNotification>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;
                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                connection.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;
        }


        /// <summary>
        /// Sets the Deal As Read By Device By Restaurant
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestId"></param>
        /// <param name="DealId"></param>
        /// <param name="DeviceToken"></param>
        /// <returns></returns>
        [WebMethod(Description = "Set Deal Veiwed By Device By Restaurant")]
        public object SetDealViewedByDevice(string UserName, string PassWord, string RestId, string DealId, string DeviceToken)
        {
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection connection = new SqlConnection(connectionString);
            dynamic Output = "<nothing></nothing>";
            int recordsInserted = 0;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                SqlCommand sqlCommand = new SqlCommand("INSERT INTO dbo.RestaurantDealsVisited (Restaurant, DealID, DeviceToken) VALUES (@RestId, @DealId, @DeviceToken)", connection);
                var _with = sqlCommand;
                _with.Parameters.AddWithValue("@RestId", RestId);
                _with.Parameters.AddWithValue("@DealID", DealId);
                _with.Parameters.AddWithValue("@DeviceToken", DeviceToken);
                recordsInserted = sqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                connection.Close();
            }

            return recordsInserted;
        }

        /// <summary>
        /// Sets the Event As Read By Device By Restaurant
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestId"></param>
        /// <param name="EventId"></param>
        /// <param name="DeviceToken"></param>
        /// <returns></returns>
        [WebMethod(Description = "Set Event Veiwed By Device By Restaurant")]
        public object SetEventViewedByDevice(string UserName, string PassWord, string RestId, string EventId, string DeviceToken)
        {
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection connection = new SqlConnection(connectionString);
            dynamic Output = "<nothing></nothing>";
            int recordsInserted = 0;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                SqlCommand sqlCommand = new SqlCommand("INSERT INTO dbo.RestaurantEventsVisited (Restaurant, EventID, DeviceToken) VALUES (@RestId, @EventId, @DeviceToken)", connection);
                var _with = sqlCommand;
                _with.Parameters.AddWithValue("@RestId", RestId);
                _with.Parameters.AddWithValue("@EventID", EventId);
                _with.Parameters.AddWithValue("@DeviceToken", DeviceToken);
                recordsInserted = sqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                connection.Close();
            }

            return recordsInserted;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="DeviceToken"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the Deals with IsNew flag of a specified Restaurant")]
        public XmlDocument GetDealsExtended_XML(string UserName, string PassWord, string RestaurantID, string DeviceToken)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            DataTable dataTable = new DataTable();
            SqlDataReader dr = null;
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetDeals '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Deals>";
                    dataTable.Load(dr);
                    dr.Close();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        sql = new SqlCommand("SELECT COUNT(*) FROM RestaurantDealsVisited WHERE Restaurant=" + RestaurantID + " AND DealID=" + row["id"] + " AND DeviceToken='" + DeviceToken + "'", con);
                        int count = (int)sql.ExecuteScalar();
                        XDtl += "<Deal>" + "<ID>" + row["id"] + "</ID>" + "<Restaurant>" + row["name"] + "</Restaurant>" + "<Title>" + row["title"] + "</Title>" + "<Desc>" + row["description"] + "</Desc>" + "<Thumbnail>" + row["thumbnail"] + "</Thumbnail>" + "<Image>" + row["image"] + "</Image>" + "<DealType>" + row["DealType"] + "</DealType>" + "<Value>" + row["value"] + "</Value>" + "<Starts>" + row["startsFrom"] + "</Starts>" + "<Expires>" + row["expiresOn"] + "</Expires><IsNew>" + ((count > 0) ? 0 : 1) + "</IsNew></Deal>";
                    }

                    XDtl += "</Deals>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="DeviceToken"></param>
        /// <returns></returns>
        [WebMethod(Description = "Returns XML document with the Events and IsNew flag of a specified Restaurant")]
        public XmlDocument GetEventsExtended_XML(string UserName, string PassWord, string RestaurantID, string DeviceToken)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection con = null;
            SqlCommand sql = null;
            SqlDataReader dr = null;
            DataTable dataTable = new DataTable();
            dynamic Output = null;
            Output = "<nothing></nothing>";
            con = new SqlConnection(connectionString);
            try
            {
                AuthenticateWebRequest(UserName, PassWord);

                con.Open();
                sql = new SqlCommand("EXEC p_Svc_GetEvents '" + RestaurantID + "'", con);
                dr = sql.ExecuteReader();
                if (dr.HasRows == false)
                {
                    Output = "<error>No Rows</error>";
                }
                else
                {
                    string XDtl = null;
                    XDtl = "<Events>";
                    dataTable.Load(dr);
                    dr.Close();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        sql = new SqlCommand("SELECT COUNT(*) FROM RestaurantEventsVisited WHERE Restaurant=" + RestaurantID + " AND EventID=" + row["EventID"] + " AND DeviceToken='" + DeviceToken + "'", con);
                        int count = (int)sql.ExecuteScalar();
                        XDtl += "<Event>" + "<ID>" + row["EventID"] + "</ID>" + "<Restaurant>" + row["RName"] + "</Restaurant>" + "<Location>" + row["LName"] + "</Location>" + "<EventTitle>" + row["EName"] + "</EventTitle>" + "<EventDesc>" + row["Description"] + "</EventDesc>" + "<EventDate>" + row["Date"] + "</EventDate>" + "<EventTime>" + row["Time"] + "</EventTime><IsNew>" + ((count > 0) ? 0 : 1) + "</IsNew></Event>";
                    }

                    XDtl += "</Events>";
                    xmlDoc.LoadXml(XDtl);

                    return xmlDoc;

                }

            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                con.Close();
            }

            xmlDoc.LoadXml(Output);

            return xmlDoc;

        }


        /// <summary>
        /// Returns basic configuration values loyalty
        /// </summary>
        /// <param name="RestaurantID"></param>
        /// <param name="EmailAddress"></param>
        /// <returns></returns>
        [WebMethod(Description = "Loyality Bootstrap call for intial information")]
        public XmlDocument LoyaltyBootstrap(string UserName, string PassWord, int RestaurantID, string EmailAddress, string DeviceToken)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            Output = "<nothing></nothing>";

            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                MapDeviceAndUser(DeviceToken, EmailAddress, RestaurantID);
                Repository loyaltyRepository = new Repository();
                string XDtl = null;
                List<Reward> rewards = loyaltyRepository.GetAllRewards(RestaurantID);
                XDtl = "<Rewards>";
                SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
                SqlCommand command = null;
                SqlDataReader dataReader = null;
                connection.Open();
                foreach (Reward reward in rewards)
                {
                    int rewardNotification = 0;
                    string query = "SELECT Count as NotificationCount FROM LoyaltyNotifications WHERE Restaurant=" + RestaurantID + " AND DeviceToken='" + DeviceToken + "' AND RewardId=" + reward.Id;
                    command = new SqlCommand(query, connection);
                    dataReader = command.ExecuteReader();
                    while (dataReader.Read())
                    {
                        rewardNotification = Convert.ToInt32(dataReader["NotificationCount"]);
                    }
                    string image = (string.IsNullOrEmpty(reward.Image)) ? "http://www.emunching.com/images/no_image.png" : reward.Image;
                    int runningCount = loyaltyRepository.GetRunningCount(RestaurantID, EmailAddress, reward.Id);
                    //List<int> runningCounts = reward.RunningCounts.Where(r => r.RestaurantId == RestaurantID && r.EmailAddress == EmailAddress && r.RewardId == reward.Id).Select(r => r.RunningCount1).ToList();
                    List<Generated_CouponCode> couponCodes = loyaltyRepository.GetCouponCodesByReward(EmailAddress, RestaurantID, false, reward.Id);
                    //List<string> couponCodes = reward.Generated_CouponCode.Where(c => c.EmailAddress == EmailAddress && c.RestaurantId == RestaurantID && c.IsRedeemed == false && c.RewardId == reward.Id).Select(c => c.CouponCode).ToList();
                    XDtl += "<Reward><Id>" + reward.Id + "</Id><Name>" + reward.Name + "</Name><Description>" + reward.Description + "</Description><EligibleCount>" + reward.NumberOfItems + "</EligibleCount><NotificationCount>" + rewardNotification + "</NotificationCount><Image>" + image + "</Image><Coupons>";
                    if (couponCodes != null && 0 < couponCodes.Count)
                    {
                        foreach (Generated_CouponCode couponCode in couponCodes)
                        {
                            DateTime time = (DateTime)couponCode.ExpirationDate;
                            XDtl += "<Coupon>" + couponCode.CouponCode + "</Coupon>";
                            XDtl += "<ExpiryDate>" + time.ToString("d MMM yyyy") + "</ExpiryDate>";
                        }
                    }
                    else
                    {
                        XDtl += "<Coupon>None</Coupon>";
                    }

                    XDtl += "</Coupons>";
                    //if (runningCounts != null && 0<runningCounts.Count)
                    //{
                    //    foreach (int runningCount in runningCounts)
                    //    {
                    //        XDtl += "<RunningCount>" + runningCount + "</RunningCount>";
                    //    }
                    //}
                    //else
                    //{
                    //    XDtl += "<RunningCount>0</RunningCount>";
                    //}

                    //XDtl += "</Reward>";
                    XDtl += "<RunningCount>" + runningCount + "</RunningCount></Reward>";
                    //XDtl += "<Reward><Id>1</Id><Name>Free Beer</Name><Description>Test Reward</Description><EligibleCount>9</EligibleCount><Coupons><Coupon>EV3uYsOU</Coupon></Coupons><RunningCount>2</RunningCount></Reward>";
                    //XDtl += "<Reward><Id>1</Id><Name>Free Cocktail</Name><Description>Free Cocktail</Description><EligibleCount>9</EligibleCount><Coupons><Coupon>LEBmi9gR</Coupon></Coupons><RunningCount>3</RunningCount></Reward>";
                    dataReader.Close();
                }
                connection.Close();
                //XDtl += "<Reward><Id>1</Id><Name>Free Beer</Name><Description>Test Reward</Description><EligibleCount>9</EligibleCount><Coupons><Coupon>EV3uYsOU</Coupon><Coupon>11sF99Tp</Coupon></Coupons><RunningCount>2</RunningCount></Reward>";
                //XDtl += "<Reward><Id>1</Id><Name>Free Cocktail</Name><Description>Free Cocktail</Description><EligibleCount>9</EligibleCount><Coupons><Coupon>LEBmi9gR</Coupon><Coupon>124YGSL9</Coupon></Coupons><RunningCount>3</RunningCount></Reward>";
                XDtl += "</Rewards>";
                //TODO:Harsha
                xmlDoc.LoadXml(XDtl);
                return xmlDoc;
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }

            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="UniqueCode"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="EmailAddress"></param>
        /// <returns></returns>
        [WebMethod(Description = "Log's Unique code per user per restaurant")]
        public XmlDocument LogUniqueCode(string UserName, string PassWord, string UniqueCode, string RestaurantID, string EmailAddress)
        {
            dynamic OutPut = "<nothing></nothing>";
            XmlDocument xmlDoc = new XmlDocument();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                Repository loyaltyRepository = new Repository();
                string XDtl = "";
                XDtl += "<LogUniqueCodeResponse>";
                if (loyaltyRepository.ValidateAndAcceptUniqueCodes(UniqueCode, EmailAddress, Convert.ToInt32(RestaurantID)))
                {
                    //int runningCount = loyaltyRepository.GetRunningCount(Convert.ToInt32(RestaurantID), EmailAddress,;
                    //int runningCount = 2;
                    //XDtl += "<RunningCount>" + runningCount + "</RunningCount>";
                    XDtl += true;
                }
                else
                {
                    string query = "INSERT INTO FailedUniqueCodes (Restaurant, UniqueCode, EmailAddress) VALUES (" + Convert.ToInt32(RestaurantID) + ", '" + UniqueCode + "','" + EmailAddress + "')";
                    connection.Open();
                    command = new SqlCommand(query, connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    XDtl += false;
                }
                XDtl += "</LogUniqueCodeResponse>";
                xmlDoc.LoadXml(XDtl);
                return xmlDoc;
            }
            catch (Exception ex)
            {
                string query = "INSERT INTO FailedUniqueCodes (Restaurant, UniqueCode, EmailAddress) VALUES (" + Convert.ToInt32(RestaurantID) + ", '" + UniqueCode + "','" + EmailAddress + "')";
                connection.Open();
                command = new SqlCommand(query, connection);
                command.ExecuteNonQuery();
                connection.Close();
                OutPut = "<error>" + ex.ToString() + "</error>";
            }
            xmlDoc.LoadXml(OutPut);
            return xmlDoc;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DeviceToken"></param>
        /// <param name="Email"></param>
        /// <param name="RestaurantID"></param>
        private void MapDeviceAndUser(string DeviceToken, string Email, int RestaurantID)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            try
            {
                connection.Open();
                command = new SqlCommand("UPDATE dbo.DeviceToken SET Email='" + Email + "' WHERE DeviceToken='" + DeviceToken + "' AND Restaurant=" + RestaurantID, connection);
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                connection.Close();
            }
        }

        [WebMethod(Description = "Register Loyalty Notifications")]
        public object RegisterLoyaltyNotification(string UserName, string PassWord, int RestaurantID, string Email, int Count, int RewardId)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            int recordsInserted = 0;
            SqlDataReader dataReader = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("SELECT DeviceToken FROM DeviceToken WHERE Restaurant=" + RestaurantID + " AND Email='" + Email + "'", connection);
                string deviceToken = (string)command.ExecuteScalar();
                command  = new SqlCommand("SELECT DeviceRegId,Id FROM DeviceTokensAndroid WHERE RestaurantId="+ RestaurantID + " AND EmailAddress='" + Email + "' AND Active =1",connection);
                List<string> androidDeviceIds = new List<string>();
                dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    androidDeviceIds.Add(dataReader["Id"].ToString());
                }
                dataReader.Close();
                if (!string.IsNullOrEmpty(deviceToken))
                {
                    string query = "IF EXISTS(SELECT * FROM LoyaltyNotifications WHERE DeviceToken='" + deviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "' AND RewardId = " + RewardId + ")";
                    query += " BEGIN ";
                    query += " UPDATE LoyaltyNotifications SET Count= Count + " + Count + " WHERE DeviceToken='" + deviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "' AND RewardId = " + RewardId;
                    query += " END ";
                    query += " ELSE ";
                    query += " BEGIN ";
                    query += " INSERT INTO LoyaltyNotifications (DeviceToken, Restaurant, Email, Count, RewardId) VALUES ('" + deviceToken + "'," + RestaurantID + ",'" + Email + "'," + Count + "," + RewardId + ")";
                    query += " END ";
                    command = new SqlCommand(query, connection);
                    recordsInserted = command.ExecuteNonQuery();
                    ServiceHelper.registerNotification(RestaurantID, "Loyalty");
                }
                if (androidDeviceIds.Count > 0)
                {
                    foreach (string androidDeviceId in androidDeviceIds)
                    {
                        string query = "IF EXISTS(SELECT * FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId='" + androidDeviceId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId + ")";
                        query += " BEGIN ";
                        query += " UPDATE LoyaltyNotificationsAndroid SET Count= Count + " + Count + ", LastModified = '"+ DateTime.Now +"' WHERE DeviceTokenId='" + androidDeviceId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        query += " ELSE ";
                        query += " BEGIN ";
                        query += " INSERT INTO LoyaltyNotificationsAndroid (DeviceTokenId, RestaurantId, Count, RewardId, Created, LastModified) VALUES ('" + androidDeviceId + "'," + RestaurantID + "," + Count + "," + RewardId + ",'"+ DateTime.Now+"','"+DateTime.Now+"')";
                        query += " END ";
                        command = new SqlCommand(query, connection);
                        recordsInserted = command.ExecuteNonQuery();
                        ServiceHelper.registerAndroidNotification(RestaurantID, 4, Email);
                    }
                }
            }
            catch (Exception ex)
            {
                return "<error>" + ex.Message + "</error>";
            }
            finally
            {
                connection.Close();
            }
            return recordsInserted;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="Email"></param>
        /// <param name="Count"></param>
        /// <param name="RewardId"></param>
        [WebMethod]
        public object UpdateLoyaltyNotification(string UserName, string PassWord, int RestaurantID, string Email, int Count, int RewardId)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            int recordUpdated = 0;
            SqlDataReader dataReader = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("SELECT DeviceToken FROM DeviceToken WHERE Restaurant=" + RestaurantID + " AND Email='" + Email + "'", connection);
                string deviceToken = (string)command.ExecuteScalar();
                command = new SqlCommand("SELECT DeviceRegId, Id FROM DeviceTokensAndroid WHERE RestaurantId=" + RestaurantID + " AND EmailAddress='" + Email + "' AND Active=1", connection);
                List<string> androidDeviceTokenIds = new List<string>();
                dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    androidDeviceTokenIds.Add(dataReader["Id"].ToString());
                }
                dataReader.Close();
                if (!string.IsNullOrEmpty(deviceToken))
                {
                    string query = "DECLARE @Count int";
                    query += " SELECT @Count=Count FROM LoyaltyNotifications WHERE DeviceToken='" + deviceToken + "' AND RewardId=" + RewardId;
                    query += " IF @Count <> " + Count;
                    query += " BEGIN ";
                    query += " UPDATE LoyaltyNotifications SET Count= Count - " + Count + " WHERE DeviceToken='" + deviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "' AND RewardId = " + RewardId;
                    query += " END ";
                    query += " ELSE ";
                    query += " BEGIN ";
                    query += " DELETE FROM LoyaltyNotifications WHERE DeviceToken = '" + deviceToken + "' AND Restaurant = " + RestaurantID + " AND Email= '" + Email + "' AND RewardId = " + RewardId;
                    query += " END ";
                    command = new SqlCommand(query, connection);
                    recordUpdated = command.ExecuteNonQuery();
                    ServiceHelper.registerNotification(RestaurantID, "Loyalty");
                }
                if (androidDeviceTokenIds.Count > 0)
                {
                    foreach (string androidDeviceTokenId in androidDeviceTokenIds)
                    {
                        string query = "DECLARE @Count int";
                        query += " SELECT @Count=Count FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId=" + androidDeviceTokenId + " AND RewardId=" + RewardId + " AND RestaurantId=" + RestaurantID;
                        query += " IF @Count <> " + Count;
                        query += " BEGIN ";
                        query += " UPDATE LoyaltyNotificationsAndroid SET Count= Count - " + Count + " WHERE DeviceTokenId='" + androidDeviceTokenId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        query += " ELSE ";
                        query += " BEGIN ";
                        query += " DELETE FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId = '" + androidDeviceTokenId + "' AND RestaurantId = " + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        command = new SqlCommand(query, connection);
                        recordUpdated = command.ExecuteNonQuery();
                        ServiceHelper.registerAndroidNotification(RestaurantID, 4, Email);
                    }
                }
            }
            catch (Exception ex)
            {
                return "<error>" + ex.Message + "</error>";
            }
            finally
            {
                connection.Close();
            }
            return recordUpdated;
        }

        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="Email"></param>
        /// <param name="DeviceToken"></param>
        /// <returns></returns>
        [WebMethod(Description = "Sets All the loyalty Notifications Read")]
        public object SetLoyaltyNotificaitonRead(string UserName, string PassWord, string RestaurantID, string Email, string DeviceToken)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            dynamic Output = "<nothing></nothing>";
            int recordDeleted = 0;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("DELETE FROM LoyaltyNotifications WHERE DeviceToken='" + DeviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "'", connection);
                recordDeleted = command.ExecuteNonQuery();
                return recordDeleted;
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }
            finally
            {
                connection.Close();
            }
            return recordDeleted;
        }

        /// <summary>
        /// Checks If the Coupon Code and Returns <br /> 0 - Invalid, 1 - Valid and not Redeemed, 2 - Valid but Redeemed
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="CouponCode"></param>
        /// <returns></returns>
        [WebMethod(Description = "Validated Coupon Code and checks if it is redeemed or not")]
        public int ValidateCouponCodeAndCheckIfRedeemed(string UserName, string PassWord, string CouponCode, int RestaurantID)
        {
            int validated = 0;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                Repository loyaltyRepository = new Repository();
                validated = loyaltyRepository.ValidateCouponCodeAndCheckIfRedeemed(CouponCode, RestaurantID);
                return validated;
            }
            catch (Exception ex)
            {

            }
            return validated;
        }

        /// <summary>
        /// Redeems Coupon Code
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="CouponCode"></param>
        /// <param name="EmailAddress"></param>
        /// <param name="RestaurantID"></param>
        /// <returns></returns>
        [WebMethod(Description = "Redeems Coupon Code")]
        public object RedeemCouponCode(string UserName, string PassWord, string CouponCode, int RestaurantID)
        {
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                Repository loyaltyRepository = new Repository();
                //if (loyaltyRepository.RedeemCouponCode(CouponCode, RestaurantID))
                //{
                //    return true;
                //}
                return true;
            }
            catch (Exception ex)
            {

            }
            return false;
        }

        [WebMethod(Description = "Returns Stats of the Rewards")]
        public XmlDocument GetRewardStats(string UserName, string PassWord, int RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            Output = "<nothing></nothing>";
            string XDtl = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                Repository loyaltyRepository = new Repository();
                List<Reward> rewards = loyaltyRepository.GetAllRewards(RestaurantID);
                XDtl = "<Rewards>";
                foreach (Reward reward in rewards)
                {
                    XDtl += "<Reward><Id></Id><Name></Name><Description></Description><Coupons><Coupon></Coupon></Coupons><RunningCount></RunningCount></Reward>";
                }
                XDtl += "</Rewards>";
                xmlDoc.LoadXml(XDtl);

                return xmlDoc;
            }
            catch (Exception ex)
            {
            }
            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }

        [WebMethod(Description = "Returns Parent Categories, Subcategories and Price ranges associated with them")]
        public XmlDocument GetParentCategoriesSubCaregoriesAndPriceRanges(string UserName, string PassWord, string RestaurantID)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            Output = "<nothing></nothing>";
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            string XDtl = null;

            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("SELECT MenuItemGroupID, MenuItemGroup FROM MenuItemGroups WHERE Restaurant= '" + RestaurantID + "' AND Parent IS NULL", connection);
                dataReader = command.ExecuteReader();
                XDtl = "<ParentCategories>";
                DataTable parentCategoryTable = new DataTable();
                parentCategoryTable.Load(dataReader);
                dataReader.Close();

                foreach (DataRow row in parentCategoryTable.Rows)
                {
                    XDtl += "<ParentCategory>";
                    XDtl += "<MenuItemGroupID>" + row["MenuItemGroupID"] + "</MenuItemGroupID><MenuItemGroup>" + row["MenuItemGroup"] + "</MenuItemGroup>";
                    command = new SqlCommand("SELECT MenuItemGroupID, MenuItemGroup FROM MenuItemGroups WHERE Parent=" + row["MenuItemGroupID"], connection);
                    dataReader = command.ExecuteReader();
                    XDtl += "<SubCategories>";
                    while (dataReader.Read())
                    {
                        XDtl += "<SubCategory><SubCategoryMenuItemGroupID>" + dataReader["MenuItemGroupID"] + "</SubCategoryMenuItemGroupID><SubCategoryMenuItemGroup>" + dataReader["MenuItemGroup"] + "</SubCategoryMenuItemGroup></SubCategory>";
                    }
                    XDtl += "</SubCategories>";
                    dataReader.Close();
                    command = new SqlCommand("SELECT PriceRange FROM MenuItemPriceRange WHERE MenuItemGroup=" + row["MenuItemGroupID"], connection);
                    dataReader = command.ExecuteReader();
                    XDtl += "<PriceRanges>";
                    while (dataReader.Read())
                    {
                        XDtl += "<PriceRange>" + dataReader["PriceRange"] + "</PriceRange>";
                    }
                    dataReader.Close();
                    XDtl += "</PriceRanges>";
                    XDtl += "</ParentCategory>";
                }

                XDtl += "</ParentCategories>";
                xmlDoc.LoadXml(XDtl);

                return xmlDoc;
            }
            catch (Exception ex)
            {
                connection.Close();
            }
            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }

        [WebMethod(Description = "Searches MenuItems Depending on Category and Price Ranges")]
        public XmlDocument SearchMenuItems(string UserName, string PassWord, string RestaurantID, string MealType, string DealType, string MenuItemType, string MealCategory, string PriceRange)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            Output = "<nothing></nothing>";
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                string[] priceRangeArray = PriceRange.Split('-');
                string lowerLimitPrice = priceRangeArray[0].Trim() + ".00";
                string upperLimitPrice = priceRangeArray[1].Trim() + ".00";
                command = new SqlCommand("EXEC p_Svc_SearchRestaurantMenuItemsByPriceRange '" + RestaurantID + "','" + MealType + "','" + DealType + "','" + MenuItemType + "','" + MealCategory + "','" + lowerLimitPrice + "','" + upperLimitPrice + "'", connection);
                string XDtl = null;
                XDtl = "<RestaurantMenuItems>";
                dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    string Str0 = null;
                    string Str1 = null;
                    string Str2 = null;
                    string Str3 = null;
                    string Str4 = null;
                    string Str5 = null;
                    string Str6 = null;
                    string Str7 = null;
                    string Str8 = null;
                    string Str9 = null;
                    Str0 = dataReader[0] == null ? "" : dataReader[0].ToString();
                    Str1 = dataReader[1] == null ? "" : dataReader[1].ToString();
                    Str2 = dataReader[2] == null ? "" : dataReader[2].ToString();
                    Str3 = dataReader[3] == null ? "" : dataReader[3].ToString();
                    Str4 = dataReader[4] == null ? "" : dataReader[4].ToString();
                    Str5 = dataReader[5] == null ? "" : dataReader[5].ToString();
                    Str6 = dataReader[6] == null ? "" : dataReader[6].ToString();
                    Str7 = dataReader[7] == null ? "" : dataReader[7].ToString();
                    Str8 = dataReader[8] == null ? "" : dataReader[8].ToString();
                    Str9 = dataReader["MenuType"] == null ? "" : dataReader["MenuType"].ToString();
                    XDtl += "<MenuItem>" + "<ID>" + Str0.Trim() + "</ID>" + "<ItemImage1>" + Str1.Trim() + "</ItemImage1>" + "<ItemImage2>" + Str2.Trim() + "</ItemImage2>" + "<ItemImage3>" + Str3.Trim() + "</ItemImage3>" + "<Item>" + Str4.Trim() + "</Item>" + "<ItemDesc>" + Str5.Trim() + "</ItemDesc>" + "<ItemPrice>" + Str6.Trim() + "</ItemPrice>" + "<ComboPrice>" + Str7.Trim() + "</ComboPrice>" + "<DiscountPrice>" + Str8.Trim() + "</DiscountPrice>" + "<MenuItemType>" + Str9.Trim() + "</MenuItemType>" + "</MenuItem>";
                }

                XDtl += "</RestaurantMenuItems>";
                xmlDoc.LoadXml(XDtl);

                return xmlDoc;
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.Message + "</error>";
            }
            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="callback"></param>
        /// <param name="input"></param>
        [WebMethod(Description = "JsonWrapper for HTML5 apps")]
        public void JsonWrapper(string callback, string input)
        {
            input = WebUtility.HtmlDecode(input);
            input = HttpUtility.UrlDecode(input);
            string[] inputList = input.Split('&');
            XmlDocument xmlDoc = new XmlDocument();
            string jsonReturn = "";
            Hashtable jsonResponse = new Hashtable();
            string outPut = "";
            Dictionary<string, string> inputVariables = new Dictionary<string, string>();
            foreach (string inputItem in inputList)
            {
                string[] variable = inputItem.Split('=');
                inputVariables.Add(variable[0], variable[1]);
            }

            switch (inputVariables["RequestMethod"])
            {
                case "GetRestaurantMenuItemsAll_XML":
                    xmlDoc = GetRestaurantMenuItemsAll_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"], inputVariables["MealType"], inputVariables["DealType"], inputVariables["MenuItemType"], inputVariables["MealCategory"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantMenuItems_XML":
                    xmlDoc = GetRestaurantMenuItems_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantsMenuItemGroups_XML":
                    xmlDoc = GetRestaurantsMenuItemGroups_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantAbout_XML":
                    xmlDoc = GetRestaurantAbout_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantsXML":
                    xmlDoc = GetRestaurantsXML(inputVariables["UserName"], inputVariables["PassWord"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetForgottenPassword_XML":
                    xmlDoc = GetForgottenPassword_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserID"], inputVariables["RestID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantResvConfig_XML":
                    xmlDoc = GetRestaurantResvConfig_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetMyReviews_XML":
                    xmlDoc = GetMyReviews_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserID"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetReviews_XML":
                    xmlDoc = GetReviews_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetEvents_XML":
                    xmlDoc = GetEvents_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetDeals_XML":
                    xmlDoc = GetDeals_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetRestaurantLocations_XML":
                    xmlDoc = GetRestaurantLocations_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "UpdateProfile":
                    outPut = UpdateProfile(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserId"], inputVariables["UserPassword"], inputVariables["Phone"], inputVariables["Location"]).ToString();
                    if (Convert.ToInt32(outPut) > 0)
                    {
                        jsonResponse.Add("Response", true);
                    }
                    else
                    {
                        jsonResponse.Add("Response", false);
                    }
                    jsonReturn = JsonConvert.SerializeObject(jsonResponse);
                    break;
                case "UpdateProfileExtended":
                    outPut = UpdateProfileExtended(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserId"], inputVariables["FirstName"], inputVariables["LastName"], inputVariables["Phone"], inputVariables["Location"], inputVariables["RestaurantID"]).ToString();
                    if (Convert.ToInt32(outPut) > 0)
                    {
                        jsonResponse.Add("Response", true);
                    }
                    else
                    {
                        jsonResponse.Add("Response", false);
                    }
                    jsonReturn = JsonConvert.SerializeObject(jsonResponse);

                    break;
                case "CreateReview":
                    outPut = CreateReview(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserId"], inputVariables["Restaurant"], inputVariables["LocaID"], inputVariables["Rating"], inputVariables["Review"]).ToString();
                    if (Convert.ToInt32(outPut) > 0)
                    {
                        jsonResponse.Add("Response", true);
                    }
                    else
                    {
                        jsonResponse.Add("Response", false);
                    }
                    jsonReturn = JsonConvert.SerializeObject(jsonResponse);
                    break;
                case "LoginUser":
                    xmlDoc = LoginUser(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"], inputVariables["UserID"], inputVariables["UserPassword"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "GetUserByUserID":
                    xmlDoc = GetUserByUserID(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["UserID"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "RegisterRestaurantUser":
                    xmlDoc = RegisterRestaurantUser(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"], inputVariables["RestaurantLocaID"], inputVariables["FirstName"], inputVariables["LastName"], inputVariables["Email"], inputVariables["Salt"], inputVariables["RPassword"], inputVariables["Phone"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "CreateOrder":
                    bool recordInserted = (bool)CreateOrder(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["OrderName"], inputVariables["RestaurantID"], inputVariables["RestaurantLocaID"], inputVariables["UserId"], inputVariables["MenuItems"]);
                    if (recordInserted)
                    {
                        jsonResponse.Add("Response", true);
                    }
                    else
                    {
                        jsonResponse.Add("Response", false);
                    }
                    jsonReturn = JsonConvert.SerializeObject(jsonResponse);
                    break;
                case "CreateReservation":
                    xmlDoc = CreateReservation(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["ResName"], inputVariables["CallBackNumber"], inputVariables["RestaurantID"], inputVariables["RestaurantLocaID"], inputVariables["UserID"], inputVariables["NumGuests"], inputVariables["TimeSlot"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "CancelReservation":
                    outPut = CancelReservation(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["ResId"]).ToString();
                    if (Convert.ToInt32(outPut) > 0)
                    {
                        jsonResponse.Add("Response", true);
                    }
                    else
                    {
                        jsonResponse.Add("Response", false);
                    }
                    jsonReturn = JsonConvert.SerializeObject(jsonResponse);
                    break;
                case "RegisterRestaurantUserExtended":
                    xmlDoc = RegisterRestaurantUserExtended(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"], inputVariables["RestaurantLocaID"], inputVariables["FirstName"], inputVariables["LastName"], inputVariables["Email"], inputVariables["Salt"], inputVariables["RPassword"], inputVariables["Phone"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                case "CheckUserExists":
                    xmlDoc = CheckUserExists(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"], inputVariables["EmailAddress"]);
                    jsonReturn = Newtonsoft.Json.JsonConvert.SerializeXmlNode(xmlDoc);
                    break;
                default:
                    break;
            }
            //xmlDoc = GetDeals_XML(inputVariables["UserName"], inputVariables["PassWord"], inputVariables["RestaurantID"]);
            this.Context.Response.Write(callback + "(" + jsonReturn + ")");
        }

        // eMunching.eMunchingWebServices
        [WebMethod(Description = "Returns XML document with the Events and IsNew flag of a specified Restaurant for android")]
        public XmlDocument GetEventsExtendedForAndroid_XML(string UserName, string PassWord, string RestaurantID, string DeviceToken, string UserId)
        {
	        XmlDocument xmlDocument = new XmlDocument();
	        string connectionString = (string)this.connectionObject["connectionStringApp"];
	        SqlConnection sqlConnection = null;
	        DataTable dataTable = new DataTable();
	        string Output = "<nothing></nothing>";
	        sqlConnection = new SqlConnection(connectionString);
	        XmlDocument result;
	        try
	        {
		        eMunchingWebServices.AuthenticateWebRequest(UserName, PassWord);
		        sqlConnection.Open();
		        SqlCommand sqlCommand;
		        if (UserId == null || UserId == "")
		        {
                    sqlCommand = new SqlCommand("Select E.EventID AS EventID, R.Name AS RName, l.Name AS LName, E.Name AS EName, E.Description AS Description, E.Date AS Date, E.Time AS Time,  (Select CASE WHEN count(*) >= 1 then 0 WHEN count(*) = 0 then 1 END  from RestaurantEventsVisitedAndroid AS V  LEFT JOIN DeviceTokensAndroid AS d ON d.Id = v.DeviceTokenId where v.RestaurantId=@RestId AND  d.DeviceRegId=@DeviceToken AND d.EmailAddress IS NULL AND v.EventId=E.EventId) AS IsNew from RestaurantEvents AS E JOIN Restaurant r ON E.Restaurant = r.Id JOIN RestaurantLocation AS l ON E.Loca = l.LocaID where E.Restaurant=@RestId1  AND E.Active=1 ", sqlConnection);
		        }
		        else
		        {
			        MailAddress mailAddress = new MailAddress(UserId);
                    sqlCommand = new SqlCommand("Select  E.EventID AS EventID, R.Name AS RName, l.Name AS LName, E.Name AS EName, E.Description AS Description, E.Date AS Date, E.Time AS Time,  (Select CASE WHEN count(*) >= 1 then 0 WHEN count(*) = 0 then 1 END  from RestaurantEventsVisitedAndroid AS V  LEFT JOIN DeviceTokensAndroid AS d ON d.Id = v.DeviceTokenId where v.RestaurantId=@RestId AND  d.DeviceRegId=@DeviceToken AND d.EmailAddress = @UserId AND v.EventId=E.EventId) AS IsNew from RestaurantEvents AS E JOIN Restaurant r ON E.Restaurant = r.Id JOIN RestaurantLocation AS l ON E.Loca = l.LocaID where E.Restaurant=@RestId1  AND E.Active=1 ", sqlConnection);
		        }
		        SqlCommand sqlCommand2 = sqlCommand;
		        sqlCommand2.Parameters.AddWithValue("@RestId", RestaurantID);
		        sqlCommand2.Parameters.AddWithValue("@RestId1", RestaurantID);
		        sqlCommand2.Parameters.AddWithValue("@DeviceToken", DeviceToken);
		        if (UserId != "")
		        {
			        sqlCommand2.Parameters.AddWithValue("@UserId", UserId);
		        }
		        SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
		        if (sqlDataReader.HasRows)
		        {
			        string text = null;
			        text = "<Events>";
			        dataTable.Load(sqlDataReader);
			        sqlDataReader.Close();
			        foreach (DataRow dataRow in dataTable.Rows)
			        {
				        text += "<Event><ID>"+ dataRow["EventID"] + "</ID><Restaurant>"+ dataRow["RName"]+ "</Restaurant><Location>"+ dataRow["LName"]+ "</Location><EventTitle>"+ dataRow["EName"]+ "</EventTitle><EventDesc>"+ dataRow["Description"]+ "</EventDesc><EventDate>"+ dataRow["Date"]+ "</EventDate><EventTime>"+ dataRow["Time"]+ "</EventTime><IsNew>"+ dataRow["IsNew"]+"</IsNew></Event>";
			        }
			        text += "</Events>";
			        xmlDocument.LoadXml(text);
			        result = xmlDocument;
			        return result;
		        }
		        Output = "<error>No Rows</error>";
	        }
	        catch (FormatException ex)
	        {
		        Output = "<ValidReturn>";
		        Output += "<ReturnString>0</ReturnString>";
		        Output += "<Message>Invalid UserId / EmailAddress </Message>";
		        Output += "</ValidReturn>";
	        }
	        catch (Exception ex)
	        {
		        Output = "<error>" + ex.ToString() + "</error>";
	        }
	        finally
	        {
		        sqlConnection.Close();
	        }

            xmlDocument.LoadXml(Output);
            result = xmlDocument;
	        return result;
        }


        // eMunching.eMunchingWebServices
        [WebMethod(Description = "Register android device for notifications")]
        public XmlDocument RegisterDeviceForAndroidNotification(string UserName, string PassWord, string RestaurantID, string DeviceToken, string UserId)
        {
	        XmlDocument xmlDocument = new XmlDocument();
	        string connectionString = (string)this.connectionObject["connectionStringApp"];
	        SqlConnection sqlConnection = null;
	        DataTable dataTable = new DataTable();
	        string Output = null;
	        Output = "<nothing></nothing>";
	        sqlConnection = new SqlConnection(connectionString);
	        XmlDocument result;
	        try
	        {
		        AuthenticateWebRequest(UserName, PassWord);
		        if (UserId != null && UserId != "")
		        {
			        MailAddress mailAddress = new MailAddress(UserId);
		        }
		        sqlConnection.Open();
		        SqlCommand sqlCommand = new SqlCommand( "EXEC registerDeviceTokens "+ RestaurantID + ", "+ ((UserId == "") ? "NULL" : ("'" + UserId + "'") ) + ", '" + DeviceToken +"'", sqlConnection);
		        SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
		        if (sqlDataReader.HasRows)
		        {
			        string text = "<ValidReturn>";
			        sqlDataReader.Read();
                    text += "<ReturnString>"+ sqlDataReader["result"]+ "</ReturnString>";
			        text += "</ValidReturn>";
			        xmlDocument.LoadXml(text);
			        result = xmlDocument;
			        return result;
		        }
		        Output = "<error>No Rows</error>";
	        }
	        catch (FormatException Ex)
	        {
		       Output = "<ValidReturn>";
		       Output += "<ReturnString>0</ReturnString>";
		       Output += "<Message>Invalid UserId / EmailAddress </Message>";
               Output += "</ValidReturn>";
	        }
	        catch (Exception ex)
	        {
		        Output = "<error>" + ex.ToString() + "</error>";
	        }
	        finally
	        {
		        sqlConnection.Close();
	        }
            xmlDocument.LoadXml(Output);
            result = xmlDocument;
	        return result;
        }

        // eMunching.eMunchingWebServices
        [WebMethod(Description = "Set Event Veiwed By Android Device By Restaurant")]
        public XmlDocument SetEventViewedByAndroidDevice(string UserName, string PassWord, string RestId, string EventId, string DeviceToken, string UserId)
        {
	        XmlDocument xmlDocument = new XmlDocument();
	        string connectionString = (string)this.connectionObject["connectionStringApp"];
	        SqlConnection sqlConnection = new SqlConnection(connectionString);
	        string Output = "<nothing></nothing>";
	        XmlDocument result;
	        try
	        {
		        AuthenticateWebRequest(UserName, PassWord);
		        sqlConnection.Open();
		        SqlCommand sqlCommand;
		        if (UserId == null || UserId == "")
		        {
			        sqlCommand = new SqlCommand("INSERT INTO RestaurantEventsVisitedAndroid(RestaurantId,EventId,DeviceTokenId,Created,LastModified) SELECT  @RestId AS RestaurantId, @EventID AS EventId, ID AS DeviceTokenId, getDate() AS Created, getDate() AS LastModified FROM DeviceTokensAndroid  WHERE DeviceRegid= @DeviceToken AND EmailAddress IS NULL", sqlConnection);
		        }
		        else
		        {
			        MailAddress mailAddress = new MailAddress(UserId);
			        sqlCommand = new SqlCommand("INSERT INTO RestaurantEventsVisitedAndroid(RestaurantId,EventId,DeviceTokenId,Created,LastModified) SELECT  @RestId AS RestaurantId, @EventID AS EventId, ID AS DeviceTokenId, getDate() AS Created, getDate() AS LastModified FROM DeviceTokensAndroid  WHERE DeviceRegid= @DeviceToken AND EmailAddress = @UserId", sqlConnection);
		        }
		         var _with1 = sqlCommand;
		        _with1.Parameters.AddWithValue("@RestId", RestId);
		        _with1.Parameters.AddWithValue("@EventID", EventId);
		        _with1.Parameters.AddWithValue("@DeviceToken", DeviceToken);
		        if (UserId != "")
		        {
			        _with1.Parameters.AddWithValue("@UserId", UserId);
		        }
		        int num = sqlCommand.ExecuteNonQuery();
		        string text = "<ValidReturn>";
		        text +="<ReturnString>" + num+ "</ReturnString>";
		        text += "</ValidReturn>";
		        xmlDocument.LoadXml(text);
		        result = xmlDocument;
		        return result;
	        }
	        catch (FormatException Exception)
	        {
		        Output = "<ValidReturn>";
                Output += "<ReturnString>0</ReturnString>";
                Output += "<Message>Invalid UserId / EmailAddress </Message>";
                Output += "</ValidReturn>";
	        }
	        catch (Exception ex)
	        {
		        Output = "<error>" + ex.ToString() + "</error>";
	        }
	        finally
	        {
		        sqlConnection.Close();
	        }
            xmlDocument.LoadXml(Output);
	        result = xmlDocument;
	        return result;
        }

        /// <summary>
        /// Returns basic configuration values loyalty
        /// </summary>
        /// <param name="RestaurantID"></param>
        /// <param name="EmailAddress"></param>
        /// <returns></returns>
        [WebMethod(Description = "Loyality Bootstrap call for intial information to Andorid Devices")]
        public XmlDocument LoyaltyBootstrapAndroid(string UserName, string PassWord, int RestaurantID, string EmailAddress, string DeviceToken)
        {
            XmlDocument xmlDoc = new XmlDocument();
            dynamic Output = null;
            Output = "<nothing></nothing>";

            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                MapDeviceAndUser(DeviceToken, EmailAddress, RestaurantID);
                Repository loyaltyRepository = new Repository();
                string XDtl = null;
                List<Reward> rewards = loyaltyRepository.GetAllRewards(RestaurantID);
                XDtl = "<Rewards>";
                SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
                SqlCommand command = null;
                SqlDataReader dataReader = null;
                connection.Open();
                foreach (Reward reward in rewards)
                {
                    int rewardNotification = 0;
                    string query = "SELECT  Count as NotificationCount FROM LoyaltyNotificationsAndroid AS l JOIN DeviceTokensAndroid AS d ON d.id = l.DeviceTokenId WHERE l.RestaurantId="+RestaurantID+" AND l.RewardId="+reward.Id+" AND d.EmailAddress='"+EmailAddress+"' AND d.deviceRegId='"+DeviceToken+"'";
                    command = new SqlCommand(query, connection);
                    dataReader = command.ExecuteReader();
                    while (dataReader.Read())
                    {
                        rewardNotification = Convert.ToInt32(dataReader["NotificationCount"]);
                    }
                    string image = (string.IsNullOrEmpty(reward.Image)) ? "http://www.emunching.com/images/no_image.png" : reward.Image;
                    int runningCount = loyaltyRepository.GetRunningCount(RestaurantID, EmailAddress, reward.Id);
                    List<Generated_CouponCode> couponCodes = loyaltyRepository.GetCouponCodesByReward(EmailAddress, RestaurantID, false, reward.Id);
                    XDtl += "<Reward><Id>" + reward.Id + "</Id><Name>" + reward.Name + "</Name><Description>" + reward.Description + "</Description><EligibleCount>" + reward.NumberOfItems + "</EligibleCount><NotificationCount>" + rewardNotification + "</NotificationCount><Image>" + image + "</Image><Coupons>";
                    if (couponCodes != null && 0 < couponCodes.Count)
                    {
                        foreach (Generated_CouponCode couponCode in couponCodes)
                        {
                            DateTime time = (DateTime)couponCode.ExpirationDate;
                            XDtl += "<Coupon>" + couponCode.CouponCode + "</Coupon>";
                            XDtl += "<ExpiryDate>" + time.ToString("d MMM yyyy") + "</ExpiryDate>";
                        }
                    }
                    else
                    {
                        XDtl += "<Coupon>None</Coupon>";
                    }
                    XDtl += "</Coupons>";
                    XDtl += "<RunningCount>" + runningCount + "</RunningCount></Reward>";
                    dataReader.Close();
                }
                connection.Close();
                XDtl += "</Rewards>";
                xmlDoc.LoadXml(XDtl);
                return xmlDoc;
            }
            catch (Exception ex)
            {
                Output = "<error>" + ex.ToString() + "</error>";
            }

            //Output = "<Rewards><Reward><Id>1</Id><Name>Free Beer</Name><Description>Get your 11th Beer Free</Description><EligibleCount>10</EligibleCount><NotificationCount>5</NotificationCount><Image>http://www.emunching.com/images/beer.png</Image><Coupons><Coupon>None</Coupon></Coupons><RunningCount>0</RunningCount></Reward></Rewards>";

            xmlDoc.LoadXml(Output);
            return xmlDoc;
        }

        [WebMethod(Description = "Register Loyalty Notifications")]
        public object RegisterAndroidLoyaltyNotification(string UserName, string PassWord, int RestaurantID, string Email, int Count, int RewardId)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            int recordsInserted = 0;
            SqlDataReader dataReader = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("SELECT DeviceToken FROM DeviceToken WHERE Restaurant=" + RestaurantID + " AND Email='" + Email + "'", connection);
                string deviceToken = (string)command.ExecuteScalar();
                command = new SqlCommand("SELECT DeviceRegId,Id FROM DeviceTokensAndroid WHERE RestaurantId=" + RestaurantID + " AND EmailAddress='" + Email + "' AND Active =1", connection);
                List<string> androidDeviceIds = new List<string>();
                dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    androidDeviceIds.Add(dataReader["Id"].ToString());
                }
                dataReader.Close();
                if (!string.IsNullOrEmpty(deviceToken))
                {
                    string query = "IF EXISTS(SELECT * FROM LoyaltyNotifications WHERE DeviceToken='" + deviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "' AND RewardId = " + RewardId + ")";
                    query += " BEGIN ";
                    query += " UPDATE LoyaltyNotifications SET Count= Count + " + Count + " WHERE DeviceToken='" + deviceToken + "' AND Restaurant=" + RestaurantID + " AND Email='" + Email + "' AND RewardId = " + RewardId;
                    query += " END ";
                    query += " ELSE ";
                    query += " BEGIN ";
                    query += " INSERT INTO LoyaltyNotifications (DeviceToken, Restaurant, Email, Count, RewardId) VALUES ('" + deviceToken + "'," + RestaurantID + ",'" + Email + "'," + Count + "," + RewardId + ")";
                    query += " END ";
                    command = new SqlCommand(query, connection);
                    recordsInserted = command.ExecuteNonQuery();
                    ServiceHelper.registerAndroidNotification(RestaurantID, 4, Email);
                }
                if (androidDeviceIds.Count > 0)
                {
                    foreach (string androidDeviceId in androidDeviceIds)
                    {
                        string query = "IF EXISTS(SELECT * FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId='" + androidDeviceId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId + ")";
                        query += " BEGIN ";
                        query += " UPDATE LoyaltyNotificationsAndroid SET Count= Count + " + Count + ", LastModified = '" + DateTime.Now + "' WHERE DeviceTokenId='" + androidDeviceId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        query += " ELSE ";
                        query += " BEGIN ";
                        query += " INSERT INTO LoyaltyNotificationsAndroid (DeviceTokenId, RestaurantId, Count, RewardId, Created, LastModified) VALUES ('" + androidDeviceId + "'," + RestaurantID + "," + Count + "," + RewardId + ",'" + DateTime.Now + "','" + DateTime.Now + "')";
                        query += " END ";
                        command = new SqlCommand(query, connection);
                        recordsInserted = command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                return "<error>" + ex.Message + "</error>";
            }
            finally
            {
                connection.Close();
            }
            return recordsInserted;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="PassWord"></param>
        /// <param name="RestaurantID"></param>
        /// <param name="Email"></param>
        /// <param name="Count"></param>
        /// <param name="RewardId"></param>
        /// <returns></returns>
        [WebMethod]
        public object UpdateLoyaltyNotificationsAndroid(string UserName, string PassWord, int RestaurantID, string Email, int Count, int RewardId)
        {
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            SqlCommand command = null;
            int recordUpdated = 0;
            SqlDataReader dataReader = null;
            try
            {
                AuthenticateWebRequest(UserName, PassWord);
                connection.Open();
                command = new SqlCommand("SELECT DeviceRegId, Id FROM DeviceTokensAndroid WHERE RestaurantId=" + RestaurantID + " AND EmailAddress='" + Email + "' AND Active=1", connection);
                List<string> androidDeviceTokenIds = new List<string>();
                dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    androidDeviceTokenIds.Add(dataReader["Id"].ToString());
                }
                dataReader.Close();
                if (androidDeviceTokenIds.Count > 0)
                {
                    foreach (string androidDeviceTokenId in androidDeviceTokenIds)
                    {
                        string query = "DECLARE @Count int";
                        query += " SELECT @Count=Count FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId=" + androidDeviceTokenId + " AND RewardId=" + RewardId + " AND RestaurantId=" + RestaurantID;
                        query += " IF @Count <> " + Count;
                        query += " BEGIN ";
                        query += " UPDATE LoyaltyNotificationsAndroid SET Count= Count - " + Count + " WHERE DeviceTokenId='" + androidDeviceTokenId + "' AND RestaurantId=" + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        query += " ELSE ";
                        query += " BEGIN ";
                        query += " DELETE FROM LoyaltyNotificationsAndroid WHERE DeviceTokenId = '" + androidDeviceTokenId + "' AND RestaurantId = " + RestaurantID + " AND RewardId = " + RewardId;
                        query += " END ";
                        command = new SqlCommand(query, connection);
                        recordUpdated = command.ExecuteNonQuery();
                    }
                    return recordUpdated;
                }
            }
            catch (Exception ex)
            {
                return "<error>" + ex.Message + "</error>";
            }
            finally
            {
                connection.Close();
            }
            return recordUpdated;
        }

        #endregion Public Methods
    }
}
