-- Lab 1: Analytical Queries
-- Author: Farwa Eeman
-- Date: February 5, 2026

-- ============================================
-- BASIC QUERIES
-- ============================================

-- Query 1: All books ordered by rating (highest first)
SELECT title, author, rating, category
FROM books_read
ORDER BY rating DESC;

-- Query 2: Books rated 4.5 or higher
SELECT title, rating, date_finished
FROM books_read
WHERE rating >= 4.5
ORDER BY rating DESC;

-- Query 3: Find all Machine Learning books
SELECT title, author, rating
FROM books_read
WHERE category = 'Machine Learning';

-- ============================================
-- AGGREGATE QUERIES
-- ============================================

-- Query 4: Average pages by category
SELECT 
    category, 
    COUNT(*) as book_count,
    ROUND(AVG(pages), 0) as avg_pages
FROM books_read
GROUP BY category
ORDER BY avg_pages DESC;

-- Query 5: Total pages read
SELECT SUM(pages) as total_pages_read 
FROM books_read;

-- Query 6: Average rating by category
SELECT 
    category,
    COUNT(*) as book_count,
    ROUND(AVG(rating), 2) as average_rating
FROM books_read
GROUP BY category
ORDER BY average_rating DESC;

-- ============================================
-- TIME-BASED QUERIES
-- ============================================

-- Query 7: Monthly reading progress
SELECT
    TO_CHAR(date_finished, 'YYYY-MM') as month,
    COUNT(*) as books_finished,
    SUM(pages) as pages_read
FROM books_read
GROUP BY TO_CHAR(date_finished, 'YYYY-MM')
ORDER BY month;

-- Query 8: Books read in 2024
SELECT title, author, date_finished
FROM books_read
WHERE EXTRACT(YEAR FROM date_finished) = 2024
ORDER BY date_finished;

-- ============================================
-- ADVANCED QUERIES
-- ============================================

-- Query 9: Top 3 longest books
SELECT title, author, pages, category
FROM books_read
ORDER BY pages DESC
LIMIT 3;

-- Query 10: Reading statistics dashboard
SELECT 
    COUNT(*) as total_books,
    SUM(pages) as total_pages,
    ROUND(AVG(pages), 0) as avg_pages_per_book,
    ROUND(AVG(rating), 2) as avg_rating,
    MAX(rating) as highest_rating,
    MIN(rating) as lowest_rating
FROM books_read;

-- Query 11: Books with above-average ratings
SELECT title, rating
FROM books_read
WHERE rating > (SELECT AVG(rating) FROM books_read)
ORDER BY rating DESC;

-- Query 12: Category performance analysis
SELECT 
    category,
    COUNT(*) as books,
    ROUND(AVG(rating), 2) as avg_rating,
    SUM(pages) as total_pages,
    MIN(rating) as min_rating,
    MAX(rating) as max_rating
FROM books_read
GROUP BY category
ORDER BY avg_rating DESC;
