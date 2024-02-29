SELECT *
FROM Information..NashvilleHousing

-- Standardize the date format
SELECT SaleDateConverted
FROM Information..NashvilleHousing

-- Adds a new column with the datatype date
ALTER TABLE Information..NashvilleHousing
ADD SaleDateConverted Date

UPDATE Information..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address Data
SELECT PropertyAddress
FROM Information..NashvilleHousing
WHERE PropertyAddress IS NULL

-- Self Join
-- Indicates rows with similar ParcelId have the same Address
SELECT Nash.ParcelId, Nash.PropertyAddress, Vill.ParcelId, Vill.PropertyAddress, ISNULL(Nash.PropertyAddress, Vill.PropertyAddress)
FROM Information..NashvilleHousing Nash
JOIN Information..NashvilleHousing Vill
ON Nash.ParcelID = Vill.ParcelID
AND Nash.[UniqueID ] <> Vill.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL

-- Fill the null values in the Nash Table with values from Vill Table
UPDATE Nash
SET PropertyAddress = ISNULL(Nash.PropertyAddress, Vill.PropertyAddress)
FROM Information..NashvilleHousing Nash
JOIN Information..NashvilleHousing Vill
ON Nash.ParcelID = Vill.ParcelID
AND Nash.[UniqueID ] <> Vill.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL

-- Splitting the Address into Address and city
-- First select the PropertyAddress column
SELECT PropertyAddress
FROM Information..NashvilleHousing

-- Breaking out Address into individual columns: Address, City
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM Information..NashvilleHousing

-- Adding the separated Address column to the table
ALTER TABLE Information..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

-- Setting the separated Address to the value of Address alone
UPDATE Information..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

-- Adding the separated City column to the table
ALTER TABLE Information..NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

-- Setting the separated City to the value of City alone
UPDATE Information..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- First viewing the OwnerAddress column
SELECT OwnerAddress
FROM Information..NashvilleHousing

--Splitting OwnerAddress into Address, City and state
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM Information..NashvilleHousing

-- Adding separated OwnerSplitAddress to the table
ALTER TABLE Information..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

-- Setting separated Address to the value of Address alone
UPDATE Information..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

-- Adding OwnerSpliCity column to the table
ALTER TABLE Information..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

-- Setting separated City to the value of City alone
UPDATE Information..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)           

-- Adding OwnerSplitState column to the table
ALTER TABLE Information..NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

-- Setting separated State to the value of State alone
UPDATE Information..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Returns non-duplicate values Yes, No, Y, N
SELECT DISTINCT(SoldAsVacant), COUNT(soldAsVacant)
FROM Information..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- Changing values of Y and N to Yes and No respectively
SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM Information..NashvilleHousing

-- Updates the SoldAsVacant Y and N values to Yes and No
UPDATE Information..NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END


-- Removing duplicates
WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) row_num
FROM Information..NashvilleHousing
)

-- Deletes the duplicate rows
DELETE
FROM RowNumCTE
WHERE row_num > 1

-- Delete Unused Columns
ALTER TABLE Information..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict







