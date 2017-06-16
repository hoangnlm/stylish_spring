<%@page import="stylish.entity.CartLineInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<!-- MAIN CONTENT -->
<!--<div class="shop-single shopping-cart">
    <div class="container">
        <div class="row">
            <div id="error">
${error}
</div>
<div class="col-md-12 col-sm-12">
<c:if test="${empty compareList}">
    <h4 style="font-weight: bold; background-color: #FFFFFF; padding: 30px; text-align: center; font-size: 30px; line-height: 50px;">Please choose some products to compare! <br/><a style="cursor: pointer;" href="index.html">Continue shopping...</a></h4>
</c:if>
<c:if test="${not empty compareList}">
<form method="GET" action="compare/deleteAll.html">
    <table class="cart-table">
        <thead>
            <tr>
                <th>Product Image</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Product discount</th>
                <th>Remove</th>
            </tr>
        </thead>
        <tbody>
    <c:forEach items="${compareList}" var="item">
        <tr id="fs-compare-del-${item.productID}">
            <td>
                <img src="assets/images/products/${item.urlImg}" class="img-responsive" alt=""/>
            </td>
            <td>
                <h4>
                    <a href="${item.productID}.html">
        ${item.productName}
    </a>
</h4>
</td>
<td>
<div class="item-price">$${item.price}</div>
</td>
<td>
<div class="item-price">-$${item.productDiscount}</div>
</td>
<td><a class="fs-compare-del" fs-compare-del-id="${item.productID}" onclick="return confirm('Are you sure to clear all?');"><i class="fa fa-trash-o"></i></a></td>
</tr>
    </c:forEach>
</tbody>
</table>
<div class="table-btn">
<a href="index.html" class="btn-black pull-left">Continue Shopping</a>
<button type="submit" class="btn-black pull-right" onclick="return confirm('Are you sure to clear all?');">Clear All</button>
</div>
</form>
</c:if>
<div class="clearfix space10"></div>
<div class="space40"></div>
</div>
</div>
</div>
</div>
<div class="clearfix space20"></div> -->

<style>
    /* -------------------------------- 
    
    Primary style
    
    -------------------------------- */
    *, *::after, *::before {
        box-sizing: border-box;
    }

    a {
        color: #9dc997;
        text-decoration: none;
    }

    img {
        max-width: 100%;
    }

    h1 {
        font-size: 2.2rem;
        text-align: center;
        padding: 4em 5%;
    }
    @media only screen and (min-width: 1170px) {
        h1 {
            font-size: 4rem;
            font-weight: 300;
            padding: 3em 5%;
        }
    }

    .cd-features-list{
        background-color: rgba(255,255,255,0.5);
    }

    .fs-compare-del {
        cursor: pointer;
    }

    div.compare-img{
        text-align: center;
    }


    /* -------------------------------- 
    
    Main Components 
    
    -------------------------------- */
    .cd-products-comparison-table {
        margin-bottom: 6em;
    }
    .cd-products-comparison-table::after {
        /* never visible - this is used in jQuery to check the current MQ */
        display: none;
        content: 'mobile';
    }
    .cd-products-comparison-table header {
        padding: 0 5% 25px;
    }
    .cd-products-comparison-table header::after {
        clear: both;
        content: "";
        display: table;
    }
    .cd-products-comparison-table h2 {
        float: left;
        font-weight: bold;
    }
    .cd-products-comparison-table .actions {
        float: right;
    }
    .cd-products-comparison-table .reset, .cd-products-comparison-table .filter {
        font-size: 1.4rem;
    }
    .cd-products-comparison-table .reset {
        color: #404042;
        text-decoration: underline;
    }
    .cd-products-comparison-table .filter {
        padding: .6em 1.5em;
        color: #ffffff;
        background-color: #cccccc;
        border-radius: 3px;
        margin-left: 1em;
        cursor: not-allowed;
        -webkit-transition: background-color 0.3s;
        -moz-transition: background-color 0.3s;
        transition: background-color 0.3s;
    }
    .cd-products-comparison-table .filter.active {
        cursor: pointer;
        background-color: #9dc997;
    }
    .no-touch .cd-products-comparison-table .filter.active:hover {
        background-color: #a7cea1;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-comparison-table {
            margin-bottom: 8em;
        }
        .cd-products-comparison-table::after {
            /* never visible - this is used in jQuery to check the current MQ */
            content: 'desktop';
        }
        .cd-products-comparison-table header {
            padding: 0 5% 40px;
        }
        .cd-products-comparison-table h2 {
            font-size: 2.4rem;
        }
        .cd-products-comparison-table .reset, .cd-products-comparison-table .filter {
            font-size: 1.6rem;
        }
        .cd-products-comparison-table .filter {
            padding: .6em 2em;
            margin-left: 1.6em;
        }
    }

    .cd-products-table {
        position: relative;
        overflow: hidden;
    }

    .cd-products-table .features {
        /* fixed left column - product properties list */
        position: absolute;
        z-index: 1;
        top: 0;
        left: 0;
        width: 120px;
        border-style: solid;
        border-color: #e6e6e6;
        border-top-width: 1px;
        border-bottom-width: 1px;
        background-color: #fafafa;
        opacity: .95;
    }
    .cd-products-table .features::after {
        /* color gradient on the right of .features -  visible while scrolling inside the .cd-products-table */
        content: '';
        position: absolute;
        top: 0;
        left: 100%;
        width: 4px;
        height: 100%;
        background-color: transparent;
        background-image: -webkit-linear-gradient(left, rgba(0, 0, 0, 0.06), transparent);
        background-image: linear-gradient(to right,rgba(0, 0, 0, 0.06), transparent);
        opacity: 0;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-table .features {
            width: 210px;
        }
    }

    .cd-products-table.scrolling .features::after {
        opacity: 1;
    }

    .cd-products-wrapper {
        overflow-x: hidden;
        /* this fixes the buggy scrolling on webkit browsers - mobile devices only - when overflow property is applied */
        -webkit-overflow-scrolling: touch;
        border-style: solid;
        border-color: #e6e6e6;
        border-top-width: 1px;
        border-bottom-width: 1px;
    }

    .cd-products-columns {
        /* products list wrapper */
        width: 1200px;
        margin-left: 120px;
    }
    .cd-products-columns::after {
        clear: both;
        content: "";
        display: table;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-columns {
            width: 2480px;
            margin-left: 210px;
        }
    }

    .cd-products-columns .product {
        position: relative;
        float: left;
        width: 150px;
        text-align: center;
        -webkit-transition: opacity 0.3s, visibility 0.3s, -webkit-transform 0.3s;
        -moz-transition: opacity 0.3s, visibility 0.3s, -moz-transform 0.3s;
        transition: opacity 0.3s, visibility 0.3s, transform 0.3s;
    }
    .filtering .cd-products-columns .product:not(.selected) {
        opacity: 0;
        visibility: hidden;
        -webkit-transform: scale(0);
        -moz-transform: scale(0);
        -ms-transform: scale(0);
        -o-transform: scale(0);
        transform: scale(0);
    }
    .no-product-transition .cd-products-columns .product.selected {
        -webkit-transition: opacity 0.3s, visibility 0.3s;
        -moz-transition: opacity 0.3s, visibility 0.3s;
        transition: opacity 0.3s, visibility 0.3s;
    }
    .filtered .cd-products-columns .product:not(.selected) {
        position: absolute;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-columns .product {
            width: 310px;
        }
    }

    .cd-features-list li {
        font-size: 1.4rem;
        font-weight: bold;
        padding: 25px 40px;
        border-color: #e6e6e6;
        border-style: solid;
        border-top-width: 1px;
        border-right-width: 1px;
        height: 70px;
    }
    .cd-features-list li.rate {
        /* rating stars */
        padding: 21px 0;
    }
    .cd-features-list li.rate span {
        display: inline-block;
        height: 22px;
        width: 110px;
        background: url(../img/cd-star.svg);
        color: transparent;
    }
    @media only screen and (min-width: 1170px) {
        .cd-features-list li {
            font-size: 1.6rem;
        }
        .cd-features-list li.rate {
            padding: 22px 0;
        }
    }

    .features .cd-features-list li,
    .cd-products-table .features .top-info {
        /* fixed left column - items */
        font-size: 1.2rem;
        font-weight: bold;
        /* set line-height value equal to font-size of text inside product cells */
        line-height: 14px;
        padding: 25px 10px;
        text-align: left;
    }
    @media only screen and (min-width: 1170px) {
        .features .cd-features-list li,
        .cd-products-table .features .top-info {
            text-transform: uppercase;
            line-height: 16px;
            padding: 25px 20px;
            letter-spacing: 1px;
        }
    }

    .features .cd-features-list li {
        /* truncate text with dots */
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
    }

    .cd-products-table .top-info {
        position: relative;
        height: 177px;
        width: 150px;
        text-align: center;
        padding: 1.25em 2.5em;
        border-color: #e6e6e6;
        border-style: solid;
        border-right-width: 1px;
        -webkit-transition: height 0.3s;
        -moz-transition: height 0.3s;
        transition: height 0.3s;
        background: #ffffff;
    }
    .cd-products-table .top-info::after {
        /* color gradient below .top-info -  visible when .top-info is fixed */
        content: '';
        position: absolute;
        left: 0;
        top: 100%;
        height: 4px;
        width: 100%;
        background-color: transparent;
        background-image: -webkit-linear-gradient(top, rgba(0, 0, 0, 0.06), transparent);
        background-image: linear-gradient(to bottom,rgba(0, 0, 0, 0.06), transparent);
        opacity: 0;
    }
    .cd-products-table .top-info h3 {
        padding: 1.25em 0 0.625em;
        font-weight: bold;
        font-size: 1.4rem;
    }
    .cd-products-table .top-info img {
        -webkit-backface-visibility: hidden;
        backface-visibility: hidden;
    }
    .cd-products-table .top-info h3, .cd-products-table .top-info img {
        -webkit-transition: -webkit-transform 0.3s;
        -moz-transition: -moz-transform 0.3s;
        transition: transform 0.3s;
    }
    .cd-products-table .top-info .check {
        position: relative;
        display: inline-block;
        height: 16px;
        width: 16px;
        margin: 0 auto 1em;
    }
    .cd-products-table .top-info .check::after, .cd-products-table .top-info .check::before {
        /* used to create the check icon and green circle dot - visible when product is selected */
        position: absolute;
        top: 0;
        left: 0;
        content: '';
        height: 100%;
        width: 100%;
    }
    .cd-products-table .top-info .check::before {
        /* green circle dot */
        border-radius: 50%;
        border: 1px solid #e6e6e6;
        background: #ffffff;
        -webkit-transition: background-color 0.3s, -webkit-transform 0.3s, border-color 0.3s;
        -moz-transition: background-color 0.3s, -moz-transform 0.3s, border-color 0.3s;
        transition: background-color 0.3s, transform 0.3s, border-color 0.3s;
    }
    .cd-products-table .top-info .check::after {
        /* check icon */
        background: url(../img/cd-check.svg) no-repeat center center;
        background-size: 24px 24px;
        opacity: 0;
        -webkit-transition: opacity 0.3s;
        -moz-transition: opacity 0.3s;
        transition: opacity 0.3s;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-table .top-info {
            height: 280px;
            width: 310px;
        }
        .cd-products-table .top-info h3 {
            padding-top: 1.4em;
            font-size: 1.6rem;
        }
        .cd-products-table .top-info .check {
            margin-bottom: 1.5em;
        }
    }

    .cd-products-table .features .top-info {
        /* models */
        width: 120px;
        cursor: auto;
        background: #fafafa;
    }
    @media only screen and (min-width: 1170px) {
        .cd-products-table .features .top-info {
            width: 210px;
        }
    }

    .cd-products-table .selected .top-info .check::before {
        /* green circle dot */
        background: #9dc997;
        border-color: #9dc997;
        -webkit-transform: scale(1.5);
        -moz-transform: scale(1.5);
        -ms-transform: scale(1.5);
        -o-transform: scale(1.5);
        transform: scale(1.5);
        -webkit-animation: cd-bounce 0.3s;
        -moz-animation: cd-bounce 0.3s;
        animation: cd-bounce 0.3s;
    }

    @-webkit-keyframes cd-bounce {
        0% {
            -webkit-transform: scale(1);
        }
        60% {
            -webkit-transform: scale(1.6);
        }
        100% {
            -webkit-transform: scale(1.5);
        }
    }
    @-moz-keyframes cd-bounce {
        0% {
            -moz-transform: scale(1);
        }
        60% {
            -moz-transform: scale(1.6);
        }
        100% {
            -moz-transform: scale(1.5);
        }
    }
    @keyframes cd-bounce {
        0% {
            -webkit-transform: scale(1);
            -moz-transform: scale(1);
            -ms-transform: scale(1);
            -o-transform: scale(1);
            transform: scale(1);
        }
        60% {
            -webkit-transform: scale(1.6);
            -moz-transform: scale(1.6);
            -ms-transform: scale(1.6);
            -o-transform: scale(1.6);
            transform: scale(1.6);
        }
        100% {
            -webkit-transform: scale(1.5);
            -moz-transform: scale(1.5);
            -ms-transform: scale(1.5);
            -o-transform: scale(1.5);
            transform: scale(1.5);
        }
    }
    .cd-products-table .selected .top-info .check::after {
        /* check icon */
        opacity: 1;
    }

    @media only screen and (min-width: 1170px) {
        .cd-products-table.top-fixed .cd-products-columns > li,
        .cd-products-table.top-scrolling .cd-products-columns > li,
        .cd-products-table.top-fixed .features,
        .cd-products-table.top-scrolling .features {
            padding-top: 160px;
        }

        .cd-products-table.top-fixed .top-info,
        .cd-products-table.top-scrolling .top-info {
            height: 160px;
            position: fixed;
            top: 0;
        }
        .no-cssgradients .cd-products-table.top-fixed .top-info, .no-cssgradients
        .cd-products-table.top-scrolling .top-info {
            border-bottom: 1px solid #e6e6e6;
        }
        .cd-products-table.top-fixed .top-info::after,
        .cd-products-table.top-scrolling .top-info::after {
            opacity: 1;
        }
        .cd-products-table.top-fixed .top-info h3,
        .cd-products-table.top-scrolling .top-info h3 {
            -webkit-transform: translateY(-116px);
            -moz-transform: translateY(-116px);
            -ms-transform: translateY(-116px);
            -o-transform: translateY(-116px);
            transform: translateY(-116px);
        }
        .cd-products-table.top-fixed .top-info img,
        .cd-products-table.top-scrolling .top-info img {
            -webkit-transform: translateY(-62px) scale(0.4);
            -moz-transform: translateY(-62px) scale(0.4);
            -ms-transform: translateY(-62px) scale(0.4);
            -o-transform: translateY(-62px) scale(0.4);
            transform: translateY(-62px) scale(0.4);
        }

        .cd-products-table.top-scrolling .top-info {
            position: absolute;
        }
    }
    .cd-table-navigation a {
        position: absolute;
        z-index: 2;
        top: 0;
        right: 15px;
        -webkit-transform: translateY(55px);
        -moz-transform: translateY(55px);
        -ms-transform: translateY(55px);
        -o-transform: translateY(55px);
        transform: translateY(55px);
        /* replace text with image */
        overflow: hidden;
        text-indent: 100%;
        white-space: nowrap;
        color: transparent;
        height: 60px;
        width: 40px;
        background: rgba(64, 64, 66, 0.8) url("assets/images/cd-arrow.svg") no-repeat center center;
        border-radius: 3px;
        -webkit-transition: background-color 0.3s, opacity 0.3s, visibility 0.3s, -webkit-transform 0.3s;
        -moz-transition: background-color 0.3s, opacity 0.3s, visibility 0.3s, -moz-transform 0.3s;
        transition: background-color 0.3s, opacity 0.3s, visibility 0.3s, transform 0.3s;
    }
    .cd-table-navigation a.inactive {
        opacity: 0;
        visibility: hidden;
    }
    .cd-table-navigation a.prev {
        left: 120px;
        right: auto;
        -webkit-transform: translateY(55px) translateX(15px) rotate(180deg);
        -moz-transform: translateY(55px) translateX(15px) rotate(180deg);
        -ms-transform: translateY(55px) translateX(15px) rotate(180deg);
        -o-transform: translateY(55px) translateX(15px) rotate(180deg);
        transform: translateY(55px) translateX(15px) rotate(180deg);
    }
    .no-touch .cd-table-navigation a:hover {
        background-color: #404042;
    }
    @media only screen and (min-width: 1170px) {
        .cd-table-navigation a {
            -webkit-transform: translateY(100px);
            -moz-transform: translateY(100px);
            -ms-transform: translateY(100px);
            -o-transform: translateY(100px);
            transform: translateY(100px);
        }
        .cd-table-navigation a.prev {
            left: 210px;
            -webkit-transform: translateY(100px) translateX(15px) rotate(180deg);
            -moz-transform: translateY(100px) translateX(15px) rotate(180deg);
            -ms-transform: translateY(100px) translateX(15px) rotate(180deg);
            -o-transform: translateY(100px) translateX(15px) rotate(180deg);
            transform: translateY(100px) translateX(15px) rotate(180deg);
        }
        .top-fixed .cd-table-navigation a {
            position: fixed;
        }
        .top-fixed .cd-table-navigation a, .top-scrolling .cd-table-navigation a {
            -webkit-transform: translateY(45px);
            -moz-transform: translateY(45px);
            -ms-transform: translateY(45px);
            -o-transform: translateY(45px);
            transform: translateY(45px);
        }
        .top-fixed .cd-table-navigation a.prev, .top-scrolling .cd-table-navigation a.prev {
            -webkit-transform: translateY(45px) translateX(15px) rotate(180deg);
            -moz-transform: translateY(45px) translateX(15px) rotate(180deg);
            -ms-transform: translateY(45px) translateX(15px) rotate(180deg);
            -o-transform: translateY(45px) translateX(15px) rotate(180deg);
            transform: translateY(45px) translateX(15px) rotate(180deg);
        }
    }

    /* -------------------------------- 
    
    No JS
    
    -------------------------------- */
    .no-js .actions {
        display: none;
    }

    .no-js .cd-products-table .top-info {
        height: 145px;
    }
    @media only screen and (min-width: 1170px) {
        .no-js .cd-products-table .top-info {
            height: 248px;
        }
    }

    .no-js .cd-products-columns .check {
        display: none;
    }

</style>

<script>
    // Compare layout script

    jQuery(document).ready(function ($) {
        function productsTable(element) {
            this.element = element;
            this.table = this.element.children('.cd-products-table');
            this.tableHeight = this.table.height();
            this.productsWrapper = this.table.children('.cd-products-wrapper');
            this.tableColumns = this.productsWrapper.children('.cd-products-columns');
            this.products = this.tableColumns.children('.product');
            this.productsNumber = this.products.length;
            this.productWidth = this.products.eq(0).width();
            this.productsTopInfo = this.table.find('.top-info');
            this.featuresTopInfo = this.table.children('.features').children('.top-info');
            this.topInfoHeight = this.featuresTopInfo.innerHeight() + 30;
            this.leftScrolling = false;
            this.filterBtn = this.element.find('.filter');
            this.resetBtn = this.element.find('.reset');
            this.filtering = false,
                    this.selectedproductsNumber = 0;
            this.filterActive = false;
            this.navigation = this.table.children('.cd-table-navigation');
            // bind table events
            this.bindEvents();
        }

        productsTable.prototype.bindEvents = function () {
            var self = this;
            //detect scroll left inside producst table
            self.productsWrapper.on('scroll', function () {
                if (!self.leftScrolling) {
                    self.leftScrolling = true;
                    (!window.requestAnimationFrame) ? setTimeout(function () {
                        self.updateLeftScrolling();
                    }, 250) : window.requestAnimationFrame(function () {
                        self.updateLeftScrolling();
                    });
                }
            });
            //select single product to filter
//            self.products.on('click', '.top-info', function () {
//                var product = $(this).parents('.product');
//                if (!self.filtering && product.hasClass('selected')) {
//                    product.removeClass('selected');
//                    self.selectedproductsNumber = self.selectedproductsNumber - 1;
//                    self.upadteFilterBtn();
//                } else if (!self.filtering && !product.hasClass('selected')) {
//                    product.addClass('selected');
//                    self.selectedproductsNumber = self.selectedproductsNumber + 1;
//                    self.upadteFilterBtn();
//                }
//            });
            //filter products
            self.filterBtn.on('click', function (event) {
                event.preventDefault();
                if (self.filterActive) {
                    self.filtering = true;
                    self.showSelection();
                    self.filterActive = false;
                    self.filterBtn.removeClass('active');
                }
            });
            //reset product selection
            self.resetBtn.on('click', function (event) {
                event.preventDefault();
                if (self.filtering) {
                    self.filtering = false;
                    self.resetSelection();
                } else {
                    self.products.removeClass('selected');
                }
                self.selectedproductsNumber = 0;
                self.upadteFilterBtn();
            });
            //scroll inside products table
            this.navigation.on('click', 'a', function (event) {
                event.preventDefault();
                self.updateSlider($(event.target).hasClass('next'));
            });
        }

        productsTable.prototype.upadteFilterBtn = function () {
            //show/hide filter btn
            if (this.selectedproductsNumber >= 2) {
                this.filterActive = true;
                this.filterBtn.addClass('active');
            } else {
                this.filterActive = false;
                this.filterBtn.removeClass('active');
            }
        }

        productsTable.prototype.updateLeftScrolling = function () {
            var totalTableWidth = parseInt(this.tableColumns.eq(0).outerWidth(true)),
                    tableViewport = parseInt(this.element.width()),
                    scrollLeft = this.productsWrapper.scrollLeft();

            (scrollLeft > 0) ? this.table.addClass('scrolling') : this.table.removeClass('scrolling');

            if (this.table.hasClass('top-fixed') && checkMQ() == 'desktop') {
                setTranformX(this.productsTopInfo, '-' + scrollLeft);
                setTranformX(this.featuresTopInfo, '0');
            }

            this.leftScrolling = false;

            this.updateNavigationVisibility(scrollLeft);
        }

        productsTable.prototype.updateNavigationVisibility = function (scrollLeft) {
            (scrollLeft > 0) ? this.navigation.find('.prev').removeClass('inactive') : this.navigation.find('.prev').addClass('inactive');
            (scrollLeft < this.tableColumns.outerWidth(true) - this.productsWrapper.width() && this.tableColumns.outerWidth(true) > this.productsWrapper.width()) ? this.navigation.find('.next').removeClass('inactive') : this.navigation.find('.next').addClass('inactive');
        }

        productsTable.prototype.updateTopScrolling = function (scrollTop) {
            var offsetTop = this.table.offset().top,
                    tableScrollLeft = this.productsWrapper.scrollLeft();

            if (offsetTop <= scrollTop && offsetTop + this.tableHeight - this.topInfoHeight >= scrollTop) {
                //fix products top-info && arrows navigation
                if (!this.table.hasClass('top-fixed') && $(document).height() > offsetTop + $(window).height() + 200) {
                    this.table.addClass('top-fixed').removeClass('top-scrolling');
                    if (checkMQ() == 'desktop') {
                        this.productsTopInfo.css('top', '0');
                        this.navigation.find('a').css('top', '0px');
                    }
                }

            } else if (offsetTop <= scrollTop) {
                //product top-info && arrows navigation -  scroll with table
                this.table.removeClass('top-fixed').addClass('top-scrolling');
                if (checkMQ() == 'desktop') {
                    this.productsTopInfo.css('top', (this.tableHeight - this.topInfoHeight) + 'px');
                    this.navigation.find('a').css('top', (this.tableHeight - this.topInfoHeight) + 'px');
                }
            } else {
                //product top-info && arrows navigation -  reset style
                this.table.removeClass('top-fixed top-scrolling');
                this.productsTopInfo.attr('style', '');
                this.navigation.find('a').attr('style', '');
            }

            this.updateLeftScrolling();
        }

        productsTable.prototype.updateProperties = function () {
            this.tableHeight = this.table.height();
            this.productWidth = this.products.eq(0).width();
            this.topInfoHeight = this.featuresTopInfo.innerHeight() + 30;
            this.tableColumns.css('width', this.productWidth * this.productsNumber + 'px');
        }

        productsTable.prototype.showSelection = function () {
            this.element.addClass('filtering');
            this.filterProducts();
        }

        productsTable.prototype.resetSelection = function () {
            this.tableColumns.css('width', this.productWidth * this.productsNumber + 'px');
            this.element.removeClass('no-product-transition');
            this.resetProductsVisibility();
        }

        productsTable.prototype.filterProducts = function () {
            var self = this,
                    containerOffsetLeft = self.tableColumns.offset().left,
                    scrollLeft = self.productsWrapper.scrollLeft(),
                    selectedProducts = this.products.filter('.selected'),
                    numberProducts = selectedProducts.length;

            selectedProducts.each(function (index) {
                var product = $(this),
                        leftTranslate = containerOffsetLeft + index * self.productWidth + scrollLeft - product.offset().left;
                setTranformX(product, leftTranslate);

                if (index == numberProducts - 1) {
                    product.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function () {
                        setTimeout(function () {
                            self.element.addClass('no-product-transition');
                        }, 50);
                        setTimeout(function () {
                            self.element.addClass('filtered');
                            self.productsWrapper.scrollLeft(0);
                            self.tableColumns.css('width', self.productWidth * numberProducts + 'px');
                            selectedProducts.attr('style', '');
                            product.off('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend');
                            self.updateNavigationVisibility(0);
                        }, 100);
                    });
                }
            });

            if ($('.no-csstransitions').length > 0) {
                //browser not supporting css transitions
                self.element.addClass('filtered');
                self.productsWrapper.scrollLeft(0);
                self.tableColumns.css('width', self.productWidth * numberProducts + 'px');
                selectedProducts.attr('style', '');
                self.updateNavigationVisibility(0);
            }
        }

        productsTable.prototype.resetProductsVisibility = function () {
            var self = this,
                    containerOffsetLeft = self.tableColumns.offset().left,
                    selectedProducts = this.products.filter('.selected'),
                    numberProducts = selectedProducts.length,
                    scrollLeft = self.productsWrapper.scrollLeft(),
                    n = 0;

            self.element.addClass('no-product-transition').removeClass('filtered');

            self.products.each(function (index) {
                var product = $(this);
                if (product.hasClass('selected')) {
                    n = n + 1;
                    var leftTranslate = (-index + n - 1) * self.productWidth;
                    setTranformX(product, leftTranslate);
                }
            });

            setTimeout(function () {
                self.element.removeClass('no-product-transition filtering');
                setTranformX(selectedProducts, '0');
                selectedProducts.removeClass('selected').attr('style', '');
            }, 50);
        }

        productsTable.prototype.updateSlider = function (bool) {
            var scrollLeft = this.productsWrapper.scrollLeft();
            scrollLeft = (bool) ? scrollLeft + this.productWidth : scrollLeft - this.productWidth;

            if (scrollLeft < 0)
                scrollLeft = 0;
            if (scrollLeft > this.tableColumns.outerWidth(true) - this.productsWrapper.width())
                scrollLeft = this.tableColumns.outerWidth(true) - this.productsWrapper.width();

            this.productsWrapper.animate({scrollLeft: scrollLeft}, 200);
        }

        var comparisonTables = [];
        $('.cd-products-comparison-table').each(function () {
            //create a productsTable object for each .cd-products-comparison-table
            comparisonTables.push(new productsTable($(this)));
        });

        var windowScrolling = false;
        //detect window scroll - fix product top-info on scrolling
        $(window).on('scroll', function () {
            if (!windowScrolling) {
                windowScrolling = true;
                (!window.requestAnimationFrame) ? setTimeout(checkScrolling, 250) : window.requestAnimationFrame(checkScrolling);
            }
        });

        var windowResize = false;
        //detect window resize - reset .cd-products-comparison-table properties
        $(window).on('resize', function () {
            if (!windowResize) {
                windowResize = true;
                (!window.requestAnimationFrame) ? setTimeout(checkResize, 250) : window.requestAnimationFrame(checkResize);
            }
        });

        function checkScrolling() {
            var scrollTop = $(window).scrollTop();
            comparisonTables.forEach(function (element) {
                element.updateTopScrolling(scrollTop);
            });

            windowScrolling = false;
        }

        function checkResize() {
            comparisonTables.forEach(function (element) {
                element.updateProperties();
            });

            windowResize = false;
        }

        function checkMQ() {
            //check if mobile or desktop device
            return window.getComputedStyle(comparisonTables[0].element.get(0), '::after').getPropertyValue('content').replace(/'/g, "").replace(/"/g, "");
        }

        function setTranformX(element, value) {
            element.css({
                '-moz-transform': 'translateX(' + value + 'px)',
                '-webkit-transform': 'translateX(' + value + 'px)',
                '-ms-transform': 'translateX(' + value + 'px)',
                '-o-transform': 'translateX(' + value + 'px)',
                'transform': 'translateX(' + value + 'px)'
            });
        }
    });
</script>

<c:if test="${empty compareList}">
    <h4 style="font-weight: bold; background-color: #FFFFFF; padding: 30px; text-align: center; font-size: 30px; line-height: 50px;">Please choose some products to compare! <br/><a style="cursor: pointer;" href="index.html">Continue shopping...</a>
    </h4>
</c:if>

<c:if test="${not empty compareList}">
    <div class="compare-table">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <form method="GET" action="compare/deleteAll.html">
                        <button type="submit" style="margin-left: 20px;" class="btn-black pull-right" onclick="return confirm('Are you sure to clear all?');">Clear all</button>
                        <a href="index.html" class="btn-black pull-right">Back to shopping</a>
                    </form
                </div>
            </div>
        </div>
        <section class="cd-products-comparison-table">
            <div class="cd-products-table">
                <div class="features">
                    <div class="top-info">Models</div>
                    <ul class="cd-features-list">
                        <li>Price</li>
                        <li>Discount</li>
                        <li>Posted Date</li>
                        <li>Views</li>
                    </ul>
                </div> <!-- .features -->

                <div class="cd-products-wrapper">
                    <ul class="cd-products-columns">

                        <c:forEach items="${compareList}" var="item">
                            <li class="product" id="fs-compare-del-${item.productID}">
                                <div class="top-info">
                                    <a class="fs-compare-del" fs-compare-del-id="${item.productID}"><span style="font-size: 40px;text-align: center;">&times;</span></a>
                                    <div class="compare-img">
                                        <img src="assets/images/products/${item.urlImg}" alt="product image" style="max-height: 100px;">
                                    </div>                            
                                    <h3>${item.productName}</h3>
                                </div> <!-- .top-info -->

                                <ul class="cd-features-list">
                                    <li>${item.price}</li>
                                    <li>${item.productDiscount}</li>
                                    <li>${item.postedDate}</li>
                                    <li>${item.productViews}</li>
                                </ul>
                            </li> <!-- .product -->
                        </c:forEach>

                    </ul> <!-- .cd-products-columns -->
                </div> <!-- .cd-products-wrapper -->

                <ul class="cd-table-navigation">
                    <li><a href="#0" class="prev inactive">Prev</a></li>
                    <li><a href="#0" class="next">Next</a></li>
                </ul>
            </div> <!-- .cd-products-table -->
        </section> <!-- .cd-products-comparison-table -->
    </div>
</c:if>

<!-- MODAL -->
<jsp:include page="../blocks/modal.jsp" flush="true" />