package stylish.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
public class WishList implements Serializable {

    private static final long serialVersionUID = 924878530828727472L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer wishID;

    @ManyToOne
    @JoinColumn(name = "userID")
    @JsonBackReference
    private Users user;

    @ManyToOne
    @JoinColumn(name = "productID")
    @JsonBackReference
    private Products product;

    @DateTimeFormat(pattern = "MM/dd/yyyy")
    @Temporal(TemporalType.DATE)
    private Date createDate;

    public Integer getWishID() {
        return wishID;
    }

    public void setWishID(Integer wishID) {
        this.wishID = wishID;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

}
