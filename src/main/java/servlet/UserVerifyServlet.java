package servlet;

import java.io.IOException;

import javabeans.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.MailTo;
import dbManager.DBManager;

/**
 * Servlet implementation class UserVerifyServlet
 */
public class UserVerifyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserVerifyServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		int userId = Integer.parseInt(request.getParameter("id"));
		int res = Integer.parseInt(request.getParameter("res"));
		User user = DBManager.dbUtil.getUserByUserId(userId);

		if (res == 1) {
			user.setStatus(true);
			if (DBManager.dbUtil.updateUser(user)) {
				// send an email
				MailTo mail = new MailTo();
				mail.sendUserVerify(user.getEmail(), user.getUserName(), true);
				response.sendRedirect("adminPage/manage_user.jsp");
			}
		} else {
			if (DBManager.dbUtil.deleteUser(userId)) {
				// send an email
				MailTo mail = new MailTo();
				mail.sendUserVerify(user.getEmail(), user.getUserName(), false);
				response.sendRedirect("adminPage/manage_verify.jsp");
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
