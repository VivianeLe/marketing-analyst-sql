-- Question 1:
-- a) Show the number of products available for each accepted risk level.
select
	p.accepted_risk_level,
	count(p.product_id) as Product_quant
from
	Products p
group by
	1
	-- b) Show the average interest rate of products provided by HSBC bank.
select
	avg(p.interest_rate) as avg_rate
from
	Products p
left join Banks b on
	p.bank_id = b.bank_id
where
	b.bank_name = "HSBC"
	-- c) Show 2 banks that have most high risk products.
select
	b.bank_name,
	count(p.product_id) as High_Risk_quant
from
	Product p
left join Banks b on
	p.bank_id = b.bank_id
where
	p.accepted_risk_level = "high"
group by
	1
order by
	count(p.product_id) desc
limit 2
-- d) Show which source brings to the marketplace more low risk customers.
select
	c.source,
	count(c.customer_id) as Customers_quant
from
	Customers c
where
	c.estimated_risk_level = "low"
group by
	1
order by
	count(c.customer_id) desc
limit 1
-- e) Show all months of the year 2017 that the number of 
-- customers applying for loans are 20% higher than the monthly average number of customers of the year.
select
	month(l.apply_date) as Month,
	count(DISTINCT l.customer_id) as Customer_quant
from
	Leads l
where
	year(l.apply_date) = 2017
group by
	month(l.apply_date)
having
	Customer_quant > (
	select
		round(count(distinct l.customer_id)/ 12, 0)
	from
		Leads l
	where
		year(l.apply_date) = 2017
	group by
		year(l.apply_date)) * 1.2
	-- f) Show the names of all leads who applied in 2017 and are older than 90% of all leads who applied in 2016
with 2016 as(
	select
		"2016" as "Year",
		l.customer_id,
		c.customer_name,
		c.customer_age,
		PERCENTILE_CONT(0.9) 
		within group (
		order by c.customer_age asc)
		over (partition by c.customer_age) as percentRank
	from
		Leads l
	left join Customers c on
		l.customer_id = c.customer_id
	where
		year(l.apply_date) = 2016),
		
2017 as(
	select
		"2017" as "Year",
		l.customer_id,
		c.customer_name,
		c.customer_age
	from
		Leads l
	left join Customers c on
		l.customer_id = c.customer_id
	where
		year(l.apply_date) = 2017)
		
select
	2017.customer_name,
	2017.customer_age
from
	2017
full join 2016
where
	2017.year = 2016.year
where
	2017.customer_age > (
	select
		2016.customer_age
	from
		2016
	where
		2016.percentRank = 0.9)
	-- Question 2:
	-- ROI by age, channel, coupon
select
	*
from
	Class6.mkt_data md2
where
	md2.last_step <> 'purchased'
	and md2.nb_units >0
limit 10

create view Class6.mkt_cost as
with cost as(
select
	CONCAT(md.age_range, md.channel, md.coupon) as id,
		md.age_range,
	channel,
	coupon, 
		sum(md.nb_units) * 18 as product_cost,
		sum(order_value) as total_value,
	if (md.channel = "Email",
	round((count(DISTINCT id) * 0.075), 2),
	round((count(DISTINCT id) * 0.05), 2)) as send_cost
from
	Class6.mkt_data md
group by
	1,
	2,
	3
order by
	md.age_range,
	md.channel,
	md.coupon asc),

coupon_cost as(
select
	CONCAT(md.age_range, md.channel, md.coupon) as id,
	md.age_range,
	md.channel,
	md.coupon,
	sum(md.coupon) as coupon_value
from
	Class6.mkt_data md
where
	md.last_step = 'purchased'
group by
	1,
	2,
	3)

select
	c.age_range,
	c.channel,
	c.coupon,
	c.send_cost,
	c.total_value,
	c.product_cost + c.send_cost + cc.coupon_value as total_cost,
	c.total_value - (c.product_cost + c.send_cost + cc.coupon_value) as net_profit
from
	cost c
join coupon_cost cc on
	c.id = cc.id
where
	c.age_range <> '60+'
	-- use view mkt_cost to allocate budget and pool size
with cte as(
	select
		*,
		round(m.net_profit / m.total_value, 2) as ROI,
		round(m.net_profit / sum(m.net_profit) over() * 60000, 2) as allocated_budget,
		case
			when m.age_range = '18-30' then round((m.net_profit / sum(m.net_profit) over(partition by m.age_range)) * 300000, 0)
			when m.age_range = '31-45' then round(m.net_profit / sum(m.net_profit) over(partition by m.age_range) * 350000, 0)
			when m.age_range = '46-60' then round(m.net_profit / sum(m.net_profit) over(partition by m.age_range) * 500000, 0)
		end as allocated_pool
	from
		Class6.mkt_cost m
	order by
		m.age_range,
		m.channel,
		m.coupon asc)
select
	e.age_range,
	e.channel,
	e.coupon,
	e.allocated_budget,
	e.allocated_pool
	-- e.allocated_budget/allocated_pool as avg_money
	-- if(e.channel = 'Email', round(e.allocated_budget/0.075,0), round(e.allocated_budget/0.05,0)) as send_times
from
	cte e
	-- ROI by age
create view Class6.P_L as
with value as(
	select
		md.age_range,
		sum(md.nb_units) * 18 as product_cost,
		sum(md.order_value) as total_value
	from
		Class6.mkt_data md
	group by
		1),
	-- total discount by coupon
	coupon as (
	select
		md2.age_range,
		sum(md2.coupon) as coupon_value
	from
		Class6.mkt_data md2
	where
		md2.last_step = 'purchased'
	group by
		1
)
select
	v.age_range,
	v.product_cost,
	c.coupon_value,
	sum(cost.send_cost) as mkt_cost,
	v.product_cost + c.coupon_value + sum(cost.send_cost) as total_cost,
	v.total_value,
	v.total_value - v.product_cost - c.coupon_value - sum(cost.send_cost) as net_profit
from
	value v
join coupon c on
	v.age_range = c.age_range
join Class6.mkt_cost cost on
	v.age_range = cost.age_range
group by
	v.age_range

select
	p.age_range,
	p.total_cost,
	p.total_value,
	-- round(p.total_value/sum(p.total_value) over(),2) as percent_value,
	p.net_profit,
	-- round(p.net_profit/sum(p.net_profit) over(),2) as percent_profit,
	round(p.net_profit / p.total_cost, 2) as roi
	-- round((p.net_profit/sum(p.net_profit) over()) * 60000,0) as allocate_budget
from
	Class6.P_L p
	-- where p.net_profit > 0
order by
	p.age_range
