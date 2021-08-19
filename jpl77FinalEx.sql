/*Q1*/
USE [DWScores_jpl77]
GO

--Drop the foreign keys

ALTER TABLE dbo.FactScores DROP CONSTRAINT FK_FactScores_DimStudents
ALTER TABLE dbo.FactScores DROP CONSTRAINT FK_FactScores_DimDates


--Clear all table records

TRUNCATE TABLE [dbo].[DimStudents]
TRUNCATE TABLE [dbo].[DimDates]
TRUNCATE TABLE [dbo].[FactScores]




--Add foreign keys back
ALTER TABLE [dbo].[FactScores]  WITH CHECK ADD  CONSTRAINT [FK_FactScores_DimStudents] FOREIGN KEY([StudentKey])
REFERENCES [dbo].[DimStudents] ([StudentKey])
ALTER TABLE [dbo].[FactScores]  WITH CHECK ADD  CONSTRAINT [FK_FactScores_DimDates] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDates] ([DateKey])
GO

--Insert data into DimStudents table

INSERT INTO [dbo].[DimStudents]
(
	StudentKey,
	StudentId,
	CollegeName,
	Gender
 )
 (

	SELECT 
		[StudentKey]		= CAST (( [Student_Key]) as int),
		[StudentId]	= CAST (( Student_Id) as nchar(10))
		[CollegeName]		= CAST (( College_Name) as nvarchar(50)),
		[Gender]	= CAST (( Gender) as nchar(1))
	FROM [ScoresDB_xxx].[dbo].[StudentKey]
)
go





-- Populate the DimDates table


Insert into [dbo].[DimDates]
(
	[DateKey], 
	[Date],
	[DateName],
	[Year],
	[YearName]
)
(
	Select 
		[DateKey] = -1,
		[Date] =  '01/01/1989',
		[DateName] = Cast('Unknown Day'),
		[Year] = -1,
		[YearName] = Cast('Unknown Year')
	From [ScoresDB_xxx].[dbo].[Students]
 )
go





--Insert data into FactScores table


INSERT INTO [dbo].[FactScores]
( 
	FactKey,
	GameId
	StudentKey,
	DateKey,
	ScoredPoints
)
(
	SELECT  
		FactKey =	  CAST ( FactKey as int),
		GameId = CAST( GameId as int ),
		StudentKey = CASE CAST( [StudentKey] as int )
		DateKey = CAST( CAST(DateKey) as int ),
		ScoredPoints= 

	FROM (ScoresDB_xxx]  INNER JOIN  DimStudents
				ON [DWScores_jpl77] = DimPublishers.PublisherID)
			INNER JOIN [DimDates]	
					ON [DWScores_jpl77] = DimDates.[Date]
)
GO


----Q2
--Reports

USE [DWScores_jpl77]
GO

select DimStduents.CollegeName, FactScores.ScoredPoints,
from FactScores join DimStudents
on FactScores.ScoredPoints = DimStudents.CollegeName
order by CollegeName, Date 

declare
@prefix nvarchar(10) = 'U')),
@prefix nvarchar(10) = 'B'

select KPI as 'KPI for Total Scored Points',
[Total for that date] = sum(ScoredPoints), 
[KPI on the sum quantity] = case
when sum(ScoredPoints) >20 then 1
when sum(ScoredPoints) between 10 and 20 then 0
when sum(ScoredPoints) <10 then -1
end
from FactScores join DimStudents