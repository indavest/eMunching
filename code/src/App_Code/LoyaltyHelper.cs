using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Data.OleDb;
using System.Text;
using System.Net.Mail;
using System.Net;

/// <summary>
/// Summary description for LoyaltyHelper
/// </summary>
public class LoyaltyHelper
{
	public LoyaltyHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static bool uploadRestaurantPayload(int restaurantId)
    {
        string completeFilePath = StringConstants.RESTAURANT_PAYLOAD_PATH;
        var directory = new DirectoryInfo(completeFilePath);
        var fileName = (from f in directory.GetFiles() orderby f.LastWriteTime descending select f).First();
        string filepath = completeFilePath + fileName.ToString();
        string fileExtension = Path.GetExtension(filepath);
        DataTable settlementInfoTable = new DataTable();
        settlementInfoTable.Columns.Add("BillNumber", typeof(string));
        settlementInfoTable.Columns.Add("UniqueCode", typeof(string));
        settlementInfoTable.Columns.Add("EmailAddres", typeof(string));
        settlementInfoTable.Columns.Add("RestaurantId", typeof(int));
        settlementInfoTable.Columns.Add("IsServiced", typeof(bool));
        settlementInfoTable.Columns.Add("Date", typeof(DateTime));
        settlementInfoTable.Columns.Add("DateCreated", typeof(DateTime));
        settlementInfoTable.Columns.Add("DateModified", typeof(DateTime));
        DataTable orderDetailsTable = new DataTable();
        orderDetailsTable.Columns.Add("BillNumber", typeof(string));
        orderDetailsTable.Columns.Add("ItemCode", typeof(string));
        orderDetailsTable.Columns.Add("Quantity", typeof(int));
        orderDetailsTable.Columns.Add("RestaurantId", typeof(int));
        try
        {
            switch(fileExtension)
            {
                case ".xlsx":
                    XSSFWorkbook xssfwb;
                    using (FileStream file = new FileStream(@filepath, FileMode.Open, FileAccess.Read))
                    {
                        //hssfwb = new HSSFWorkbook(file);
                        xssfwb = new XSSFWorkbook(file);
                    }

                    //ISheet sheet = hssfwb.GetSheetAt(0);
                    XSSFSheet xssfsheet = (XSSFSheet)xssfwb.GetSheetAt(0);
                    for (int row = 0; row <= xssfsheet.LastRowNum; row++)
                    {
                        if (xssfsheet.GetRow(row) != null) //null is when the row only contains empty cells 
                        {
                            //MessageBox.Show(string.Format("Row {0} = {1}", row, sheet.GetRow(row).GetCell(0).StringCellValue));
                            string billNumber = xssfsheet.GetRow(row).GetCell(0).NumericCellValue.ToString();
                            string uniqueCode = xssfsheet.GetRow(row).GetCell(2).NumericCellValue.ToString();
                            bool isServiced = false;
                            string date = DateTime.Now.ToString();
                            string dateCreated = DateTime.Now.ToString();
                            settlementInfoTable.Rows.Add(billNumber, uniqueCode, null, restaurantId, isServiced, date, dateCreated, dateCreated);
                            double itemCode = xssfsheet.GetRow(row).GetCell(3).NumericCellValue;
                            double quantity = xssfsheet.GetRow(row).GetCell(4).NumericCellValue;
                            orderDetailsTable.Rows.Add(billNumber, itemCode, quantity, restaurantId);
                        }
                    }
                    break;
                case ".xls":
                    HSSFWorkbook hssfwb;
                    using (FileStream file = new FileStream(@filepath, FileMode.Open, FileAccess.Read))
                    {
                        hssfwb = new HSSFWorkbook(file);
                    }

                    ISheet isheet = hssfwb.GetSheetAt(0);
                    for (int row = 0; row <= isheet.LastRowNum; row++)
                    {
                        if (isheet.GetRow(row) != null) //null is when the row only contains empty cells 
                        {
                            //dynamic value = isheet.GetRow(row).GetCell(1).StringCellValue;
                            string billNumber = isheet.GetRow(row).GetCell(0).NumericCellValue.ToString();
                            string uniqueCode = isheet.GetRow(row).GetCell(1).NumericCellValue.ToString();
                            bool isServiced = false;
                            string date = DateTime.Now.ToString();
                            string dateCreated = DateTime.Now.ToString();
                            settlementInfoTable.Rows.Add(billNumber, uniqueCode, null, 36, isServiced, date, dateCreated, dateCreated);
                            double itemCode = isheet.GetRow(row).GetCell(3).NumericCellValue;
                            double quantity = isheet.GetRow(row).GetCell(4).NumericCellValue;
                            orderDetailsTable.Rows.Add(billNumber, itemCode, quantity, 36);
                        }
                    }
                    break;
                case ".csv":
                    break;
            }

            DataSet dataSet = new DataSet();
            dataSet.Tables.Add(settlementInfoTable);
            dataSet.Tables.Add(orderDetailsTable);
            Hashtable connectionObject = Helper.getDBNameAndConnectionStringForLoyalty();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            System.Data.SqlClient.SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connection);
            sqlBulkCopy.DestinationTableName = "dbo.SettlementInfo";
            connection.Open();
            sqlBulkCopy.WriteToServer(dataSet.Tables[0]);
            sqlBulkCopy.DestinationTableName = "dbo.OrderDetail";
            sqlBulkCopy.WriteToServer(dataSet.Tables[1]);
        }
        catch (Exception ex)
        {
        }
        return true;
    }

    public static void WriteToTextFile(string separator, string filename)
    {
        //DB Connection object and connection string
        Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
        string connectionString = connectionObject["connectionStringApp"].ToString();
        string query = "SELECT S.BILNUB 'Bill Number', S.RESCOD 'Restaurant Code', S.BILDAT 'Billing Date', O.ITMCOD 'Item Code', O.QUANTY 'Quantity' FROM POSSET2012 S, POSORD2012 O WHERE S.BILDAT = 20121108 AND O.KOTDAT = 20121108 AND S.BILNUB = O.BILNUB";
        string sep = separator;

        StreamWriter sw = new StreamWriter(HttpContext.Current.Server.MapPath(filename));
        try
        {
            using (SqlConnection Conn = new SqlConnection(connectionString))
            {
                using (SqlCommand Cmd = new SqlCommand(query, Conn))
                {
                    Conn.Open();
                    using (SqlDataReader dr = Cmd.ExecuteReader())
                    {
                        int fields = dr.FieldCount - 1;
                        while (dr.Read())
                        {
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i <= fields; i++)
                            {
                                if (i != fields)
                                {
                                    sep = separator;
                                }
                                else
                                {
                                    sep = "";
                                }
                                sb.Append(dr[i].ToString() + sep);

                            }
                            sw.WriteLine(sb.ToString());
                        }
                        sw.Close();
                        LoyaltyHelper.UploadFile(HttpContext.Current.Server.MapPath(filename), "ftp://www.emunching.com/" + filename, "Toit", "indavest");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            sendEmailToEengage("tech@emunching.com", "", "Generating CSV Exception From Toit", ex.Message, null, "Toit Loyalty");
        }
        
    }

    /// <summary>
    /// Methods to upload file to FTP Server
    /// </summary>
    /// <param name="_FileName">local source file name</param>
    /// <param name="_UploadPath">Upload FTP path including Host name</param>
    /// <param name="_FTPUser">FTP login username</param>
    /// <param name="_FTPPass">FTP login password</param>
    public static void UploadFile(string _FileName, string _UploadPath, string _FTPUser, string _FTPPass)
    {
        System.IO.FileInfo _FileInfo = new System.IO.FileInfo(_FileName);

        try
        {
            // Create FtpWebRequest object from the Uri provided
            System.Net.FtpWebRequest _FtpWebRequest = (System.Net.FtpWebRequest)System.Net.FtpWebRequest.Create(new Uri(_UploadPath));

            // Provide the WebPermission Credintials
            _FtpWebRequest.Credentials = new System.Net.NetworkCredential(_FTPUser, _FTPPass);

            // By default KeepAlive is true, where the control connection is not closed
            // after a command is executed.
            _FtpWebRequest.KeepAlive = false;

            // set timeout for 20 seconds
            _FtpWebRequest.Timeout = 20000;

            // Specify the command to be executed.
            _FtpWebRequest.Method = System.Net.WebRequestMethods.Ftp.UploadFile;

            // Specify the data transfer type.
            _FtpWebRequest.UseBinary = true;

            // Notify the server about the size of the uploaded file
            _FtpWebRequest.ContentLength = _FileInfo.Length;

            //_FtpWebRequest.UsePassive = false;
            // The buffer size is set to 2kb
            int buffLength = 2048;
            byte[] buff = new byte[buffLength];

            // Opens a file stream (System.IO.FileStream) to read the file to be uploaded
            System.IO.FileStream _FileStream = _FileInfo.OpenRead();
            // Stream to which the file to be upload is written
            System.IO.Stream _Stream = _FtpWebRequest.GetRequestStream();

            // Read from the file stream 2kb at a time
            int contentLen = _FileStream.Read(buff, 0, buffLength);

            // Till Stream content ends
            while (contentLen != 0)
            {
                // Write Content from the file stream to the FTP Upload Stream
                _Stream.Write(buff, 0, contentLen);
                contentLen = _FileStream.Read(buff, 0, buffLength);
            }

            // Close the file stream and the Request Stream
            _Stream.Close();
            _Stream.Dispose();
            _FileStream.Close();
            _FileStream.Dispose();
        }
        catch (Exception ex)
        {
            sendEmailToEengage("tech@emunching.com", "", "Uploading Payload Exception From Toit", ex.Message, null, "Toit Loyalty");
            //MessageBox.Show(ex.Message, "Upload Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    public static void sendEmailToEengage(String To, String Cc, String Subject, String Body, String From, String FromName)
    {
        string SMTP_HOST = "smtp.gmail.com";
        string SMTP_USER = "tech@emunching.com";
        string SMTP_PASS = "..emunching01";
        try
        {
            MailMessage msg = new MailMessage();
            msg.Subject = Subject;
            msg.Body = Body;
            msg.IsBodyHtml = true;
            msg.From = new MailAddress("svc@emunching.com", FromName);
            String[] toArray = To.Split(new string[] { ";" }, StringSplitOptions.None);
            String[] ccArray = Cc.Split(new string[] { ";" }, StringSplitOptions.None);
            for (int toLength = 0; toLength < toArray.Length; toLength++)
            {
                msg.To.Add(new MailAddress(toArray[toLength]));
            }

            for (int ccLength = 0; ccLength < ccArray.Length; ccLength++)
            {
                if (!String.IsNullOrEmpty(ccArray[ccLength]))
                {
                    msg.CC.Add(new MailAddress(ccArray[ccLength]));
                }
            }

            SmtpClient smtp = new SmtpClient();
            smtp.Host = SMTP_HOST;

            NetworkCredential authinfo = new NetworkCredential(SMTP_USER, SMTP_PASS);
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = authinfo;
            smtp.EnableSsl = true;
            smtp.Send(msg);
        }
        catch (Exception ex)
        {

        }
    }

    public static void uploadToitUniquecodes()
    {
        string completeFilePath = StringConstants.RESTAURANT_PAYLOAD_PATH;
        var directory = new DirectoryInfo(completeFilePath);
        var fileName = (from f in directory.GetFiles() orderby f.LastWriteTime descending select f).First();
        string filepath = completeFilePath + "batch1.xls";
        string fileExtension = Path.GetExtension(filepath);
        DataTable prmLoyaltyTable = new DataTable();
        prmLoyaltyTable.Columns.Add("LoyaltyNumber", typeof(string));
        prmLoyaltyTable.Columns.Add("RESCOD", typeof(string));
        prmLoyaltyTable.Columns.Add("BillDate", typeof(DateTime));
        prmLoyaltyTable.Columns.Add("BillNumber", typeof(string));
        prmLoyaltyTable.Columns.Add("UserId", typeof(string));
        prmLoyaltyTable.Columns.Add("BillTime", typeof(DateTime));
        prmLoyaltyTable.Columns.Add("STR001", typeof(string));
        prmLoyaltyTable.Columns.Add("NUB001", typeof(string));
        prmLoyaltyTable.Columns.Add("STR002", typeof(string));
        prmLoyaltyTable.Columns.Add("NUB002", typeof(string));
        
        HSSFWorkbook hssfwb;
        using (FileStream file = new FileStream(@filepath, FileMode.Open, FileAccess.Read))
        {
            hssfwb = new HSSFWorkbook(file);
        }

        try
        {
            ISheet isheet = hssfwb.GetSheetAt(0);
            for (int row = 0; row <= isheet.LastRowNum; row++)
            {
                if (isheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    //dynamic value = isheet.GetRow(row).GetCell(1).StringCellValue;
                    string LoyaltyNumber = isheet.GetRow(row).GetCell(0).StringCellValue;
                    prmLoyaltyTable.Rows.Add(LoyaltyNumber, "", "1900-01-01 00:00:00.000", 0, "", "1900-01-01 00:00:00.000", "", 0, "", 0);
                }
            }
            DataSet dataSet = new DataSet();
            dataSet.Tables.Add(prmLoyaltyTable);
            Hashtable connectionObject = Helper.getDBNameAndConnectionStringForLoyalty();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            System.Data.SqlClient.SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connection);
            sqlBulkCopy.DestinationTableName = "dbo.PRMLOYALTY";
            connection.Open();
            sqlBulkCopy.WriteToServer(dataSet.Tables[0]);
        }
        catch (Exception ex)
        {
            
        }
        
    }


    public static void uploadUniqueCodesToServer()
    {
        string completeFilePath = StringConstants.RESTAURANT_PAYLOAD_PATH;
        var directory = new DirectoryInfo(completeFilePath);
        var fileName = (from f in directory.GetFiles() orderby f.LastWriteTime descending select f).First();
        string filepath = completeFilePath + "batch1.xls";
        string fileExtension = Path.GetExtension(filepath);
        DataTable loyaltyTable = new DataTable();
        loyaltyTable.Columns.Add("UniqueCode", typeof(string));
        loyaltyTable.Columns.Add("DateCreated", typeof(DateTime));
        loyaltyTable.Columns.Add("RestaurantId", typeof(int));
        loyaltyTable.Columns.Add("DateAssigned", typeof(DateTime));
        loyaltyTable.Columns.Add("IsAssigned", typeof(byte));
        
        HSSFWorkbook hssfwb;
        using (FileStream file = new FileStream(@filepath, FileMode.Open, FileAccess.Read))
        {
            hssfwb = new HSSFWorkbook(file);
        }

        try
        {
            ISheet isheet = hssfwb.GetSheetAt(0);
            for (int row = 0; row <= isheet.LastRowNum; row++)
            {
                if (isheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    //dynamic value = isheet.GetRow(row).GetCell(1).StringCellValue;
                    string LoyaltyNumber = isheet.GetRow(row).GetCell(0).NumericCellValue.ToString();
                    loyaltyTable.Rows.Add(LoyaltyNumber, DateTime.Now, 67, null, 0);
                }
            }
            DataSet dataSet = new DataSet();
            dataSet.Tables.Add(loyaltyTable);
            Hashtable connectionObject = Helper.getDBNameAndConnectionStringForLoyalty();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            System.Data.SqlClient.SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connection);
            sqlBulkCopy.DestinationTableName = "dbo.Generated_SimpleCouponCode";
            connection.Open();
            sqlBulkCopy.WriteToServer(dataSet.Tables[0]);
        }
        catch (Exception ex)
        {

        }
    }

    public static void uploadCouponCodesToServer()
    {
        string completeFilePath = StringConstants.RESTAURANT_PAYLOAD_PATH;
        var directory = new DirectoryInfo(completeFilePath);
        var fileName = (from f in directory.GetFiles() orderby f.LastWriteTime descending select f).First();
        string filepath = completeFilePath + "batch1.xls";
        string fileExtension = Path.GetExtension(filepath);
        DataTable loyaltyTable = new DataTable();
        loyaltyTable.Columns.Add("UniqueCode", typeof(string));
        loyaltyTable.Columns.Add("DateCreated", typeof(DateTime));
        loyaltyTable.Columns.Add("RestaurantId", typeof(int));
        loyaltyTable.Columns.Add("DateAssigned", typeof(DateTime));
        loyaltyTable.Columns.Add("IsAssigned", typeof(byte));

        HSSFWorkbook hssfwb;
        using (FileStream file = new FileStream(@filepath, FileMode.Open, FileAccess.Read))
        {
            hssfwb = new HSSFWorkbook(file);
        }

        try
        {
            ISheet isheet = hssfwb.GetSheetAt(0);
            for (int row = 0; row <= isheet.LastRowNum; row++)
            {
                if (isheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    //dynamic value = isheet.GetRow(row).GetCell(1).StringCellValue;
                    string LoyaltyNumber = isheet.GetRow(row).GetCell(0).StringCellValue;
                    loyaltyTable.Rows.Add(LoyaltyNumber, DateTime.Now, 67, null, 0);
                }
            }
            DataSet dataSet = new DataSet();
            dataSet.Tables.Add(loyaltyTable);
            Hashtable connectionObject = Helper.getDBNameAndConnectionStringForLoyalty();
            SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
            System.Data.SqlClient.SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(connection);
            sqlBulkCopy.DestinationTableName = "dbo.Generated_SimpleCouponCode";
            connection.Open();
            sqlBulkCopy.WriteToServer(dataSet.Tables[0]);
        }
        catch (Exception ex)
        {

        }
    }
}
