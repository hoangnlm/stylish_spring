package stylish.interceptor;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import stylish.ejb.UsersStateLessBeanLocal;

public class LoginInterceptor extends HandlerInterceptorAdapter {

    private UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.
        HttpSession session = request.getSession();
        String ctx = request.getContextPath();
        String uri = request.getRequestURI();
        String base = uri.substring(ctx.length());
//        System.out.println("base: " + base);
        session.setAttribute("request_url", base);      // Dung luu url de redirect lai trang do sau khi login

        if (session.getAttribute("email") != null) {
            return true; //Cho vào
        } else { //không có session
            Cookie[] ck = request.getCookies();
            if (ck != null) { //Nếu có cookie
                String email = "";
                String pass = "";
                for (Cookie c : ck) {
                    if (c.getName().equals("emailA")) {
                        email = c.getValue();
                    }
                    if (c.getName().equals("passwordA")) {
                        pass = c.getValue();
                    }
                }

                if (email != "" && pass != "") {
                    int error = usersStateLessBean.login(email, pass);
                    if (error == 1) {
                        session.setAttribute("email", email);
                        return true;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/login.html");
//                session.setAttribute("request_url", base);
                return false; //Có cookie
            } else { //Không có cookie
                response.sendRedirect(request.getContextPath() + "/admin/login.html");
                return false;
            }
        }

    }

    private UsersStateLessBeanLocal lookupUsersStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (UsersStateLessBeanLocal) c.lookup("java:global/stylishstore/UsersStateLessBean!stylish.ejb.UsersStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
