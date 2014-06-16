using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Net;


namespace Utilities
{
    public class MailHelper
    {
        public const String RESTAURANT_ADMIN_PATH = "~/Restaurants/Admin/Admin/default.aspx";
        public const String SMTP_HOST = "smtp.gmail.com";
        public const String SMTP_USER = "tech@emunching.com";
        public const String SMTP_PASS = "..emunching01";
        public MailHelper()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static Boolean SendMail(String To, String Cc, String Subject, String Body, String From, String FromName)
        {
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
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}