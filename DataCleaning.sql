select*
from pp..NashvilleHousing

--Change date format

select SaleDate, convert(Date, SaleDate)
from pp..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

--Adding property address where null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from pp..NashvilleHousing a
join pp..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from pp..NashvilleHousing a
join pp..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

-- Spliting up address column

select 
substring(PropertyAddress,1, charindex(',', PropertyAddress)-1) as address,
substring(PropertyAddress,charindex(',', PropertyAddress)+1, Len(propertyaddress)) as address
from pp..NashvilleHousing

--splitting owner address

select
parsename(replace(owneraddress, ',','.'),3) as address, 
parsename(replace(owneraddress, ',','.'),2) as city,
parsename(replace(owneraddress, ',','.'),1) as state
from pp..nashvilleHousing

alter table nashvillehousing
add Ownersplitcity Nvarchar(255);

alter table nashvillehousing
add Ownersplitaddress Nvarchar(255);

alter table nashvillehousing
add Ownersplitstate Nvarchar(255);

update NashvilleHousing
set ownersplitaddress = parsename(replace(owneraddress, ',','.'),3)

update NashvilleHousing
set ownersplitcity = parsename(replace(owneraddress, ',','.'),2)

update NashvilleHousing
set ownersplitstate = parsename(replace(owneraddress, ',','.'),1)

-- Making Boolean in SoldAsVacant to 'Yes' or 'No'

select soldasvacant,
case when SoldAsVacant = '0' then 'No'
	when soldasvacant = '1' then 'Yes'
	Else 'other'
	end 
from pp..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = '0' then 'No'
	when SoldAsVacant = '1' then 'Yes'
	Else null
	end 

--Remove duplicate

select distinct(UniqueID)
from pp..NashvilleHousing

--Delete columns

alter table pp..nashvillehousing
drop column taxdistrict


