package stylish.admin.controller;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import stylish.ejb.RolesStateLessBeanLocal;
import stylish.ejb.UsersStateLessBeanLocal;
import stylish.common.SharedFunctions;

@Controller
public class LoginController {

    RolesStateLessBeanLocal rolesStateLessBean = lookupRolesStateLessBeanLocal();
    UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();

    @Autowired
    SharedFunctions sharedFunc;

    @RequestMapping(value = "/admin/login", method = RequestMethod.GET)
    public String login(HttpSession session) {
        String email = (String) session.getAttribute("email");
        if (email != null) {
            session.setAttribute("fList", sharedFunc.getFunctionListFromEmail(email));
//            System.out.println("fList Login: " + sharedFunc.getFunctionListFromEmail(email));
            return "redirect:/admin/index.html";
        }
        return "admin/login";
    }

    @RequestMapping(value = "/admin/login", method = RequestMethod.POST)
    //    @ResponseBody
    public String login(ModelMap model,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "remember", required = false) Short remember,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            RedirectAttributes redirectAttributes) {
        int error = usersStateLessBean.login(email, sharedFunc.encodePassword(password));
//        System.out.println("remember: " + remember);
        switch (error) {
            case 1:
                session.setAttribute("email", email);
                session.setAttribute("fList", sharedFunc.getFunctionListFromEmail(email));
//                System.out.println("fList Login: " + sharedFunc.getFunctionListFromEmail(email));
                
                if (remember != null && remember == 1) {
                    Cookie ckEmail = new Cookie("emailA", email);
                    ckEmail.setMaxAge(24 * 60 * 60);
                    response.addCookie(ckEmail);
                    Cookie ckPassword = new Cookie("passwordA", sharedFunc.encodePassword(password));
                    ckPassword.setMaxAge(24 * 60 * 60);
                    response.addCookie(ckPassword);
                }

                if (session.getAttribute("request_url") == null || ((String) session.getAttribute("request_url")).equals("/admin/logout.html")) {
                    session.removeAttribute("request_url");
                    return "redirect:/admin/index.html";
                } else {
                    return "redirect:" + session.getAttribute("request_url");
                }
            case 2:
                model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Error Email Wrong!</div>");
                break;
            case 3:
                model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Error Wrong!</div>");
                break;
            default:
                model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Error Password Wrong!</div>");
                break;
        }
        return "admin/login";
    }

    @RequestMapping(value = "/admin/logout")
    public String logOut(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        ///Remove Session
        session.removeAttribute("email");

        // Remove Cookie
        for (Cookie ck : request.getCookies()) {
            if (ck.getName().equalsIgnoreCase("emailA")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
            if (ck.getName().equalsIgnoreCase("passwordA")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
        }
        return "redirect:/admin/login.html";
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

    private RolesStateLessBeanLocal lookupRolesStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (RolesStateLessBeanLocal) c.lookup("java:global/stylishstore/RolesStateLessBean!stylish.ejb.RolesStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
