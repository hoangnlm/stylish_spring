USE master

GO

IF db_id ('F21508T1_stylish_store_2017') is not null
	drop database F21508T1_stylish_store_2017

GO

CREATE DATABASE F21508T1_stylish_store_2017

GO

USE F21508T1_stylish_store_2017

GO

-- TABLE "User" -- 
CREATE TABLE roles (
	roleID		INT				PRIMARY KEY		IDENTITY(1,1),
	roleName	NVARCHAR(30)	NOT NULL,
)

GO

CREATE TABLE users (
	userID					INT				PRIMARY KEY		IDENTITY(1,1),
	roleID					INT				FOREIGN KEY		REFERENCES roles(roleID),
	email					NVARCHAR(50)	UNIQUE			NOT NULL,
	[password]				NVARCHAR(500)	NOT NULL,
	firstName				NVARCHAR(50)	NOT NULL,
	lastName				NVARCHAR(50)	NOT NULL,	
	avatar					NVARCHAR(50)	DEFAULT 'default_user.jpg',
	gender					TINYINT,		--1: MALE; 0: FEMALE
	birthday				DATE,
	registrationDate		DATE			DEFAULT getDate(),
	[status]				TINYINT			DEFAULT 1			--1: WORKING, 0: BANNED 
)

GO

CREATE TABLE userAddresses (
	addressID		INT					PRIMARY KEY		IDENTITY(1,1),
	userID			INT					FOREIGN KEY		REFERENCES users(userID),
	[address]		NVARCHAR(255)		NOT NULL,
	phoneNumber		NVARCHAR(20)		NOT NULL
)

GO

-- TABLE RELATE TO "PRODUCT" --
CREATE TABLE categories (
	cateID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateName		NVARCHAR(255)	NOT NULL		UNIQUE,
	cateNameNA		NVARCHAR(255)	NOT NULL
)

GO

CREATE TABLE subCategories (
	subCateID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateID				INT				FOREIGN KEY		REFERENCES categories(cateID),
	subCateName			NVARCHAR(255)	NOT NULL,
	subCateNameNA		NVARCHAR(500)	NOT NULL		--NA: Non-Accent
)

--test chức năng utf-8
GO

CREATE TABLE products (
	productID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateID				INT				FOREIGN KEY		REFERENCES categories(cateID),
	subCateID			INT				FOREIGN KEY		REFERENCES subCategories(subCateID),
	productName			NVARCHAR(255)	NOT NULL,
	productNameNA		NVARCHAR(255)	NOT NULL,		--NA: Non-Accent
	price				FLOAT			NOT NULL,
	urlImg				NVARCHAR(255)	NOT NULL,
	productDescription	TEXT,
	productDiscount		TINYINT			DEFAULT 0,
	postedDate			DATE			DEFAULT getDate(),	
	productViews		INT				DEFAULT 0,
	[status]			TINYINT			DEFAULT 1		
)

GO

CREATE TABLE productColors (
	colorID				INT				PRIMARY KEY		IDENTITY(1,1),
	productID			INT				FOREIGN KEY		REFERENCES products(productID),
	color				NVARCHAR(255)	NOT NULL,
	colorNA				NVARCHAR(255)	NOT NULL,
	urlColorImg			NVARCHAR(255)	NOT NULL,
	colorOrder			INT				NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO
CREATE TABLE sizesByColor (
	sizeID				INT				PRIMARY KEY		IDENTITY(1,1),
	colorID				INT				FOREIGN KEY		REFERENCES productColors(colorID),
	size				NVARCHAR(255)	NOT NULL,
	quantity			INT				NOT NULL,
	sizeOrder			INT				NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO

CREATE TABLE productSubImgs (
	subImgID		INT				PRIMARY KEY		IDENTITY(1,1),
	colorID			INT				FOREIGN KEY		REFERENCES productColors(colorID),
	urlImg			NVARCHAR(255)	NOT NULL,
	subImgOrder		INT				NOT NULL
)

GO

CREATE TABLE productRating (
	ratingID	INT				PRIMARY KEY		IDENTITY(1,1),
	productID	INT				FOREIGN KEY		REFERENCES products(productID),
	userID		INT				FOREIGN KEY		REFERENCES users(userID),
	rating		INT				NOT NULL,
	ratingDate	DATE			DEFAULT getDate(),
	review		TEXT,
	[status]	TINYINT			DEFAULT 0 -- 0: NOT VERIFIED, 1: VERIFIED 
)

GO

-- Table "ORDERS" -- 

CREATE TABLE discountVoucher(
	voucherID			NVARCHAR(50)		PRIMARY KEY,
	discount			TINYINT				NOT NULL,
	quantity			INT					NOT NULL,
	beginDate			DATE,
	endDate				DATE,
	[description]		TEXT
)

GO

CREATE TABLE orders (
	ordersID			INT				PRIMARY KEY		IDENTITY(1,1),
	userID				INT				FOREIGN KEY		REFERENCES users(userID),
	ordersDate			DATETIME		DEFAULT getDate(),
	receiverFirstName	NVARCHAR(100)	NOT NULL,
	receiverLastName	NVARCHAR(50)	NOT NULL,
	phoneNumber			NVARCHAR(20)	NOT NULL,
	deliveryAddress		NVARCHAR(100)	NOT NULL,
	voucherID			NVARCHAR(50)	FOREIGN KEY		REFERENCES discountVoucher(voucherID)	NULL,
	note				TEXT,
	[status]			TINYINT			-- 1: completed; 2: Pending; 3: Confirmed; 0: Cancelled
)

GO

CREATE TABLE ordersDetail (
	ordersDetailID		INT		PRIMARY KEY		IDENTITY(1,1),
	ordersID			INT		FOREIGN KEY		REFERENCES orders(ordersID),
	productID			INT		FOREIGN KEY		REFERENCES products(productID),
	sizeID				INT		FOREIGN KEY		REFERENCES sizesByColor(sizeID),
	productDiscount		TINYINT	NOT NULL,
	quantity			INT		NOT NULL,
	price				FLOAT	NOT NULL,
	[status]			TINYINT					--0: not change; 1: old; 2: new
)

GO

-- TABLE "WISHLIST"--
CREATE TABLE wishList(
	wishID		INT		PRIMARY KEY		IDENTITY(1,1),
	userID		INT		FOREIGN KEY		REFERENCES users(userID),
	productID	INT		FOREIGN KEY		REFERENCES products(productID),
	createDate	DATE					DEFAULT getDate()
)

GO

-- TABLE "BLOG" --
CREATE TABLE blogCategories (
	blogCateID		INT				PRIMARY KEY		IDENTITY(1,1),
	blogCateName	NVARCHAR(255)	NOT NULL,
	blogCateNameNA	NVARCHAR(255)	NOT NULL
)

GO

CREATE TABLE blogs( 
	blogID			INT				PRIMARY KEY		IDENTITY(1,1),
	blogCateID		INT				FOREIGN KEY		REFERENCES blogCategories(blogCateID),
	userID			INT				FOREIGN KEY		REFERENCES users(userID),
	blogTitle		NVARCHAR(255)	NOT NULL,
	blogTitleNA		NVARCHAR(255)	NOT NULL,
	blogSummary		NVARCHAR(500)	NOT NULL,
	blogImg			NVARCHAR(255)	NOT NULL,
	postedDate		DATE			DEFAULT getDate(),	
	content			TEXT,
	blogViews		INT				DEFAULT 0,
	[status]		TINYINT			DEFAULT 1
)

GO
SET IDENTITY_INSERT [dbo].[roles] ON 

GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (1, N'Admin')
GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (2, N'Moderator')
GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (3, N'User')
GO
SET IDENTITY_INSERT [dbo].[roles] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (1, 1, N'admin@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Hoang', N'Nguyen', N'default_user.jpg', 1, CAST(N'1992-12-19' AS Date), CAST(N'2017-04-27' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (2, 2, N'product@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Duy', N'Le', N'default_user.jpg', 0, CAST(N'1998-01-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (3, 2, N'orders@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Mai', N'Pham', N'default_user.jpg', 1, CAST(N'1995-04-07' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (4, 2, N'blogs@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Thanh', N'Nhan', N'default_user.jpg', 1, CAST(N'1996-05-08' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (5, 3, N'laurel@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Laurel', N'Lance', N'default_user.jpg', 0, CAST(N'1982-09-13' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (6, 3, N'queen@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Oliver', N'Queen', N'default_user.jpg', 1, CAST(N'1980-12-08' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (7, 3, N'ba@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Barry', N'Allen', N'default_user.jpg', 1, CAST(N'1984-01-05' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (8, 3, N'bruce@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Bruce', N'Wayne', N'default_user.jpg', 1, CAST(N'1980-02-03' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (9, 3, N'luke@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Luke', N'Cage', N'default_user.jpg', 1, CAST(N'1970-04-09' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (10, 3, N'clark@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Clark', N'Kent', N'default_user.jpg', 1, CAST(N'1978-03-04' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (11, 3, N'thea@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Thea', N'Queen', N'default_user.jpg', 0, CAST(N'1990-05-17' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (12, 3, N'hal@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Hal', N'Jordan', N'default_user.jpg', 1, CAST(N'1976-05-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (13, 3, N'tim@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Tim', N'Drake', N'default_user.jpg', 1, CAST(N'1985-03-27' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (14, 3, N'lex@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Lex', N'Luthor', N'default_user.jpg', 1, CAST(N'1972-06-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (15, 3, N'peter@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Peter', N'Parker', N'default_user.jpg', 1, CAST(N'1989-07-14' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (16, 3, N'steve@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Steve', N'Roger', N'default_user.jpg', 1, CAST(N'1980-08-28' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (17, 3, N'tony@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Tony', N'Stark', N'default_user.jpg', 1, CAST(N'1980-03-04' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET IDENTITY_INSERT [dbo].[userAddresses] ON 

GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (1, 5, N'District 1, Ho Chi Minh City', N'0168726543')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (2, 6, N'Thu Duc District, Ho Chi Minh City', N'0918727328')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (3, 7, N'District 8, Ho Chi Minh City', N'0967827631')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (4, 9, N'District 5, Ho Chi Minh City', N'0987264813')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (5, 10, N'Tan Binh District, Ho Chi Minh City', N'0128736817')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (6, 8, N'District 3, Ho Chi Minh City', N'0188726813')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (7, 13, N'District 4, Ho Chi Minh City', N'0935124897')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (8, 16, N'District 3, Ho Chi Minh City', N'0951235487')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (9, 17, N'District 2, Ho Chi Minh City', N'0963548425')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (10, 14, N'District 7, Ho Chi Minh City', N'0122458725')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (11, 14, N'179/12 Su Van Hanh , P.13 , District 10 , Ho Chi Minh City', N'0988766567')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (12, 14, N'200/12 Au Co , P.Hoa Thanh , District Tan Phu , Ho Chi Minh City', N'01220888789')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (13, 14, N'201 De Tham , P.Cau Ong Lanh , District 1 , Ho Chi Minh City', N'0906723423')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (14, 14, N'787 Luy Ban Bich , P.Tan Thanh , District Tan Phu , Ho Chi Minh City', N'01234480888')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (15, 10, N'35 Truong Dinh , P.6, District 3 , Ho Chi Minh City', N'0903758002')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (16, 10, N'101/1 Nguyen Phi Khanh, P.Tan Dinh , District 1 , Ho Chi Minh City', N'0903650432')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (17, 10, N'21/15/8 Truong Son, P.4 ,  District Tan Binh, Ho Chi Minh City', N'0983807880')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (18, 10, N'72 Nguyen Minh Hoang, P.12 , District Tan Binh, Ho Chi Minh City', N'0983080818')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (19, 17, N'202 Pasteur , District 3 , Ho Chi Minh City', N'0914770545')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (20, 17, N'172C Nguyen Dinh Chieu, P.6 , District 3 , Ho Chi Minh City', N'0944545232')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (21, 17, N'11 Tu Xuong, District 3 , Ho Chi Minh City', N'01668890843')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (22, 17, N'44 Ngo Duc Ke, District 1 , Ho Chi Minh City', N'0962089926')
GO
SET IDENTITY_INSERT [dbo].[userAddresses] OFF
GO
SET IDENTITY_INSERT [dbo].[categories] ON 

GO
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (1, N'Men', N'men')
GO
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (2, N'Women', N'women')
GO
SET IDENTITY_INSERT [dbo].[categories] OFF
GO
SET IDENTITY_INSERT [dbo].[subCategories] ON 

GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (1, 1, N'Shirts', N'shirts')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (2, 1, N'T-Shirts', N't-shirts')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (3, 1, N'Coats', N'coats')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (4, 1, N'Sweaters', N'sweaters')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (5, 2, N'Dresses', N'dresses')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (6, 2, N'Coats', N'coats')
GO
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (7, 2, N'Knitwears', N'knitwears')
GO
SET IDENTITY_INSERT [dbo].[subCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[products] ON 

GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (1, 1, 1, N'Short Sleeve Oxford Shirt', N'short-sleeve-oxford-shirt', 24, N'20170427_18_53_19ms01.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (2, 1, 1, N'Slim Fit Stretch Shirt', N'slim-fit-stretch-shirt', 24, N'20170427_19_06_12ms02.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (3, 1, 2, N'Spliced Band T Shirt', N'spliced-band-t-shirt', 24, N'20170427_19_13_04mts01.jpg', N'<p><em><strong>T-shirts and vests are the power players in every man&rsquo;s wardrobe</strong></em></p>

<p>This season the dream team in male dressing gets daring with&nbsp;t-shirts and vests&nbsp;taking on poppin&rsquo; paisley prints and sporty slogans to keep you enviably on-trend. Vests come in versatile block colours for building your perfect look and polos in polished prints, while back to nature animal motifs are the new trend to try. Pair your&nbsp;printed tee&nbsp;with&nbsp;skinny jeans&nbsp;and suede&nbsp;desert boots&nbsp;to take you from day to night in style.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (4, 1, 3, N'Destroyed Denim Jacket', N'destroyed-denim-jacket', 70, N'20170427_20_36_24mc01.jpg', N'<p><em><strong>Turn your outerwear into shouterwear with a boohooMAN coat or jacket</strong></em></p>

<p>We&rsquo;ll make sure your outerwear is out-there with&nbsp;coats and jackets&nbsp;for every occasion. From classic quilted coats and supersize puffa jackets to distressed denim jackets and fur trim parkas, we&rsquo;ve got your cold weather warmers covered. For lightweight rather than layers, pair a gilet over a&nbsp;printed tee&nbsp;with&nbsp;denim shorts&nbsp;and&nbsp;trainers.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (5, 1, 1, N'Sew Spliced Shirt', N'sew-spliced-shirt', 26, N'20170427_20_46_45ms03.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton</li>
	<li>Front Faux pocket Shirt</li>
	<li>With Contrast Sleeves</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (6, 1, 1, N'Long Sleeve Geo Shirt', N'long-sleeve-geo-shirt', 36, N'20170427_20_54_55ms04.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton</li>
	<li>Printed Shirt</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (7, 1, 1, N'Hawaiian Print Shirt', N'hawaiian-print-shirt', 32, N'20170427_21_05_45ms05.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton</li>
	<li>Hawaiian Print Shirt</li>
	<li>Model Is 6&quot;1 And Wears UK Size Medium</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (8, 1, 1, N'Polka Dot Print Shirt', N'polka-dot-print-shirt', 28, N'20170427_21_13_27ms06.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton</li>
	<li>Short Sleeve Polka Dot Shirt</li>
	<li>Front Pocket Detail</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (9, 1, 1, N'Ombre Check Shirt', N'ombre-check-shirt', 40, N'20170427_21_19_45ms07.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton.</li>
	<li>Black Ombre Check Shirt With Front Pocket and Single Button Cuff.</li>
	<li>Model is 6&#39;1&quot; and UK Size M.</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (10, 1, 1, N'Short Sleeve Floral Shirt', N'short-sleeve-floral-shirt', 32, N'20170427_21_25_42ms08.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Viscose.</li>
	<li>Navy Printed Collared Short Sleeve Floral Shirt.</li>
	<li>Model Is 6&#39;1 And Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (11, 1, 1, N'Vertical Stripe Shirt', N'vertical-stripe-shirt', 26, N'20170427_21_32_51ms09.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton</li>
	<li>Printed Shirt</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (12, 1, 1, N'Revere Collar Shirt', N'revere-collar-shirt', 28, N'20170427_21_41_47ms10.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Viscose.</li>
	<li>Plain Revere Collar Shirt With Front Pocket.</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M.</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (13, 1, 1, N'Floral Print Shirt', N'floral-print-shirt', 32, N'20170427_21_48_33ms11.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul>
	<li>100% Cotton.</li>
	<li>Short Sleeve Collared Floral Print Shirt With Roll-Ups.</li>
	<li>Model Is 6&#39;1 And Wears UK Size M</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (14, 1, 1, N'Sleeve Sprayed Shirt', N'sleeve-sprayed-shirt', 32, N'20170427_21_53_35ms12.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul style="margin-left:40px">
	<li>100% Cotton</li>
	<li>Red Oversized Raw Edge Cap Sleeve Shirt With Paint Spray Effect</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M.</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (15, 1, 1, N'Collar Stripe Shirt', N'collar-stripe-shirt', 32, N'20170427_22_01_43ms13.jpg', N'<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<ul style="margin-left:40px">
	<li>100% Viscose.</li>
	<li>Revere Collar Striped Short Sleeve Shirt. Model is 6&#39;1&quot; and UK Size M.</li>
</ul>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (16, 1, 1, N'Palm Print Shirts', N'palm-print-shirts', 32, N'20170427_22_13_22ms14.jpg', N'<h3><strong>STYLE NOTES</strong></h3>

<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<h3><strong>RETURNS INFO</strong></h3>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (17, 1, 1, N'Cord Slim Fit Shirt', N'cord-slim-fit-shirt', 26, N'20170427_22_22_05ms15.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Button up and get sharp in a shirt</strong></em></p>

<p>Mixing classic with quirky, the boohooMAN&nbsp;shirt&nbsp;collection is sure to shake up your wardrobe. Long sleeve or short, the Oxford shirt takes care of your work wear woes, while checks and stripes see you through from day to night in style. Pair prints with primary colour&nbsp;chinos, a retro&nbsp;rucksack&nbsp;and street style&nbsp;snapback.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul>
	<li style="margin-left: 40px;">100% Cotton</li>
	<li style="margin-left: 40px;">Cord Shirt</li>
	<li style="margin-left: 40px;">Model Is 6&#39;1 And Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-27' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (19, 2, 5, N'Plunge Neck Maxi Dress', N'plunge-neck-maxi-dress', 80, N'20170428_21_33_39wd01.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>100% Polyester.</li>
	<li>Flat Measurement of Garment Not Worn: Shoulder to Hem 148cm/58&quot;, Bust 38cm/15&quot;, Waist 32cm/12.5&quot;.</li>
	<li>Machine Washable.</li>
	<li>Model Wears UK Size Medium.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (20, 2, 5, N'Shoulder Shift Dress', N'shoulder-shift-dress', 30, N'20170428_21_40_28wd02.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>60% Cotton, 37% Polyester, 3% Polyester.</li>
	<li>Flat Measurement of Garment Not Worn Centre Back to Hem: 87cm/34.5&quot;.</li>
	<li>Measured on UK Size M.</li>
	<li>Machine Washable.</li>
	<li>Model Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (21, 2, 5, N'Striped Tie Front Dress', N'striped-tie-front-dress', 40, N'20170428_21_49_03wd03.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>100% Cotton.</li>
	<li>Flat Measurement of Garment Not Centre Back to Hem: 71cm/28&quot;.</li>
	<li>Measured on UK Size 10.</li>
	<li>Machine Washable.</li>
	<li>Model Wears UK Size 10.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (22, 2, 5, N'Sleeve TShirt Dress', N'sleeve-tshirt-dress', 20, N'20170428_22_07_35wd04.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>95% Viscose 5% Elastane.</li>
	<li>Flat Measurement of Garment: Shoulder To Hem 84cm/33&quot;, Bust 36cm/15&quot;.</li>
	<li>Machine Washable.</li>
	<li>Model Wears UK Size 10.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (23, 2, 5, N'Crochet Midi Dress', N'crochet-midi-dress', 70, N'20170428_22_16_40wd05.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (24, 2, 5, N'Mesh Bodycon Dress', N'mesh-bodycon-dress', 40, N'20170428_22_24_55wd06.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>50% Polyester 45% Nylon 5% Elastane.</li>
	<li>Flat Measurement of Garment: Shoulder To Hem 84cm/33&quot;, Bust 36cm/15&quot;.</li>
	<li>Machine Washable.</li>
	<li>Model Wears UK Size 10.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (25, 2, 5, N'Split Print Dress', N'split-print-dress', 24, N'20170429_10_05_01wd07.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>boohoo PETITE.</strong></u></p>

<p>Serving up the same statement styles in scaled down sizes, boohoo Petite is your port of call for perfectly proportioned pieces designed to fit women of&nbsp;<strong>5&rsquo;3&rdquo;/1.60m and under</strong>.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (26, 2, 5, N'Denim Shirt Dress', N'denim-shirt-dress', 44, N'20170429_10_10_30wd08.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Jeans are the genius wear-with-anything wardrobe item</strong></em></p>

<p>Skinny, straight, or slim, find your perfect&nbsp;jeans&nbsp;fit in the boohoo denim collection. Work the hot-right-now high waist in mom jeans and baggy boyfriend styles, and take your blues to the next level with punk badges and rock &#39;n&#39; roll rips. Wear with a basic tee by day and add barely-there&nbsp;heeled sandals&nbsp;to take your denim from day to night.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>Fabric outer shell:100% polyester.</li>
	<li>Flat measurement total length:56cm/22&quot; BNW:21cm/8.5&quot; Chest:42cm/16.5&quot;</li>
	<li>Measured on a UK age 7-8/Height range 122cm-128cm.</li>
	<li>Machine wash.</li>
	<li>Model Wears UK age 7-8.KEEP AWAY FROM FIRE.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (27, 2, 5, N'Festival Knitted Dress', N'festival-knitted-dress', 36, N'20170429_10_24_34wd09.jpg', N'<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (28, 2, 5, N'Lara Denim Shirt Dress', N'lara-denim-shirt-dress', 35, N'20170429_10_29_30wd10.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Jeans are the genius wear-with-anything wardrobe item</strong></em></p>

<p>Skinny, straight, or slim, find your perfect&nbsp;jeans&nbsp;fit in the boohoo denim collection. Work the hot-right-now high waist in mom jeans and baggy boyfriend styles, and take your blues to the next level with punk badges and rock &#39;n&#39; roll rips. Wear with a basic tee by day and add barely-there&nbsp;heeled sandals&nbsp;to take your denim from day to night.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (29, 2, 5, N'Paisley Print Maxi Dress', N'paisley-print-maxi-dress', 35, N'20170429_10_35_50wd11.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (30, 2, 5, N'Knitted Skater Dress', N'knitted-skater-dress', 20, N'20170429_10_43_02wd12.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Nail new season knitwear in the jumpers and cardigans that are cosy yet cool</strong></em></p>

<p>Go back to nature with your knits this season and add animal motifs to your must-haves. When you&#39;re not wrapping up in woodland warmers, nod to chunky Nordic knits and polo neck jumpers in peppered marl for your laidback layering pieces. Bejewelled basics and standout sequin sweaters transform your knitwear for nights out.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (31, 2, 5, N'Hooded Sweat Dress', N'hooded-sweat-dress', 40, N'20170429_10_52_44wd13.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>93% Cotton, 7% Elastane.</li>
	<li>Flat Measurement of Garment Not Worn Shoulder to Hem: 84cm/33&quot;.</li>
	<li>Measured on UK Size M.</li>
	<li>( Machine Washable.) Model Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (32, 2, 5, N'Michelle Lace Dress', N'michelle-lace-dress', 40, N'20170429_11_02_47wd14.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><u><strong>Dresses are the most-wanted wardrobe item for day-to-night dressing.</strong></u></p>

<p>From cool-tone whites to block brights, we&#39;ve got the everyday skater dresses and party-ready bodycon styles that are perfect for transitioning from day to play. Minis, midis and maxis are our motto, with classic jersey always genius and printed cami&nbsp;dresses&nbsp;the season&#39;s killer cut - add skyscraper&nbsp;heels&nbsp;for a serioulsy statement look. Dress up or down in style with boohoo.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>100% Cotton.</li>
	<li>Flat Measurement of Garment Not Worn Shoulder to Hem: 84cm/33&quot;.</li>
	<li>Measured on UK Size M.</li>
	<li>( Machine Washable.) Model Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>

<p>&nbsp;</p>
', 0, CAST(N'2017-04-29' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (33, 2, 6, N'Boutique Maya Faux', N'boutique-maya-faux', 100, N'20170519_04_34_59wc01.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><strong><em>Wrap up in the latest coats and jackets and get out-there with your outerwear</em></strong></p>

<p>Breathe life into your new season layering with the latest&nbsp;coats and jackets&nbsp;from boohoo. Supersize your silhouette in a puffa jacket, stick to sporty styling with a bomber, or protect yourself from the elements in a plastic raincoat. For a more luxe layering piece, faux fur coats come in fondant shades and longline duster coats give your look an androgynous edge.</p>

<p>&nbsp;</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>50% Polyester 50% Laine.</li>
	<li>Flat Measurement Of Garment Not Worn of UK Size S.</li>
	<li>Length To Hem 69cm/27&quot;.</li>
	<li>Sleeve Length 61cm/24&quot;.</li>
	<li>Machine Wash.</li>
	<li>Model Wears UK Size S.</li>
</ul>

<p>&nbsp;</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>

<p>Click&nbsp;<strong>here</strong>&nbsp;to view our full Returns Policy.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (34, 2, 7, N'Ribbed Crochet Knitted', N'ribbed-crochet-knitted', 20, N'20170519_04_45_19wc02.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Nail new season knitwear in the jumpers and cardigans that are cosy yet cool</strong></em></p>

<p>Go back to nature with your knits this season and add animal motifs to your must-haves. When you&#39;re not wrapping up in woodland warmers, nod to chunky Nordic knits and polo neck jumpers in peppered marl for your laidback layering pieces. Bejewelled basics and standout sequin sweaters transform your knitwear for nights out.</p>

<p>&nbsp;</p>

<p><strong>RETURNS INFO</strong></p>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (35, 1, 3, N'Box Fit Denim Jacket', N'box-fit-denim-jacket', 64, N'20170519_05_00_56mc02.jpg', N'<h4>STYLE NOTES</h4>

<p><em><strong>Turn your outerwear into shouterwear with a boohooMAN coat or jacket</strong></em></p>

<p>We&rsquo;ll make sure your outerwear is out-there with&nbsp;coats and jackets&nbsp;for every occasion. From classic quilted coats and supersize puffa jackets to distressed denim jackets and fur trim parkas, we&rsquo;ve got your cold weather warmers covered. For lightweight rather than layers, pair a gilet over a&nbsp;printed tee&nbsp;with&nbsp;denim shorts&nbsp;and&nbsp;trainers.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>95% Cotton,</li>
	<li>5% Polyester. Oversized Box Fit Denim Jacket.</li>
	<li>Pocket Attachment To Left Chest Area.</li>
	<li>Model is 6&quot;1 And Wears Uk Size Medium.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (36, 2, 7, N'Knit Hooded Cardigan', N'knit-hooded-cardigan', 30, N'20170519_05_13_35wk01.jpg', N'<h4>STYLE NOTES</h4>

<p><em><strong>Nail new season knitwear in the jumpers and cardigans that are cosy yet cool</strong></em></p>

<p>Go back to nature with your knits this season and add animal motifs to your must-haves. When you&#39;re not wrapping up in woodland warmers, nod to chunky Nordic knits and polo neck jumpers in peppered marl for your laidback layering pieces. Bejewelled basics and standout sequin sweaters transform your knitwear for nights out.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (37, 1, 3, N'Slim Fit Jersey Bomber', N'slim-fit-jersey-bomber', 20, N'20170519_05_22_50mc03.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Hoodies and sweats are every man&rsquo;s failsafe fashion fave</strong></em></p>

<p>Updated with directional designs and talk-about textures, laid back gets luxe this season.&nbsp;Hoodies and sweats&nbsp;go crazy for quilting and PU panelling, but don&rsquo;t sweat &ndash; sporty is staying on the style radar with varsity vibes reigning supreme. Give a nod to the 90s in a bad ass&nbsp;bomber jacket, layer over&nbsp;t-shirts and vests&nbsp;and add a&nbsp;beanie hat&nbsp;for style that&rsquo;s street.</p>

<p>&nbsp;</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>Body:50%</li>
	<li>Cotton 50% Polyester</li>
	<li>Rib:52%</li>
	<li>Cotton. 45% Polyester.</li>
	<li>3% Elastane</li>
	<li>Slim Fit Jersey Bomber</li>
	<li>With Side Pockets</li>
	<li>Model Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (38, 1, 4, N'Textured Cardigan', N'textured-cardigan', 36, N'20170519_05_32_44msw01.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Layer up and look good in a jumper or cardigan</strong></em></p>

<p>Fashion&rsquo;s all about the finishing touches and&nbsp;jumpers and cardigans&nbsp;are the easiest way to fix up your look. Keep it cool in cable knits, work it in waffle or do the finer details in a fisherman. Show off your style in a sharp&nbsp;shirt&nbsp;and&nbsp;shawl cardigan&nbsp;combo, finish off withbrogues&nbsp;and you&rsquo;ll be up there with fashion&rsquo;s finest.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (39, 1, 2, N'LA Oversized T Shirt', N'la-oversized-t-shirt', 24, N'20170519_05_38_45mts02.jpg', N'<h4>STYLE NOTES</h4>

<p><em><strong>T-shirts and vests are the power players in every man&rsquo;s wardrobe</strong></em></p>

<p>This season the dream team in male dressing gets daring with&nbsp;t-shirts and vests&nbsp;taking on poppin&rsquo; paisley prints and sporty slogans to keep you enviably on-trend. Vests come in versatile block colours for building your perfect look and polos in polished prints, while back to nature animal motifs are the new trend to try. Pair your&nbsp;printed tee&nbsp;with&nbsp;skinny jeans&nbsp;and suede&nbsp;desert boots&nbsp;to take you from day to night in style.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>Main: 100% Cotton,</li>
	<li>Rib: 96% Cotton,</li>
	<li>4% Elastane. City Of Angels LA Oversized T Shirt.</li>
	<li>Model Is 6&#39;1 And Wears UK Size M</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (40, 1, 3, N'Hooded Inspired Jacket', N'hooded-inspired-jacket', 52, N'20170519_05_44_44mc04.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Turn your outerwear into shouterwear with a boohooMAN coat or jacket</strong></em></p>

<p>We&rsquo;ll make sure your outerwear is out-there with&nbsp;coats and jackets&nbsp;for every occasion. From classic quilted coats and supersize puffa jackets to distressed denim jackets and fur trim parkas, we&rsquo;ve got your cold weather warmers covered. For lightweight rather than layers, pair a gilet over a&nbsp;printed tee&nbsp;with&nbsp;denim shorts&nbsp;and&nbsp;trainers.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>100% Polyester</li>
	<li>Hooded Windbreaker Inspired Jacket</li>
	<li>Model Is 6&#39;1 And Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>

<p>&nbsp;</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (41, 2, 6, N'Collar Wrap Coat', N'collar-wrap-coat', 92, N'20170519_05_51_44wc3.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><strong><em>Wrap up in the latest coats and jackets and get out-there with your outerwear</em></strong></p>

<p>Breathe life into your new season layering with the latest&nbsp;coats and jackets&nbsp;from boohoo. Supersize your silhouette in a puffa jacket, stick to sporty styling with a bomber, or protect yourself from the elements in a plastic raincoat. For a more luxe layering piece, faux fur coats come in fondant shades and longline duster coats give your look an androgynous edge.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>90% Polyester 2% Elastane 8% Visocse.</li>
	<li>Flat Measurement Not Worn Of UK Size S.</li>
	<li>Length To Hem 115cm/45&quot;.</li>
	<li>Sleeve Length 57.5cm/22.5&quot;.</li>
	<li>Hand Wash. Model Wears UK Size S.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 5, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (42, 2, 6, N'Olivia Fasten Duster', N'olivia-fasten-duster', 26, N'20170519_06_02_04wc4.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><strong><em>Wrap up in the latest coats and jackets and get out-there with your outerwear</em></strong></p>

<p>Breathe life into your new season layering with the latest&nbsp;coats and jackets&nbsp;from boohoo. Supersize your silhouette in a puffa jacket, stick to sporty styling with a bomber, or protect yourself from the elements in a plastic raincoat. For a more luxe layering piece, faux fur coats come in fondant shades and longline duster coats give your look an androgynous edge.</p>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (43, 1, 4, N'Stitch Hooded Cardigan', N'stitch-hooded-cardigan', 44, N'20170519_06_09_08msw02.jpg', N'<h5><strong>STYLE NOTES</strong></h5>

<p><em><strong>Layer up and look good in a jumper or cardigan</strong></em></p>

<p>Fashion&rsquo;s all about the finishing touches and&nbsp;jumpers and cardigans&nbsp;are the easiest way to fix up your look. Keep it cool in cable knits, work it in waffle or do the finer details in a fisherman. Show off your style in a sharp&nbsp;shirt&nbsp;and&nbsp;shawl cardigan&nbsp;combo, finish off with&nbsp;brogues&nbsp;and you&rsquo;ll be up there with fashion&rsquo;s finest.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>Colour:Grey. Pattern:Waffle Stitch.</li>
	<li>Fabric: 50% Cotton 50% Acrylic.</li>
	<li>Fit:Regular</li>
	<li>Waffle Stitch Hooded Cardigan</li>
	<li>Model Is 6&#39;1 And Wears UK Size M.</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (44, 1, 4, N'Crew Neck Jumper', N'crew-neck-jumper', 32, N'20170519_06_16_25msw03.jpg', N'<h4><strong>STYLE NOTES</strong></h4>

<p><em><strong>Layer up and look good in a jumper or cardigan</strong></em></p>

<p>Fashion&rsquo;s all about the finishing touches and&nbsp;jumpers and cardigans&nbsp;are the easiest way to fix up your look. Keep it cool in cable knits, work it in waffle or do the finer details in a fisherman. Show off your style in a sharp&nbsp;shirt&nbsp;and&nbsp;shawl cardigan&nbsp;combo, finish off with&nbsp;brogues&nbsp;and you&rsquo;ll be up there with fashion&rsquo;s finest.</p>

<h4><strong>DETAILS &amp; CARE</strong></h4>

<ul style="margin-left:40px">
	<li>50% Cotton, 50% Acrylic</li>
	<li>Fisherman Knit Crew Neck Jumper</li>
	<li>Model is 6&#39;1&quot; and Wears UK Size M</li>
</ul>

<h4><strong>RETURNS INFO</strong></h4>

<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>

<p>&nbsp;</p>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (45, 1, 2, N'License Band T Shirt', N'license-band-t-shirt', 28, N'20170519_12_02_23mts03.jpg', N'<h4 style="text-align:left"><strong>STYLE NOTES</strong></h4>

<div style="text-align:left">
<p><em><strong>T-shirts and vests are the power players in every man&rsquo;s wardrobe</strong></em></p>

<p>This season the dream team in male dressing gets daring with&nbsp;t-shirts and vests&nbsp;taking on poppin&rsquo; paisley prints and sporty slogans to keep you enviably on-trend. Vests come in versatile block colours for building your perfect look and polos in polished prints, while back to nature animal motifs are the new trend to try. Pair your&nbsp;printed tee&nbsp;with&nbsp;skinny jeans&nbsp;and suede&nbsp;desert boots&nbsp;to take you from day to night in style.</p>

<h4 style="text-align:left"><strong>DETAILS &amp; CARE</strong></h4>

<div style="text-align:left">100% Cotton. Black Nirvana Jersey Crew Neck T Shirt. Model is 6&#39;1&quot; and Wears UK Size M.</div>

<h4 style="text-align:left">&nbsp;</h4>

<div style="text-align:left">
<h4 style="text-align:left"><strong>RETURNS INFO</strong></h4>

<div style="text-align:left">
<div>
<p>We hope you are satisfied with all of your purchases but if you ever need to return an item, you can do so within 28 days from the date your parcel was dispatched.</p>

<p>Please note, we cannot offer refunds on pierced jewellery or on swimwear if the hygiene seal is not in place or has been broken.</p>
</div>
</div>
</div>
</div>
', 0, CAST(N'2017-05-19' AS Date), 0, 1)
GO
SET IDENTITY_INSERT [dbo].[products] OFF
GO
SET IDENTITY_INSERT [dbo].[productRating] ON 

GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (1, 2, 17, 3, CAST(N'2017-05-18' AS Date), N'That''s the best Product that i had ever seen!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (2, 2, 10, 5, CAST(N'2017-05-19' AS Date), N'It''s Awesome.', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (3, 2, 5, 1, CAST(N'2017-05-19' AS Date), N'I will buy it for my husband!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (4, 2, 7, 2, CAST(N'2017-05-19' AS Date), N'I don''t think it is the best product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (5, 2, 6, 5, CAST(N'2017-05-19' AS Date), N'That product must be voted for 5 Stars', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (6, 4, 10, 3, CAST(N'2017-05-19' AS Date), N'Here is the first review for this product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (7, 17, 17, 1, CAST(N'2017-05-19' AS Date), N'This product is too expensive!!!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (8, 2, 8, 5, CAST(N'2017-05-19' AS Date), N'Haha, Bruce Wayne will buy this product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (9, 32, 17, 5, CAST(N'2017-05-19' AS Date), N'It''s beautiful, I Will buy it for my wife.', 0)
GO
SET IDENTITY_INSERT [dbo].[productRating] OFF
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU01', 20, 20, NULL, NULL, N'discount 20%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU02', 15, 100, CAST(N'2017-04-30' AS Date), CAST(N'2017-05-01' AS Date), N'discount 15%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU03', 10, 50, CAST(N'2017-05-01' AS Date), CAST(N'2017-05-31' AS Date), N'discount 10%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU04', 5, 200, CAST(N'2017-06-01' AS Date), CAST(N'2017-06-30' AS Date), N'discount 5%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU05', 50, 0, CAST(N'2017-05-01' AS Date), CAST(N'2017-05-31' AS Date), N'discount 50%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU06', 70, 0, NULL, NULL, N'discount 70%')
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (1, 5, CAST(N'2017-05-01 09:12:22.290' AS DateTime), N'Laurel', N'Lance', N'0168726543', N'District 1, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (2, 6, CAST(N'2017-05-01 10:18:47.800' AS DateTime), N'Oliver', N'Queen', N'0918727328', N'Thu Duc District, Ho Chi Minh City', NULL, NULL, 3)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (3, 7, CAST(N'2017-05-01 11:20:39.293' AS DateTime), N'Barry', N'Allen', N'0967827631', N'District 8, Ho Chi Minh City', NULL, NULL, 3)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (4, 9, CAST(N'2017-05-01 12:21:12.223' AS DateTime), N'Luke', N'Cage', N'0987264813', N'District 5, Ho Chi Minh City', NULL, NULL, 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (5, 10, CAST(N'2017-05-01 13:22:38.497' AS DateTime), N'Clark', N'Kent', N'0128736817', N'Tan Binh District, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (6, 8, CAST(N'2017-05-01 14:23:17.583' AS DateTime), N'Bruce', N'Wayne', N'0188726813', N'District 3, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (7, 13, CAST(N'2017-05-01 15:23:49.050' AS DateTime), N'Tim', N'Drake', N'0935124897', N'District 4, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (8, 16, CAST(N'2017-05-01 16:25:23.120' AS DateTime), N'Steve', N'Roger', N'0951235487', N'District 3, Ho Chi Minh City', NULL, NULL, 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (9, 17, CAST(N'2017-05-01 17:26:22.193' AS DateTime), N'Tony', N'Stark', N'0963548425', N'District 2, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (10, 14, CAST(N'2017-05-01 18:29:16.660' AS DateTime), N'Lex', N'Luthor', N'0122458725', N'District 7, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (11, 5, CAST(N'2017-05-10 15:18:03.977' AS DateTime), N'Laurel', N'Lance', N'0168726543', N'District 1, Ho Chi Minh City', N'VOU01', N'deliver before 12h', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (12, 6, CAST(N'2017-05-10 15:26:22.743' AS DateTime), N'Oliver', N'Queen', N'0918727328', N'Thu Duc District, Ho Chi Minh City', N'VOU02', N'...', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (13, 7, CAST(N'2017-05-12 15:30:42.913' AS DateTime), N'Barry', N'Allen', N'0967827631', N'District 8, Ho Chi Minh City', N'VOU03', N'deliver before 5h afternoon', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (14, 8, CAST(N'2017-05-12 15:32:34.397' AS DateTime), N'Bruce', N'Wayne', N'0188726813', N'District 3, Ho Chi Minh City', NULL, N'', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (15, 9, CAST(N'2017-05-13 15:43:36.753' AS DateTime), N'Luke', N'Cage', N'0987264813', N'District 5, Ho Chi Minh City', NULL, N'NO COMMENT', 2)
GO
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[wishList] ON 

GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (1, 17, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (2, 17, 14, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (3, 17, 15, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (4, 17, 16, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (5, 11, 27, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (6, 11, 28, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (7, 11, 29, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (8, 11, 30, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (9, 12, 17, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (10, 12, 8, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (11, 12, 9, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (12, 13, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (13, 13, 15, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (14, 13, 16, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (15, 14, 2, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (16, 14, 3, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (17, 15, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (18, 15, 3, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (19, 16, 8, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (20, 16, 9, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (21, 5, 32, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (22, 5, 31, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (23, 6, 2, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (24, 6, 4, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (25, 7, 5, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (26, 7, 6, CAST(N'2017-05-19' AS Date))
GO
SET IDENTITY_INSERT [dbo].[wishList] OFF
GO
SET IDENTITY_INSERT [dbo].[blogCategories] ON 

GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (1, N'STYLE', N'style')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (2, N'BEAUTY', N'beauty')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (3, N'CELEB', N'celeb')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (4, N'NEWS & RUNWAY', N'news-&-runway')
GO
SET IDENTITY_INSERT [dbo].[blogCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[blogs] ON 

GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (1, 1, 1, N'10 Cute Plus-Size Swimsuits to Buy Right Now', N'10-cute-plus-size-swimsuits-to-buy-right-now', N'Ready for summer? Dive in with these cute plus-size swimsuits for every shape and size. Look sharp! From primers to fragrance to root touch-up tools, there''s a makeup pencil for everything.', N'815x500b.jpeg', CAST(N'2017-01-13' AS Date), N'<p>Rihanna, woman of our hearts, has invented the perfect summer shoe. The Bow Creeper Sandal, Rih&rsquo;s answer to the espadrille, features a soft leather upper, a sweet outsize bow accent and Fenty x Puma&rsquo;s signature serrated gum sole (in lieu of traditional jute rope). The sneaker-sandal hybrid also has&nbsp;lengthy shoelace ties that wind around the ankle to create that coveted pointe shoe effect. (She&rsquo;s coming for you, Miu Miu.)<br />', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (2, 1, 1, N'Say Goodbye to Monochrome Monotony and Hello to Bold Brights', N'say-goodbye-to-monochrome-monotony-and-hello-to-bold-brights', N'Kim Kardashian, your reign of neutrality is over. Ready for summer? Dive in with these cute plus-size swimsuits for every shape and size', N'a1size.jpg', CAST(N'2017-02-13' AS Date), N'<p>Stray Rats&nbsp;hoodie, strapped on some crimson stilettos and shielded your eyes from the sun&rsquo;s glare with coordinating (<a href="https://lespecs.com/the-last-lolita-1502112-opaque-red-silver-mirror-las1502112" onclick="javascript:_gaq.push(['' trackEvent'',''outbound-article'',''http://lespecs.com'']);" rel="nofollow" target="_blank">Adam Selman x Le Specs</a>-reminiscent) shades? For&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/742749-bella-hadid-opens-up-about-her-muslim-heritage/" target="_blank">Bella Hadid</a>, the answer to that question would be &ldquo;last Thursday&rdquo; (or &ldquo;May 4, 2017&rdquo; or &ldquo;Star Wars Day,&rdquo; depending on how technical or festive she was feeling).<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a3size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>It&rsquo;s official. When it comes to&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/705753-how-to-wear-monochrome-colors-like-a-celebrity/" target="_blank">tonal dressing</a>, that easy-peasy styling trick that, unlike most fashion trends, is more eternal than cyclical, vibrant colors are in and dull neutrals are out. Nowadays, we&rsquo;d rather look like Power Rangers than Kim Kardashian. Why are we of the cult of minimalism suddenly so willing to sport head-to-toe bubble gum? Street style star Pandora Sykes points to the rise of &ldquo;post-truth fashion.&rdquo; In the face of harsh political circumstances, &ldquo;we are led by our emotional gut and seek uplifting fashion that rejuvenates us and distracts us, momentarily,&rdquo; wrote Sykes in a February&nbsp;<a href="http://www.manrepeller.com/2017/02/why-i-love-a-pink-suit.html" onclick="javascript:_gaq.push(['' trackEvent'',''outbound-article'',''http://www.manrepeller.com'']);" rel="nofollow" target="_blank">Man Repeller</a>&nbsp;post.<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (3, 2, 1, N'9 Foot Peels to Get You Ready for Sandal Season', N'9-foot-peels-to-get-you-ready-for-sandal-season', N'Baby-soft feet, right this way. Just when you thought she couldn''t get any cooler.', N'a4.jpg', CAST(N'2017-03-13' AS Date), N'<p>Gucci&nbsp;and&nbsp;<a href="http://www.thefashionspot.com/runway-news/683689-loewe-fall-2016-runway/" target="_blank">Loewe</a>, but&nbsp;the trend really gained traction&nbsp;in September, when striking&nbsp;tonal&nbsp;ensembles walked the Spring 2017 runways of Max Mara, Sies Marjan, Monse, Victoria Beckham and more. The same goes for Fall 2017, when Mara Hoffman, Celine, Balenciaga, Christopher Kane, Tibi and again Monse favored eye-grabbing monochromatic palettes.</p><p>&nbsp;</p>
<p><img alt="" src="/fashionshop/assets/images/userfiles/images/815x500a.jpeg" style="height:500px; width:815px" /><br />
&nbsp;</p>
<p>You&rsquo;ve probably seen the dramatic before and after photos on social media &mdash; because the results are&nbsp;<em>that</em>&nbsp;good. In just a few days (or weeks, depending on the foot peel), you&rsquo;ll see some seriously impressive results. The right foot peel will take off months of dead skin without any burning and without the need for any aggressive scrubbing. If you&rsquo;ve been a fan of foot files, one foot peel could be enough for you to throw out that brush and embrace the plastic booties.<br />
&nbsp;</p>
<p><img alt="" src="/fashionshop/assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p>
<p>So, grab one of these best foot peels, slip on a pair of plastic booties and get ready to flaunt your new, baby soft feet.<br />
&nbsp;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (4, 3, 1, N'Hate Waxing? Try Sugaring Instead', N'hate-waxing?-try-sugaring-instead', N'Sugaring is the all-natural, less painful answer to waxing. The takeaway? We must try 80s draping.', N'a3size.jpg', CAST(N'2017-04-13' AS Date), N'<p>body hair removal. If you&rsquo;ve been going au naturel under your jeans and cozy sweaters, the warmer weather may be your signal to bust out the wax strips and&nbsp;<a href="http://www.thefashionspot.com/beauty/740689-best-drugstore-razors/">razors</a>. Before you go back to your usual hair removal regimen, it&rsquo;s worth considering other methods &mdash; and a&nbsp;brilliant one is sugaring.<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>Sugaring hair removal may not be as well known as waxing, plucking and shaving, but it should be. (And not just because&nbsp;<a href="https://books.google.com/books?id=9Z6vCGbf66YC&amp;pg=PA180&amp;lpg=PA180&amp;dq=encyclopedia+egyptian+hair+removal&amp;source=bl&amp;ots=YL16CYj9re&amp;sig=AE4vcRG1bj02RAEymcfkPVteliI&amp;hl=en&amp;sa=X&amp;ei=JdNHVdyuGMvooAS3-ICgBg&amp;ved=0CD8Q6AEwBQ#v=onepage&amp;q=encyclopedia%20egyptian%20hair%20removal&amp;f=false" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://books.google.com'']);" rel="nofollow" target="_blank">the technique has been used since ancient times</a>&nbsp;in the Middle East, Greece and parts of Africa.) Not only does sugaring take full advantage of one of our favorite guilty pleasures, it also has many other benefits.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a3size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p><h3>What is Sugaring?</h3>
<p>Sugaring is sometimes referred to as sugaring wax or sugared waxing, but make no mistake, sugaring and traditional waxing are very different. Angela Rosen, founder of&nbsp;<a href="http://www.daphne.studio/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.daphne.studio'']);" rel="nofollow" target="_blank">DAPHNE Studio</a>&nbsp;beauty store and spa in New York City, explains that traditional Egyptian sugaring involves a technique that mixes sugar with water and lemon to create a paste. When this mixture is applied to skin, it is able to remove hair in the direction of hair growth &mdash; and it does so without having to use any traditional waxing strips or additional tools.</p>
<p><img alt="" src="/fashionshop/assets/images/userfiles/images/815x500b.jpeg" style="height:500px; width:815px" /></p>
<p>&quot;&gt;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (5, 4, 1, N'Watch: Amandla Stenberg Just Made Her Musical Debut', N'watch:-amandla-stenberg-just-made-her-musical-debut', N'Just when you thought she couldn''t get any cooler. Spring cleaning your beauty routine is a top priority.', N'815x500c.jpeg', CAST(N'2017-05-13' AS Date), N'<p>&nbsp;</p><p>&nbsp;</p>
<p>The message is fairly straightforward: obsessive phone use inhibits&nbsp;you from fully engaging with the world. In the video, Stenberg dances in a hazy, Technicolor, &ldquo;Hotline Bling&rdquo;-reminiscent room. She&rsquo;s surrounded by a crew of zombie-like teens who&rsquo;ve been completely hypnotized by their screens. (Like we said, none too subtle.) The setup is simple yet striking, and the extras, though static, are stylish AF. We can&rsquo;t wait for more where this came from.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a6size.jpg" style="height:500px; width:815px" /></p>
<p>Makeup pencils are easy to use and deposit the right amount of color while staying in both real and imaginary lines. Whether they&rsquo;re super skinny or supersized, pencils get the job done and they do it fast. Pencils are also perfect for travel and on-the-go touchups &mdash; and the slim shape makes it easy to fit into&nbsp;<a href="http://www.thefashionspot.com/style-trends/700799-fashion-trend-micro-bags/" target="_blank">the tiniest micro bag</a>.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (6, 3, 1, N'Watch: Amandla Stenberg Just Made Her Musical Debut', N'watch:-amandla-stenberg-just-made-her-musical-debut', N'Just when you thought she couldn''t get any cooler.', N'a4.jpg', CAST(N'2017-03-12' AS Date), N'<p>When she&rsquo;s not writing poetry, illustrating comic books, directing films, studying at NYU, fronting international fashion campaigns or schooling her peers on&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/697995-amandla-stenberg-sexuality/" target="_blank">intersectional feminism</a>, Amandla Stenberg is an actress. In her latest film,&nbsp;<em>Everything, Everything</em>&nbsp;&mdash; which already has&nbsp;<a href="http://pagesix.com/2017/05/08/beyonce-throws-support-behind-amandla-stenberg/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://pagesix.com'']);" target="_blank">Beyonc&eacute;&rsquo;s stamp of approval</a>&nbsp;&mdash; Stenberg plays Madeline Whittier, an 18-year-old girl with a severe immunodeficiency (SCID) that&rsquo;s left her allergic to just about everything. Then young love strikes, inspiring Madeline to defy fate and venture outside her hermetically sealed home. (Get ready to exercise those tear ducts.)<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/815x500b.jpeg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>Stenberg, Jane of All Trades that she is, shows off her vocal talents on the film&rsquo;s soundtrack. Her debut single, a cover of Mac DeMarco&rsquo;s &ldquo;Let My Baby Stay,&rdquo; is bluesy, ethereal and very Solange-reminiscent. The accompanying music video, released today on Vevo, is equally impressive, mostly because it was recorded, directed and edited by Stenberg herself.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>The message is fairly straightforward: obsessive phone use inhibits&nbsp;you from fully engaging with the world. In the video, Stenberg dances in a hazy, Technicolor, &ldquo;Hotline Bling&rdquo;-reminiscent room. She&rsquo;s surrounded by a crew of zombie-like teens who&rsquo;ve been completely hypnotized by their screens. (Like we said, none too subtle.) The setup is simple yet striking, and the extras, though static, are stylish AF. We can&rsquo;t wait for more where this came from.</p>', 3, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (7, 1, 1, N'Watch: Paris Hilton on the Early 2000s Trends That Are Still ‘So Hot’', N'watch:-paris-hilton-on-the-early-2000s-trends-that-are-still-‘so-hot’', N'"Tracksuits are so cute and comfortable. But always wear ones that are colorful, or else you''ll look like you''re actually going to the gym — ew."', N'a4.jpg', CAST(N'2017-02-12' AS Date), N'<p><a href="http://www.thefashionspot.com/style-trends/744551-denim-jeans-trends/" target="_blank">The early 2000s are back</a>&nbsp;and so, too, is their queen. To accompany her new&nbsp;<a href="http://www.wmagazine.com/story/paris-hilton-interview" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.wmagazine.com'']);" target="_blank"><em>W</em></a>&nbsp;feature,&nbsp;Paris Hilton &mdash; heiress, OG reality star, DJ, entrepreneur, singer and self-proclaimed selfie inventor&nbsp;&mdash; shot a fashion infomercial&nbsp;in which she breaks down&nbsp;the&nbsp;early aughts&nbsp;trends that (in her opinion) are still &ldquo;so hot.&rdquo; In&nbsp;<a href="https://broadly.vice.com/en_us/article/paris-hilton-profile-2015-19-fragrances-and-counting-heiress" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://broadly.vice.com'']);" target="_blank">her patented fake baby voice</a>, Hilton&nbsp;serves up priceless advice for styling 2000s hits like tracksuits, graphic tees, miniskirts, tiaras and low-waist jeans. For instance: &ldquo;Tracksuits are so cute and comfortable. But always wear ones that are colorful, or else you&rsquo;ll look like you&rsquo;re actually going to the gym &mdash; ew.&rdquo; #Iconic as ever.&nbsp;<em>E!&nbsp;</em>execs, if you&rsquo;re listening, we demand&nbsp;a&nbsp;<em>The Simple Life</em>&nbsp;reboot.<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p>
<p>#Queen. When it comes to advocating for body-positivity and self-love, Metz is right up there with national treasures&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/729007-ashley-graham-cellulite-confidence/" target="_blank">Ashley Graham</a>,&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/694185-kesha-instagram-body-shamers/" target="_blank">Kesha</a>&nbsp;and&nbsp;<a href="http://www.thefashionspot.com/runway-news/742911-amy-schumer-instyle/" target="_blank">Amy Schumer</a>. In her&nbsp;aforementioned&nbsp;<em>Harper&rsquo;s Bazaar</em>&nbsp;feature, Metz made it abundantly clear she has no time for body-shamers, nor fashion critics. &ldquo;I want to wear something because I love it, not because it follows the rules,&rdquo; Metz said of her style. She and stylist Jordan Grossman are known for their&nbsp;bold, glamorous&nbsp;fashion choices.&nbsp;&ldquo;I ever end up on the worst-dressed list, it&rsquo;s not going to make me fall apart,&rdquo; Metz stated. &ldquo;I want to look great and feel good and be comfortable, but at the same time, none of this [as in red carpet appearances and photo shoots] really matters. This is the fun stuff.&rdquo; And with that, Metz rolled four&nbsp;important life lessons into one: love yourself, focus on what really matters, brush off the haters and keep fashion fun.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a2size.jpg" style="height:500px; width:815px" /></p>
<p>Chrissy Metz, one-third of&nbsp;<em>This Is Us</em>&rsquo; beloved (present day) Big Three, is not here for internet fat shamers who don&rsquo;t think anyone over a size eight should be allowed to wear latex on camera. The actress, who was recently dubbed &ldquo;Hollywood&rsquo;s New Pin Up Girl&rdquo; by&nbsp;<a href="http://www.harpersbazaar.com/celebrity/a21194/chrissy-metz-this-is-us-interview/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.harpersbazaar.com'']);" target="_blank"><em>Harper&rsquo;s Bazaar</em></a>, attended last night&rsquo;s&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/746737-2017-mtv-movie-tv-awards/" target="_blank">MTV TV and Movie Awards</a>&nbsp;in a custom Jane Doe Latex empire-waist dress. Metz wore the ruffle-sleeved burgundy frock to present Best Duo award alongside co-star (and fictional father of the year) Milo Ventimiglia. As they are wont to do, the internet trolls descended. Metz, a beacon of body-positivity, let the negative, needless comments roll right off her back, tweeting the following response:<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>&nbsp;</p>
<p>Everyone pretty much marched to the beat of their own fashion drum at the newly minted MTV Movie &amp; TV Awards. The award show&nbsp;<a href="http://www.thefashionspot.com/runway-news/743151-mtv-movie-and-tv-awards/" target="_blank">boasted genderless categories this go-round</a>&nbsp;and a majority of the looks were &uuml;ber feminine with a few brave souls diverging from the pack by opting for more gender-neutral ensembles. Sparkle and fancy embroidery were definitely trending as several attendees embraced metallics, even down to their accessories. One-shoulder pieces were popular as were asymmetric hemlines. On the beauty front, strong lips were a real theme with stars rocking everything from deep red to bright blue lip colors. For all the fashion action from last night&rsquo;s ceremony, check out the slideshow above.</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (8, 2, 1, N'The Best (and Worst!) Beauty Looks from the 2017 Met Gala', N'the-best-(and-worst!)-beauty-looks-from-the-2017-met-gala', N'The takeaway? We must try 80s draping.', N'a5size.jpg', CAST(N'2017-02-12' AS Date), N'<p>If there&rsquo;s any time to get wildly experimental with your&nbsp;<em>lewk</em>, it&rsquo;s at a&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/719281-rei-kawakubo-costume-institute-2017/" target="_blank">Comme des Gar&ccedil;ons-themed Met Gala</a>. While the&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/745809-met-gala-2017-red-carpet/" target="_blank">2017 Met Gala red carpet</a>&nbsp;was sorely lacking in Rei Kawakubo-backed designs, attendees were more than willing to show their weird via avant-garde beauty looks.&nbsp;<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/815x500a.jpeg" style="height:500px; width:815px" /></p>
<p>For Cara Delevingne, that meant a bejeweled, spray-painted, hair-free head. Others paid homage to the woman of the hour by rocking&nbsp;<a href="http://www.vogue.com/article/bob-haircuts-met-gala-2017-rei-kawakubo-commes-des-garcons-olivia-wilde" onclick="javascript:_gaq.push([''_trackEvent'',''utbound-article'',''http://www.vogue.com'']);" target="_blank">her signature blunt bob</a>.</p>
<p>&nbsp;High-octane eyeshadow was another overarching theme, seen on the likes of Selena Gomez, Katy Perry, Evan Rachel Wood and Jemima Kirke. And, as with any red carpet, there was no shortage of flawless cat eyes (though Candice Swanepoel&rsquo;s took the crown).</p>
<p><img alt="" src="/fashionshop/assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /><br />
Click through the slideshow above to see all the over-the-top transformations and some of the more subtle, yet equally memorable, hair and makeup looks. (And remember, in life, we must take the bad with the good.)<br />
&nbsp;</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (9, 2, 1, N'8 Brand New Beauty Products to Try This May', N'8-brand-new-beauty-products-to-try-this-may', N'Spring cleaning your beauty routine is a top priority.', N'a6size.jpg', CAST(N'2017-01-12' AS Date), N'<p>As the steamy summer days quickly approach &mdash; and spring cleaning is still a top priority &mdash; it&rsquo;s the ideal time to make some swaps in your beauty routine. Toss gunky old creams in exchange for lighter lotions and oils. Think about&nbsp;<a href="http://www.thefashionspot.com/beauty/586511-best-overnight-face-masks/">repairing your skin while you sleep</a>&nbsp;so you have more time to sit alfresco sipping ros&eacute;. And don&rsquo;t neglect your fuzzy legs &mdash; there&rsquo;s a new product for that, too. From French cult favorites to the must-have nail polish color of the season, these beauty buys are sure to up your game pre-summer.</p><p><br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p><p>Another benefit of in-shower masks is that there are a variety of different formulas to target different skin concerns. Looking to tighten and brighten? There&rsquo;s a mask for that. Want to look more awake? There are splash masks to add radiance. Is your skin acting up and you don&rsquo;t know how to deal? There are soothing splash masks for that.<br />
&nbsp;</p><p><img alt="" src="/fashionshop/assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>Remember what we said about making some room in your shower? Here are the eight masks worth adding to your routine.<br />
&nbsp;</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (10, 4, 1, N'Yesterday’s Chanel Cruise Show May Have Been Karl Lagerfeld’s Final Collection', N'yesterday’s-chanel-cruise-show-may-have-been-karl-lagerfeld’s-final-collection', N'Say it ain''t so. But did you know that almost every type of beauty product now comes in pencil form?', N'a5size.jpg', CAST(N'2017-01-13' AS Date), N'<p>Karl Lagerfeld&nbsp;may be in poor health. According to unnamed Chanel sources, the French fashion house&rsquo;s&nbsp;<a href="http://www.thefashionspot.com/runway-news/746235-chanel-cruise-2018/" target="_blank">2018 Resort Show</a>&nbsp;&mdash; typically staged at&nbsp;<a href="http://www.thefashionspot.com/runway-news/692477-chanel-resort-2017-cruise-cuba/" target="_blank">some exotic locale</a>&nbsp;&mdash; was originally intended for Lisbon, not Paris&rsquo; Grand Palais. However, the faux Temple of Poseidon was ultimately erected in Paris because &ldquo;as more than one put it, &lsquo;Karl is not doing well.&rsquo;&rdquo;<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p><p>&nbsp;</p>
<p>Apparently, those lucky enough to attend the presentation were struck by the 83-year-old fashion legend&rsquo;s &ldquo;unstable&rdquo; finale walk, throughout which he &ldquo;limped distinctly&rdquo; and held tight to his godson Hudson Kroenig&rsquo;s hand. Adding to the speculation is the fact that Lagerfeld would not see well-wishers and reporters after the show. An &ldquo;unusual&rdquo; no backstage policy ensured his privacy. Another Chanel source implied Lagerfeld will be stepping down from his professional obligations. &ldquo;You can feel the winding down in-house,&rdquo; the&nbsp;source told&nbsp;<em>Town &amp; Country</em>. &ldquo;It definitely feels like an era is coming to an end.&rdquo;<br />
<img alt="" src="/fashionshop/assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>Chanel spokespeople have yet to comment on the subject. Cross your fingers, people.<br />
&nbsp;</p>', 5, 0)
GO
SET IDENTITY_INSERT [dbo].[blogs] OFF
GO
SET IDENTITY_INSERT [dbo].[productColors] ON 

GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (1, 1, N'Blue', N'blue', N'20170427_18_53_19ms01-blue.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (2, 2, N'White', N'white', N'20170427_19_06_12ms02-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (3, 3, N'White', N'white', N'20170427_19_13_04mts01-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (4, 4, N'Wash Blue', N'wash-blue', N'20170427_20_36_24mc01-wash-blue.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (5, 4, N'Black', N'black', N'20170427_20_36_24mc01-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (6, 5, N'White', N'white', N'20170427_20_46_45ms03-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (7, 6, N'Navy', N'navy', N'20170427_20_54_55ms04-navi.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (8, 7, N'Ecru', N'ecru', N'20170427_21_05_45ms05-ecru.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (9, 8, N'White', N'white', N'20170427_21_13_27ms06-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (10, 9, N'Black', N'black', N'20170427_21_19_45ms07-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (11, 10, N'Navy', N'navy', N'20170427_21_25_42ms08-navy.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (12, 11, N'Navy', N'navy', N'20170427_21_32_51ms09-navy.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (13, 12, N'Stone', N'stone', N'20170427_21_41_47ms10-stone.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (14, 12, N'Sky', N'sky', N'20170427_21_41_47ms10-sky.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (15, 13, N'Navy', N'navy', N'20170427_21_48_33ms11-navy.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (16, 14, N'Red', N'red', N'20170427_21_53_35ms12-red.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (17, 15, N'Navy', N'navy', N'20170427_22_01_43ms13-navy.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (18, 15, N'Stone', N'stone', N'20170427_22_01_43ms13-stone.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (19, 16, N'White', N'white', N'20170427_22_13_22ms14-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (20, 17, N'Tobacco', N'tobacco', N'20170427_22_22_05ms15-tobacco.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (21, 17, N'Black', N'black', N'20170427_22_22_05ms15-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (25, 19, N'Pink', N'pink', N'20170428_21_33_39wd01-pink.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (26, 19, N'White', N'white', N'20170428_21_33_39wd01-white.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (27, 19, N'Black', N'black', N'20170428_21_33_39wd01-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (28, 20, N'Blue', N'blue', N'20170428_21_40_28wd02-blue.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (29, 20, N'Black', N'black', N'20170428_21_40_28wd02-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (30, 21, N'Blue', N'blue', N'20170428_21_49_03wd03-blue.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (31, 21, N'Pink', N'pink', N'20170428_21_49_03wd03-pink.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (32, 22, N'Red', N'red', N'20170428_22_07_35wd04-red.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (33, 22, N'Lime', N'lime', N'20170428_22_07_34wd04-lime.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (34, 22, N'Sand', N'sand', N'20170428_22_07_34wd04-sand.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (35, 23, N'Black', N'black', N'20170428_22_16_40wd05-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (36, 23, N'White', N'white', N'20170428_22_16_40wd05-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (37, 24, N'Black', N'black', N'20170428_22_24_55wd06-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (38, 25, N'Black', N'black', N'20170429_10_05_01wd07-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (39, 26, N'Mid Blue', N'mid-blue', N'20170429_10_10_30wd08-mid-blue.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (40, 27, N'Orange', N'orange', N'20170429_10_24_34wd09-orange.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (41, 27, N'Black', N'black', N'20170429_10_24_34wd09-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (42, 27, N'Ivory', N'ivory', N'20170429_10_24_34wd09-ivory.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (43, 28, N'Blue', N'blue', N'20170429_10_29_30wd10-blue.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (44, 29, N'Orange', N'orange', N'20170429_10_35_50wd11-orange.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (45, 30, N'Black', N'black', N'20170429_10_43_02wd12-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (46, 30, N'Grey', N'grey', N'20170429_10_43_02wd12-grey.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (47, 31, N'Grey', N'grey', N'20170429_10_52_44wd13-grey.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (48, 31, N'Blush', N'blush', N'20170429_10_52_44wd13-blush.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (49, 31, N'Black', N'black', N'20170429_10_52_44wd13-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (50, 32, N'Grey', N'grey', N'20170429_11_02_47wd14-grey.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (51, 32, N'Navy', N'navy', N'20170429_11_02_47wd14-navy.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (52, 32, N'Black', N'black', N'20170429_11_02_47wd14-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (53, 33, N'Black', N'black', N'20170519_04_34_59wc1-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (54, 34, N'Orange', N'orange', N'20170519_04_45_18wc2-orange.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (55, 34, N'Black', N'black', N'20170519_04_45_18wc2-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (56, 35, N'Black', N'black', N'20170519_05_00_56mc02-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (57, 35, N'White', N'white', N'20170519_05_00_56mc02-white.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (58, 36, N'Navy', N'navy', N'20170519_05_13_35wk01-navy.jpg', 3, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (59, 36, N'Blush', N'blush', N'20170519_05_13_35wk01-blush.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (60, 36, N'Khaki', N'khaki', N'20170519_05_13_35wk01-khaki.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (61, 36, N'Black', N'black', N'20170519_05_13_35wk01-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (62, 37, N'Black', N'black', N'20170519_05_22_50mc03-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (63, 37, N'Burgundy', N'burgundy', N'20170519_05_22_49mc03-burgundy.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (64, 38, N'Navy', N'navy', N'20170519_05_32_44msw01-navy.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (65, 38, N'Oatmeal', N'oatmeal', N'20170519_05_32_44msw01-oatmeal.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (66, 39, N'Black', N'black', N'20170519_05_38_45mts02-black.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (67, 40, N'Navy', N'navy', N'20170519_05_44_44mc04-navy.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (68, 41, N'Camel', N'camel', N'20170519_05_51_43wc3-camel.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (69, 42, N'Black', N'black', N'20170519_06_02_04wc4-black.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (70, 42, N'Rust', N'rust', N'20170519_06_02_04wc4-rust.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (71, 42, N'Silver', N'silver', N'20170519_06_02_04wc4-silver.jpg', 2, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (72, 43, N'Grey', N'grey', N'20170519_06_09_08msw02-grey.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (73, 44, N'Rust', N'rust', N'20170519_06_16_25msw03-rust.jpg', 1, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (74, 44, N'Mint', N'mint', N'20170519_06_16_25msw03-mint.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (75, 45, N'Black', N'black', N'20170519_12_02_22mts03-black.jpg', 0, 1)
GO
SET IDENTITY_INSERT [dbo].[productColors] OFF
GO
SET IDENTITY_INSERT [dbo].[sizesByColor] ON 

GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (1, 1, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (2, 1, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (3, 1, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (4, 1, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (5, 2, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (6, 2, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (7, 2, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (8, 2, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (9, 3, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (10, 3, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (11, 3, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (12, 3, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (13, 5, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (14, 5, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (15, 4, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (16, 4, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (17, 5, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (18, 4, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (19, 5, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (20, 4, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (21, 6, N'S', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (22, 6, N'M', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (23, 6, N'XS', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (24, 6, N'XL', 50, 4, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (25, 6, N'L', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (26, 7, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (27, 7, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (28, 7, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (29, 7, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (30, 8, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (31, 8, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (32, 8, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (33, 8, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (34, 9, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (35, 9, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (36, 9, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (37, 9, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (38, 10, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (39, 10, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (40, 10, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (41, 10, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (42, 11, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (43, 11, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (44, 11, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (45, 11, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (46, 12, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (47, 12, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (48, 12, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (49, 12, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (50, 13, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (51, 13, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (52, 14, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (53, 13, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (54, 14, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (55, 13, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (56, 14, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (57, 14, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (58, 15, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (59, 15, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (60, 15, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (61, 15, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (62, 16, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (63, 16, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (64, 16, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (65, 16, N'XXL', 50, 4, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (66, 16, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (67, 18, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (68, 17, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (69, 17, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (70, 17, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (71, 18, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (72, 18, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (73, 17, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (74, 18, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (75, 19, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (76, 19, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (77, 19, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (78, 19, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (79, 21, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (80, 21, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (81, 20, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (82, 21, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (83, 21, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (84, 20, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (85, 20, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (86, 20, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (96, 27, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (97, 26, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (98, 25, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (99, 26, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (100, 25, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (101, 26, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (102, 27, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (103, 25, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (104, 27, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (105, 29, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (106, 28, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (107, 28, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (108, 28, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (109, 29, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (110, 29, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (111, 31, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (112, 30, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (113, 30, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (114, 31, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (115, 30, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (116, 31, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (117, 33, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (118, 33, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (119, 32, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (120, 32, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (121, 33, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (122, 32, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (123, 34, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (124, 33, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (125, 34, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (126, 34, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (127, 32, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (128, 34, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (129, 36, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (130, 35, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (131, 35, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (132, 36, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (133, 35, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (134, 36, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (135, 37, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (136, 37, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (137, 37, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (138, 37, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (139, 38, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (140, 38, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (141, 38, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (142, 39, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (143, 39, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (144, 39, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (145, 39, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (146, 40, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (147, 41, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (148, 40, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (149, 41, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (150, 42, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (151, 42, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (152, 41, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (153, 42, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (154, 40, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (155, 43, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (156, 43, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (157, 43, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (158, 44, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (159, 44, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (160, 44, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (161, 45, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (162, 46, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (163, 46, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (164, 45, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (165, 45, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (166, 46, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (167, 47, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (168, 49, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (169, 47, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (170, 48, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (171, 49, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (172, 47, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (173, 49, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (174, 48, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (175, 48, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (176, 50, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (177, 51, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (178, 52, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (179, 50, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (180, 51, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (181, 52, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (182, 50, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (183, 51, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (184, 52, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (185, 53, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (186, 53, N'XL', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (187, 54, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (188, 54, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (189, 55, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (190, 54, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (191, 55, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (192, 55, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (193, 57, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (194, 56, N'M', 0, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (195, 57, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (196, 57, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (197, 57, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (198, 56, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (199, 56, N'S', 0, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (200, 56, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (201, 59, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (202, 59, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (203, 58, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (204, 61, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (205, 58, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (206, 61, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (207, 59, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (208, 61, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (209, 60, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (210, 60, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (211, 58, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (212, 60, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (213, 63, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (214, 62, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (215, 62, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (216, 63, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (217, 62, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (218, 63, N'S', 50, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (219, 63, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (220, 62, N'L', 50, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (221, 64, N'M', 47, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (222, 64, N'S', 34, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (223, 65, N'M', 50, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (224, 65, N'XL', 40, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (225, 65, N'S', 10, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (226, 65, N'L', 43, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (227, 64, N'XL', 24, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (228, 64, N'L', 35, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (229, 66, N'M', 24, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (230, 66, N'XL', 25, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (231, 66, N'L', 35, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (232, 66, N'S', 10, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (233, 67, N'M', 14, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (234, 67, N'S', 35, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (235, 67, N'XL', 24, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (236, 67, N'L', 35, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (237, 68, N'M', 23, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (238, 70, N'M', 15, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (239, 69, N'S', 34, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (240, 71, N'M', 36, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (241, 70, N'S', 13, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (242, 71, N'L', 37, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (243, 69, N'M', 24, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (244, 71, N'S', 34, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (245, 70, N'L', 34, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (246, 69, N'L', 42, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (247, 72, N'S', 34, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (248, 72, N'XL', 35, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (249, 72, N'L', 25, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (250, 72, N'M', 10, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (251, 74, N'S', 34, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (252, 74, N'M', 45, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (253, 73, N'S', 20, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (254, 74, N'XL', 13, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (255, 73, N'XL', 20, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (256, 73, N'M', 20, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (257, 74, N'L', 21, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (258, 73, N'L', 20, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (259, 75, N'XL', 50, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (260, 75, N'L', 34, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (261, 75, N'M', 20, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (262, 75, N'S', 20, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[sizesByColor] OFF
GO
SET IDENTITY_INSERT [dbo].[ordersDetail] ON 

GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (1, 1, 20, 105, 0, 2, 30, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (2, 1, 24, 136, 0, 2, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (3, 2, 1, 4, 0, 1, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (4, 2, 7, 31, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (5, 2, 10, 43, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (6, 3, 3, 9, 0, 2, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (7, 3, 15, 70, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (9, 4, 4, 18, 0, 2, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (10, 5, 7, 33, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (11, 5, 10, 45, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (12, 5, 12, 54, 0, 2, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (13, 6, 8, 36, 0, 1, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (14, 6, 14, 62, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (15, 7, 7, 31, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (16, 7, 13, 59, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (17, 8, 9, 41, 0, 1, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (18, 8, 7, 33, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (19, 8, 11, 48, 0, 1, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (20, 9, 2, 5, 0, 1, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (21, 10, 5, 22, 0, 1, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (22, 10, 6, 28, 0, 1, 36, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (23, 11, 10, 43, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (24, 11, 17, 79, 0, 2, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (25, 11, 29, 158, 0, 2, 35, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (26, 12, 24, 135, 0, 2, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (27, 12, 24, 138, 0, 1, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (28, 13, 23, 134, 0, 3, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (29, 13, 4, 13, 0, 2, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (30, 14, 8, 34, 0, 2, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (31, 15, 28, 155, 0, 1, 35, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (32, 15, 27, 148, 0, 2, 36, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (33, 15, 10, 43, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (34, 15, 10, 42, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (35, 15, 1, 1, 0, 1, 24, 0)
GO
SET IDENTITY_INSERT [dbo].[ordersDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[productSubImgs] ON 

GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (1, 1, N'20170427_18_53_19ms01-blue-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (2, 1, N'20170427_18_53_19ms01-blue-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (3, 1, N'20170427_18_53_19ms01-blue-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (4, 1, N'20170427_18_53_19ms01-blue-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (5, 2, N'20170427_19_06_12ms02-white-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (6, 2, N'20170427_19_06_12ms02-white-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (7, 2, N'20170427_19_06_12ms02-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (8, 2, N'20170427_19_06_12ms02-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (9, 3, N'20170427_19_13_04mts01-white-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (10, 3, N'20170427_19_13_04mts01-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (11, 3, N'20170427_19_13_04mts01-white-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (12, 3, N'20170427_19_13_04mts01-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (13, 4, N'20170427_20_36_24mc01_wash_blue_4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (14, 5, N'20170427_20_36_24mc01_black_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (15, 4, N'20170427_20_36_24mc01_wash_blue_3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (16, 4, N'20170427_20_36_24mc01_wash_blue_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (17, 4, N'20170427_20_36_24mc01_wash_blue_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (18, 5, N'20170427_20_36_24mc01_black_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (19, 6, N'20170427_20_46_45ms03_white_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (20, 6, N'20170427_20_46_45ms03_white_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (21, 6, N'20170427_20_46_45ms03_white_4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (22, 6, N'20170427_20_46_45ms03_white_3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (23, 7, N'20170427_20_54_55ms04_navy_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (24, 7, N'20170427_20_54_55ms04_navy_4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (25, 7, N'20170427_20_54_55ms04_navy_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (26, 7, N'20170427_20_54_55ms04_navy_3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (27, 8, N'20170427_21_05_45ms05_ecru_3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (28, 8, N'20170427_21_05_45ms05_ecru_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (29, 8, N'20170427_21_05_45ms05_ecru_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (30, 8, N'20170427_21_05_45ms05_ecru_4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (31, 9, N'20170427_21_13_27ms06-white_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (32, 9, N'20170427_21_13_27ms06-white_3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (33, 9, N'20170427_21_13_27ms06-white_2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (34, 9, N'20170427_21_13_27ms06-white_4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (35, 10, N'20170427_21_19_45ms07-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (36, 10, N'20170427_21_19_45ms07-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (37, 10, N'20170427_21_19_45ms07-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (38, 10, N'20170427_21_19_45ms07-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (39, 11, N'20170427_21_25_42ms08-navy-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (40, 11, N'20170427_21_25_42ms08-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (41, 11, N'20170427_21_25_42ms08-navy-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (42, 11, N'20170427_21_25_42ms08-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (43, 12, N'20170427_21_32_51ms09-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (44, 12, N'20170427_21_32_51ms09-navy-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (45, 12, N'20170427_21_32_51ms09-navy-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (46, 12, N'20170427_21_32_51ms09-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (47, 14, N'20170427_21_41_47ms10-sky-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (48, 13, N'20170427_21_41_47ms10-stone-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (49, 13, N'20170427_21_41_47ms10-stone-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (50, 13, N'20170427_21_41_47ms10-stone-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (51, 13, N'20170427_21_41_47ms10-stone-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (52, 14, N'20170427_21_41_47ms10-sky-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (53, 15, N'20170427_21_48_33ms11-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (54, 15, N'20170427_21_48_33ms11-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (55, 15, N'20170427_21_48_33ms11-navy-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (56, 16, N'20170427_21_53_35ms12-red-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (57, 16, N'20170427_21_53_35ms12-red-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (58, 16, N'20170427_21_53_35ms12-red-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (59, 16, N'20170427_21_53_35ms12-red-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (60, 18, N'20170427_22_01_43ms13-stone-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (61, 17, N'20170427_22_01_43ms13-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (62, 18, N'20170427_22_01_43ms13-stone-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (63, 17, N'20170427_22_01_43ms13-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (64, 18, N'20170427_22_01_43ms13-stone-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (65, 18, N'20170427_22_01_43ms13-stone-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (66, 19, N'20170427_22_13_22ms14-white-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (67, 19, N'20170427_22_13_22ms14-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (68, 19, N'20170427_22_13_22ms14-white-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (69, 19, N'20170427_22_13_22ms14-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (70, 21, N'20170427_22_22_05ms15-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (71, 20, N'20170427_22_22_05ms15-tobacco-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (72, 21, N'20170427_22_22_05ms15-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (73, 20, N'20170427_22_22_05ms15-tobacco-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (74, 20, N'20170427_22_22_05ms15-tobacco-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (75, 20, N'20170427_22_22_05ms15-tobacco-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (84, 27, N'20170428_21_33_39wd01-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (85, 25, N'20170428_21_33_39wd01-pink-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (86, 27, N'20170428_21_33_39wd01-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (87, 26, N'20170428_21_33_39wd01-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (88, 27, N'20170428_21_33_39wd01-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (89, 25, N'20170428_21_33_39wd01-pink-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (90, 27, N'20170428_21_33_39wd01-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (91, 26, N'20170428_21_33_39wd01-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (92, 28, N'20170428_21_40_28wd02-blue-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (93, 28, N'20170428_21_40_28wd02-blue-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (94, 29, N'20170428_21_40_28wd02-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (95, 29, N'20170428_21_40_28wd02-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (96, 29, N'20170428_21_40_28wd02-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (97, 29, N'20170428_21_40_28wd02-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (98, 30, N'20170428_21_49_03wd03-blue-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (99, 30, N'20170428_21_49_03wd03-blue-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (100, 31, N'20170428_21_49_03wd03-pink-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (101, 31, N'20170428_21_49_03wd03-pink-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (102, 30, N'20170428_21_49_03wd03-blue-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (103, 30, N'20170428_21_49_03wd03-blue-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (104, 34, N'20170428_22_07_34wd04-sand-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (105, 34, N'20170428_22_07_34wd04-sand-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (106, 34, N'20170428_22_07_34wd04-sand-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (107, 33, N'20170428_22_07_35wd04-lime-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (108, 32, N'20170428_22_07_35wd04-red-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (109, 32, N'20170428_22_07_35wd04-red-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (110, 33, N'20170428_22_07_34wd04-lime-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (111, 34, N'20170428_22_07_34wd04-sand-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (112, 36, N'20170428_22_16_40wd05-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (113, 35, N'20170428_22_16_40wd05-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (114, 36, N'20170428_22_16_40wd05-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (115, 36, N'20170428_22_16_40wd05-white-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (116, 36, N'20170428_22_16_40wd05-white-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (117, 35, N'20170428_22_16_40wd05-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (118, 37, N'20170428_22_24_55wd06-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (119, 37, N'20170428_22_24_55wd06-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (120, 37, N'20170428_22_24_55wd06-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (121, 37, N'20170428_22_24_55wd06-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (122, 38, N'20170429_10_05_01wd07-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (123, 38, N'20170429_10_05_01wd07-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (124, 38, N'20170429_10_05_01wd07-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (125, 38, N'20170429_10_05_01wd07-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (126, 39, N'20170429_10_10_30wd08-mid-blue-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (127, 39, N'20170429_10_10_30wd08-mid-blue-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (128, 39, N'20170429_10_10_30wd08-mid-blue-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (129, 39, N'20170429_10_10_30wd08-mid-blue-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (130, 40, N'20170429_10_24_34wd09-orange-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (131, 42, N'20170429_10_24_34wd09-ivory-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (132, 41, N'20170429_10_24_34wd09-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (133, 41, N'20170429_10_24_34wd09-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (134, 40, N'20170429_10_24_34wd09-orange-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (135, 41, N'20170429_10_24_34wd09-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (136, 42, N'20170429_10_24_34wd09-ivory-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (137, 41, N'20170429_10_24_34wd09-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (138, 43, N'20170429_10_29_30wd10-blue-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (139, 43, N'20170429_10_29_30wd10-blue-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (140, 43, N'20170429_10_29_30wd10-blue-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (141, 43, N'20170429_10_29_30wd10-blue-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (142, 44, N'20170429_10_35_50wd11-orange-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (143, 44, N'20170429_10_35_50wd11-orange-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (144, 44, N'20170429_10_35_50wd11-orange-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (145, 44, N'20170429_10_35_50wd11-orange-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (146, 45, N'20170429_10_43_02wd12-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (147, 45, N'20170429_10_43_02wd12-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (148, 46, N'20170429_10_43_02wd12-grey-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (149, 46, N'20170429_10_43_02wd12-grey-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (150, 45, N'20170429_10_43_02wd12-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (151, 45, N'20170429_10_43_02wd12-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (152, 49, N'20170429_10_52_44wd13-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (153, 47, N'20170429_10_52_44wd13-grey-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (154, 49, N'20170429_10_52_44wd13-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (155, 47, N'20170429_10_52_44wd13-grey-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (156, 48, N'20170429_10_52_44wd13-blush-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (157, 48, N'20170429_10_52_44wd13-blush-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (158, 47, N'20170429_10_52_44wd13-grey-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (159, 47, N'20170429_10_52_44wd13-grey-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (160, 52, N'20170429_11_02_47wd14-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (161, 52, N'20170429_11_02_47wd14-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (162, 50, N'20170429_11_02_47wd14-grey-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (163, 50, N'20170429_11_02_47wd14-grey-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (164, 51, N'20170429_11_02_47wd14-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (165, 50, N'20170429_11_02_47wd14-grey-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (166, 51, N'20170429_11_02_47wd14-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (167, 50, N'20170429_11_02_47wd14-grey-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (168, 53, N'20170519_04_34_59wc01-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (169, 53, N'20170519_04_34_59wc01-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (170, 53, N'20170519_04_34_59wc01-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (171, 53, N'20170519_04_34_59wc01-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (172, 54, N'20170519_04_45_18wc02-orange-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (173, 55, N'20170519_04_45_18wc2-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (174, 55, N'20170519_04_45_18wc2-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (175, 54, N'20170519_04_45_18wc02-orange-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (176, 54, N'20170519_04_45_18wc02-orange-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (177, 54, N'20170519_04_45_18wc02-orange-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (178, 57, N'20170519_05_00_56mc02-white-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (179, 56, N'20170519_05_00_56mc02-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (180, 57, N'20170519_05_00_56mc02-white-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (181, 56, N'20170519_05_00_56mc02-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (182, 57, N'20170519_05_00_56mc02-white-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (183, 57, N'20170519_05_00_56mc02-white-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (184, 61, N'20170519_05_13_35wk01-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (185, 61, N'20170519_05_13_35wk01-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (186, 60, N'20170519_05_13_35wk01-khaki-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (187, 59, N'20170519_05_13_35wk01-blush-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (188, 60, N'20170519_05_13_35wk01-khaki-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (189, 61, N'20170519_05_13_35wk01-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (190, 61, N'20170519_05_13_35wk01-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (191, 58, N'20170519_05_13_35wk01-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (192, 58, N'20170519_05_13_35wk01-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (193, 59, N'20170519_05_13_35wk01-blush-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (194, 63, N'20170519_05_22_50mc03-burgundy-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (195, 63, N'20170519_05_22_49mc03-burgundy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (196, 63, N'20170519_05_22_50mc03-burgundy-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (197, 63, N'20170519_05_22_49mc03-burgundy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (198, 62, N'20170519_05_22_50mc03-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (199, 62, N'20170519_05_22_50mc03-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (200, 65, N'20170519_05_32_44msw01-oatmeal-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (201, 64, N'20170519_05_32_44msw01-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (202, 65, N'20170519_05_32_44msw01-oatmeal-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (203, 65, N'20170519_05_32_44msw01-oatmeal-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (204, 65, N'20170519_05_32_44msw01-oatmeal-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (205, 66, N'20170519_05_38_45mts02-black-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (206, 66, N'20170519_05_38_45mts02-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (207, 66, N'20170519_05_38_45mts02-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (208, 66, N'20170519_05_38_45mts02-black-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (209, 67, N'20170519_05_44_44mc04-navy-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (210, 67, N'20170519_05_44_44mc04-navy-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (211, 67, N'20170519_05_44_44mc04-navy-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (212, 67, N'20170519_05_44_44mc04-navy-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (213, 68, N'20170519_05_51_44wc3-camel-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (214, 68, N'20170519_05_51_43wc3-camel-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (215, 68, N'20170519_05_51_43wc3-camel-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (216, 68, N'20170519_05_51_43wc3-camel-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (217, 70, N'20170519_06_02_04wc4-rust-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (218, 71, N'20170519_06_02_04wc4-silver-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (219, 71, N'20170519_06_02_04wc4-silver-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (220, 69, N'20170519_06_02_04wc4-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (221, 69, N'20170519_06_02_04wc4-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (222, 70, N'20170519_06_02_04wc4-rust-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (223, 70, N'20170519_06_02_04wc4-rust-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (224, 70, N'20170519_06_02_04wc4-rust-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (225, 72, N'20170519_06_09_08msw02-grey-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (226, 72, N'20170519_06_09_08msw02-grey-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (227, 72, N'20170519_06_09_08msw02-grey-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (228, 72, N'20170519_06_09_08msw02-grey-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (229, 73, N'20170519_06_16_25msw03-rust-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (230, 74, N'20170519_06_16_25msw03-mint-4.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (231, 74, N'20170519_06_16_25msw03-mint-3.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (232, 74, N'20170519_06_16_25msw03-mint-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (233, 74, N'20170519_06_16_25msw03-mint-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (234, 73, N'20170519_06_16_25msw03-rust-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (235, 75, N'20170519_12_02_22mts03-black-1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (236, 75, N'20170519_12_02_23mts03-black-2.jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (237, 75, N'20170519_12_02_23mts03-black-4.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (238, 75, N'20170519_12_02_23mts03-black-3.jpg', 3)
GO
SET IDENTITY_INSERT [dbo].[productSubImgs] OFF
GO
