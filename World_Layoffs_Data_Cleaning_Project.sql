Select *
From layoffs;

-- 1. Removes Duplicates
-- 2. Standardize The Data
-- 3. Null values or blank values
-- 4. Remove Columns

Create table layoffs_staging
like layoffs; 

select * 
From layoffs_staging;

Insert layoffs_staging
Select *
from layoffs;

select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as row_num
From layoffs_staging;

with duplicate_cte as
(select company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions , 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as row_num
From layoffs_staging)
select *
from duplicate_cte
;

select * 
From layoffs_staging
where company = '' ;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2
Where row_num > 2;

Insert into layoffs_staging2
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as row_num
From layoffs_staging
;

Delete
From layoffs_staging2
Where row_num >= 2;

Select *
From layoffs_staging2;

-- Standardization

Select company, trim(company)
From layoffs_staging2;

Update layoffs_staging2
Set company = trim(company);

Select *
from layoffs_staging2
where industry like 'Crypto%';

Update layoffs_staging2
set industry = 'Crypto' 
where industry like 'Crypto%';

Select distinct location
from layoffs_staging2
order by 1;

Select distinct country, trim( trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim( trailing '.' from country)
where country like 'United States%' ;

Select distinct country
from layoffs_staging2
order by 1;

Select `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
From layoffs_staging2;

Update layoffs_staging2
set `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

Alter Table layoffs_staging2
Modify Column `date` date;

--- Looking at Null Values

Select *
From layoffs_staging2
Where total_laid_off is Null
and percentage_laid_off is null;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;
--- Removing Columns
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoffs_staging2;










