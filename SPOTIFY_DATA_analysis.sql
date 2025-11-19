DROP TABLE IF EXISTS SPOTIFYY;
CREATE TABLE SPOTIFYY (
    spotify_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    artists VARCHAR(500),
    daily_rank INT,
    daily_movement INT,
    weekly_movement INT,
    country VARCHAR(100),
    snapshot_date VARCHAR(20),
    popularity INT,
    is_explicit BIT,
    duration_ms INT,
    album_name VARCHAR(255),
    album_release_date VARCHAR(20),
    danceability FLOAT,
    energy FLOAT,
    key_signature INT,
    loudness FLOAT,
    mode INT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    time_signature INT
);



--data exploration 
SELECT * FROM SPOTIFYY

--DATA ANALYSIS--

--1. Top 10 Most-Streamed Songs

 select distinct top 10 name,artists,popularity
 from SPOTIFYY
 order by popularity desc

--2. Songs Released After 2015

select *
from SPOTIFYY
where year(try_cast(album_release_date as date))>2015

--3. Songs with High Energy (>0.8)

select * from SPOTIFYY
where energy>0.8

--4. Total Number of Songs

select count(name) as songscount
from SPOTIFYY

--ARTISTS WITH DUPLICATE SONGS

select artists,count(name) as dup_songs
from SPOTIFYY
group by artists
having count(name)>1

--Find songs with NULL or missing values.

select * from SPOTIFYY
where name is null

--6. Average danceability 

select avg(danceability) as avgdanceability from SPOTIFYY

--7.Year with Highest Song Releases

select top 1 album_release_date,count(*) songs
from SPOTIFYY
group by album_release_date
order by count(*) desc

--8.Number of Songs per Artist

select artists,count(*) as number_of_songs
from SPOTIFYY
group by artists

--9.Rank Songs for Each Artist.

select distinct artists,popularity,
DENSE_RANK() over (partition by artists order by popularity desc) as ranking
from SPOTIFYY

--10.Top-Streamed Song for Each Year

SELECT *
FROM (
    SELECT name, artists, album_release_date, popularity,
           ROW_NUMBER() OVER (PARTITION BY album_release_date ORDER BY popularity DESC) AS rn
    FROM SPOTIFYY
) AS ranked_songs
WHERE rn = 1;


--11. Songs with Streams Greater Than Average

select name,popularity
from SPOTIFYY
where popularity>(select avg(s.popularity) from SPOTIFYY as s)

--12. Songs Longer Than Average Duration

SELECT name, duration_ms
FROM SPOTIFYY
WHERE duration_ms > (
    SELECT AVG(CAST(duration_ms AS BIGINT)) FROM SPOTIFYY
);


