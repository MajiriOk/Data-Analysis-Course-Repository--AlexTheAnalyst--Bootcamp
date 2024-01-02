/*
Cleaning SQL Queries
*/

SELECT *
FROM HousingDataset$

-- Standardize Date Format

SELECT SaleDate, CONVERT(date, SaleDate), SaleDateConverted
FROM HousingDataset$

--UPDATE HousingDataset$
--SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE HousingDataset$
ADD SaleDateConverted date

UPDATE HousingDataset$
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address Data

SELECT *
FROM HousingDataset$
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM HousingDataset$ AS x
JOIN HousingDataset$ AS y
	ON x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress IS NULL

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM HousingDataset$ AS x
JOIN HousingDataset$ AS y
	ON x.ParcelID = y.ParcelID
	AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress IS NULL

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM HousingDataset$

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM HousingDataset$

-- Create 2 new columns

--COLUMN 1
ALTER TABLE HousingDataset$
ADD PropertySplitAddress Nvarchar(255);

UPDATE HousingDataset$
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

--COLUMN 2
ALTER TABLE HousingDataset$
ADD PropertySplitCity Nvarchar(255);

UPDATE HousingDataset$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Breaking out Owner Address into Individual Columns (Address, City, State)

SELECT *
FROM HousingDataset$

SELECT OwnerAddress
FROM HousingDataset$

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM HousingDataset$

-- Create 3 new columns

--COLUMN 1
ALTER TABLE HousingDataset$
ADD OwnerSplitAddress Nvarchar(255);

UPDATE HousingDataset$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

--COLUMN 2
ALTER TABLE HousingDataset$
ADD OwnerSplitCity Nvarchar(255);

UPDATE HousingDataset$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

--COLUMN 3
ALTER TABLE HousingDataset$
ADD OwnerSplitState Nvarchar(255);

UPDATE HousingDataset$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Change 'Y' and 'N' to 'Yes' and 'No' in 'SoldAsVacant' field

SELECT DISTINCT(SoldAsVacant)
FROM HousingDataset$

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS CountResponse
FROM HousingDataset$
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM HousingDataset$

UPDATE HousingDataset$
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

-- Remove Duplicates (Locating the Duplicate fields)

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS RowNum
FROM HousingDataset$
)
SELECT *
FROM RowNumCTE
WHERE RowNum > 1
ORDER BY PropertyAddress

-- Deleting Duplicate fields

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS RowNum
FROM HousingDataset$
)
DELETE
FROM RowNumCTE
WHERE RowNum > 1
--ORDER BY PropertyAddress

--Delete Unused Columns

SELECT *
FROM HousingDataset$

ALTER TABLE HousingDataset$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE HousingDataset$
DROP COLUMN SaleDate