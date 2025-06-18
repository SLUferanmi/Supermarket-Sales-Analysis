CREATE DATABASE BrainWave_SocialMedia
-- Creating Database

USE BrainWave_SocialMedia
--Use specified database

GO
CREATE SCHEMA BrainWaveE
--Creating schema 

GO
SELECT *
FROM BrainWave.SocialMediaSentiments
--Viewing the whole table

--Data Cleaning
DELETE FROM BrainWave.SocialMediaSentiments
WHERE [Post_ID] NOT IN(
    SELECT MIN(Post_ID)
    FROM BrainWave.SocialMediaSentiments
    GROUP BY Post_Content
)
--Getting rid of duplicates

UPDATE BrainWave.SocialMediaSentiments
SET [Language]= REPLACE([Language], 'fr', 'French')
WHERE [Language] LIKE 'fr';

UPDATE BrainWave.SocialMediaSentiments
SET [Language]= REPLACE([Language], 'zh', 'Chinese')
WHERE [Language] LIKE 'zh';

UPDATE BrainWave.SocialMediaSentiments
SET [Language]= REPLACE([Language], 'es', 'Spanish')
WHERE [Language] LIKE 'es';

UPDATE BrainWave.SocialMediaSentiments
SET [Language]= REPLACE([Language], 'en', 'English')
WHERE [Language] LIKE 'en';

UPDATE BrainWave.SocialMediaSentiments
SET [Language]= REPLACE([Language], 'de', 'German')
WHERE [Language] LIKE 'de';
--changing the language code to the actual languages they represent

SELECT CAST([Post_Date_and_Time] AS DATE) AS Post_date, CAST([Post_Date_and_Time] AS TIME) AS Post_Time
FROM BrainWave.SocialMediaSentiments
--temporarily checking the time and date in separate columns

ALTER TABLE BrainWave.SocialMediaSentiments
ADD Post_Date DATE,
    Post_Time TIME;
--adding two new columns

UPDATE BrainWave.SocialMediaSentiments
SET
    Post_Date = CAST(Post_Date_and_Time AS DATE),
    Post_Time = CAST(Post_Date_and_Time AS TIME);
--putting values into the new columns

ALTER TABLE BrainWave.SocialMediaSentiments
DROP COLUMN Post_Date_and_Time;
--deleting datetime column since we have created new ones

ALTER TABLE BrainWave.SocialMediaSentiments
DROP COLUMN Post_Content;
--deleted the column because it has no use in this analysis

--Now unto analysis;

--average engagement across different post types
SELECT Post_Type, 
    AVG(Number_of_Likes + Number_of_Shares + Number_of_Comments)
    AS Average_Engagements
FROM BrainWave.SocialMediaSentiments
GROUP BY Post_Type;

--Days with highest engagements
SELECT Post_Date, 
    AVG(Number_of_Likes + Number_of_Shares + Number_of_Comments)
    AS Average_Engagements
FROM BrainWave.SocialMediaSentiments
GROUP BY Post_Date
ORDER BY Average_Engagements DESC;

--Times with the highest engagements
SELECT Post_Time, 
    AVG(Number_of_Likes + Number_of_Shares + Number_of_Comments)
    AS Average_Engagements
FROM BrainWave.SocialMediaSentiments
GROUP BY Post_Time
ORDER BY Post_Time;

--What Kind of posts receive positive or negative reactions
SELECT Post_Type,
       Sentiment_Label,
       COUNT(Post_ID) AS Post_Count
FROM BrainWave.SocialMediaSentiments
GROUP BY Post_Type, Sentiment_Label
ORDER BY Sentiment_Label, Post_Count DESC;

--what sentiment tends to gather more engagements
SELECT Sentiment_Label,
    AVG(Number_of_Likes + Number_of_Shares + Number_of_Comments)
    AS Average_Engagements
FROM BrainWave.SocialMediaSentiments
GROUP BY Sentiment_Label
ORDER BY Sentiment_Label DESC;

-- how does a users' following affect the sentiment attached
SELECT Sentiment_Label,
       AVG(User_Follower_Count) AS Avg_Followers
FROM BrainWave.SocialMediaSentiments
GROUP BY Sentiment_Label
ORDER BY Avg_Followers DESC;

--days of the week and their engagements
SELECT DATENAME(WEEKDAY, Post_Date) AS DayOfWeek,
    AVG(Number_of_Likes + Number_of_Shares + Number_of_Comments)
    AS Average_Engagements
FROM BrainWave.SocialMediaSentiments
GROUP BY DATENAME(WEEKDAY, Post_Date)
ORDER BY DayOfWeek ASC
