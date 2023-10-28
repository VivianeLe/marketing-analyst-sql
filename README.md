# marketing-analyst-sql
**TRUSTING SOCIAL**
**Question 1**
Assuming that your company is running a loan marketplace where people who want to borrow money are matched with appropriate loan products provided by different banks, the data schemas are shown below:

<img width="870" alt="Screen Shot 2023-10-28 at 22 50 38" src="https://github.com/VivianeLe/marketing-analyst-sql/assets/95589311/0b929dbe-2de7-4552-a532-6f02a79dc793">
<img width="855" alt="Screen Shot 2023-10-28 at 22 48 52" src="https://github.com/VivianeLe/marketing-analyst-sql/assets/95589311/b7277cbe-2c20-4dae-ac0a-9e50427950ba">
<img width="861" alt="Screen Shot 2023-10-28 at 22 49 52" src="https://github.com/VivianeLe/marketing-analyst-sql/assets/95589311/0e4f3b9a-e10a-4efe-a723-b62223df2f69">
<img width="863" alt="Screen Shot 2023-10-28 at 22 50 21" src="https://github.com/VivianeLe/marketing-analyst-sql/assets/95589311/9a81ee93-0fbe-46b7-941e-de3cb2899a5e">

A customer with estimated risk level X will only be matched with a product that accepts risk level X. Based on the above data tables, please write SQL queries to:
a) Show the number of products available for each accepted risk level.
b) Show the average interest rate of products provided by HSBC bank.
c) Show 2 banks that have most high risk products.
d) Show which source brings to the marketplace more low risk customers.
e) Show all months of the year 2017 that the number of customers applying for loans are 20% higher than the monthly average number of customers of the year.
f) Show the names of all leads who applied in 2017 and are older than 90% of all leads who applied in 2016

**Question 2**
You are a Data Analyst for a company which produces a new generation of electric men razor. Your company registered an e-commerce site at www.Coolmen-Coolrazors.com 1 month ago to sell its product online instead of the traditional supermarket channel. During the last month, it piloted advertising on 2 channels:
● Email Channel
● SMS Channel
Data are extracted from a centralized database and stored in the attached file called “mkt_data.csv”.

The column “last_step” is the final point of contact with customers before they leave our website. Its values are explained below:
● Received: sms/email sent successfully, but no clicked.
● Bounced: they clicked but exited immediately.
● Saw review: scroll down and read the review and information of the product ● Added to cart: customers added the product to cart to check out
● Payment page: They stopped at payment without finishing it ● Purchased: They made an order

Financial Information
Together with the data above, you have additional information about the production cost and the marketing campaigns.
● Production cost for each razor is 18$.
● Cost per one SMS is $0.050, cost per one email sent is $0.075.
● Each email or SMS will be supplied a coupon which can have value of 2$, 4$ or 6$. Coupon is valid for up to 3 razors in each order. They have the option to wrap the items as gift. Ignore wrapping and shipping costs.
● The price without coupon is 40$ / razor.
● From experience (and some models), potential customers are divided into 4 age groups:
○ 18 - 30 ○ 31 - 45 ○ 46 - 60 ○ 60 +

Question
2.a. For the next quarter, your marketing department has a budget of $60,000 to spend on online campaigns. How would you allocate it between SMS and Email? Assume that we have potential customer pool for each age group as below:
<img width="819" alt="Screen Shot 2023-10-28 at 22 52 34" src="https://github.com/VivianeLe/marketing-analyst-sql/assets/95589311/29055b9c-ff89-41f0-a569-6e7fc376bc87">
2.b. Now assume that you are also responsible for the operation of the company’s website. Do you have any comments or suggestions so that we can improve the website’s performance in order to maximize net profit?
