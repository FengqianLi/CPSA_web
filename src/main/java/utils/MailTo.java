package utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;

public class MailTo {

	private String serverHost;
	private String ServerPort;
	private String userName;
	private String password;
	private String fromAddress;
	private String pageAddress;
	private String subject;

	public MailTo() {
		Properties mailProp = new Properties();
		Properties siteProp = new Properties();
		FileInputStream mailFis;
		FileInputStream siteFis;
		try {
			String path = MailTo.class.getClassLoader().getResource("").toURI()
					.getPath();
			mailFis = new FileInputStream(path + "mailconfig.xml");
			mailProp.loadFromXML(mailFis);
			siteFis = new FileInputStream(path + "siteconfig.xml");
			siteProp.loadFromXML(siteFis);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (InvalidPropertiesFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}

		this.serverHost = mailProp.getProperty("server host");
		this.ServerPort = mailProp.getProperty("server port");
		this.userName = mailProp.getProperty("user");
		this.password = mailProp.getProperty("password");
		this.fromAddress = mailProp.getProperty("from address");
		this.pageAddress = siteProp.getProperty("site url")
				+ "/resetPassword.jsp";
		this.subject = "华为静态代码性能检测系统密码修改";
	}

	public void sendResetPassword(String toAddress, String userName, String id) {
		MailSenderInfo mailInfo = new MailSenderInfo();
		mailInfo.setMailServerHost(this.serverHost);
		mailInfo.setMailServerPort(this.ServerPort);
		mailInfo.setValidate(true);
		mailInfo.setUserName(this.userName);
		mailInfo.setPassword(this.password);
		mailInfo.setFromAddress(this.fromAddress);
		mailInfo.setToAddress(toAddress);
		mailInfo.setSubject(this.subject);
		mailInfo.setContent(EmailContent.getResetPasswordContent(userName,
				pageAddress + "?id=" + id));

		SimpleMailSender sms = new SimpleMailSender();
		sms.sendHtmlMail(mailInfo);
	}

	public void sendUserVerify(String toAddress, String userName, boolean res) {
		MailSenderInfo mailInfo = new MailSenderInfo();
		mailInfo.setMailServerHost(this.serverHost);
		mailInfo.setMailServerPort(this.ServerPort);
		mailInfo.setValidate(true);
		mailInfo.setUserName(this.userName);
		mailInfo.setPassword(this.password);
		mailInfo.setFromAddress(this.fromAddress);
		mailInfo.setToAddress(toAddress);
		mailInfo.setSubject(this.subject);
		if (res)
			mailInfo.setContent(EmailContent.getVerifySuccessContent(userName));
		else
			mailInfo.setContent(EmailContent.getVerifyFailContent(userName));

		SimpleMailSender sms = new SimpleMailSender();
		sms.sendHtmlMail(mailInfo);
	}
}
