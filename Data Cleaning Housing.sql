SELECT * FROM dbo.nashvillehousing


---Standardize Date Format

Select SaleDate, CONVERT(Date, SaleDate)
From dbo.nashvillehousing

alter table NashvilleHousing
alter column Saledate DATE



--Populate Property Address Data

SELECT*FROM dbo.nashvillehousing
order by ParcelID

SELECT * FROM dbo.nashvillehousing
where propertyaddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, B.PropertyAddress)
FROM dbo.nashvillehousing A
join dbo.nashvillehousing b
on a.ParcelID=b.ParcelID
AND a. [UniqueID]<> b.[UniqueID]
where a.propertyaddress is null

Update a 
SET PropertyAddress= ISNULL(a.PropertyAddress, B.PropertyAddress)
FROM dbo.nashvillehousing A
join dbo.nashvillehousing b
on a.ParcelID=b.ParcelID
AND a. [UniqueID]<> b.[UniqueID]
where a.propertyaddress is null


--Breaking out address into individual columns  (Address, city, state)


SELECT propertyaddress FROM dbo.nashvillehousing


SELECT 
SUBSTRING (propertyaddress, 1, CHARINDEX(',', Propertyaddress)-1) as Address,
SUBSTRING (propertyaddress, CHARINDEX(',', Propertyaddress)+1, LEN(PropertyAddress)) as City

FROM dbo.nashvillehousing


ALTER TABLE dbo.nashvillehousing
Add Propertysplitaddress Nvarchar(255);


Update dbo.nashvillehousing
SET PropertySplitAddress= SUBSTRING (propertyaddress, 1, CHARINDEX(',', Propertyaddress)-1)


ALTER TABLE dbo.nashvillehousing
Add Propertysplitcity Nvarchar(255);

Update dbo.nashvillehousing
SET PropertySplitCity= SUBSTRING (propertyaddress, CHARINDEX(',', Propertyaddress)+1, LEN(PropertyAddress))



SELECT Owneraddress FROM dbo.nashvillehousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM dbo.nashvillehousing

ALTER TABLE dbo.nashvillehousing
Add Ownersplitaddress Nvarchar(255);


Update dbo.nashvillehousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE dbo.nashvillehousing
Add ownersplitcity Nvarchar(255);

Update dbo.nashvillehousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE dbo.nashvillehousing
Add ownersplitstate Nvarchar(255);

Update dbo.nashvillehousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


SELECT soldasvacant from dbo.nashvillehousing


--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(soldasvacant), count(soldasvacant)
from dbo.nashvillehousing
group by soldasvacant
order by 2


alter table NashvilleHousing
alter column soldasvacant VARCHAR(50)


Select soldasvacant,
CASE when soldasvacant = '1' THEN 'Yes'
when soldasvacant = '0' THEN 'No'
ELSE soldasvacant
END
from dbo.nashvillehousing


SELECT distinct (soldasvacant), count(soldasvacant) 
from dbo.nashvillehousing 
Group by soldasvacant
order by 2


Update dbo.nashvillehousing
SET Soldasvacant= CASE when soldasvacant = '1' THEN 'Yes'
when soldasvacant = '0' THEN 'No'
ELSE soldasvacant
END
from dbo.nashvillehousing


SELECT soldasvacant,
CASE when soldasvacant = '1' THEN 'Yes'
when soldasvacant = '0' THEN 'No'
ELSE soldasvacant
END
from dbo.nashvillehousing




-- Remove Duplicates

WITH RowNumCTE As(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
				UniqueID) row_num

from dbo.nashvillehousing)

Select * From RowNumCTE
Where row_num > 1
Order by propertyaddress



-- Delete Unused Columns

Select *
From dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate







