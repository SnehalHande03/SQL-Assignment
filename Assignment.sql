-------------- ASSINGNMENT1 ------------------
             -- /09/2026
SELECT * FROM HotelGuest
SELECT * FROM HotelBooking
--1. Front office wants a contact list of all active guests from Delhi to send a New Year promotional SMS. Show FirstName, LastName, PhoneNumber, Email.
SELECT FirstName,LastName,PhoneNumber,Email,City 
FROM HotelGuest
where IsActive=1 and City='Delhi'

--2. Marketing team wants to know from which cities guests are coming to plan targeted campaigns. 
--List all distinct cities.
SELECT distinct(City) FROM HotelGuest

--3. Revenue manager wants to review all cancelled or no-show bookings to study patterns. 
--Show BookingID, GuestID, BookingStatus, CheckInDate, RoomType.
SELECT BookingID,GuestID,BookingStatus,CheckInDate,RoomType
FROM HotelBooking
WHERE BookingStatus in('Cancelled' ,'NoShow')


--4. Management wants a list of Suite bookings where the TotalAmount > 30000 to identify high-value stays. 
--Show BookingID, GuestID, RoomNumber, TotalAmount.
SELECT BookingID,GuestID,RoomNumber,TotalAmount
FROM HotelBooking
WHERE RoomType='Suite' and TotalAmount > 30000

--5. Loyalty team wants to send gifts to Gold or Platinum guests whose TotalSpend > 60000. 
--Show GuestID, FirstName, LastName, LoyaltyLevel, TotalSpend.
SELECT GuestID, FirstName,LastName,LoyaltyLevel,TotalSpend
FROM HotelGuest
where LoyaltyLevel in ('Gold','Platinum') and TotalSpend> 60000

--6. Reservations team needs a report of all bookings with guest names. 
--Show BookingID, FirstName, LastName, RoomType, CheckInDate.
SELECT HG.FirstName,HG.LastName, B.RoomType,B.CheckInDate
FROM HotelGuest as HG
inner join
HotelBooking as B
on 
HG.GuestID=B.GuestID


--7. Management wants to see all guests, including those who never booked, 
--with their latest booking date if any. Show GuestID, FirstName, LastName, LastBookingDate.
SELECT HG.FirstName,HG.LastName, B.LastUpdatedDate
FROM HotelGuest as HG
Left join
HotelBooking as B
on 
HG.GuestID=B.GuestID
where B.BookingStatus='NoShow'

--8. Digital team wants to analyze bookings done through the Website channel. Show FirstName, LastName, BookingID, TotalAmount.
SELECT HG.FirstName,HG.LastName, B.BookingID,B.TotalAmount,B.BookingChannel
FROM HotelGuest as HG
inner join
HotelBooking as B
on 
HG.GuestID=B.GuestID
where B.BookingChannel='Website'

--9. Sales wants a list of guests who have ever booked a Suite, to upsell future suite offers.
--Show distinct GuestID, FirstName, LastName.
select Distinct HG.GuestID,HG.FirstName,HG.LastName ,B.RoomType
FROM HotelGuest as HG
inner join
HotelBooking as B
on 
HG.GuestID=B.GuestID
where B.RoomType='Suite'

--10. Management wants a summary of number of bookings by status (CheckedOut, Booked, Cancelled, etc.).
select BookingStatus,count(BookingStatus)
from HotelBooking
group by BookingStatus

--11. Management wants total revenue per RoomType. Show RoomType and TotalRevenue
select RoomType,sum(TotalAmount) as TOTAL_REVENUE
from HotelBooking 
Group By RoomType

--12. For each BookingChannel, show number of bookings and average TotalAmount.
select BookingChannel,avg(TotalAmount),count(GuestID)
from HotelBooking 
Group By BookingChannel

select Avg(TotalAmount),count(GuestID) from HotelBoooking
Group By BookingChannel

--13. Management wants guests whose total booked nights are more than 6. Show GuestID, FirstName, TotalBookedNights
select Distinct B.GuestID,HG.FirstName,SUM(B.Nights) as TOTAL_BOOKING_NIGHTS
FROM HotelBooking as B
inner join
HotelGuest as HG
on
HG.GuestID=B.GuestID
GROUP BY B.GuestID,HG.FirstName
having sum(Nights) > 6;


-- 14. For each LoyaltyLevel,find how many distinct guests and their total TotalSpend from HotelGuest table.
SELECT distinct(count(GuestID))as Total_Guest,sum(TotalSpend) as Total_spend,LoyaltyLevel
FROM HotelGuest 
Group By LoyaltyLevel


--15. Add a new column GSTNumber VARCHAR(20) NULL to HotelGuest.
alter table HotelGuest add GSTNum varchar(20) null 
SELECT * FROM HotelGuest

--16. Change the data type of PhoneNumber in HotelGuest to VARCHAR(20).
Alter Table HotelGuest alter column PhoneNumber Varchar(20)

--17. Rename table HotelGuest to GuestMaster and then rename it back to HotelGuest.
EXEC sp_rename 'HotelGuest','GuestMaster';
EXEC sp_rename 'GuestMaster','HotelGuest';


--18. Update BookingStatus to 'CheckedOut' for all bookings where CheckOutDate is in the past and 
--status is currently 'Booked' or 'CheckedIn'.
update HotelBooking
set BookingStatus='CheckedOut'
where [CheckOutDate]<GETDATE() AND [BookingStatus] in ('Booked' ,'CheckedIn');

--19. Delete all bookings with BookingStatus = 'NoShow' that are older than '2023-01-01'.
DELETE b
FROM HotelBooking b
JOIN HotelGuest c
  ON b.GuestID = c.GuestID
WHERE b.BookingStatus = 'NoShow'
  AND b.CreatedDate < '2023-01-01';

--delete from HotelBooking 
--where BookingStatus='NoShow' and CreatedDate <'2023-01-01'

--20. Remove all data from HotelBooking but keep the table structure.
TRUNCATE table HotelBooking


--21. Create a view vw_ActiveGuests that shows only active guests 
--(IsActive = 1) with GuestID, FullName (FirstName + ' ' + LastName), City, LoyaltyLevel.
CREATE VIEW VW_ActiveGuests
AS
select GuestID,FirstName,LastName,City,LoyaltyLevel,isactive from HotelGuest
where IsActive=1
select * from VW_ActiveGuests

--22. Create a view vw_BookingSummary that shows BookingID, GuestID, RoomType, BookingStatus, TotalAmount, BookingChannel.
create view VW_BookingSummary
AS
SELECT BookingID,GuestID,RoomType,BookingStatus,TotalAmount,BookingChannel FROM HotelBooking
SELECT * FROM VW_BookingSummary
--23. Using vw_BookingSummary, find total revenue by BookingChannel.
CREATE VIEW VW_BookingSummary
as 
select * from HotelGuest

--24. Create a stored procedure sp_GetGuestBookings that accepts @GuestID and returns all bookings for that guest.


--25. Create a stored procedure sp_GetRevenueByRoomType that returns RoomType, TotalRevenue (SUM TotalAmount).

--26. Find all bookings made in December 2024, showing BookingID, GuestID, RoomType, 
--TotalAmount, and BookingChannel.
SELECT BookingID, GuestID, RoomType, TotalAmount, BookingChannel
FROM HotelBooking
WHERE MONTH(CreatedDate) = 12
AND YEAR(CreatedDate) = 2024;

  --27 Guests who stayed more than 20 nights
  select FirstName, LastName,Gender,TotalNights
  from HotelGuest
  where TotalNights >20;

  -- Get guest name with booking details
  select HG.FirstName,HG.LastName,Hb.BookingID,HB.TotalAmount
  from HotelGuest as HG
  join
  HotelBooking as HB
  on HG.GuestID= HB.GuestID

  -- Find top spending guest
  select top 1 G.FirstName,G.LastName,sum(B.TotalAmount) AS TotalSpend
  from HotelGuest as G
  join
  HotelBooking as B
  on G.GuestID = B.GuestID
  group by G.FirstName,G.LastName
  order by sum(B.TotalAmount) desc;
