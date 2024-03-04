--Data Cleaning

SELECT *
FROM PortfolioProject..NashvilleHousing

-------------------------------------------

--Standarize Date Format
SELECT SaleDate, CAST(SaleDate AS date) AS Saledates
FROM PortfolioProject..NashvilleHousing

UPDate NashvilleHousing
SET SaleDate=CAST(SaleDate AS date)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDate NashvilleHousing
SET SaleDateConverted = CAST(SaleDate AS date)

SELECT SaleDateConverted, CAST(SaleDate AS date) AS Saledates
FROM PortfolioProject..NashvilleHousing

-----------------------------------------

--Populate Property Address data

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID


--Doing Self Jion
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

	UPDATe a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

	SELECT PropertyAddress
	FROM PortfolioProject..NashvilleHousing

	---Breaking The updated Address Into (Address, City, State)
	SELECT PropertyAddress
	FROM PortfolioProject..NashvilleHousing

	-- spliting the property address into address and city
	SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertySplitAddress
	,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEn(PropertyAddress)) AS PropertySplitCity
	FROM PortfolioProject..NashvilleHousing

	--Adding the PropertyssplitAddress And PropertySplitCity
ALTER TABLE  NashvilleHousing
ADD PropertySplitAddress  Nvarchar(255);

UPDate NashvilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity  Nvarchar(255);

UPDate NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEn(PropertyAddress))


SElect *
FROM..NashvilleHousing


-- OWner Address
SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE  NashvilleHousing
ADD OwnerSplitAddress  Nvarchar(255);

UPDate NashvilleHousing
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity  Nvarchar(255);

UPDate NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE  NashvilleHousing
ADD OwnerSplitState  Nvarchar(255);

UPDate NashvilleHousing
SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


SELECT *
FROM PortfolioProject..NashvilleHousing

-- Change Y, N to Yes And No in 'Sold As Vacant' Field
SELEct Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant='Y' THEn 'YES'
		WHEN SoldAsVacant='N' THen 'NO'
		ELSE SoldAsVacant
		END
FROM PortfolioProject..NashvilleHousing

UpDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEn 'YES'
		WHEN SoldAsVacant='N' THen 'NO'
		ELSE SoldAsVacant
		END

		--REMOVE DUPLICATES
	WITH ROWNumCTE AS(
	SELECT *,
			ROW_NUMBER() OVER(
			PARTITION BY ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							ORDER BY UniqueID
							)row_num
FROM PortfolioProject..NashvilleHousing
--ORDER BY [UniqueID ]
)
	SELECT *
FROM ROWNumCTE

	WITH ROWNumCTE AS(
	SELECT *,
			ROW_NUMBER() OVER(
			PARTITION BY ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							ORDER BY UniqueID
							)row_num
FROM PortfolioProject..NashvilleHousing
--ORDER BY [UniqueID ]
)
	DELETE
FROM ROWNumCTE
WHERE row_num>1

--DELETING UNUSED COLUMNS 
SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY [UniqueID ]

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress,SaleDate