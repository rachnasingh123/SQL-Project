create database ipl;
use ipl;
create table ipl (
id int primary key,	
season varchar(200),	
city varchar(200),	
date DATE,	
match_type varchar(200),	
player_of_match	Varchar(200),
venue varchar(200),	
team1 varchar(200),	
team2 varchar(200),	
toss_winner	varchar(200),
toss_decision varchar(200),	
winner varchar(200),	
result	varchar(200),
result_margin varchar(200),	
target_runs	varchar(200),
target_overs varchar(200),	
super_over varchar(10),	
method	varchar(200),
umpire1	varchar(150),
umpire2 varchar(150));

-- 1. Which team won the most matches in IPL?
SELECT winner,count(*) from ipl 
group by winner order by count(*) desc limit 1;

-- 2. Which player won the most player of the match awards?
select player_of_match,count(*) as award_counts from  ipl 
group by player_of_match order by award_counts desc limit 1;

-- 3. Which city hosted the most matches?
select city,count(*) from ipl 
group by city order by count(*) desc limit 1;

-- 4. What was the highest win by run(Defending)?Which team achieved it?
select winner,cast(result_margin as signed) as win_by_runs from ipl where result ='runs'
group by winner, win_by_runs order by win_by_runs desc limit 1;

-- 5.What was the highest win by wickets(chasing)?Which team achieved it?
select winner,cast(result_margin as signed) as win_by_wickets from ipl where result ='wickets'
group by winner, win_by_wickets order by win_by_wickets desc limit 1;




 