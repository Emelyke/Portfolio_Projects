/*
Data Cleaning Project in SQL

*/

Select *
From Project.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


--Date Format Standardization


Select SaleDateConverted, CONVERT(Date,SaleDate)
From Project.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


-- If it doesn't Update properly


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------

-- Populating Property Address data


select *
From Project.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project.dbo.NashvilleHousing a
Join Project.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project.dbo.NashvilleHousing a
Join Project.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
From Project.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) AS Address
From Project.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertysplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



ALTER TABLE NashvilleHousing
Add PropertysplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))



select *
From Project.dbo.NashvilleHousing



select OwnerAddress
From Project.dbo.NashvilleHousing


SELECT 
PARSENAME(REPLACE(Owneraddress,',' , '.'), 3)
,PARSENAME(REPLACE(Owneraddress,',' , '.'), 2)
,PARSENAME(REPLACE(Owneraddress,',' , '.'), 1)
From Project.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnersplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(Owneraddress,',' , '.'), 3)



ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress,',' , '.'), 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress,',' , '.'), 1)




--------------------------------------------------------------------------------------------------------------------------


-- Change Column Y and N to Yes and No in "Sold as Vacant" field


Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From Project.dbo.NashvilleHousing 
Group by SoldAsVacant
Order by SoldAsVacant 


Select SoldAsVacant
, CASE  When SoldAsVacant = 'N' THEN 'NO'
		When SoldAsVacant = 'Y' THEN 'YES'
		ELSE SoldAsVacant
		END
From Project.dbo.NashvilleHousing 


Update NashvilleHousing
SET SoldAsVacant = CASE  When SoldAsVacant = 'N' THEN 'NO'
		When SoldAsVacant = 'Y' THEN 'YES'
		ELSE SoldAsVacant
		END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates


WITH RownumCTE AS(
select *, 
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
							PropertyAddress,
							SaleDate,
							LegalReference
							ORDER BY 
								UniqueID
								) Row_num

From Project.dbo.NashvilleHousing 
--Order by ParcelID
)
select *
from RownumCTE
Where Row_num >1
order by PropertyAddress


SELECT *
From Project.dbo.NashvilleHousing 

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
From Project.dbo.NashvilleHousing 

ALTER TABLE Project.dbo.NashvilleHousing 
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate, TaxDistrict