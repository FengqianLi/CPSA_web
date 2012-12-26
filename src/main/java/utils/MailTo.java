package utils;

import protocol.MailProtocol;
import protocol.SiteProtocol;

public class MailTo {

	private String serverHost = MailProtocol.SERVERHOST;
	private String ServerPort = MailProtocol.SERVERPORT;
	private String userName = MailProtocol.USERNAME;
	private String password = MailProtocol.PASSWORD;
	private String fromAddress = MailProtocol.FROMADDRESS;
	private String pageAddress = SiteProtocol.URL + "/resetPassword.jsp";
	private String subject = "华为静态代码性能检测系统密码修改";

	public MailTo() {
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
